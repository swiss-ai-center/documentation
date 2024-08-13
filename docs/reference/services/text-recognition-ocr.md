# text-recognition-ocr

- [:material-account-group: Main author - HEIA-FR](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/text-recognition-ocr-service)
- [:material-kubernetes: Deployment configuration](https://github.com/swiss-ai-center/text-recognition-ocr-service/tree/main/kubernetes)
- [:material-test-tube: Staging](https://text-recognition-ocr-swiss-ai-center.kube.isc.heia-fr.ch)
- [:material-factory: Production](https://text-recognition-ocs.swiss-ai-center.ch)

## Description

!!! note

    More information about the service specification can be found in the
    [**Core concepts > Service**](../core-concepts/service.md) documentation.

This service takes a PNG or JPG image as input and performs optical text recognition (OCR) on it using Tesseract 5.
The result is returned as a JSON containing the detected text and its bounding boxes.

## Model
This service uses Tesseract through [pytesseract](https://pypi.org/project/pytesseract/).
For more details about Tesseract 5, head to its [github page](https://github.com/tesseract-ocr/tesseract/releases).


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
