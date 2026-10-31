# Setup and Installation

## Environment
Implementation used Windows 11, PowerShell, Docker Desktop Kubernetes, context `docker-desktop`, node `desktop-control-plane`, Kubernetes `v1.36.1` (recorded).

## Prerequisites
Install Git, Docker Desktop with Kubernetes enabled, kubectl and Helm 3. Verify:
```powershell
git --version
docker version
kubectl version --client
helm version
kubectl config current-context
kubectl get nodes
```

## Clone
```powershell
git clone https://github.com/shreya1302/DevOps-SRE.git
cd DevOps-SRE
git switch main
git pull origin main
```

## Build and smoke test
```powershell
docker build -t devops-sre-app:local .
docker run --rm -p 8080:8080 devops-sre-app:local
```
In another PowerShell window:
```powershell
Invoke-WebRequest http://localhost:8080/healthcheck
```
The application health endpoint is `/healthcheck` on port `8080`.

## Kubernetes and Argo CD
```powershell
kubectl get namespaces
kubectl get pods -n argocd
kubectl get applications -n argocd
kubectl get all -n devops-sre
```
Argo CD tracks `main`, path `k8s/base`, destination namespace `devops-sre`, with automated sync, pruning and self-healing. The exact version-specific installation command was not retained in the project evidence; do not assume a command from this document is the original installation command.

## Helm releases
Values files in the repository:
- `monitoring-values.yaml`
- `loki-values.yaml`
- `alloy-values.yaml`

Recorded versions: kube-prometheus-stack chart `92.16.1` (app `v0.94.2`); Loki chart `7.5.0` (app `3.6.16`). Local upstream chart directories were not committed. Fetch matching chart versions before a fresh install. Alloy chart version was not recorded.

Latest captured monitoring output showed Helm release `monitoring` as `failed`, Grafana `2/3` ready and Prometheus initializing. Revalidate/recover before live demonstration.

## Port forwarding
```powershell
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
```
Grafana: `http://localhost:3000`; Prometheus: `http://localhost:9090`.

Retrieve Grafana password locally without sharing it:
```powershell
$encoded = kubectl get secret grafana-admin-credentials -n monitoring -o jsonpath="{.data.admin-password}"
[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($encoded))
```
Never commit credentials or decoded Secret values.
