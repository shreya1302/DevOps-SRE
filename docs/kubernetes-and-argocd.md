# Kubernetes and Argo CD

## Workloads
Namespace: `devops-sre`. Three Deployments:
- `devops-sre-app-v1`
- `devops-sre-app-v2`
- `devops-sre-app-v3`

One shared Service: `devops-sre-app-service`, port 8080. Recorded ClusterIP `10.96.59.47`, NodePort `30779`. Its common application selector selects the three versioned workloads; Kubernetes distributes traffic among eligible endpoints but does not guarantee strict equal request counts.

```powershell
kubectl get deployments,pods,svc -n devops-sre -o wide
kubectl get endpoints -n devops-sre devops-sre-app-service
```

## Resource controls
Each app container: request `128Mi`, limit `400Mi`. OOMKilled terminations with exit code `137` and subsequent restarts were observed. A Pod may become Ready after restart while its previous container state remains OOMKilled; inspect restart count and last state.

## Required Kubernetes resources
| Resource | Configuration |
|---|---|
| ConfigMap | `devops-sre-config` |
| Secret | `devops-sre-secret` (demo values; omitted) |
| initContainer | `init-setup`, writes marker into shared `emptyDir`; observed exit 0 |
| ServiceAccount | `devops-sre-reader` |
| Role | `devops-sre-pod-reader`, read-only Pod access |
| RoleBinding | Binds ServiceAccount to Role |
| ResourceQuota | `devops-sre-quota`: 6 Pods, 1Gi memory requests, 2Gi memory limits |
| NetworkPolicy | Manifest applied; enforcement not verified |

The application mounts init data read-only. Never put real credentials in Git or documentation.

## NetworkPolicy qualification
The local cluster uses `kindnet`; enforcement was not verified because this CNI does not provide the NetworkPolicy enforcement used in this test. Describe this as a manifest applied, not proven isolation. A CNI that supports policies and explicit allow/deny tests are required to validate enforcement.

## Argo CD
Application `devops-sre-app` tracks `https://github.com/shreya1302/DevOps-SRE.git`, revision `main`, path `k8s/base`, destination namespace `devops-sre`. Automated sync, prune and self-heal are enabled.

Validation recorded:
- Manually scaling a Deployment to 2 replicas was reverted to desired replicas 1.
- A merged ConfigMap update was reflected in the cluster without manual `kubectl apply`.

Useful checks:
```powershell
kubectl get applications -n argocd
kubectl describe application devops-sre-app -n argocd
kubectl describe resourcequota devops-sre-quota -n devops-sre
kubectl get networkpolicy -n devops-sre
kubectl get role,rolebinding,serviceaccount -n devops-sre
```
