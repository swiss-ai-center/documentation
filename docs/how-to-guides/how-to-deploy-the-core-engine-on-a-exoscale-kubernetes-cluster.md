# How to deploy the Core engine on a Exoscale Kuburnetes cluster

This guide will help you to deploy the Core engine on a Exoscale Kubernetes
cluster.

## Guide

### Install and configure the Exoscale CLI

Install and configure the Exoscale CLI by following the instructions in the
official documentation at <https://community.exoscale.com/documentation/tools/exoscale-command-line-interface/#installation> and <https://community.exoscale.com/documentation/tools/exoscale-command-line-interface/#configuration>.

### Install kubectl

Install kubectl by following the instructions in the
[official documentation](https://kubernetes.io/docs/tasks/tools/#kubectl).

### Create a Kubernetes cluster

Create a Kubernetes cluster by executing the following commands (inspired by the
[official documentation](https://community.exoscale.com/documentation/kubernetes/quickstart/)):

```sh title="Execute the following command(s) in a terminal"
# Create the security group
exo compute security-group create swiss-ai-center-prod-security-group

# Allow NodePort services
exo compute security-group rule add swiss-ai-center-prod-security-group \
    --description "NodePort services" \
    --protocol tcp \
    --network 0.0.0.0/0 \
    --port 30000-32767

# Allow SKS kubelet
exo compute security-group rule add swiss-ai-center-prod-security-group \
    --description "SKS kubelet" \
    --protocol tcp \
    --port 10250 \
    --security-group swiss-ai-center-prod-security-group

# Allow Calico traffic
exo compute security-group rule add swiss-ai-center-prod-security-group \
    --description "Calico traffic" \
    --protocol udp \
    --port 4789 \
    --security-group swiss-ai-center-prod-security-group

# Create the Kubernetes cluster
exo compute sks create swiss-ai-center-prod-cluster \
    --zone ch-gva-2 \
    --service-level pro \
    --nodepool-name swiss-ai-center-prod-nodepool-1 \
    --nodepool-size 2 \
    --nodepool-disk-size 20 \
    --nodepool-instance-type "standard.small" \
    --nodepool-security-group swiss-ai-center-prod-security-group

# Validate the creation of the Kubernetes cluster
exo compute sks list

# Get the kubeconfig file
exo compute sks kubeconfig swiss-ai-center-prod-cluster kube-admin > exoscale.kubeconfig

# Validate kubectl can access the Kubernetes cluster
kubectl --kubeconfig exoscale.kubeconfig \
    get node
```

#### Install Nginx Ingress Controller

Install Nginx Ingress Controller by executing the following commands (inspired
by the
[official documentation](https://kubernetes.github.io/ingress-nginx/deploy/#exoscale)
and the
[official Exoscale documentation](https://community.exoscale.com/documentation/sks/loadbalancer-ingress/)):

```sh title="Execute the following command(s) in a terminal"
# Install the Nginx Ingress Controller
kubectl --kubeconfig exoscale.kubeconfig \
    apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/exoscale/deploy.yaml

# Validate the installation
kubectl --kubeconfig exoscale.kubeconfig \
    get pods -n ingress-nginx \
    -l app.kubernetes.io/name=ingress-nginx --watch

# Get the external IP address of the Nginx Ingress Controller
kubectl --kubeconfig exoscale.kubeconfig \
    get svc -n ingress-nginx
```

### Configure the DNS zone

Add an `A` record to your DNS zone to point to the Nginx Ingress Controller
external IP address. You can use a wildcard `*.swiss-ai-center.ch` (for example)
`A` record to point to the Nginx Ingress Controller external IP address.

### Install and configure cert-manager

Install cert-manager by executing the following commands (inspired by the
[official documentation](https://cert-manager.io/docs/installation/kubectl/)):

```sh title="Execute the following command(s) in a terminal"
# Install cert-manager
kubectl --kubeconfig exoscale.kubeconfig \
    apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml

# Validate the installation
kubectl --kubeconfig exoscale.kubeconfig \
    get pods -n cert-manager --watch
```

#### Configure Let's Encrypt issuer with HTTP-01 challenge

```sh title="Execute the following command(s) in a terminal"
# Create a Let's Encrypt issuer
cat <<EOF > letsencrypt-issuer.yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: monitor@swiss-ai-center.ch
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt
    # Enable the HTTP-01 challenge provider
    solvers:
      - http01:
          ingress:
            ingressClassName: nginx
EOF

# Deploy the Let's Encrypt issuer
kubectl --kubeconfig exoscale.kubeconfig \
    apply -f letsencrypt-issuer.yaml

# Validate the deployment
kubectl --kubeconfig exoscale.kubeconfig \
    describe issuer letsencrypt
```

#### Deploy a dummy pod to validate the Kubernetes cluster configuration

Deploy a dummy pod to validate the Kubernetes cluster configuration by executing
the following commands:

```sh title="Execute the following command(s) in a terminal"
# Create the Kubernetes configuration file
cat <<EOF > dummy-pod.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: hello
  name: hello
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
        - image: nginxdemos/hello:plain-text
          name: hello
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: hello
  name: hello
spec:
  ports:
    - port: 80
      protocol: TCP
      targetPort: 80
  selector:
    app: hello
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello
  annotations:
    cert-manager.io/issuer: "letsencrypt"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - hello.swiss-ai-center.ch
      secretName: hello-tls
  rules:
    - host: hello.swiss-ai-center.ch
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hello
                port:
                  number: 80
EOF

# Deploy the dummy pod
kubectl --kubeconfig exoscale.kubeconfig \
    apply -f dummy-pod.yaml

# Validate the deployment
curl http://hello.swiss-ai-center.ch
```

The output should be similar to the following:

```text
Server address: 192.168.21.198:80
Server name: hello-7766f96cd-s57xz
Date: 13/Mar/2024:10:34:34 +0000
URI: /
Request ID: caabe951ce74b20c70460b9a1705b88e
```

#### Configure Let's Encrypt issuer with DNS-01 challenge

This configuration uses Infomaniak as the DNS provider. You must change the
`dns01` section to match your DNS provider.

https://github.com/Infomaniak/cert-manager-webhook-infomaniak

```sh title="Execute the following command(s) in a terminal"
# Install Infomaniak webhook
kubectl --kubeconfig exoscale.kubeconfig \
    apply -f https://github.com/infomaniak/cert-manager-webhook-infomaniak/releases/download/v0.2.0/rendered-manifest.yaml

# Export the Infomaniak API key
export INFOMANIAK_TOKEN=your-api-key

# Create a secret with the Infomaniak API key
cat <<EOF | kubectl apply --kubeconfig exoscale.kubeconfig -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: infomaniak-api-credentials
  namespace: cert-manager
type: Opaque
data:
  api-token: $(echo -n $INFOMANIAK_TOKEN|base64 -w0)
EOF

# Create a Let's Encrypt issuer
cat <<EOF > letsencrypt-issuer.yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: monitor@swiss-ai-center.ch
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt
    # Enable the DNS-01 challenge provider
    solvers:
      - dns01:
        webhook:
          groupName: acme.infomaniak.com
          solverName: infomaniak
          config:
            apiTokenSecretRef:
              name: infomaniak-api-credentials
              key: api-token
EOF

# Deploy the Let's Encrypt issuer
kubectl --kubeconfig exoscale.kubeconfig \
    apply -f letsencrypt-issuer.yaml

# Validate the deployment
kubectl --kubeconfig exoscale.kubeconfig \
    describe issuer letsencrypt
```




cat <<EOF | kubectl apply --kubeconfig exoscale.kubeconfig -f -
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: swiss-ai-center-ch
spec:
  secretName: swiss-ai-center-ch-tls
  issuerRef:
    name: letsencrypt
    kind: ClusterIssuer
  dnsNames:
  - 'hello2.swiss-ai-center.ch'
EOF

#### Deploy a dummy pod to validate the Kubernetes cluster configuration

Deploy a dummy pod to validate the Kubernetes cluster configuration by executing
the following commands:

```sh title="Execute the following command(s) in a terminal"
# Create the Kubernetes configuration file
cat <<EOF > dummy-pod.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: hello
  name: hello
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
        - image: nginxdemos/hello:plain-text
          name: hello
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: hello
  name: hello
spec:
  ports:
    - port: 80
      protocol: TCP
      targetPort: 80
  selector:
    app: hello
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello
  annotations:
    cert-manager.io/issuer: "letsencrypt"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - hello.swiss-ai-center.ch
  rules:
    - host: hello.swiss-ai-center.ch
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hello
                port:
                  number: 80
EOF

# Deploy the dummy pod
kubectl --kubeconfig exoscale.kubeconfig \
    apply -f dummy-pod.yaml

# Validate the deployment
curl http://hello.swiss-ai-center.ch
```

The output should be similar to the following:

```text
Server address: 192.168.21.198:80
Server name: hello-7766f96cd-s57xz
Date: 13/Mar/2024:10:34:34 +0000
URI: /
Request ID: caabe951ce74b20c70460b9a1705b88e
```

### Create a PostgreSQL database

Create a PostgreSQL database by executing the following commands (inspired by the
[official documentation](https://community.exoscale.com/documentation/dbaas/quick-start/)):

```sh title="Execute the following command(s) in a terminal"
# Create a PostgreSQL database
exo dbaas create pg hobbyist-2 core-engine-prod-database --zone ch-gva-2

# Get the connection string
exo dbaas --zone ch-gva-2 show core-engine-prod-database --uri
```

### Create a S3 bucket

Create a S3 bucket by executing the following commands (inspired by the
[official documentation](https://community.exoscale.com/documentation/object-storage/quick-start/#create-a-bucket)):

```sh title="Execute the following command(s) in a terminal"
# Create a S3 bucket
exo storage mb --zone ch-gva-2 sos://core-engine-prod-bucket

# Validate the creation of the S3 bucket
exo storage ls --zone ch-gva-2
```

### Update the Core engine GitHub Actions configuration

### Deploy the Core engine

### Deploy a service

## Related explanations

These explanations are related to the current item (in alphabetical order).

_None at the moment._

## Resources

These resources are related to the current item (in alphabetical order).

_None at the moment._
