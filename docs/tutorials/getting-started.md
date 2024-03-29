# Getting started

Welcome to the Swiss AI Center getting started guide!

This guide will help you to get started with the Swiss AI Center projects.

## Prerequisites

In order to run the Swiss AI Center projects locally, you will need to install
the following tools:

- [Prerequisites](#prerequisites)
  - [Install an IDE](#install-an-ide)
  - [Install Docker and Docker Compose](#install-docker-and-docker-compose)
  - [Install Git](#install-git)
  - [Install minikube (optional)](#install-minikube-optional)
  - [Install Python](#install-python)
- [Follow the tutorials](#follow-the-tutorials)
  - [Start the Core engine](#start-the-core-engine)
  - [Create new services](#create-new-services)
  - [Create pipelines](#create-pipelines)
- [Go further](#go-further)

### Install an IDE

(e.g. [PyCharm](https://www.jetbrains.com/pycharm/) or
[Visual Studio Code](https://code.visualstudio.com/))

An Integrated Development Environment (IDE) is a software application that
provides comprehensive facilities to computer programmers for software
development.

The following IDEs are recommended for Python development:

- [PyCharm](https://www.jetbrains.com/help/pycharm/installation-guide.html)
  _"The Python IDE for Professional Developers"_
- [Visual Studio Code](https://code.visualstudio.com/download)
  _"Free. Open source. Runs everywhere."_

### Install Docker and Docker Compose

[Docker](https://docker.com/)
_"delivers software in packages called containers"_.

Follow the
[_Install Docker Engine_ - docs.docker.com](https://docs.docker.com/engine/install/)
guide to install and configure Docker.

### Install Git

Git is a free and open-source distributed version control system designed to
handle everything from small to very large projects with speed and efficiency.

Follow the
[_Git installation tutorial_ - github.com](https://github.com/git-guides/install-git)
to install and configure Git.

### Install minikube (optional)

!!! info

    This is only required if you want to run the Core engine locally using
    Kubernetes.

[minikube](https://minikube.sigs.k8s.io/)
_"quickly sets up a local Kubernetes cluster on macOS, Linux, and Windows"_.

Follow the
[_Get Started!_ - minikube.sigs.k8s.io](https://minikube.sigs.k8s.io/docs/start/)
guide to install and configure minikube.

### Install Python

Follow the
[_Python installation tutorial_ - realpython.com](https://realpython.com/installing-python/)
to install and configure Python.

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
