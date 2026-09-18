# Stage 1: Builder
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt


# Stage 2: Runtime
FROM python:3.12-slim

WORKDIR /app

# Create a non-root user
RUN useradd --create-home appuser

# Copy the virtual environment
COPY --from=builder /opt/venv /opt/venv

# Copy application
COPY app.py .

# Use the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Run as non-root user
USER appuser

EXPOSE 5000

# Container health check
HEALTHCHECK --interval=30s --timeout=5s \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
