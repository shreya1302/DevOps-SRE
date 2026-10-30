FROM python:3.12-slim-trixie

WORKDIR /app

RUN apt-get update && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN useradd --system --no-create-home appuser

COPY --chown=appuser:appuser app/app.py ./app.py

USER appuser

LABEL org.opencontainers.image.description="DevOps-SRE application release 3"

EXPOSE 8080

CMD ["python", "-u", "app.py"]
