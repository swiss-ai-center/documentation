# chatbot-ollama

- [:material-account-group: Main author - HE-Arc](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/chatbot-ollama-service)
- [:material-kubernetes: Deployment configuration](https://github.com/swiss-ai-center/chatbot-ollama-service/tree/main/kubernetes)
- [:material-test-tube: Staging](https://chatbot-ollama-swiss-ai-center.kube.isc.heia-fr.ch/)
- [:material-factory: Production (not available yet)](https://chatbot-ollama.swiss-ai-center.ch/)

## Description

This service is a streamlit interface to interact with a large language model
using the [ollama API](https://ollama.ai/) and langchain.

Ollama is an open source project that aims to provide a simple and easy to use
app to download and use LLM models like llama2 or mistral locally.

On the [Ollama official website](https://ollama.ai/), you can find the list of
available models and the link to the
[github repository](https://github.com/jmorganca/ollama).

Before using this service, you need to vectorize a pdf document using the
[document-vectorizer service](../reference/services/document-vectorizer.md).

## Environment variables

All environment variables are described in the
[`.env`](https://github.com/swiss-ai-center/chatbot-ollama-service/blob/main/.env)
file.

The environment variables can be overwritten during the CI/CD pipeline described
in the
[`workflow.yml`](https://github.com/swiss-ai-center/chatbot-ollama-service/blob/main/.github/workflows/workflow.yml)
GitHub workflow file.

## Start the service locally with Python

In the `chatbot-ollama` directory, start the service with the following
commands.

```sh
# Generate the virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Install the requirements
pip install /code[ui]
```

Start the application.

```sh
# Start the application
streamlit run app/app.py --server.port 80
```

Access the service app on <http://localhost:80>.

## Start the service locally with minikube and the Docker image hosted on GitHub

Start the service with the following commands. This will start the service with
the official Docker images that are hosted on GitHub.

In the `chatbot-ollama` directory, start the service with the following
commands.

```sh
# Start the chatbot-ollama
kubectl apply \
    -f kubernetes/chatbot-ollama.config-map.yml \
    -f kubernetes/chatbot-ollama.stateful.yml \
    -f kubernetes/chatbot-ollama.service.yml
```

Create a tunnel to access the Kubernetes cluster from the local machine. The
terminal in which the tunnel is created must stay open.

```sh
# Open a tunnel to the Kubernetes cluster
minikube tunnel --bind-address 127.0.0.1
```

Access the `chatbot-ollama` app on <http://localhost:9090/>.

Then you must use the document-vectorizer service to vectorize a pdf document
before using the chatbot-ollama app. See the
[document-vectorizer service](../reference/services/document-vectorizer.md#start-the-service-locally-with-minikube-and-the-docker-image-hosted-on-github)
documentation to deploy it locally.

### Deploy ollama locally

add the following container to the `chatbot-ollama.stateful` deployment file

```yaml
- name: ollama
image: ollama/ollama
ports:
- name: http
    containerPort: 11434
command: ["/bin/bash", "-c"]
args:
- |
    ollama serve &
    sleep 10
    ollama pull mistral:instruct
    sleep infinity
resources:
    requests:
    tencent.com/vcuda-core: 20
    tencent.com/vcuda-memory: 8
    limits:
    tencent.com/vcuda-core: 20
    tencent.com/vcuda-memory: 8
```

## Start the service locally with minikube and a local Docker image

**Note**: The service StatefulSet (`chatbot-ollama.stateful.yml` file) must be
deleted and recreated every time a new Docker image is created.

Start the service with the following commands. This will start the service with
the a local Docker image for the service.

In the `chatbot-ollama` directory, build the Docker image with the following
commands.

```sh
# Access the Minikube's Docker environment
eval $(minikube docker-env)

# Build the Docker image
docker build -t ghcr.io/swiss-ai-center/chatbot-ollama-service:latest .

# Exit the Minikube's Docker environment
eval $(minikube docker-env -u)

# Edit the `kubernetes/chatbot-ollama.stateful.yml` file to use the local image by uncommented the line `imagePullPolicy`
#
# From
#
#        # imagePullPolicy: Never
#
# To
#
#        imagePullPolicy: Never
```

In the `chatbot-ollama` directory, start the service with the following
commands.

```sh
# Start the chatbot-ollama
kubectl apply \
    -f kubernetes/chatbot-ollama.config-map.yml \
    -f kubernetes/chatbot-ollama.stateful.yml \
    -f kubernetes/chatbot-ollama.service.yml
```

Create a tunnel to access the Kubernetes cluster from the local machine. The
terminal in which the tunnel is created must stay open.

```sh
# Open a tunnel to the Kubernetes cluster
minikube tunnel --bind-address 127.0.0.1
```

Access the `chatbot-ollama` app on <http://localhost:9090/docs>.

Access the Core engine documentation on <http://localhost:8080/docs> to validate
the backend has been successfully registered to the Core engine.
