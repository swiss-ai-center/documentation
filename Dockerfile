# Base image
FROM python:3.11

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

# Copy the dependencies
COPY requirements.txt .
COPY requirements-all.txt .

# Install Python dependencies
RUN pip install \
    --requirement requirements.txt \
    --requirement requirements-all.txt
