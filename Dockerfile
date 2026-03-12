# Base image
FROM python:3.12

# Working directory
WORKDIR /workspaces/swiss-ai-center

# Add mkdocs dependencies
RUN apt update && apt install --yes \
    libcairo2-dev \
    libfreetype6-dev \
    libffi-dev \
    libjpeg-dev \
    libpng-dev \
    libz-dev

# Install uv
RUN pip install --no-cache-dir uv
