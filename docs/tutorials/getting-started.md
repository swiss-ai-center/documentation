# Getting started

Welcome to the Swiss AI Center getting started guide!

This guide will help you to get started with the Swiss AI Center projects.

## Prerequisites

In order to run the Swiss AI Center projects locally, you will need to install
the following tools:

- [An IDE](#install-an-ide)
- [Docker and Docker Compose](#install-docker-and-docker-compose)
- [Git](#install-git)
- [minikube (optional)](#install-minikube-optional)
- [Python](#install-python)

### Install an IDE

(e.g. [PyCharm](https://www.jetbrains.com/pycharm/) or
[Visual Studio Code](https://code.visualstudio.com/))

TODO

### Install Docker and Docker Compose

TODO

[Docker](https://docker.com/)
_"delivers software in packages called containers"_. Follow the
[_Install Docker Engine_ - docs.docker.com](https://docs.docker.com/engine/install/)
guide to install and configure Docker.

### Install Git

TODO

### Install minikube (optional)

!!! info
    This is only required if you want to run the Core engine locally using
    Kubernetes.

TODO

[minikube](https://minikube.sigs.k8s.io/)
_"quickly sets up a local Kubernetes cluster on macOS, Linux, and Windows"_.
Follow the
[_Get Started!_ - minikube.sigs.k8s.io](https://minikube.sigs.k8s.io/docs/start/)
guide to install and configure minikube.

### Install Python

TODO

## Follow the tutorials

The tutorials will guide you through the Swiss AI Center projects and help you
understand the concepts behind them.

### Start the Core engine

- [Start the Core engine](./start-the-core-engine.md)

### Create new services

- [Create a service to rotate an image (generic template)](./create-a-service-to-rotate-an-image.md)
- [Create a service to summarize a text using an existing model (generic template)](./create-a-service-to-summarize-a-text-using-an-existing-model.md)
- [Create a service to detect anomalies using a model built from scratch (model from scratch template)](./create-a-service-to-detect-anomalies-using-a-model-built-from-scratch.md)

### Create pipelines

- [Create a pipeline that blurs faces in an image](./create-a-pipeline-that-blurs-faces-in-an-image.md)

## Go further

Once you have a good understanding of the Swiss AI Center projects, you can
start to create your own services! The
[How-to guides](../how-to-guides/index.md) will help you in the process.

The [Reference](../reference/index.md) page contains all the projects we manage
at the Swiss AI Center.

The [Explanations](../explanations/index.md) page contains all the explanations
about the technologies/framework/workflows we use at the Swiss AI Center.

---

Move these to "About Kubernetes" page

## Kubernetes tips

To visualize pods (= containers), use the following command.

```sh
# View pods
kubectl get pods
```

To visualize pod's logs, use the following command.

```sh
# View pod's logs
kubectl logs <name of the pod>

# or

# Follow the pod's logs (CTRL+C to exit)
kubectl logs --follow <name of the pod>
```

## Start minikube

In order to start minikube, execute the following command.

```sh
# Start minikube
minikube start
```

Validate minikube has successfully started with the following command.

```sh
# Validate minikube has started
kubectl get pods --all-namespaces
```

## Start the Core engine

_Follow the instructions described in the [Core engine documentation - Run locally using Kubernetes (with minikube) and official Docker images](../reference/core-engine.md)._

## Start a machine learning service

A machine learning service is a service that will register to the Core engine in
order to accept tasks to execute.

Refer to the [Services](../reference/index.md#services) documentation for all
the available machine learning backend services.
