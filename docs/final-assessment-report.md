# Final Assessment Report

## Executive summary
The project implements a PR-based DevSecOps pipeline, GHCR release automation, Argo CD GitOps deployment, Kubernetes resource controls and an observability/logging design for a Python microservice with an intentional memory leak.

Core delivery and GitOps workflows were implemented and validated. The 400Mi application memory limit was configured and OOMKilled events were observed. Prometheus/Grafana and Loki/Alloy were configured and previously demonstrated, but the latest captured monitoring snapshot was unhealthy and requires revalidation before final presentation.

## Requirement mapping
| Assessment requirement | Implementation | Qualification |
|---|---|---|
| Minimal, non-root Docker image | Python 3.12 slim, non-root | Implemented; size not recorded |
| PR-only branch protection | Required PR and `Test and Code Quality` | Verified by rejected direct push |
| Unit tests | pytest | Six passed in recorded run |
| Lint/SAST/secret/image scan | Flake8, Bandit, Gitleaks, Trivy | Integrated; HIGH Trivy findings remain |
| Release and registry | GHCR SHA images | Implemented |
| Manifest image update | Release-created PR | Implemented and merged |
| Argo CD | Tracks `main`/`k8s/base` | Auto-sync and self-heal verified |
| Three Deployments/shared Service | v1/v2/v3 + one Service | Implemented |
| 400Mi memory limit | App container limit | OOMKilled exit 137 observed |
| Namespace, ConfigMap, Secret, initContainer | Present | Implemented; demo Secret |
| RBAC | ServiceAccount, Role, RoleBinding | Implemented and read-only access tested |
| NetworkPolicy | Manifest | Enforcement unverified |
| ResourceQuota | Pod and memory quotas | Implemented |
| Prometheus/Grafana | Helm installation and dashboard | Latest Helm snapshot failed |
| Node CPU/memory/disk | CPU and memory panels | Disk panel missing |
| Pod CPU/memory | Dashboard panels | Previously populated |
| Centralized logs | Alloy to Loki | Earlier query returned 194 lines; latest state recheck needed |
| Health/OOM alerts | Grafana rules | Rules saved; no notification target |
| Reproducible docs | This package | Prepared; environment recovery still needed |

## Recorded technical evidence
- Six pytest tests passed.
- Direct push to `main` was rejected by branch protection.
- SHA-tagged GHCR images were published and manifest-update PR merged.
- Argo CD reverted manual replica drift and reflected a Git ConfigMap change.
- App Pods had `128Mi` memory request and `400Mi` limit.
- OOMKilled with exit code 137 was observed.
- initContainer completed with exit code 0.
- Grafana dashboard and Loki Explore worked in an earlier validation session.

## Outstanding items before submission
1. Restore and revalidate monitoring stack.
2. Capture fresh Grafana, alert and Loki evidence.
3. Export Grafana dashboard and alert definitions to Git.
4. Review HIGH Trivy findings.
5. Validate NetworkPolicy enforcement or disclose the limitation.
6. Add the documentation through a PR and confirm CI passes.

## Conclusion
The core DevSecOps and GitOps implementation is in place. The remaining gaps are explicitly identified above; the project should not be represented as having complete disk monitoring, notification delivery, verified NetworkPolicy enforcement or a currently healthy monitoring stack until those items are closed.
