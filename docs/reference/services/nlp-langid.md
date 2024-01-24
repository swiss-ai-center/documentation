# nlp-langid

- [:material-account-group: Main author - HEIA-FR](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/nlp-langid-service)
- [:material-kubernetes: Deployment configuration](https://github.com/swiss-ai-center/nlp-langid-service/tree/main/model-serving/kubernetes)
- [:material-test-tube: Staging](https://langid-swiss-ai-center.kube.isc.heia-fr.ch)
- [:material-factory: Production (not available yet)](https://langid.swiss-ai-center.ch)

The purpose of a language identification service (in short langid) is to detect which language is present in a snippet of text. The detection usually works well starting from a couple of phrases, so there is no need to input a whole 100 pages document to this service. If multiple languages are present in the input text, then the detection will output the most present language. To be noted that some languages are closer than other, e.g. the latin based languages.

The current langid model is here based on a naive bayes implementation multiplying n-gram probabilities, and assuming equal a priori probabilities for each languages. To simplify the implementation, n is here fixed for a given model. n-grams are produced simply sliding a window of length n on the input string. Tests have shown that 3-grams are providing satisfying results up to at least 10 languages. Once the models are loaded, computation is quite fast, basically O(1) for 1 n-gram as it is simple lookups in dictionaries to retrieve the probabilities. The computation time is only proportional to the length of the string and the number of languages in the model set, which is very much reasonable.

The list of languages that can be identified are in dir src/trained_models and currently includes en, de, es, fr, it, nl, pl, pt, ru, tr and dialect de-CH.

The API documentation is automatically generated by FastAPI using the OpenAPI
standard. A user friendly interface provided by Swagger is available under the
`/docs` route, where the endpoints of the service are described.

This simple service only has one route `/compute` that takes an image as input,
which will be analyzed.

## Environment variables

All environment variables are described in the
[`.env`](https://github.com/swiss-ai-center/nlp-langid/blob/main/.env) file.

The environment variables can be overwritten during the CI/CD pipeline described
in the
[`nlp-langid.yml`](https://github.com/swiss-ai-center/nlp-langid/blob/main/.github/workflows/nlp-langid.yml)
GitHub workflow file.

## Start the service locally with Python

In the `nlp-langid` directory, start the service with the following commands.

```sh
# Generate the virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Install the requirements
pip install \
    --requirement requirements.txt \
    --requirement requirements-all.txt
```

Start the application.

```sh
# Switch to the `src` directory
cd src

# Start the application
uvicorn --reload --port 9090 main:app
```

Access the service documentation on <http://localhost:9090/docs>.

## Run the tests with Python

For each module a test file is available to check the correct behavior of the
code. The tests are run using the `pytest` library with code coverage check. To
run the tests, use the following command inside the `nlp-langid` folder:

```sh
pytest --cov-report term:skip-covered --cov-report term-missing --cov=. -s --cov-config=.coveragerc
```

## Start the service locally with minikube and the Docker image hosted on GitHub

Start the service with the following commands. This will start the service with
the official Docker images that are hosted on GitHub.

In the `nlp-langid` directory, start the service with the following commands.

```sh
# Start the nlp-langid backend
kubectl apply \
    -f kubernetes/config-map.yml \
    -f kubernetes/stateful.yml \
    -f kubernetes/service.yml
```

Create a tunnel to access the Kubernetes cluster from the local machine. The
terminal in which the tunnel is created must stay open.

```sh
# Open a tunnel to the Kubernetes cluster
minikube tunnel --bind-address 127.0.0.1
```

Access the `nlp-langid` documentation on <http://localhost:9090/docs>.

Access the Core engine documentation on <http://localhost:8080/docs> to validate
the backend has been successfully registered to the Core engine.

## Start the service locally with minikube and a local Docker image

**Note**: The service StatefulSet (`stateful.yml` file) must be deleted
and recreated every time a new Docker image is created.

Start the service with the following commands. This will start the service with
the a local Docker image for the service.

In the `nlp-langid` directory, build the Docker image with the following commands.

```sh
# Access the Minikube's Docker environment
eval $(minikube docker-env)

# Build the Docker image
docker build -t ghcr.io/swiss-ai-center/nlp-langid-service:latest .

# Exit the Minikube's Docker environment
eval $(minikube docker-env -u)

# Edit the `kubernetes/stateful.yml` file to use the local image by uncommented the line `imagePullPolicy`
#
# From
#
#        # imagePullPolicy: Never
#
# To
#
#        imagePullPolicy: Never
```

In the `nlp-langid` directory, start the service with the following commands.

```sh
# Start the nlp-langid backend
kubectl apply \
    -f kubernetes/config-map.yml \
    -f kubernetes/stateful.yml \
    -f kubernetes/service.yml
```

Create a tunnel to access the Kubernetes cluster from the local machine. The
terminal in which the tunnel is created must stay open.

```sh
# Open a tunnel to the Kubernetes cluster
minikube tunnel --bind-address 127.0.0.1
```

Access the `nlp-langid` documentation on <http://localhost:9090/docs>.

Access the Core engine documentation on <http://localhost:8080/docs> to validate
the backend has been successfully registered to the Core engine.