# Known Limitations and Future Improvements

## Current limitations
1. **Trivy:** an earlier scan reported 44 HIGH and 0 CRITICAL findings in Debian 13.7 packages. HIGH findings still need triage/remediation.
2. **NetworkPolicy:** YAML applied, but enforcement was not validated with local `kindnet`.
3. **Disk monitoring:** requested node disk panel was skipped because the selected query returned no data.
4. **Loki persistence:** filesystem data under `/tmp`, persistence disabled; logs may be lost on Pod recreation.
5. **Alert notifications:** Grafana alert rules saved, but no contact point configured; no Slack/email delivery.
6. **Dashboard/rules as code:** created in Grafana UI; export/provisioning into Git remains.
7. **Monitoring health:** latest captured Helm release was failed; Grafana and Prometheus were not fully ready.
8. **Local resource pressure:** monitoring components had readiness and restart issues.

## Prioritized improvements
### P1 — Restore and validate
- Diagnose failed monitoring Helm release.
- Check Grafana, Prometheus, Loki and Alloy Pods/logs.
- Confirm Argo CD Synced and Healthy.
- Capture fresh evidence.

### P2 — Complete observability
- Build a node filesystem usage panel from available Node Exporter metrics.
- Configure and test a Grafana contact point and notification policy.
- Export dashboard JSON and alert definitions into version control.
- Enable persistent Loki storage and define retention.

### P3 — Security
- Triage HIGH Trivy CVEs and rebuild/rescan.
- Keep security scans as required PR checks.
- Validate NetworkPolicy using a CNI that enforces policies and test both allowed/blocked flows.
- Pin Actions and base images to reviewed versions/digests.

### P4 — Operations
- Add runbooks for OOMKilled, unready Pods, Loki ingestion and Prometheus target failures.
- Document resource sizing, retention, backup and recovery.
- Define service-level indicators and alert thresholds.

This is a local assessment/demo implementation, not a production-ready platform.
