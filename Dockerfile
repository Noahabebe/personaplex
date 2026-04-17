FROM python:3.12-slim AS base

# Install system deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libopus-dev \
 && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app/moshi/

# Copy project
COPY moshi/ /app/moshi/

# Create virtual env
RUN uv venv /app/moshi/.venv --python 3.12

# 🔑 Force CPU PyTorch BEFORE syncing
 Force CPU torch FIRST
RUN uv pip install torch --index-url https://download.pytorch.org/whl/cpu

# Then install rest
RUN uv sync --no-dev

# SSL dir
RUN mkdir -p /app/ssl

EXPOSE 8998

CMD ["/app/moshi/.venv/bin/python", "-m", "moshi.server", "--ssl", "/app/ssl"]
