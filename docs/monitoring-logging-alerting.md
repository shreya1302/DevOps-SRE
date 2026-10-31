# Monitoring, Logging and Alerting

## Components
Prometheus and Grafana were installed using kube-prometheus-stack Helm chart `92.16.1` (app `v0.94.2`). Loki chart `7.5.0` (app `3.6.16`) and Grafana Alloy were configured. Alloy discovers Kubernetes Pods and forwards logs to Loki.

## Grafana dashboard
Dashboard: `DevOps-SRE Monitoring Dashboard`.

### Pod memory
```promql
sum by (pod) (container_memory_working_set_bytes{namespace="devops-sre",container!="",container!="POD"})
```
### Pod CPU
```promql
sum by (pod) (rate(container_cpu_usage_seconds_total{namespace="devops-sre",container!="",container!="POD"}[5m]))
```
### Container restarts
```promql
sum by (pod) (kube_pod_container_status_restarts_total{namespace="devops-sre"})
```
### OOMKilled
```promql
kube_pod_container_status_last_terminated_reason{namespace="devops-sre",reason="OOMKilled"} == 1
```
### Node CPU
```promql
100 * (1 - avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])))
```
### Node memory
```promql
100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))
```

**Disk panel gap:** a node disk query using `mountpoint="/"` returned no data; the disk usage panel was skipped.

## Centralized logs
```text
Kubernetes container logs -> Grafana Alloy DaemonSet
 -> http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push
 -> Loki -> Grafana Explore
```
Loki datasource URL:
`http://loki.monitoring.svc.cluster.local:3100`

A prior Explore query `{namespace="devops-sre"}` returned 194 lines. This is historical evidence, not proof of latest health. Loki used filesystem storage under `/tmp` with persistence disabled; data may be lost when its Pod is recreated. Recheck Loki/Alloy Pods before demonstration.

## Grafana alert rules
Folder `DevOps-SRE`; group `devops-sre-alerts`; evaluation interval 1 minute.

Unready Pod query:
```promql
kube_pod_status_ready{namespace="devops-sre",condition="true",pod=~"devops-sre-app-v[123].*"}
```
Condition: below 1; pending 1 minute.

OOMKilled query:
```promql
kube_pod_container_status_last_terminated_reason{namespace="devops-sre",container="devops-sre-app",reason="OOMKilled"} == 1
```
Condition: above 0; no pending delay.

Both rules were saved in Grafana UI. The contact point was empty, so evaluation exists but Slack/email delivery is not configured.

## Latest state caveat
Latest captured output on 31 October 2026 showed Helm release `monitoring` as `failed`, Grafana `2/3` containers ready and Prometheus `PodInitializing`, with probe timeouts. Earlier dashboards/log queries worked. Revalidate before saying the stack is healthy.

```powershell
helm list -n monitoring
kubectl get pods -n monitoring -o wide
kubectl get events -n monitoring --sort-by='.lastTimestamp' | Select-Object -Last 20
```
