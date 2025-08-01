# ts-anomaly-detection

- [:material-account-group: Main author - HES-SO Valais-Wallis](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/ts-anomaly-detection-service)
- [:material-kubernetes: Deployment configuration](https://github.com/swiss-ai-center/ts-anomaly-detection-service/tree/main/kubernetes)
- [:material-test-tube: Staging](https://ts-anomaly-detection-swiss-ai-center.kube-ext.isc.heia-fr.ch)
- [:material-factory: Production](https://ts-anomaly-detection-service.swiss-ai-center.ch)

## Description

!!! note

    More information about the service specification can be found in the
    [**Core concepts > Service**](../core-concepts/service.md) documentation.

This service uses
[MOMENT](https://github.com/moment-timeseries-foundation-model/moment) to
identify anomalies in time series. The serviced provided works in a
zero-shot-fashion. However, MOMENT allows fine-tuning. If interested, check
their
[docs and tutorials](https://github.com/moment-timeseries-foundation-model/moment/tree/main/tutorials).

!!! note

    You can download a time series sample from
	[here](https://www.cs.ucr.edu/%7Eeamonn/time_series_data_2018/).
    Choose the .csv format.

The API documentation is automatically generated by FastAPI using the OpenAPI
standard. A user friendly interface provided by Swagger is available under the
`/docs` route, where the endpoints of the service are described.

This simple service only has one route `/compute` that takes a mp3 file as
input, which will be analyzed.

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
