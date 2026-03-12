# Swiss AI Center documentation

The Swiss AI Center project documentation. Website available at
<https://docs.swiss-ai-center.ch>.

## Local development with Docker Compose (recommended)

To improve the documentation locally, run
[Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) with the
following commands:

```sh
# Build the Docker container
docker compose build

# Start the Docker container
docker compose up serve
```

You can now access the local development server at <http://localhost:8000>.

If you make changes to the documentation, the web page should reload.

## Local development with Python

To improve the documentation locally, run
[Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) with the
following commands:

```sh
# Install all dependencies for Material for MkDocs
sudo apt install --yes \
    libcairo2-dev \
    libfreetype6-dev \
    libffi-dev \
    libjpeg-dev \
    libpng-dev \
    libz-dev

```

You can now access the local development server at <http://localhost:8000>.

If you make changes to the documentation, the web page should reload.

## Format the documentation with Docker Compose (recommended)

To format the Markdown documentation, run
[mdwrap](https://github.com/swiss-ai-center/mdwrap) with the following commands:

```sh
# Build the Docker container
docker compose build

# Start the Docker container
docker compose up format
```

## Format the documentation with Python

To format the Markdown documentation, run
[mdwrap](https://github.com/swiss-ai-center/mdwrap) with the following commands:

```sh
# Install uv with pip (Python 3.12)
python3.12 -m pip install --upgrade uv

# Sync dependencies from pyproject.toml into .venv
uv sync --python 3.12 --all-groups

# Run mdwrap
uv run mdwrap --fmt .
```

## Preview presentation:

To preview the presentation, run

```bash
docker run --rm -p 8080:8080 \
  -v "$PWD":/home/marp/app \
  -w /home/marp/app \
  marpteam/marp-cli:v3.0.2 \
  --config .github/workflows/marp.config.js \
  --html --server --watch -I presentation
```
