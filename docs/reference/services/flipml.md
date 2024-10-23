# flipml
- [:material-account-group: Main author - HEIA-FR](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/flipml-service)
- [:material-kubernetes: Deployment configuration](https://github.com/swiss-ai-center/flipml-service/tree/main/kubernetes)
- [:material-test-tube: Staging](https://flipml-swiss-ai-center.kube.isc.heia-fr.ch)
- [:material-factory: Production](https://flipml.swiss-ai-center.ch)

## Description

!!! note

    More information about the service specification can be found in the
    [**Core concepts > Service**](../core-concepts/service.md) documentation.

This service uses a machine learning model to detect if a scanned document is upside down. The document can be uploaded as a png or jpeg image. 
It is resized to 512x512 px before being processed by the model. The return value is either 0 (0° rotation) or 180 (180° rotation, upside down).

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
