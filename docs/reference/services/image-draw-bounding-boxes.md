# image-draw-bounding-boxes

- [:material-account-group: Main author - HEIA-FR](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/text-recognition-ocr-service)
- [:material-kubernetes: Deployment configuration](https://github.com/swiss-ai-center/text-recognition-ocr-service/tree/main/kubernetes)
- [:material-test-tube: Staging](https://text-recognition-ocr-swiss-ai-center.kube.isc.heia-fr.ch)
- [:material-factory: Production](https://text-recognition-ocs.swiss-ai-center.ch)

## Description

!!! note

    More information about the service specification can be found in the
    [**Core concepts > Service**](../core-concepts/service.md) documentation.

This microservice draws boxes on an image. It is intended to work with the text recognition OCR service. The bounding boxes are passed in a JSON file that corresponds to the output of the text recognition service. Namely, it must have the following structure:
```
{"boxes":[
    "position":{
        "left": ...,
        "top": ...,
        "width": ...,
        "height": ...,
    },
    {"position": ...},
    ...
]}
```
Where the values in "left", "top", "width" and "height" are given in pixels. The bounding boxes are drawn as red unfilled rectangles at the coordinates specified by the 4 fields above.

The JSON file may contain additional fields; they will be ignored.

## Tools
The service uses Pillow to draw the boxes.


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
