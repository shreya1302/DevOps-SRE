
FROM python:3.12-slim-trixie

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN useradd --system --no-create-home appuser

COPY --chown=appuser:appuser app/app.py ./app.py

USER appuser

LABEL org.opencontainers.image.description="DevOps-SRE application"

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/healthcheck', timeout=3)"]

CMD ["python", "-u", "app.py"]
