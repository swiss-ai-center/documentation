# About minikube

As the website of [minikube](https://minikube.sigs.k8s.io/docs/) mentions:

!!! quote

    minikube quickly sets up a local Kubernetes cluster on macOS, Linux, and
    Windows. We proudly focus on helping application developers and new Kubernetes
    users.

## How and why do we use minikube

We use minikube to deploy our platform locally for development purposes.

## Configuration

_None._

## Common tasks

### Install minikube

Install minikube with the official documentation accessible at
<https://minikube.sigs.k8s.io/docs/start/>

### Start minikube

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

## Resources and alternatives

These resources and alternatives are related to the current item (in
alphabetical order).

_None at the moment._
