# Testing and Validation

This document separates recorded successful checks from fresh checks still required.

## CI and container
| Check | Recorded result |
|---|---|
| pytest | Six tests passed |
| Flake8 | Included in PR workflow |
| Bandit | Included in PR workflow |
| Docker build | Included in PR workflow |
| Trivy | Earlier scan: 44 HIGH, 0 CRITICAL |
| Gitleaks | Included in PR workflow |
| Branch protection | Direct push to `main` rejected |
| GHCR release | SHA-tagged images published |
| Manifest update | Release-created PR merged |

Local checks (where tools are installed):
```powershell
python -m pytest -v
python -m flake8 app test
python -m bandit -r app
docker build -t devops-sre-app:validation .
```

## Kubernetes and GitOps
| Check | Recorded result | Recheck |
|---|---|---|
| Three Deployments | v1/v2/v3 created | `kubectl get deploy -n devops-sre` |
| Shared Service | Created | `kubectl get svc,endpoints -n devops-sre` |
| 400Mi limit | Configured | `kubectl describe pod -n devops-sre` |
| OOMKilled | Exit 137 observed | Inspect Pod last state/restarts |
| initContainer | Completed, exit 0 | `kubectl describe pod -n devops-sre` |
| RBAC | Read-only Pod access tested | `kubectl auth can-i get pods --as=system:serviceaccount:devops-sre:devops-sre-reader -n devops-sre` |
| ResourceQuota | Applied | `kubectl describe quota -n devops-sre` |
| NetworkPolicy | Manifest applied; enforcement unverified | Requires supported CNI |
| Argo CD | Auto-sync and self-heal verified | `kubectl get applications -n argocd` |

## Monitoring and logs
Earlier validation showed populated Grafana panels, Loki Explore returning 194 log lines, Alloy running 2/2, and saved alert rules. Disk panel and alert delivery were not completed. Latest monitoring Helm snapshot was failed and components were not all ready.

Fresh final checks:
```powershell
helm list -n monitoring
kubectl get pods -n monitoring -o wide
kubectl get pods -n devops-sre -o wide
kubectl get applications -n argocd
```
Open Grafana to check dashboard, datasource, alert rules and a fresh Loki query after the stack is healthy.

## Screenshot checklist
Capture current evidence for:
1. Branch protection and required check.
2. Successful PR workflow and security scan jobs.
3. GHCR image tags and release manifest PR.
4. Argo CD Synced/Healthy and self-heal.
5. Three Deployments and shared Service.
6. Pod description showing 400Mi and OOMKilled last state.
7. initContainer, RBAC and ResourceQuota.
8. Grafana dashboard and alert rules.
9. Loki Explore logs and Alloy status.

Do not expose passwords, tokens, decoded Secret values or private account data.
