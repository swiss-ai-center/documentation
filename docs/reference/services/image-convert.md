# image-convert

- [:material-account-group: Main author - HEIA-FR](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/image-convert-service)
- [:material-kubernetes: Deployment configuration](https://github.com/swiss-ai-center/image-convert-service/tree/main/kubernetes)
- [:material-test-tube: Staging](https://image-convert-swiss-ai-center.kube-ext.isc.heia-fr.ch)
- [:material-factory: Production](https://image-convert-service.swiss-ai-center.ch)

## Description

!!! note

    More information about the service specification can be found in the
    [**Core concepts > Service**](../core-concepts/service.md) documentation.

This service uses Pillows to convert an image to a different format.

The API documentation is automatically generated by FastAPI using the OpenAPI
standard. A user friendly interface provided by Swagger is available under the
`/docs` route, where the endpoints of the service are described.

This simple service only has one route `/compute` that takes an image and a text
as input, which will be used to convert the image.

## Environment variables

Check the
[**Core concepts > Service > Environment variables**](../core-concepts/service.md#environment-variables)
documentation for more details.

## Run the tests with Python

Check the
[**Core concepts > Service > Run the tests with Python**](../core-concepts/service.md#run-the-tests-with-python)
documentation for more details.

## Start the service locally

Check the
[**Core concepts > Service > Start the service locally**](../core-concepts/service.md#start-the-service-locally)
documentation for more details.
