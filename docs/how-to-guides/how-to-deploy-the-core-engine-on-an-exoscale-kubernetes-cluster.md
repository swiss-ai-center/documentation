# How to deploy the Core engine on an Exoscale Kubernetes cluster

This guide will help you to deploy the Core engine on an Exoscale Kubernetes
cluster.

## Guide

### Install and configure required tools

#### Exoscale CLI

Install and configure the Exoscale CLI by following the instructions in the
official documentation:

 - <https://community.exoscale.com/documentation/tools/exoscale-command-line-interface/#installation>

 - <https://community.exoscale.com/documentation/tools/exoscale-command-line-interface/#configuration>.

#### kubectl

Install kubectl by following the instructions in the official documentation at
<https://kubernetes.io/docs/tasks/tools/#kubectl>.

### Create and configure a Kubernetes cluster

#### Create a Kubernetes cluster

Create a Kubernetes cluster by executing the following commands (inspired by the
official documentation at
<https://community.exoscale.com/documentation/kubernetes/quickstart/>):

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

# Display the Kubernetes cluster configuration
cat exoscale.kubeconfig

# Validate kubectl can access the Kubernetes cluster
kubectl --kubeconfig exoscale.kubeconfig \
    get node
```

#### Install Nginx Ingress Controller

Install Nginx Ingress Controller by executing the following commands (inspired
by the official documentation at
<https://kubernetes.github.io/ingress-nginx/deploy/#exoscale> and the official
Exoscale documentation at
<https://community.exoscale.com/documentation/sks/loadbalancer-ingress/>):

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

#### Check if overlay network is functioning correctly

Check if overlay network is functioning correctly by executing the following
commands (inspired by the documentation at
<https://ranchermanager.docs.rancher.com/v2.8/troubleshooting/other-troubleshooting-tips/networking#check-if-overlay-network-is-functioning-correctly>):

```sh
# Save the overlaytest manifest
cat <<EOF > overlaytest.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: overlaytest
spec:
  selector:
      matchLabels:
        name: overlaytest
  template:
    metadata:
      labels:
        name: overlaytest
    spec:
      tolerations:
      - operator: Exists
      containers:
      - image: rancherlabs/swiss-army-knife
        imagePullPolicy: Always
        name: overlaytest
        command: ["sh", "-c", "tail -f /dev/null"]
        terminationMessagePath: /dev/termination-log
EOF

# Launch it
kubectl --kubeconfig exoscale.kubeconfig \
    create -f overlaytest.yaml

# Check the status - it should return `daemon set "overlaytest" successfully rolled out`.
kubectl --kubeconfig exoscale.kubeconfig \
    rollout status ds/overlaytest --watch

# Ping each `overlaytest` container on every host
echo "=> Start network overlay test"
  kubectl --kubeconfig exoscale.kubeconfig get pods -l name=overlaytest -o jsonpath='{range .items[*]}{@.metadata.name}{" "}{@.spec.nodeName}{"\n"}{end}' |
  while read spod shost
    do kubectl --kubeconfig exoscale.kubeconfig get pods -l name=overlaytest -o jsonpath='{range .items[*]}{@.status.podIP}{" "}{@.spec.nodeName}{"\n"}{end}' |
    while read tip thost
      do kubectl --kubeconfig exoscale.kubeconfig --request-timeout='10s' exec $spod -c overlaytest -- /bin/sh -c "ping -c2 $tip > /dev/null 2>&1"
        RC=$?
        if [ $RC -ne 0 ]
          then echo FAIL: $spod on $shost cannot reach pod IP $tip on $thost
          else echo $shost can reach $thost
        fi
    done
  done
echo "=> End network overlay test"
```

The output should be similar to the following:

```text
=> Start network overlay test
pool-79a73-lnamo can reach pool-79a73-lnamo
pool-79a73-lnamo can reach pool-79a73-wnliz
pool-79a73-wnliz can reach pool-79a73-lnamo
pool-79a73-wnliz can reach pool-79a73-wnliz
=> End network overlay test
```

If you see error in the output, there is some issue with the route between the
pods on the two hosts. This could be because the required ports for overlay
networking are not opened.

You can now clean up the DaemonSet by running the following command:

```sh title="Execute the following command(s) in a terminal"
# Delete the DaemonSet
kubectl --kubeconfig exoscale.kubeconfig \
  delete ds/overlaytest
```

#### Configure the DNS zone

Add an `A` record to your DNS zone to point to the Nginx Ingress Controller
external IP address. You can use a wildcard `*.swiss-ai-center.ch` (for example)
`A` record to point to the Nginx Ingress Controller external IP address.

#### Install and configure cert-manager

Install cert-manager by executing the following commands (inspired by the
official documentation at <https://cert-manager.io/docs/installation/kubectl/>):

```sh title="Execute the following command(s) in a terminal"
# Install cert-manager
kubectl --kubeconfig exoscale.kubeconfig \
    apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml

# Validate the installation
kubectl --kubeconfig exoscale.kubeconfig \
    get pods -n cert-manager --watch
```

#### Configure Let's Encrypt issuer

=== "With HTTP-01 challenge"

    Configure Let's Encrypt issuer with HTTP-01 challenge by executing the following
    commands (inspired by the official documentation at
    <https://cert-manager.io/docs/configuration/acme/> and the tutorial at
    <https://cert-manager.io/docs/tutorials/acme/nginx-ingress/>):

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

=== "With DNS-01 challenge (Infomaniak)"

    !!! warning

        This is a work in progress. It has not been tested yet.

    This configuration uses Infomaniak as the DNS provider. You must change the
    `dns01` section to match your DNS provider. Inspired by the official
    documentation at <https://cert-manager.io/docs/configuration/acme/dns01/> and
    <https://github.com/Infomaniak/cert-manager-webhook-infomaniak>.

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

### Deploy a dummy pod to validate the Kubernetes cluster configuration

Deploy a dummy pod to validate the Kubernetes cluster configuration (inspired by
the tutorial at <https://cert-manager.io/docs/tutorials/acme/nginx-ingress/>).

=== "With HTTP-01 challenge"

    Create the Kubernetes configuration file by executing the following command:

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
    ```

=== "With DNS-01 challenge (Infomaniak)"

    !!! warning

        This is a work in progress. It has not been tested yet.

    Create the Kubernetes configuration file by executing the following command:

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
    ```

Deploy the dummy pod by executing the following commands:

!!! info

    It can take a few minutes for the certificate to be issued.

```sh title="Execute the following command(s) in a terminal"
# Deploy the dummy pod
kubectl --kubeconfig exoscale.kubeconfig \
    apply -f dummy-pod.yaml

# Validate the deployment
curl https://hello.swiss-ai-center.ch
```

The output should be similar to the following:

```text
Server address: 192.168.21.198:80
Server name: hello-7766f96cd-s57xz
Date: 13/Mar/2024:10:34:34 +0000
URI: /
Request ID: caabe951ce74b20c70460b9a1705b88e
```

You can delete the dummy pod by executing the following command:

```sh title="Execute the following command(s) in a terminal"
# Delete the dummy pod
kubectl --kubeconfig exoscale.kubeconfig \
    delete -f dummy-pod.yaml
```

### Deploy the Core engine

#### Create a PostgreSQL database

Create a PostgreSQL database by executing the following commands (inspired by
the official documentation
<https://community.exoscale.com/documentation/dbaas/quick-start/>):

```sh title="Execute the following command(s) in a terminal"
# Create a PostgreSQL database
exo dbaas create pg hobbyist-2 core-engine-prod-database --zone ch-gva-2

# Validate the creation of the PostgreSQL database
exo dbaas --zone ch-gva-2 show core-engine-prod-database

# Get the PostgreSQL database URL
exo dbaas --zone ch-gva-2 show core-engine-prod-database --uri
```

#### Allow the Kubernetes cluster to access the PostgreSQL database

Allow the Kubernetes cluster to access the PostgreSQL database by executing the
following commands (inspired by the blog post at
<https://www.exoscale.com/syslog/sks-dbaas-terraform/> and the GitHub repository
at <https://github.com/exoscale-labs/sks-sample-manifests/>):

```sh title="Execute the following command(s) in a terminal"
# Create a new role for Kubernetes
exo iam role create k8s --policy '{"default-service-strategy":"deny","services":{"dbaas":{"type":"allow","rules":[]}}}'

# Create a new API key for Kubernetes
exo iam api-key create k8s-dbaas k8s

# Create a new secret for the API key
kubectl --kubeconfig exoscale.kubeconfig \
    -n kube-system create secret generic exoscale-k8s-dbaas-credentials \
    --from-literal=api-key='API_KEY' \
    --from-literal=api-secret='API_SECRET'

# Download the Kubernetes manifest
curl -o k8s-dbaas.yaml https://raw.githubusercontent.com/exoscale-labs/sks-sample-manifests/main/exo-k8s-dbaas-filter/exo-k8s-dbaas-filter.yaml

# Edit the Kubernetes manifest to use the correct API key and secret and database(s) name(s)
#
# Example:
#
# ```yaml
#         env:
#           - name: EXOSCALE_API_KEY
#             valueFrom:
#               secretKeyRef:
#                 key: api-key
#                 # change the name of the secret if necessary
#                 name: exoscale-k8s-dbaas-credentials
#           - name: EXOSCALE_API_SECRET
#             valueFrom:
#               secretKeyRef:
#                 key: api-secret
#                 # change the name of the secret if necessary
#                 name: exoscale-k8s-dbaas-credentials
# ```
#
# and
#
# `exo dbaas update --pg-ip-filter "$IPLISTFOREXO" core-engine-prod-database -z ch-gva-2`

# Deploy the Kubernetes manifest
kubectl --kubeconfig exoscale.kubeconfig \
    apply -f k8s-dbaas.yaml

# Validate the deployment
kubectl --kubeconfig exoscale.kubeconfig \
    get pods -n kube-system \
    -l app=exo-k8s-dbaas-filter --watch

# View the logs of the pod
kubectl --kubeconfig exoscale.kubeconfig \
    logs -n kube-system \
    -l app=exo-k8s-dbaas-filter
```

#### Create a S3 bucket

Create a S3 bucket by executing the following commands (inspired by the
[official documentation](https://community.exoscale.com/documentation/object-storage/quick-start/#create-a-bucket)):

```sh title="Execute the following command(s) in a terminal"
# Create a S3 bucket
exo storage mb --zone ch-gva-2 sos://core-engine-prod-bucket

# Validate the creation of the S3 bucket
exo storage ls --zone ch-gva-2
```

#### Allow the Core engine to access the S3 bucket

Allow the Core engine to access the S3 bucket by executing the following
commands:

```sh title="Execute the following command(s) in a terminal"
# Create a new role for the Core engine
exo iam role create core-engine --policy '{"default-service-strategy":"deny","services":{"sos":{"type":"allow","rules":[]}}}'

# Create a new API key for the Core engine
exo iam api-key create s3 core-engine
```

#### Update the Core engine GitHub Actions configuration

Update the Core engine GitHub Actions configuration by adding/updating the
following secrets:

!!! warning

    The `PROD_DATABASE_URL` must be saved with `postgresql://` protocol. The default
    value is `postgres://`.

- `PROD_KUBE_CONFIG`: The content of the Kubernetes configuration file (this is
  an Organization secret in our repository)
- `PROD_DATABASE_URL`: The URL of the PostgreSQL database
- `PROD_S3_ACCESS_KEY_ID`: The access key ID of the S3 bucket
- `PROD_S3_SECRET_ACCESS_KEY`: The secret access key of the S3 bucket
- `PROD_S3_HOST`: The host of the S3 bucket (ex: `https://sos-ch-gva-2.exo.io` -
  <https://community.exoscale.com/api/sos/>)

Update the Core engine GitHub Actions configuration by adding/updating the
following variables:

- `DEPLOY_PROD`: `true`
- `PROD_HOST`: The host of the Core engine backend
- `PROD_BACKEND_URL`: The URL of the Core engine backend used by the frontend
- `PROD_BACKEND_WS_URL`: The WebSocket URL of the Core engine backend used by
  the frontend
- `PROD_FRONTEND_HOST`: The URL of the Core engine frontend
- `PROD_S3_BUCKET`: The name of the S3 bucket
- `PROD_S3_REGION`: The region of the S3 bucket (ex: `ch-gva-2`)

#### Deploy the Core engine

Run the GitHub Actions workflow to deploy the Core engine.

#### Validate the deployment

Validate the deployment by executing the following commands:

```sh title="Execute the following command(s) in a terminal"
# Check the pods
kubectl --kubeconfig exoscale.kubeconfig \
    get pods

# Check the logs
kubectl --kubeconfig exoscale.kubeconfig \
    logs core-engine-backend-stateful-0
```

### Deploy a service

Deploying a service is similar to deploying the core engine. You need to update
the GitHub Actions configuration by adding/updating the following secrets:

- `PROD_KUBE_CONFIG`: The content of the Kubernetes configuration file (this is
  an Organization secret in our repository)

Update the GitHub Actions configuration by adding/updating the following
variables:

- `DEPLOY_PROD`: `true`
- `PROD_SERVICE_URL`: The URL of the service
- `SERVICE_NAME`: The name of the service

Run the GitHub Actions workflow to deploy the service.

#### Validate the deployment

Validate the deployment by executing the following commands:

```sh title="Execute the following command(s) in a terminal"
# Check the pods
kubectl --kubeconfig exoscale.kubeconfig \
    get pods

# Check the logs
kubectl --kubeconfig exoscale.kubeconfig \
    logs average-shade-stateful-0
```

### Scale the Kubernetes cluster node pools
At some point, if you deploy more services, you may need to scale the Kubernetes
cluster node pools. You can do this by executing the following commands:

```sh title="Execute the following command(s) in a terminal"
# Scale the Kubernetes cluster node pools to the double of the current size
exo compute sks nodepool update swiss-ai-center-prod-cluster swiss-ai-center-prod-nodepool-1 --size 4

# Validate the scaling of the Kubernetes cluster node pools
exo compute sks nodepool list swiss-ai-center-prod-cluster
```

If you only also wanted to change the instance type and/or disk size, you can do
this by executing the following commands:

```sh title="Execute the following command(s) in a terminal"
# Change the type of the Kubernetes cluster node pools to a different instance type and bigger disk-size
exo compute sks nodepool update swiss-ai-center-prod-cluster swiss-ai-center-prod-nodepool-1 --instance-type "standard.medium" --disk-size 400

# Scale the Kubernetes cluster node pools to the double of the current size
# ...see the code snippet above

# Validate the scaling of the Kubernetes cluster node pools
exo compute sks nodepool show swiss-ai-center-prod-cluster swiss-ai-center-prod-nodepool-1
# You should see Disk size: 400 and Instance type: standard.medium
```

```sh title="Execute the following command(s) in a terminal"
# You now need to drain the old nodes to move the pods to the new nodes and delete the old nodes. You can do this by executing the following commands:

# Find the node pool names
kubectl get nodes --kubeconfig exoscale.kubeconfig

# For each old node, drain the node to move the pods to the new nodes and delete the old node
# Note: To find which node are the old nodes, you can look at the AGE column in the output of the previous command
kubectl drain <old-node-name> --kubeconfig exoscale.kubeconfig --ignore-daemonsets --delete-emptydir-data

exo compute sks nodepool evict swiss-ai-center-prod-cluster swiss-ai-center-prod-nodepool-1 <old-node-name>
```



### Delete all resources

If you ever need to delete all resources, you can execute the following
commands:

```sh title="Execute the following command(s) in a terminal"
# Delete all node pools
exo compute sks nodepool delete swiss-ai-center-prod-cluster swiss-ai-center-prod-nodepool-1

# Delete the Kubernetes cluster
exo compute sks delete swiss-ai-center-prod-cluster

# List the load balancers
exo compute load-balancer list

# Delete the load balancer
exo compute load-balancer delete k8s-9fb0fdfd-c90d-4234-b50c-871885f0982d

# Delete the security group
exo compute security-group delete swiss-ai-center-prod-security-group

# Remove terminations protection from the PostgreSQL database
exo dbaas update core-engine-prod-database --zone ch-gva-2 --termination-protection=false

# Delete the PostgreSQL database
exo dbaas delete core-engine-prod-database --zone ch-gva-2

# Delete the S3 bucket
exo storage rb --recursive sos://core-engine-prod-bucket

# Delete the API key for Kubernetes
exo iam api-key delete k8s-dbaas

# Delete the role for Kubernetes
exo iam role delete k8s

# Delete the API key for the Core engine
exo iam api-key delete s3

# Delete the role for the Core engine
exo iam role delete core-engine
```

## Related explanations

These explanations are related to the current item (in alphabetical order).

_None at the moment._

## Resources

These resources are related to the current item (in alphabetical order).

_None at the moment._
