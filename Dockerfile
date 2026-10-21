
FROM python:3.12-slim-trixie

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN useradd --system --no-create-home appuser

COPY --chown=appuser:appuser app/app.py ./app.py

USER appuser

EXPOSE 8080

CMD ["python", "-u", "app.py"]
