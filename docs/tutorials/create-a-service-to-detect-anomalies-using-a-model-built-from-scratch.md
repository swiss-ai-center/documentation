# Create a service to detect anomalies using a model built from scratch (model from scratch template)

This tutorial shows how to create a
[service](../reference/core-concepts/service.md) to detect anomalies using a
model built from scratch using the
[model from scratch template](../how-to-guides/how-to-create-a-new-service.md).

## Introduction

This tutorial shows how to create a service to detect anomalies using a model
built from scratch.

This service will take a time series dataset as input and return a list of
anomalies using an [autoencoder](https://en.wikipedia.org/wiki/Autoencoder)
model.

## Prerequisites

To follow this tutorial, we highly recommend you to follow the
[Getting started](../tutorials/getting-started.md) guide first.

It contains all the required tools to follow this tutorial.

## Bootstrap the service based on the model from scratch template

In this section, you will bootstrap a new service based on the
[_Create a new service (model from scratch) template_](https://github.com/swiss-ai-center/create-a-new-service-model-from-scratch-template).

You have three ways to bootstrap a new service based on the template:

=== "Use the template"

    If you are part of the Swiss AI Center GitHub organization, this is the
    recommended way to bootstrap a new service.

    Access the
    [_Create a new service (model from scratch) template_](https://github.com/swiss-ai-center/create-a-new-service-model-from-scratch-template)
    repository.

    Use the **"Use the template"** button to create a new repository based on the
    template in the Swiss AI Center GitHub organization or in your own GitHub
    account.

    For the **Repository name**, use `my-anomalies-detection-service`.

    Clone the newly created repository locally.

    This will be the root directory of your new service for the rest of this
    tutorial.

=== "Fork the template"

    If you are not part of the Swiss AI Center GitHub organization, this is the
    recommended way to bootstrap a new service.

    Fork the
    [_Create a new service (model from scratch) template_](https://github.com/swiss-ai-center/create-a-new-service-model-from-scratch-template)
    to fork a new repository based on the chosen template.

    For the **Repository name**, use `my-anomalies-detection-service`.

    Clone the newly created repository locally.

    This will be the root directory of your new service for the rest of this
    tutorial.

=== "Download the template"

    If you do not want to host your codebase on GitHub or if you do not want to be
    linked to the Swiss AI Center organization, download the
    [_Create a new service (model from scratch) template_](https://github.com/swiss-ai-center/create-a-new-service-model-from-scratch-template)
    as an archive file (**"Download ZIP"**) from the GitHub repository and start
    over locally or in a new Git repository.

    Extract the archive and name the directory `my-anomalies-detection-service`.

    This will be the root directory of your new service for the rest of this
    tutorial.

## Explaining the template

In this section, you will learn about the different files and folders that are
part of the template.

### `README.md`

This file contains a checklist of the steps to follow to bootstrap a new service
based on the template. This can help you to follow step-by-step what you need to
do to bootstrap a new service based on the template.

### `model-creation`

This folder contains the code to create the model. This is where you will
implement the code to create the model that will be saved as a binary file.

The binary file will then be copied/moved in the `model-serving` folder.

### `model-serving`

This folder contains the code to serve the model. This is where you will
implement the code to load the model from the binary file and serve it over a
[FastAPI](../explanations/about-fastapi.md) REST API.

## Implement the anomalies detection service

In this section, you will implement the anomalies detection service.

The service is composed of two parts:

- The model creation
- The model serving

### Implement the model creation

In this section, you will implement the code to create the model to detect
anomalies. This model will then be used in the next section to serve the model.

!!! warning
    Make sure you are in the `model-creation` folder.

#### Create a new Python virtual environment

Instead of installing the dependencies globally, it is recommended to create a
virtual environment.

To create a virtual environment, run the following command inside the project
folder:

```sh
# Create a virtual environment
python3.10 -m venv .venv
```

Then, activate the virtual environment:

```sh
# Activate the virtual environment
source .venv/bin/activate
```

#### Install the dependencies

!!! warning
    Make sure you are in the virtual environment.

Create a `requirements.txt` file with the following content:

```text title="requirements.txt"
matplotlib==3.6.3
numpy==1.24.2
pandas==1.5.3
scikit-learn==1.2.1
tensorflow==2.9.0
```

These are the dependencies required to create the model to detect anomalies.

Then, install the dependencies:

```sh
# Install the dependencies
pip install --requirement requirements.txt
```

Create a freeze file to pin all dependencies to their current versions.

```sh
# Freeze the dependencies
pip freeze --local --all > requirements-all.txt
```

This will ensure that the same versions of the dependencies are installed on
every machine.

#### Create the source files

Create a `src/train_model.py` file with the following content:

```py title="src/train_model.py"
import argparse
import pandas as pd
import tensorflow as tf
import matplotlib.pyplot as plt

from pathlib import Path


def build_model(shape):
    # Preprocess the data (e.g., scale the data, create train/test splits)

    # Define the input layer
    input_layer = tf.keras.layers.Input(shape=(shape,))

    # Define the encoding layers
    encoded = tf.keras.layers.Dense(32, activation='relu')(input_layer)
    encoded = tf.keras.layers.Dense(16, activation='relu')(encoded)

    # Define the decoding layers
    decoded = tf.keras.layers.Dense(16, activation='relu')(encoded)
    decoded = tf.keras.layers.Dense(32, activation='relu')(decoded)

    # Define the output layer
    output_layer = tf.keras.layers.Dense(shape)(decoded)

    # Create the autoencoder model
    autoencoder = tf.keras.models.Model(input_layer, output_layer)

    # Compile the model
    autoencoder.compile(optimizer='adam', loss='mean_squared_error')

    return autoencoder


def train_model(X_train):
    # Fit the model to the time series data
    model = build_model(X_train.shape[1])
    history = model.fit(X_train, X_train, epochs=10, batch_size=32)

    # Save the model
    Path("model").mkdir(parents=True, exist_ok=True)
    model.save("model/anomalies_detection_model.h5", save_format='h5')

    return history


def plot_loss(history):
    plt.plot(history.history['loss'])
    plt.title('Model loss')
    plt.ylabel('Loss')
    plt.xlabel('Epoch')

    # Save the plot
    Path("evaluation").mkdir(parents=True, exist_ok=True)
    plt.savefig('evaluation/training_loss.png')


def main():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Train an autoencoder model on the given dataset.")
    parser.add_argument("--dataset", type=str, required=True, help="Input path to the dataset file (CSV format).")
    args = parser.parse_args()

    # Load the dataset
    X_train = pd.read_csv(args.dataset)

    # Train the model and get the training history
    history = train_model(X_train)

    # Plot and save the training loss
    plot_loss(history)


if __name__ == "__main__":
    main()
```

This file contains the code to create the model to detect anomalies.

Create a `src/evaluate_model.py` file with the following content:

```py title="src/evaluate_model.py"
import argparse
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
import pandas as pd

from pathlib import Path


def load_model(model_path):
    return tf.keras.models.load_model(model_path)


def evaluate_model(model, X_test):
    reconstructed_X = model.predict(X_test)

    # Calculate the reconstruction error for each point in the time series
    reconstruction_error = np.square(X_test - reconstructed_X).mean(axis=1)

    err = X_test
    fig, ax = plt.subplots(figsize=(20, 6))

    a = err.loc[reconstruction_error >= np.max(reconstruction_error)]  # anomaly
    # b = np.arange(35774-12000, 35874-12000)
    ax.plot(err, color='blue', label='Normal')
    # ax.scatter(b, err[35774-12000:35874-12000], color='green', label = 'Real anomaly')
    ax.scatter(a.index, a, color='red', label='Anomaly')
    plt.legend()

    # Save the plot
    Path("model").mkdir(parents=True, exist_ok=True)
    plt.savefig("evaluation/result.png")


def main():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Load and evaluate an autoencoder model on a test dataset.")
    parser.add_argument("--model", type=str, required=True, help="Path to the trained model file (HDF5 format).")
    parser.add_argument("--test-dataset", type=str, required=True, help="Path to the test dataset file (CSV format).")
    args = parser.parse_args()

    # Load the trained model
    model = load_model(args.model)

    # Load the test dataset
    X_test = pd.read_csv(args.test_dataset)

    # Evaluate the model using the test dataset
    evaluate_model(model, X_test)


if __name__ == "__main__":
    main()
```

#### Import the dataset

Place the following dataset in the `data` folder:

```text title="data/train.txt"
TODO
```

```text title="data/test.txt"
TODO
```

#### Train the model

```sh
# Train the model
python src/train_model.py --dataset data/train.txt
```

#### Evaluate the model

```sh
# Evaluate the model
python src/evaluate_model.py --model model/anomalies_detection_model.h5 --test-dataset data/test.txt
```

#### Where to find the model binary file

The model binary file is saved in the `model-creation/model` folder under the
name `anomalies_detection_model.h5`. You will need this file in the next
section.

### Implement the model serving

In this section, you will implement the code to serve the model to detect
anomalies you created in the previous section.

!!! warning
    Make sure you are in the `model-serving` folder.

#### Copy the model binary file

TODO

#### Update the template files to load and serve the model

TODO

#### Start the service

!!! info

    While optional, it is recommended to start the Core engine as mentioned in the
    [Getting started](../tutorials/getting-started.md) guide for this step.

TODO

#### Test the service with the Web UI

Access the Core engine at <http://localhost:3000>.

The service should be listed in the **Services** section.

Try to start a new task with the service.

You should receive a response with the anomalies detected.

#### Build, publish and deploy the service

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

    **Store the environment variables in GitHub Actions**

    **Store the secrets in GitHub Actions**

    **Run the GitHub Actions workflow**

=== "Build, publish and deploy manually"

    **Build the Docker image**

    **Run the Docker container**

    **Test the Docker container**

    **Publish the Docker image**

    **Deploy the service on Kubernetes**

#### Access and test the service

Access the service using the URL defined in the Kubernetes Ingress.

You should be able to access the FastAPI Swagger UI.

The service should be

You should be able to send a request to the service and get a response.

### Conclusion

Congratulations! You have successfully created a service to detect anomalies
using a model built from scratch.

The service has then been published to a container registry and deployed on
Kubernetes.

The service is now accessible through a REST API on the Internet.

### Go further

#### Move model data to S3 with the help of DVC

In this tutorial, you have learned how to create a service to detect anomalies
using a model built from scratch.

This model does not contain a lot of data to store and therefore, it is not a
problem to store it in the Git repository.

For some models, you might have a lot of data to store and it might not be a
good idea to store it in the Git repository (performance issues, Git repository
size, etc.).

You might want to store the model data in a cloud storage service like AWS S3.

[DVC](../explanations/about-dvc.md) is the perfect tool to do that.

Learn how to move the model data to S3 with the help of DVC in the
[How to add DVC to a service](./move-model-data-to-s3-with-the-help-of-dvc.md)
how-to guide.
