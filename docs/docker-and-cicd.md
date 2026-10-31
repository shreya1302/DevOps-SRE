# Docker and CI/CD

## Docker
The Dockerfile uses a Python 3.12 slim base, a non-root runtime user, application port `8080` and a health check at `/healthcheck`. Verify the committed Dockerfile for exact build steps. Image size was not captured, so no numeric size claim is made.

## Pull-request workflow
`.github/workflows/ci.yml` runs for pull requests targeting `main`. Recorded steps:
1. Checkout and Python 3.12 setup.
2. Install development dependencies.
3. pytest.
4. Flake8.
5. Bandit SAST.
6. Docker image build.
7. Trivy image scan.
8. Gitleaks secret scan.

Six pytest tests were reported passing in a recorded run.

## Branch protection
Direct pushes to `main` were rejected by GitHub. PRs are required and `Test and Code Quality` is the required status check.

## Release workflow
After a PR is merged into `main`, the release workflow builds an image, tags it with the source commit SHA, publishes to GHCR and opens a manifest update PR. The manifest PR is checked and merged; Argo CD then reconciles the updated desired state.

Registry:
```text
ghcr.io/shreya1302/devops-sre-app
```
Recorded tags:
```text
sha-f2f262bfee7ab44c7bb3f382e6d14ef49e4b14d5
sha-a2509dbc302776e276ac0f7b2d3730abf43fa6ec
sha-347399b663e983e72bb88f12ef5a3148674363f2
```

The workflow uses repository secret `RELEASE_AUTOMATION_TOKEN` for the manifest PR. Keep the token private and rotate/renew it when expired.

## Security findings
An earlier Trivy scan reported **44 HIGH and 0 CRITICAL** vulnerabilities in Debian 13.7 packages. The pipeline blocks CRITICAL findings; HIGH findings remained for review. Do not describe the image as vulnerability-free. Review affected packages, update base image/dependencies, rebuild and rescan. Bandit and Gitleaks are integrated; claim clean results only when supported by a specific successful workflow run.
