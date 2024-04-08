# Create a service to summarize a text using an existing model (generic template)

This tutorial shows how to implement a
[Service](../reference/core-concepts/service.md) in the Swiss AI Center project
step by step. The [Service](../reference/core-concepts/service.md) is a text
summarizer tool that summarizes a text using the
[Hugging Face](https://huggingface.co/) library.

## Introduction

This tutorial shows how to implement a
[Service](../reference/core-concepts/service.md) that uses an existing model to
summarize a text from Hugging Face.

## Prerequisites

To follow this tutorial, we highly recommend you to follow the
[Getting started](../tutorials/getting-started.md) guide first.

It contains all the required tools to follow this tutorial.

## Bootstrap the service based on the generic template

In this section, you will bootstrap a new service based on the
[_Create a new service (generic) template_](https://github.com/swiss-ai-center/create-a-new-service-generic-template).

You have three ways to bootstrap a new service based on the template:

=== "Use the template"

    If you are part of the Swiss AI Center GitHub organization, this is the
    recommended way to bootstrap a new service.

    Access the
    [_Create a new service (generic) template_](https://github.com/swiss-ai-center/create-a-new-service-generic-template).

    Use the **"Use the template"** button to create a new repository based on the
    template in the Swiss AI Center GitHub organization or in your own GitHub
    account.

    For the **Repository name**, use `my-text-summarizer-service`.

    Clone the newly created repository locally.

    This will be the root directory of your new service for the rest of this
    tutorial.

=== "Fork the template"

    If you are not part of the Swiss AI Center GitHub organization, this is the
    recommended way to bootstrap a new service.

    Fork the
    [_Create a new service (generic) template_](https://github.com/swiss-ai-center/create-a-new-service-generic-template).
    to fork a new repository based on the chosen template.

    For the **Repository name**, use `my-text-summarizer-service`.

    Clone the newly created repository locally.

    This will be the root directory of your new service for the rest of this
    tutorial.

=== "Download the template"

    If you do not want to host your codebase on GitHub or if you do not want to be
    linked to the Swiss AI Center organization, download the
    [_Create a new service (generic) template_](https://github.com/swiss-ai-center/create-a-new-service-generic-template).
    as an archive file (**"Download ZIP"**) from the GitHub repository and start
    over locally or in a new Git repository.

    Extract the archive and name the directory `my-text-summarizer-service`.

    This will be the root directory of your new service for the rest of this
    tutorial.

## Explaining the template

In this section, you will learn about the different files and folders that are
part of the template.

### `README.md`

This file contains a checklist of the steps to follow to bootstrap a new service
based on the template. This can help you to follow step-by-step what you need to
do to bootstrap a new service based on the template.

### Other files and folders

The other files and folders contain everything to serve your tool. This is where
you will implement to do it over a [FastAPI](../explanations/about-fastapi.md)
REST API.

## Implement the service

### Create a virtual environment

Instead of installing the dependencies globally, it is recommended to create a
virtual environment.

To create a virtual environment, run the following command inside the project
folder:

```sh title="Execute this in the 'root' folder"
# Create a virtual environment
python3.11 -m venv .venv
```

Then, activate the virtual environment:

```sh title="Execute this in the 'root' folder"
# Activate the virtual environment
source .venv/bin/activate
```

### Install the dependencies

!!! warning
    Make sure you are in the virtual environment.

Update the `requirements.txt` file with the following content:

```txt hl_lines="2 3"
common-code[test] @ git+https://github.com/swiss-ai-center/common-code.git@main
transformers==4.39.3
torch==2.2.2
```

The `common-code` package is required to serve the model over a FastAPI REST API
and boilerplate code to handle the configuration.

We will also need to install transformers and torch for the service to work.

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

Finally, copy the line `common-code @ git+https://github.com/swiss-ai-center/common-code.git@<commit>` from
the `requirements-all.txt` file into the `requirements.txt` file, replacing the generic existing line.

This will ensure that the same versions of the dependencies are installed on
every machine if you ever share your code with someone else.

!!! note

    To facilitate easier updates to services in the event of a  common-code  dependency update,
    consider removing the specific line referencing `common-code @ git+https://github.com/swiss-ai-center/common-code.git@<commit>`
    from `requirements-all.txt`. This specific line may conflict with the more general line in `requirements.txt`
    due to its explicit commit reference.

    By removing this specific line, updates to the `common-code` dependency won't require any modifications
    to the service configuration before redeployment. Do note however that this approach will not guarantee
    that the `common-code` dependency remains consistent across different service deployments.

### Update the template files

#### Update the README

Open the `README.md` file and update the title and the description of the
[Service](../reference/core-concepts/service.md).

```md
# Text Summarizer

This service summarizes a text using the Hugging Face library.
```

!!! note

    If the service is part of the Swiss AI Center GitHub organization also add a
    link to the [Service](../reference/core-concepts/service.md)'s
    [Reference](../reference/core-concepts/service.md) page in the repository
    README.md file.

    ```md
    # Text Summarizer

    This service summarizes a text using the Hugging Face library.

    _Check the [related documentation](https://swiss-ai-center.github.io/swiss-ai-center/reference/text-summarizer) for more information._
    ```

#### Update the `pyproject.toml` file

```toml title="pyproject.toml" hl_lines="2"
[project]
name = "text-summarizer"

[tool.pytest.ini_options]
pythonpath = [".", "src"]
addopts = "--cov-config=.coveragerc --cov-report xml --cov-report term-missing --cov=./src"
```

1. Change the name of the project to `text-summarizer`.

#### Update the `src/main.py` file

All the code of the [Service](../reference/core-concepts/service.md) is in the
`main.py` file. The [Service](../reference/core-concepts/service.md) is a text
summarizer tool that summarizes a text using the
[Hugging Face](https://huggingface.co/) library.

Open the `main.py` with your favorite editor and follow the instructions below.

```py hl_lines="23 26 31-33 42-43 49-62 67-87 91-98 101-111"
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

# Imports required by the service's model
# TODO: 1. ADD REQUIRED IMPORTS (ALSO IN THE REQUIREMENTS.TXT) (1)!
from transformers import pipeline

settings = get_settings()
classifier = pipeline("summarization", model="philschmid/bart-large-cnn-samsum")


class MyService(Service):
    # TODO: 2. CHANGE THIS DESCRIPTION (2)!
    """
    Text summarizer model
    """

    # Any additional fields must be excluded of model by adding a leading underscore for Pydantic to work
    _model: object
    _logger: Logger

    def __init__(self):
        super().__init__(
            # TODO: 3. CHANGE THE SERVICE NAME AND SLUG (3)!
            name="Text Summarizer",
            slug="text-summarizer",
            url=settings.service_url,
            summary=api_summary,
            description=api_description,
            status=ServiceStatus.AVAILABLE,
            # TODO: 4. CHANGE THE INPUT AND OUTPUT FIELDS, THE TAGS AND THE HAS_AI VARIABLE (4)!
            data_in_fields=[
                FieldDescription(name="text", type=[FieldDescriptionType.TEXT_PLAIN]),
            ],
            data_out_fields=[
                FieldDescription(name="result", type=[FieldDescriptionType.TEXT_PLAIN]),
            ],
            tags=[
                ExecutionUnitTag(
                    name=ExecutionUnitTagName.NATURAL_LANGUAGE_PROCESSING,
                    acronym=ExecutionUnitTagAcronym.NATURAL_LANGUAGE_PROCESSING,
                ),
            ],
            has_ai=True,
            docs_url="https://docs.swiss-ai-center.ch/reference/core-concepts/service/", # (5)!
        )
        self._logger = get_logger(settings)

    # TODO: 5. CHANGE THE PROCESS METHOD (CORE OF THE SERVICE) (6)!
    def process(self, data):
        # Get the text to analyze from storage
        text = data["text"].data
        # Convert bytes to string
        text = text.decode("utf-8")

        # Limit the text to 142 words
        text = " ".join(text.split()[:500])

        # Run the model
        result = classifier(text, max_length=100, min_length=5, do_sample=False)

        # Convert the result to bytes
        file_bytes = result[0]["summary_text"].encode("utf-8")

        return {
            "result": TaskData(
                data=file_bytes,
                type=FieldDescriptionType.TEXT_PLAIN
            )
        }

...

# TODO: 6. CHANGE THE API DESCRIPTION AND SUMMARY (7)!
api_summary = """
Summarize the given text.
"""

api_description = """
Summarize the given text using the HuggingFace transformers library with model bart-large-cnn-samsum.
"""

# Define the FastAPI application with information
# TODO: 7. CHANGE THE API TITLE, VERSION, CONTACT AND LICENSE (8)!
app = FastAPI(
    lifespan=lifespan,
    title="Text summarizer API.",
    description=api_description,
    version="0.0.1",
    contact={
        "name": "Swiss AI Center",
        "url": "https://swiss-ai-center.ch/",
        "email": "info@swiss-ai-center.ch",
    },
    swagger_ui_parameters={
        "tagsSorter": "alpha",
        "operationsSorter": "method",
    },
    license_info={
        "name": "GNU Affero General Public License v3.0 (GNU AGPLv3)",
        "url": "https://choosealicense.com/licenses/agpl-3.0/",
    },
)
...
```

1. Import the required packages.
2. Change the description of the service.
3. Change the name and the slug of the service. This is used to identify the
   service in the Core engine.
4. Change the input/output fields of the service. The name of the field is the
   key of the dictionary that will be used in the process function. The type of the
   field is the type of the data that will be sent to the service. They are defined
   in the FieldDescriptionType enum. The tags are used to identify the service in
   the Core engine. The `has_ai` variable is used to identify if the service is an
   AI service.
5. Optional: Edit the documentation URL of the service.
6. Change the process function. This is the core of the service. The data is a
   dictionary with the keys being the field names set in the data_in_fields. The
   result must be a dictionary with the keys being the field names set in the
   data_out_fields.
7. Change the API description and summary. The description is a markdown string
   that will be displayed in the API documentation. The summary is a short
   description of the API.
8. Change the API title, version, contact and license.

!!! Note
    The `process` function TaskData object must be serializable.

!!! Note
    The input and output data of the process function are bytes. Depending on the
    wanted type of the data, you might need to convert the data to the expected
    type.

### Start the service

!!! tip

    Start the Core engine as mentioned in the
    [Getting started](../tutorials/getting-started.md) guide for this step.

Start the service with the following command:

```sh title="Execute this in the virtual environment"
# Switch to the `src` directory
cd src

# Start the application
uvicorn --reload --host 0.0.0.0 --port 9090 main:app
```

The service should try to announce itself to the Core engine.

It will then be available at <http://localhost:9090>.

Access the Core engine either at <http://localhost:3000> (Frontend UI) or
<http://localhost:9090> (Backend UI).

The service should be listed in the **Services** section.

### Test the service

!!! tip

    Start the Core engine as mentioned in the
    [Getting started](../tutorials/getting-started.md) guide for this step.

Create a file called text.txt and add some text in it.

There are two ways to test the service:

=== "Using the Frontend UI (recommended)"

    Access the Core engine at <http://localhost:3000>.

    ![text-summarizer-frontend](../assets/screenshots/text-summarizer-frontend.png)

    Now you can test the [Service](../reference/core-concepts/service.md) by
    clicking the `View` button. Now upload the text file and click on the `Run`
    button.

    ![text-summarizer-frontend-execute](../assets/screenshots/text-summarizer-frontend-execute.png)

    The execution should start and as soon as it is finished, the `Download` button
    should be clickable. Use it to download the result.

    ![text-summarizer-frontend-download](../assets/screenshots/text-summarizer-frontend-download.png)

    The text should be summarized.

=== "Using the Backend UI"

    Access the Core engine at <http://localhost:9090>.

    The service should be listed in the **Registered Services** section.

    **Start a new task**

    Try to start a new task with the service.

    Unfold the `/text-summarizer` endpoint and click on the Try it out button.
    Upload the text file and click on the Execute button. The response body should
    be something similar to the following:

    ```json hl_lines="4-7 11"
    {
      "created_at": "2024-01-09T16:30:22.627620",
      "updated_at": "2024-01-09T16:54:58.221528",
      "data_in": [
        "8a3bb409-bfe6-444d-9f94-8e245b0370b6.txt"//(1)!
      ],
      "data_out": null,//(2)!
      "status": "pending",
      "service_id": "c0ddda6c-9ffa-4912-90a2-b4e9b1769b56",
      "pipeline_execution_id": null,
      "id": "b7b73c95-88d1-4f02-87f6-29feabf41d7e",//(3)!
      "service": {
        "created_at": "2024-01-09T16:30:22.627620",
        "updated_at": "2024-01-09T16:49:08.499620",
        "description": "\nSummarize the given text using the HuggingFace transformers library with model bart-large-cnn-samsum.\n",
        "status": "available",
        "data_in_fields": [
          {
            "name": "text",
            "type": [
              "text/plain"
            ]
          }
        ],
        "data_out_fields": [
          {
            "name": "result",
            "type": [
              "text/plain"
            ]
          }
        ],
        "tags": [
          {
            "name": "Natural Language Processing",
            "acronym": "NLP"
          }
        ],
        "has_ai": true,
        "id": "c0ddda6c-9ffa-4912-90a2-b4e9b1769b56",
        "name": "Text Summarizer",
        "slug": "text-summarizer",
        "summary": "\nSummarize the given text.\n",
        "url": "http://localhost:9090",
        "docs_url": "https://docs.swiss-ai-center.ch/reference/services/text-summarizer/",
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

    1. Click on Try it out and paste the id in the task_id field.
    2. Click on Execute.
    3. In the body response, if the status is `finished` find the `data_out` field
       and copy the id of the image
      (e.g. `a38ef233-ac01-431d-adc8-cb6269cdeb71.png`).
    4. Now, unfold the GET `/storage/{key}` endpoint under the Storage name.
    5. Click on Try it out and paste the id of the text file in the key field.
    6. Click on Execute.
    7. Click on the Download file button and save the file in your computer.

    The text should be summarized.
You have validated that the service works as expected.

## Commit and push the changes (optional)

Commit and push the changes to the Git repository so it is available for the
other developers.

## Build, publish and deploy the service

Now that you have implemented the service, you can build, publish and deploy it.

Follow the
[How to build, publish and deploy a service](../how-to-guides/how-to-build-publish-and-deploy-a-service.md)
guide to build, publish and deploy the service to Kubernetes.

## Access and test the service

Access the service using its URL (either by the URL defined in the
`DEV_SERVICE_URL`/ `PROD_SERVICE_URL` variable or by the URL defined in the
Kubernetes Ingress file).

You should be able to access the FastAPI Swagger UI.

The service should be available in the **Services** section of the Core engine
it has announced itself to.

You should be able to send a request to the service and get a response.

## Conclusion

Congratulations! You have successfully created a service to summarize a text.

The service has then been published to a container registry and deployed on
Kubernetes.

The service is now accessible through a REST API on the Internet and you have
completed this tutorial! Well done!
