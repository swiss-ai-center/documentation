# summarization

- [:material-account-group: Main author - HE-Arc](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/summarization-service)
- [:material-kubernetes: Deployment configuration](https://github.com/swiss-ai-center/summarization-service/tree/main/kubernetes)
- [:material-test-tube: Staging](https://summarization-swiss-ai-center.kube.isc.heia-fr.ch/docs)
- [:material-factory: Production](https://summarization-service.swiss-ai-center.ch)

## Description

!!! note

    More information about the service specification can be found in the
    [**Core concepts > Service**](../core-concepts/service.md) documentation.

This service uses
[langchain](https://python.langchain.com/docs/get_started/introduction) and LLMs
to create summaries of documents. The technique used for the summarization is
the
[Map/reduce](https://python.langchain.com/v0.2/docs/tutorials/summarization/#map-reduce)
technique showed by langchain. Each document will be summarized individually
(Mapping phase) and then all the summaries will be combined into a single
summary (Reduce phase).

The LLMs used by this service are hosted by [Ollama](https://ollama.ai/).

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

### Deploy ollama locally

add the following container to the `stateful.yml` deployment file

```yaml
- name: ollama
image: ollama/ollama
ports:
- name: http
    containerPort: 11434
command: ["/bin/bash", "-c"]
args:
- |
    ollama serve &
    sleep 10
    ollama pull mistral:instruct
    sleep infinity
resources:
    requests:
    tencent.com/vcuda-core: 20
    tencent.com/vcuda-memory: 8
    limits:
    tencent.com/vcuda-core: 20
    tencent.com/vcuda-memory: 8
```
