# How to build, publish and deploy a service

This guide will help you in the steps to build, publish and deploy a service for
the [Core engine](../reference/core-engine.md).

## Follow the official tutorials

If you have not already, we highly recommend you to follow the two official
tutorials to learn how to create a new service:

- [Rotate an image](TODO) - Uses the _Create a new service (generic)_ template
  mentioned below
- [Summarize a text using an existing model](TODO) - Uses the _Create a new
  service (generic)_ template mentioned below
- [Detect anomalies using a model built from scratch](../tutorials/create-a-service-to-detect-anomalies-using-a-model-built-from-scratch.md) -
  Uses the _Create a new service (model from scratch)_ template mentioned below

## Build, publish and deploy a service

!!! info

    If you want to deploy the service, you will need a container registry and a
    Kubernetes cluster.

    If you are part of the Swiss AI Center GitHub organization, most of the process
    is automated and you can use GitHub container registry and Kubernetes cluster.

    If you are not part of the Swiss AI Center GitHub organization, you can use a
    container registry and a Kubernetes cluster of your choice such as GitHub
    container registry and your own Kubernetes cluster. You will need the Kubeconfig
    file of your Kubernetes cluster.

You have two ways to build, publish and deploy your service:

=== "Using a CI/CD pipeline (recommended)"

    !!! tip

        This can only work if you commit and push your code to a GitHub repository.

    **Store the secrets in GitHub Actions**

    !!! note

        If your repository is part of the Swiss AI Center GitHub organization, most of
        the following secrets are already set for you.

    Access the GitHub repository settings. Under **Secrets and variables** >
    **Actions**, open the **Secrets** tab.

    Add secrets using the **New repository secret** button.

    The following secrets are required to build, publish and deploy the service:

    | Secret name       | Description                           | Type      | Default value[^1] |
    | ----------------- | ------------------------------------- | --------- | ----------------- |
    | `DEV_KUBE_CONFIG` | The content of the Kubeconfig file.   | string    | `*****`           |

    All `DEV_*` secrets can be duplicated to `PROD_*` secrets to deploy the service
    on the production environment.

    **Store the variables in GitHub Actions**

    !!! note

        If your repository is part of the Swiss AI Center GitHub organization, most of
        the following variables are already set for you.

    Access the GitHub repository settings. Under **Secrets and variables** >
    **Actions**, open the **Variables** tab.

    Add variables using the **New repository variable** button.

    The following variables are required to build, publish and deploy the service:

    | Variable name                     | Description                                                                                                   | Type      | Default value[^1]                                                         |
    | --------------------------------- | ------------------------------------------------------------------------------------------------------------- | --------- | ------------------------------------------------------------------------- |
    | `RUN_CICD`                        | Whether to run the CI/CD pipeline.                                                                            | boolean   | `true`                                                                    |
    | `DEPLOY_DEV`                      | Whether to deploy the service on the development environment.                                                 | boolean   | `false`                                                                   |
    | `DEPLOY_PROD`                     | Whether to deploy the service on the production environment.                                                  | boolean   | `false`                                                                   |
    | `SERVICE_NAME`                    | The name of the service.                                                                                      | string    |                                                                           |
    | `MODEL_PATH`                      | The path to the model binary file, e.g. `./model-creation/model/my-model.h5`                                  | string    |                                                                           |
    | `DEV_SERVICE_URL`                 | The URL of the service of the development environment.                                                        | string    |                                                                           |
    | `DEV_CORE_ENGINE_URLS`            | The URL(s) of the Core engine(s) of the development environment.                                              | string    | `'["https://backend-core-engine-swiss-ai-center.kube.isc.heia-fr.ch"]'`   |
    | `DEV_ENGINE_ANNOUNCE_RETRIES`     | The number of retries to announce the service to the Core engine(s) of the development environment.           | string    | `'5'`                                                                     |
    | `DEV_ENGINE_ANNOUNCE_RETRY_DELAY` | The delay between each retry to announce the service to the Core engine(s) of the development environment.    | string    | `'3'`                                                                     |
    | `DEV_LOG_LEVEL`                   | The log level of the service of the development environment.                                                  | string    | `info`                                                                    |
    | `DEV_MAX_TASKS`                   | The maximum number of tasks the service of the development environment can accept in its queue.               | string    | `'50'`                                                                    |
    | `DEV_NAMESPACE`                   | The namespace of the service of the development environment.                                                  | string    | `swiss-ai-center-dev`                                                     |

    All `DEV_*` variables can be duplicated to `PROD_*` variables to deploy the
    service on the production environment.

    **Run the GitHub Actions workflow**

    !!! note

        Your code must be pushed to a GitHub repository to trigger the GitHub Actions
        workflow.

    In the GitHub repository, open the **Actions** tab.

    If a workflow is already running, you can click on it to see its progress.

    If no workflow is running, you can click on the **github_workflow** on the left
    side of the **Actions** tab.

    Click on the **Run workflow** button. Select the `main` branch and click on the
    **Run workflow** button.

    The workflow should start and your service should be built, published and
    deployed automatically:

    1. The `model-serving` directory is reviewed with the help of
       [Flake8](../explanations/about-flake8.md)
    2. The model is trained in the `model-creation` directory
    3. The model is uploaded to GitHub artifacts using the `MODEL_PATH` variable
    4. The service is tested in the `model-serving` directory with the help of
       [pytest](../explanations/about-pytest.md)
    5. The service is released to the GitHub container registry
    6. The service is deployed on the development/production environment

    The service should be deployed on the development/production environment.

=== "Build, publish and deploy manually"

    **Build the Docker image**

    !!! info

        If you want to publish the Docker image to a container registry, you will need
        to tag the Docker image with the URL of the container registry.

        See the official
        [GitHub container registry documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#building-container-images)
        or the official
        [GitLab container registry documentation](https://docs.gitlab.com/ee/user/packages/container_registry/build_and_push_images.html)
        for more information.

    Build the Docker image using the following command:

    ```sh
    # Build the Docker image
    docker build -t <image-name>:<image-tag> .
    ```

    **Run the Docker container**

    Run the Docker container using the following command:

    ```sh
    # Run the Docker container
    docker run -p 9090:80 <image-name>:<image-tag>
    ```

    **Access the Docker container**

    Access the Docker container at <http://localhost:9090>. You should see the
    FastAPI documentation of the service.

    **Publish the Docker image**

    Login to the container registry using the following command:

    ```sh
    # Login to the container registry
    docker login <container-registry-url>
    ```

    Publish the Docker image using the following command:

    ```sh
    # Publish the Docker image
    docker push <image-name>:<image-tag>
    ```

    **Update the Kubernetes files**

    Edit the following Kubernetes files to configure your service:

    - `kubernetes/config-map.yml`
    - `kubernetes/ingress.yml`
    - `kubernetes/service.yml`
    - `kubernetes/stateful.yml`

    **Deploy the service on Kubernetes**

    Using the Kubeconfig file of your Kubernetes cluster, deploy the service on
    Kubernetes using the following command:

    ```sh
    # Deploy the service on Kubernetes
    kubectl --kubeconfig ~/path/to/your/kubeconfig --namespace namespace-of-your-kubernetes-cluster apply \
        -f kubernetes/config-map.yml \
        -f kubernetes/ingress.yml \
        -f kubernetes/service.yml \
        -f kubernetes/stateful.yml
    ```

    The service should be deployed on Kubernetes.

[^1]:
    If your repository is part of the Swiss AI Center GitHub organization.
