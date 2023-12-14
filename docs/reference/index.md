# Reference

This page contains all the projects we manage at the Swiss AI Center.

## Common code

The common code contains code that is shared between the Core engine and the
services.

- Documentation: [common-code](./common-code.md)
- Code: <https://github.com/swiss-ai-center/common-code>

## Core engine

The Core engine allows to create and manage pipelines of microservices.

- Documentation: [core-engine](./core-engine.md)
- Code: <https://github.com/swiss-ai-center/core-engine>
- Staging URL (frontend):
  <https://frontend-core-engine-swiss-ai-center.kube.isc.heia-fr.ch>
- Staging URL (backend):
  <https://backend-core-engine-swiss-ai-center.kube.isc.heia-fr.ch>
- Production URL (frontend): <https://app.swiss-ai-center.ch>
- Production URL (backend): <http://app.swiss-ai-center.ch/api>

## mdwrap

mdwrap is a command line tool to format our Markdown documentation made with
[Material for MkDocs](../explanations/about-material-for-mkdocs.md).

- Documentation: [mdwrap](./mdwrap.md)
- Code: <https://github.com/swiss-ai-center/mdwrap>

## Services

| Documentation                                          | Code                                                               | Staging URL                                                              | Production URL (not available yet)                    |
| ------------------------------------------------------ | ------------------------------------------------------------------ | ------------------------------------------------------------------------ | ----------------------------------------------------- |
| [ae-ano-detection](./services/ae-ano-detection.md)     | <https://github.com/swiss-ai-center/ae-ano-detection-service>      | <https://ae-ano-detection-swiss-ai-center.kube.isc.heia-fr.ch>      | <https://ae-ano-detection.swiss-ai-center.ch>    |
| [average-shade](./services/average-shade.md)           | <https://github.com/swiss-ai-center/average-shade-service>         | <https://average-shade-swiss-ai-center.kube.isc.heia-fr.ch>         | <https://average-shade.swiss-ai-center.ch>       |
| [digit-recognition](./services/digit-recognition.md)   | <https://github.com/swiss-ai-center/digit-recognition-service>     | <https://digit-recognition-swiss-ai-center.kube.isc.heia-fr.ch>     | <https://digit-recognition.swiss-ai-center.ch>   |
| [face-analyzer](./services/face-analyzer.md)           | <https://github.com/swiss-ai-center/face-analyzer-service>         | <https://face-analyzer-swiss-ai-center.kube.isc.heia-fr.ch>         | <https://face-analyzer.swiss-ai-center.ch>       |
| [face-detection](./services/face-detection.md)         | <https://github.com/swiss-ai-center/face-detection-service>        | <https://face-detection-swiss-ai-center.kube.isc.heia-fr.ch>        | <https://face-detection.swiss-ai-center.ch>      |
| [image-analyzer](./services/image-analyzer.md)         | <https://github.com/swiss-ai-center/image-analyzer-service>        | <https://image-analyzer-swiss-ai-center.kube.isc.heia-fr.ch>        | <https://image-analyzer.swiss-ai-center.ch>      |
| [image-blur](./services/image-blur.md)                 | <https://github.com/swiss-ai-center/image-blur-service>            | <https://image-blur-swiss-ai-center.kube.isc.heia-fr.ch>            | <https://image-blur.swiss-ai-center.ch>          |
| [image-convert](./services/image-convert.md)           | <https://github.com/swiss-ai-center/image-convert-service>         | <https://image-convert-swiss-ai-center.kube.isc.heia-fr.ch>         | <https://image-convert.swiss-ai-center.ch>       |
| [image-crop](./services/image-crop.md)                 | <https://github.com/swiss-ai-center/image-crop-service>            | <https://image-crop-swiss-ai-center.kube.isc.heia-fr.ch>            | <https://image-crop.swiss-ai-center.ch>          |
| [image-greyscale](./services/image-greyscale.md)       | <https://github.com/swiss-ai-center/image-greyscale-service>       | <https://image-greyscale-swiss-ai-center.kube.isc.heia-fr.ch>       | <https://image-greyscale.swiss-ai-center.ch>     |
| [image-resize](./services/image-resize.md)             | <https://github.com/swiss-ai-center/image-resize-service>          | <https://image-resize-swiss-ai-center.kube.isc.heia-fr.ch>          | <https://image-resize.swiss-ai-center.ch>        |
| [image-rotate](./services/image-rotate.md)             | <https://github.com/swiss-ai-center/image-rotate-service>          | <https://image-rotate-swiss-ai-center.kube.isc.heia-fr.ch>          | <https://image-rotate.swiss-ai-center.ch>        |
| [image-sam](./services/image-sam.md)                   | <https://github.com/swiss-ai-center/image-sam-service>             | <https://image-sam-swiss-ai-center.kube.isc.heia-fr.ch>             | <https://image-sam.swiss-ai-center.ch>           |
| [integrity-checker](./services/integrity-checker.md)   | <https://github.com/swiss-ai-center/integrity-checker-service>     | <https://intergrity-checker-swiss-ai-center.kube.isc.heia-fr.ch>    | <https://intergrity-checker.swiss-ai-center.ch>  |
| [doodle](./services/doodle.md)                         | <https://github.com/swiss-ai-center/doodle-service>                | <https://doodle-swiss-ai-center.kube.isc.heia-fr.ch>                | <https://doodle.swiss-ai-center.ch>              |
| [yolov8](./services/yolov8.md)                         | <https://github.com/swiss-ai-center/yolov8-service>                | <https://yolov8-swiss-ai-center.kube.isc.heia-fr.ch>                | <https://yolov8.swiss-ai-center.ch>              |

## Pipelines

| Name      | Services                      |
| --------- | ----------------------------- |
| Face Blur | Face detection, Image blur    |
