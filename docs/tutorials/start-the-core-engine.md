# Start the Core engine

This tutorial shows how to start the [Core engine](../reference/core-engine.md)
that will orchestrate the [services](../reference/core-concepts/service.md) and
the [pipelines](../reference/core-concepts/pipeline.md).

## Introduction

This tutorial shows how to start the Core engine.

## Prerequisites

To follow this tutorial, we highly recommend you to follow the
[Getting started](../tutorials/getting-started.md) guide first.

It contains all the required tools to follow this tutorial.

## Start the Core engine locally

### Clone the Core engine repository

Clone the Core engine repository with the following command.

```sh
# Clone the Core engine repository
git clone git@github.com:swiss-ai-center/core-engine
```

### Start the Core engine locally with Docker Compose

In the `core-engine/backend` directory, start the Core engine Backend with the
following commands:

```sh
# Build the Docker image
docker compose build

# Start the Core engine Backend
docker compose up
```

Access the Core engine Backend documentation at <http://localhost:8080/docs>.

In the `core-engine/frontend` directory, start the Core engine Frontend with the
following commands:

```sh
# Build the Docker image
docker compose build

# Start the Core engine Frontend
docker compose up
```

Access the Core engine Frontend on <http://localhost:3000>.

## Start a dummy service to test the Core engine locally

### Clone the dummy service repository

[average-shade-service](../reference/services/average-shade.md) is a very simple
service that can be used to test the Core engine locally.

Clone the average-shade-service repository with the following command.

```sh
# Clone the average-shade-service repository
git clone https://github.com/swiss-ai-center/average-shade-service
```

### Start the service locally with Docker Compose

In the `average-shade-service` directory, start the service with the following
commands:

```sh
# Build the Docker image
docker compose build

# Start the service
docker compose up
```

Access the service documentation at <http://localhost:9090/docs>.

## Try out the Core engine with the dummy service

Access the Core engine on <http://localhost:3000> or
<http://localhost:8080/docs> to validate the service has been successfully
registered to the Core engine.

Try out the service by uploading an image and clicking on the `Run` button.

It should return the average shade of the image.

## Conclusion

Congratulations! You have successfully started the Core engine and a dummy
service to try out the features of the Core engine.

## Go further

Follow the official tutorials by following the
[Getting started](./getting-started.md) guide.
