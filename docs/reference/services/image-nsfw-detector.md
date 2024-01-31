# image-nsfw-detector

- [:material-account-group: Main author - HEIA-FR](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/image-nsfw-detector-service)
- [:material-kubernetes: Deployment configuration](https://github.com/swiss-ai-center/image-nsfw-detector-service/tree/main/kubernetes)
- [:material-test-tube: Staging](https://image-nsfw-detector-swiss-ai-center.kube.isc.heia-fr.ch)
- [:material-factory: Production (not available yet)](https://image-nsfw-detector.swiss-ai-center.ch)

## Description

!!! note

    More information about the service specification can be found in the
    [**Core concepts > Service**](../core-concepts/service.md) documentation.

This service takes as input an image and returns a json with information about
the probability that it includes NSFW content.

### NSFW content detection

NSFW stands for *not safe for work*. This Internet slang is a general term
associated to un-appropriate content such as nudity, pornography etc. See e.g.
https://en.wikipedia.org/wiki/Not_safe_for _work. It is important to exercise
caution when viewing or sharing NSFW images, as they may violate workplace
policies or community guidelines.

The current service encapsulates a trained AI model to detect NSFW images with a
focus on sexual content. Caution: the current version of the service is not able
to detect profanity and violence for now.

### Definition of categories

The border between categories is sometimes thin, e.g. what can be considered as
acceptable nudity in some cultural context would be considered as pornography by
others. Therefore we need to disclaim any complaints that would be done by using
the model trained in this project. We can't be taken responsible of any offense
or classifications that would be falsely considered as appropriate or not. To
make the task even more interesting, we went here for two main categories *nsfw*
and *safe* in which we have sub-categories.

- **nsfw**:
  - **porn**: male erection, open legs, touching breast or genital parts,
    intercourse, blowjob, etc; men or women nude and with open legs fall into this
    category; nudity with sperma on body parts is considered porn
  - **nudity**: penis visible, female breast visible, vagina visible in normal
    position (i.e. standing or sitting but not open leg)
  - **suggestive**: images including people or objects making someone think of sex
    and sexual relationships; genital parts are not visible otherwise the image
    should be in the porn or nudity category; dressed people kissing and or touching
    fall into this category; people undressing; licking fingers; woman with tong
    with sexy bra
  - **cartoon_sex**: cartoon images that are showing or strongly suggesting sexual
    situation
- **safe**:
  - **neutral**: all kind of images with or without people not falling into porn,
    nudity or suggestive category
  - **cartoon_neutral**: cartoon images that are not showing or suggesting sexual
    situation

Inspecting the output giving probabilities for the categories (safe vs not-safe)
and the sub-categories, the user can decide where to place the threshold on what
is acceptable or not for a given service.

### Data set used to build the model

A dataset was assembled using existing NSFW image sets and was completed with
web scraping data. The dataset is available for research purpose - contact us if
you want to have an access. Here are some statistics about its conent (numbers
indicate amount of images). The dataset is balanced among the categories, which
should avoid biased classifications.

| categories     | safe    |        |         | nsfw       |        |      |         | total   |       |       |
|----------------|---------|--------|---------|------------|--------|------|---------|---------|-------|-------|
| sub-categories | general | person | cartoon | suggestive | nudity | porn | cartoon | safe    | nsfw  | all   |
| v2.2           | 5500    | 5500   | 5500    | 5500       | 5500   | 5500 | 5500    | 16500   | 22000 | 38500 |

### Model training and performance

We used transfer learning on MobileNetV2 which present a good trade-off between
performance and runtime efficiency.

| Set  | Model                                                   | Whole |       | Val   |       | Test  |       |
|------|---------------------------------------------------------|-------|-------|-------|-------|-------|-------|
|      |                                                         | sa/ns | sub   | sa/ns | sub   | sa/ns | sub   |
| V2.1 | TL_MNV2_finetune_224_B32_AD1E10-5_NSFW-V2.1_DA2.hdf5    |       |       | 95.7% | 85.1% | 95.7% | 86.1% |

In this Table, the performance is reported as accuracy on the safe vs not-safe
(sa/ns) main categories and on the sub-categories (sub). The sub performance in
indeed lower as we have naturally more confusion between some categories and as
there is simply a larger cardinality in the number of classes.

The API documentation is automatically generated by FastAPI using the OpenAPI
standard. A user friendly interface provided by Swagger is available under the
`/docs` route, where the endpoints of the service are described.

This service only has one route `/compute` that takes an image as input, which
will be used to detect NSFW content.

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
