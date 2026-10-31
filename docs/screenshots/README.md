# DevOps-SRE Project — Essential Screenshot Evidence

These screenshots document the CI/CD and Kubernetes work completed so far.

## CI/CD and GitHub
1. Git main branch updated after merge.
2. GHCR release workflow configuration.
3. Automated Kubernetes manifest image-tag update step.
4. Pull-request CI checks passing.
5. GitHub Actions release run.
6. Kubernetes deployment manifest on GitHub with the SHA-based image tag.
7. Active main-branch ruleset.

## Kubernetes
8. Local Kubernetes node Ready.
9. Existing cluster Pods running.
10. Existing deployments and services.
11. `devops-sre` namespace created.
12. Application Deployment manifest.
13. Deployment details and available replica.
14. Deployment applied and Pod started.
15. Port-forwarded `/healthcheck` returning `{"status":"healthy"}`.
16. Pod CPU and memory metrics.
17. OOMKilled evidence: 400Mi memory limit, exit code 137, restart count 2.

## Add to the Git repository
Extract this folder into the repository as `docs/screenshots/`. Keep the filenames as they are. Then commit and push the screenshots when convenient.

Note: These are selected milestone screenshots, not every troubleshooting screenshot. The latest OOMKilled capture is included.
