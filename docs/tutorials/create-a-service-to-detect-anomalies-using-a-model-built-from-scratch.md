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

```sh title="Execute this in the 'model-creation' folder"
# Create a virtual environment
python3.11 -m venv .venv
```

Then, activate the virtual environment:

```sh title="Execute this in the 'model-creation' folder"
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

```sh title="Execute this in the 'model-serving' folder"
# Install the dependencies
pip install --requirement requirements.txt
```

Create a freeze file to pin all dependencies to their current versions:

```sh title="Execute this in the 'model-serving' folder"
# Freeze the dependencies
pip freeze --local --all > requirements-all.txt
```

This will ensure that the same versions of the dependencies are installed on
every machine if you ever share your code with someone else.

#### Create the source files

Create a `src/train_model.py` file with the following content:

```py title="src/train_model.py"
import argparse
import pandas as pd
import tensorflow as tf
import matplotlib.pyplot as plt

from pathlib import Path


def build_model(shape):
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
    parser.add_argument("--train-dataset", type=str, required=True, help="Input path to the training dataset file (CSV format).")
    args = parser.parse_args()

    # Load the dataset
    X_train = pd.read_csv(args.train_dataset)

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

    a = err.loc[reconstruction_error >= np.mean(reconstruction_error)]  # anomaly
    ax.plot(err, color='blue', label='Normal')
    ax.scatter(a.index, a, color='red', label='Anomaly')
    plt.legend()

    # Save the plot
    Path("model").mkdir(parents=True, exist_ok=True)
    plt.savefig("evaluation/result.png")


def main():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Load and evaluate an autoencoder model on a test dataset.")
    parser.add_argument("--model", type=str, required=True, help="Path to the trained model file (HDF5 format).")
    parser.add_argument("--test-dataset", type=str, required=True, help="Path to the testing dataset file (CSV format).")
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

Create the following dataset in the `data` folder:

```text title="data/train.csv"
Measurements
0.7362
-0.4291
0.5824
-0.8127
0.1843
0.9038
-0.6781
-0.3154
0.7496
-0.9265
-0.1047
0.2658
0.4789
-0.5912
0.8311
-0.7123
0.9460
-0.0398
0.6927
-0.8705
```

The training dataset contains 20 measurements between -1 and 1.

```text title="data/test.csv"
Measurements
0.4567
-0.7890
0.1234
-0.9876
3.8765
-0.2345
0.6789
-0.2345
0.7890
-0.5678
0.5678
-0.8765
0.3456
-2.876
0.6543
-0.2109
0.8765
-0.5432
0.1098
-0.8765
```

In the training dataset, there are 20 measurements and 2 anomalies (`3.8765` and
`-2.876`).

#### Train the model

Run the following command to train the model:

```sh title="Execute this in the virtual environment"
# Train the model
python src/train_model.py --train-dataset data/train.csv
```

The model will be saved in the `model-creation/model` folder under the name
`anomalies_detection_model.h5`.

A plot of the training loss will be saved in the `model-creation/evaluation`
folder under the name `training_loss.png`.

#### Evaluate the model

Run the following command to evaluate the model:

```sh title="Execute this in the virtual environment"
# Evaluate the model
python src/evaluate_model.py --model model/anomalies_detection_model.h5 --test-dataset data/test.csv
```

A plot of the anomalies detected will be saved in the
`model-creation/evaluation` folder under the name `result.png`.

#### Where to find the model binary file

The model binary file is saved in the `model-creation/model` folder under the
name `anomalies_detection_model.h5`. You will need this file in the next
section.

### Implement the model serving

In this section, you will implement the code to serve the model to detect
anomalies you created in the previous section.

!!! warning
    Make sure you are in the `model-serving` folder.

#### Create a new Python virtual environment

Create a new Python virtual environment as explained in the previous section:

```sh title="Execute this in the 'model-serving' folder"
# Create a virtual environment
python3.11 -m venv .venv
```

Then, activate the virtual environment:

```sh title="Execute this in the 'model-serving' folder"
# Activate the virtual environment
source .venv/bin/activate
```

This will ensure that the dependencies of the model creation and the model
serving are isolated.

#### Install the dependencies

!!! warning
    Make sure you are in the virtual environment.

Update the `requirements.txt` file with the following content:

```text title="requirements.txt" hl_lines="2-6"
common-code[test] @ git+https://github.com/swiss-ai-center/common-code.git@main
matplotlib==3.6.3
numpy==1.24.2
pandas==1.5.3
scikit-learn==1.2.1
tensorflow==2.9.0
```

The `common-code` package is required to serve the model over a FastAPI REST API
and boilerplate code to handle the configuration.

You must add to this file all the dependencies your model needs to be loaded and
executed. In the case of this model, it is `matplotlib`, `numpy`, `pandas`,
`scikit-learn` and `tensorflow`.

Install the dependencies as explained in the previous section:

```sh title="Execute this in the virtual environment"
# Install the dependencies
pip install --requirement requirements.txt
```

Create a freeze file to pin all dependencies to their current versions:

```sh title="Execute this in the virtual environment"
# Freeze the dependencies
pip freeze --local --all > requirements-all.txt
```

This will ensure that the same versions of the dependencies are installed on
every machine if you ever share your code with someone else.

#### Copy the model binary file

Copy the model binary file from the `model-creation/model` folder to the
`model-serving/model` folder:

```sh title="Execute this in the 'model-serving' folder"
# Copy the model binary file
cp ../model-creation/model/anomalies_detection_model.h5 anomalies_detection_model.h5
```

#### Update the template files to load and serve the model

##### Update the `pyproject.toml` file

Update the `pyproject.toml` file to rename the package name (usually the name of
the repository):

```toml title="pyproject.toml" hl_lines="2"
[project]
name = "my-anomalies-detection-service" # (1)!

[tool.pytest.ini_options]
pythonpath = [".", "src"]
addopts = "--cov-config=.coveragerc --cov-report xml --cov-report term-missing --cov=./src"
```

1. The name is usually the name of the repository.

##### Update the `src/main.py` file

Update the `src/main.py` file to load the model binary file and serve it over
FastAPI:

```py title="src/main.py" hl_lines="21-31 37-39 47 48 53-78 82-84 86-119 174-179 180-181 186 188 189-193 198-201"
import asyncio
import time
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
from common_code.config import get_settings
from common_code.http_client import HttpClient
from common_code.logger.logger import get_logger, Logger
from common_code.service.controller import router as service_router
from common_code.service.service import ServiceService
from common_code.storage.service import StorageService
from common_code.tasks.controller import router as tasks_router
from common_code.tasks.service import TasksService
from common_code.tasks.models import TaskData
from common_code.service.models import Service
from common_code.service.enums import ServiceStatus
from common_code.common.enums import FieldDescriptionType, ExecutionUnitTagName, ExecutionUnitTagAcronym
from common_code.common.models import FieldDescription, ExecutionUnitTag
from contextlib import asynccontextmanager

# Imports required by the service's model(1)
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
import pandas as pd

import os
import io
import matplotlib

matplotlib.use('agg')

settings = get_settings()


class MyService(Service):# (2)!
    """
    My anomalies detection service model
    """

    # Any additional fields must be excluded for Pydantic to work
    _model: object
    _logger: Logger

    def __init__(self):
        super().__init__(
            name="My anomalies detection service",# (3)!
            slug="my-anomalies-detection-service",# (4)!
            url=settings.service_url,
            summary=api_summary,
            description=api_description,
            status=ServiceStatus.AVAILABLE,
            data_in_fields=[# (5)!
                FieldDescription(
                    name="dataset",
                    type=[
                        FieldDescriptionType.TEXT_CSV,
                        FieldDescriptionType.TEXT_PLAIN,
                    ],
                ),
            ],
            data_out_fields=[# (6)!
                FieldDescription(
                    name="result", type=[FieldDescriptionType.IMAGE_PNG]
                ),
            ],
            tags=[# (7)!
                ExecutionUnitTag(
                    name=ExecutionUnitTagName.ANOMALY_DETECTION,
                    acronym=ExecutionUnitTagAcronym.ANOMALY_DETECTION
                ),
                ExecutionUnitTag(
                    name=ExecutionUnitTagName.TIME_SERIES,
                    acronym=ExecutionUnitTagAcronym.TIME_SERIES
                ),
            ],
            has_ai=True,# (8)!
            docs_url="https://docs.swiss-ai-center.ch/reference/core-concepts/service/", # (9)!
        )
        self._logger = get_logger(settings)

        self._model = tf.keras.models.load_model(# (10)!
            os.path.join(os.path.dirname(__file__), "..", "anomalies_detection_model.h5")
        )

    def process(self, data):
        # NOTE that the data is a dictionary with the keys being the field names set in the data_in_fields
        raw = data["dataset"].data# (11)!
        input_type = data["dataset"].type# (12)!

        print("Input type: ", str(input_type))

        X_test = pd.read_csv(io.BytesIO(raw))

        # Use the model to reconstruct the original time series data
        reconstructed_X = self._model.predict(X_test)# (13)!

        # Calculate the reconstruction error for each point in the time series
        reconstruction_error = np.square(X_test - reconstructed_X).mean(axis=1)

        err = X_test
        fig, ax = plt.subplots(figsize=(20, 6))

        a = err.loc[reconstruction_error >= np.mean(reconstruction_error)]  # anomaly
        ax.plot(err, color='blue', label='Normal')
        ax.scatter(a.index, a, color='red', label='Anomaly')
        plt.legend()

        # Save the plot
        buf = io.BytesIO()
        plt.savefig(buf, format='png')

        # Reset the buffer
        buf.seek(0)

        # NOTE that the result must be a dictionary with the keys being the field names set in the data_out_fields
        return {
            "result": TaskData(data=buf.read(), type=FieldDescriptionType.IMAGE_PNG)# (14)!
        }


service_service: ServiceService | None = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Manual instances because startup events doesn't support Dependency Injection
    # https://github.com/tiangolo/fastapi/issues/2057
    # https://github.com/tiangolo/fastapi/issues/425

    # Global variable
    global service_service

    # Startup
    logger = get_logger(settings)
    http_client = HttpClient()
    storage_service = StorageService(logger)
    my_service = MyService()
    tasks_service = TasksService(logger, settings, http_client, storage_service)
    service_service = ServiceService(logger, settings, http_client, tasks_service)

    tasks_service.set_service(my_service)

    # Start the tasks service
    tasks_service.start()

    async def announce():
        retries = settings.engine_announce_retries
        for engine_url in settings.engine_urls:
            announced = False
            while not announced and retries > 0:
                announced = await service_service.announce_service(
                    my_service, engine_url
                )
                retries -= 1
                if not announced:
                    time.sleep(settings.engine_announce_retry_delay)
                    if retries == 0:
                        logger.warning(
                            f"Aborting service announcement after "
                            f"{settings.engine_announce_retries} retries"
                        )

    # Announce the service to its engine
    asyncio.ensure_future(announce())

    yield

    # Shutdown
    for engine_url in settings.engine_urls:
        await service_service.graceful_shutdown(my_service, engine_url)


api_description = """This service detects anomalies in a time series using an autoencoder.

The service expects a CSV file with a single column containing the time series data.

The service returns a plot of the time series with the detected anomalies highlighted in red.
"""# (15)!
api_summary = """My anomalies detection service detects anomalies in a time series using an autoencoder.
"""# (16)!

# Define the FastAPI application with information
app = FastAPI(
    lifespan=lifespan,
    title="My anomalies detection service API.",# (16)!
    description=api_description,
    version="0.0.1",# (18)!
    contact={# (19)!
        "name": "Swiss AI Center",
        "url": "https://swiss-ai-center.ch/",
        "email": "info@swiss-ai-center.ch",
    },
    swagger_ui_parameters={
        "tagsSorter": "alpha",
        "operationsSorter": "method",
    },
    license_info={# (20)!
        "name": "GNU Affero General Public License v3.0 (GNU AGPLv3)",
        "url": "https://choosealicense.com/licenses/agpl-3.0/",
    },
)

# Include routers from other files
app.include_router(service_router, tags=["Service"])
app.include_router(tasks_router, tags=["Tasks"])

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Redirect to docs
@app.get("/", include_in_schema=False)
async def root():
    return RedirectResponse("/docs", status_code=301)
```

1. Import the dependencies required by the model.
2. Edit the description of the service.
3. Edit the name of the service.
4. Edit the slug of the service.
5. Edit the input fields of the service.
6. Edit the output fields of the service.
7. Edit the tags of the service.
8. Edit the `has_ai` field of the service.
9. Optional: Edit the documentation URL of the service.
10. Load the model binary file.
11. Get the raw data from the `dataset` field.
12. Get the type of the data from the `dataset` field.
13. Use the model to reconstruct the original time series data.
14. Return the result of the service.
15. Change the API description. The description is a markdown string
   that will be displayed in the API documentation.
16. Edit the summary of the service.
17. Edit the title of the service.
18. Edit the version of the service.
19. Edit the contact information of the service.
20. Edit the license information of the service.

!!! Note
    The input and output data of the process function are bytes. Depending on the
    wanted type of the data, you might need to convert the data to the expected
    type.

##### Update the `Dockerfile` file

Update the Dockerfile to install all required packages that might be required by
the model and the model itself:

```dockerfile title="Dockerfile" hl_lines="4-5 20-21"
# Base image
FROM python:3.11

# Install all required packages to run the model(1)
# RUN apt update && apt install --yes package1 package2 ...

# Work directory
WORKDIR /app

# Copy requirements file
COPY ./requirements.txt .
COPY ./requirements-all.txt .

# Install dependencies
RUN pip install --requirement requirements.txt --requirement requirements-all.txt

# Copy sources
COPY src src

# Copy model(2)
COPY anomalies_detection_model.h5 .

# Environment variables
ENV ENVIRONMENT=${ENVIRONMENT}
ENV LOG_LEVEL=${LOG_LEVEL}
ENV ENGINE_URL=${ENGINE_URL}
ENV MAX_TASKS=${MAX_TASKS}
ENV ENGINE_ANNOUNCE_RETRIES=${ENGINE_ANNOUNCE_RETRIES}
ENV ENGINE_ANNOUNCE_RETRY_DELAY=${ENGINE_ANNOUNCE_RETRY_DELAY}

# Exposed ports
EXPOSE 80

# Switch to src directory
WORKDIR "/app/src"

# Command to run on start
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
```

1. Some OS packages might need to be installed in order to run the model. If
   needed, you can add them here.
2. Change the name of the model file to match the name of your model file.

##### Update the `.gitignore` file

To avoid pushing the model binary file to the Git repository, update the
`.gitignore` file to ignore the model binary file:

```sh title=".gitignore" hl_lines="2"
# Check parent `.gitignore` file for complete ignored files
anomalies_detection_model.h5 # (1)!
```

1. Add the model binary file to the `.gitignore` file.

#### Start the service

!!! tip

    Start the Core engine as mentioned in the
    [Getting started](../tutorials/getting-started.md) guide for this step.

Start the service with the following command:

```sh title="Execute this in the virtual environment"
# Switch to the `src` directory
cd src

# Start the application
uvicorn --reload --port 9090 main:app
```

The service should try to announce itself to the Core engine.

It will then be available at <http://localhost:9090>.

Access the Core engine either at <http://localhost:3000> (Frontend UI) or
<http://localhost:9090> (Backend UI).

The service should be listed in the **Services** section.

#### Test the service

!!! tip

    Start the Core engine as mentioned in the
    [Getting started](../tutorials/getting-started.md) guide for this step.

There are two ways to test the service:

=== "Using the Frontend UI (recommended)"

    Access the Core engine at <http://localhost:3000>.

    The service should be listed in the **Services** section.

    Try to start a new task with the service. You can use the
    `model-creation/data/test.csv` file as input.

    The service should execute the task and return a response with the anomalies.

    You can download the anomalies plot by clicking on the **Download** button.

=== "Using the Backend UI"

    Access the Core engine at <http://localhost:9090>.

    The service should be listed in the **Registered Services** section.

    **Start a new task**

    Try to start a new task with the service. You can use the
    `model-creation/data/test.csv` file as input.

    A primary JSON response should be returned with the task ID similar to this:

    ```json title="JSON response" hl_lines="4-6 7 11"
    {
    "created_at": "2024-01-25T12:31:42.967078",
    "updated_at": "2024-01-25T14:45:35.100946",
    "data_in": [
        "0a5d72aa-d524-4562-a511-f4bb7cfe7381.csv"// (1)!
    ],
    "data_out": null,// (2)!
    "status": "pending",
    "service_id": "00d89465-947e-44f8-9b4b-1731ebbd6fe3",
    "pipeline_execution_id": null,
    "id": "edd1ddd0-1d48-460b-906d-fb780078c534",// (3)!
    "service": {
        "name": "My anomalies detection service",
        "updated_at": "2024-01-25T12:35:11.431437",
        "summary": "My anomalies detection service detects anomalies in a time series using an autoencoder.\n",
        "status": "available",
        "data_out_fields": [
        {
            "name": "result",
            "type": [
            "image/png"
            ]
        }
        ],
        "url": "http://localhost:9090",
        "id": "00d89465-947e-44f8-9b4b-1731ebbd6fe3",
        "created_at": "2024-01-25T12:31:42.967078",
        "slug": "my-anomalies-detection-service",
        "description": "This service detects anomalies in a time series using an autoencoder.\n\nThe service expects a CSV file with a single column containing the time series data.\n\nThe service returns a plot of the time series with the detected anomalies highlighted in red.\n",
        "data_in_fields": [
        {
            "name": "dataset",
            "type": [
            "text/csv",
            "text/plain"
            ]
        }
        ],
        "tags": [
        {
            "name": "Anomaly Detection",
            "acronym": "AD"
        },
        {
            "name": "Time Series",
            "acronym": "TS"
        }
        ],
        "has_ai": true
    },
    "pipeline_execution": null
    }
    ```

    1. The input data is stored in the `data_in` field.
    2. The output is not available yet and will be stored in the `data_out` field.
    3. The task ID is stored in the `id` field.

    **Get the task status and result**

    You can then use the task ID to get the task status and the task result from the
    **Tasks** section.

    Using the task ID, you can get the details of the task similar to this:

    ```json title="JSON response" hl_lines="7-9 10"
    {
    "created_at": "2024-01-25T12:31:42.967078",
    "updated_at": "2024-01-25T14:45:35.100946",
    "data_in": [
        "0a5d72aa-d524-4562-a511-f4bb7cfe7381.csv"
    ],
    "data_out": [// (1)!
        "2e8c8029-ea8c-4bf9-b25a-b85c92ad3852.png"
    ],
    "status": "finished",// (2)!
    "service_id": "00d89465-947e-44f8-9b4b-1731ebbd6fe3",
    "pipeline_execution_id": null,
    "id": "edd1ddd0-1d48-460b-906d-fb780078c534",
    "service": {
        "name": "My anomalies detection service",
        "updated_at": "2024-01-25T12:35:11.431437",
        "summary": "My anomalies detection service detects anomalies in a time series using an autoencoder.\n",
        "status": "available",
        "data_out_fields": [
        {
            "name": "result",
            "type": [
            "image/png"
            ]
        }
        ],
        "url": "http://localhost:9090",
        "id": "00d89465-947e-44f8-9b4b-1731ebbd6fe3",
        "created_at": "2024-01-25T12:31:42.967078",
        "slug": "my-anomalies-detection-service",
        "description": "This service detects anomalies in a time series using an autoencoder.\n\nThe service expects a CSV file with a single column containing the time series data.\n\nThe service returns a plot of the time series with the detected anomalies highlighted in red.\n",
        "data_in_fields": [
        {
            "name": "dataset",
            "type": [
            "text/csv",
            "text/plain"
            ]
        }
        ],
        "tags": [
        {
            "name": "Anomaly Detection",
            "acronym": "AD"
        },
        {
            "name": "Time Series",
            "acronym": "TS"
        }
        ],
        "has_ai": true,
        "docs_url": "https://docs.swiss-ai-center.ch/reference/services/ae-ano-detection/",
    },
    "pipeline_execution": null
    }
    ```

    1. If the task is finished, the output data is stored in the `data_out` field.
    2. The status of the task. The service can have a queue of tasks to execute and
       your task might not be executed yet.

    **Download the result**

    Using the file key(s) of the `data_out` field, you can download the result of
    the task under the **Storage** section.

    You should then be able to download the anomalies plot.

You have validated that the service works as expected.

### Commit and push the changes (optional)

Commit and push the changes to the Git repository so it is available for the
other developers.

### Build, publish and deploy the service

Now that you have implemented the service, you can build, publish and deploy it.

Follow the
[How to build, publish and deploy a service](../how-to-guides/how-to-build-publish-and-deploy-a-service.md)
guide to build, publish and deploy the service to Kubernetes.

### Access and test the service

Access the service using its URL (either by the URL defined in the
`DEV_SERVICE_URL`/ `PROD_SERVICE_URL` variable or by the URL defined in the
Kubernetes Ingress file).

You should be able to access the FastAPI Swagger UI.

The service should be available in the **Services** section of the Core engine
it has announced itself to.

You should be able to send a request to the service and get a response.

## Conclusion

Congratulations! You have successfully created a service to detect anomalies
using a model built from scratch.

The service has then been published to a container registry and deployed on
Kubernetes.

The service is now accessible through a REST API on the Internet and you have
completed this tutorial! Well done!

## Go further

### Move model data to S3 with the help of DVC

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
[How to add DVC to a service](../how-to-guides/how-to-add-dvc-to-a-service.md)
guide.
