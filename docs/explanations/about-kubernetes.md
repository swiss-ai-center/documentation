# About Kubernetes

As the website of [Kubernetes](https://kubernetes.io/) mentions:

!!! quote

    Kubernetes, also known as K8s, is an open-source system for automating
    deployment, scaling, and management of containerized applications.

## How and why do we use Kubernetes

We use Kubernetes to deploy and host our platform on our provider.

## Access Kubernetes

To access [HEIA-FR](./about-heia-fr.md) Kubernetes cluster, ask a team member.

## Configuration

_None._

## Common tasks

### Visualize pods

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

## Resources and alternatives

These resources and alternatives are related to the current item (in
alphabetical order).

_None at the moment._
