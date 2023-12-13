# Reference

## Common code

- Documentation: [common-code](./common-code.md)
- Code: <https://github.com/swiss-ai-center/common-code>

## Core engine

- Documentation: [core-engine](./core-engine.md)
- Code: <https://github.com/swiss-ai-center/core-engine>
- Staging URL (frontend):
  <https://frontend-core-engine-swiss-ai-center.kube.isc.heia-fr.ch>
- Staging URL (backend):
  <https://backend-core-engine-swiss-ai-center.kube.isc.heia-fr.ch/docs>
- Production URL (frontend): <https://app.swiss-ai-center.ch>
- Production URL (backend): <http://app.swiss-ai-center.ch/api>

## Services

| Documentation                                 | Code                                                               | Staging URL                                                              | Production URL (not available yet)                    |
| --------------------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------------ | ----------------------------------------------------- |
| [ae-ano-detection](./services/ae-ano-detection.md)     | <https://github.com/swiss-ai-center/ae-ano-detection-service>      | <https://ae-ano-detection-swiss-ai-center.kube.isc.heia-fr.ch/docs>      | <https://ae-ano-detection.swiss-ai-center.ch/docs>    |
| [average-shade](./services/average-shade.md)           | <https://github.com/swiss-ai-center/average-shade-service>         | <https://average-shade-swiss-ai-center.kube.isc.heia-fr.ch/docs>         | <https://average-shade.swiss-ai-center.ch/docs>       |
| [digit-recognition](./services/digit-recognition.md)   | <https://github.com/swiss-ai-center/digit-recognition-service>     | <https://digit-recognition-swiss-ai-center.kube.isc.heia-fr.ch/docs>     | <https://digit-recognition.swiss-ai-center.ch/docs>   |
| [face-analyzer](./services/face-analyzer.md)           | <https://github.com/swiss-ai-center/face-analyzer-service>         | <https://face-analyzer-swiss-ai-center.kube.isc.heia-fr.ch/docs>         | <https://face-analyzer.swiss-ai-center.ch/docs>       |
| [face-detection](./services/face-detection.md)         | <https://github.com/swiss-ai-center/face-detection-service>        | <https://face-detection-swiss-ai-center.kube.isc.heia-fr.ch/docs>        | <https://face-detection.swiss-ai-center.ch/docs>      |
| [image-analyzer](./services/image-analyzer.md)         | <https://github.com/swiss-ai-center/image-analyzer-service>        | <https://image-analyzer-swiss-ai-center.kube.isc.heia-fr.ch/docs>        | <https://image-analyzer.swiss-ai-center.ch/docs>      |
| [image-blur](./services/image-blur.md)                 | <https://github.com/swiss-ai-center/image-blur-service>            | <https://image-blur-swiss-ai-center.kube.isc.heia-fr.ch/docs>            | <https://image-blur.swiss-ai-center.ch/docs>          |
| [image-convert](./services/image-convert.md)           | <https://github.com/swiss-ai-center/image-convert-service>         | <https://image-convert-swiss-ai-center.kube.isc.heia-fr.ch/docs>         | <https://image-convert.swiss-ai-center.ch/docs>       |
| [image-crop](./services/image-crop.md)                 | <https://github.com/swiss-ai-center/image-crop-service>            | <https://image-crop-swiss-ai-center.kube.isc.heia-fr.ch/docs>            | <https://image-crop.swiss-ai-center.ch/docs>          |
| [image-greyscale](./services/image-greyscale.md)       | <https://github.com/swiss-ai-center/image-greyscale-service>       | <https://image-greyscale-swiss-ai-center.kube.isc.heia-fr.ch/docs>       | <https://image-greyscale.swiss-ai-center.ch/docs>     |
| [image-resize](./services/image-resize.md)             | <https://github.com/swiss-ai-center/image-resize-service>          | <https://image-resize-swiss-ai-center.kube.isc.heia-fr.ch/docs>          | <https://image-resize.swiss-ai-center.ch/docs>        |
| [image-rotate](./services/image-rotate.md)             | <https://github.com/swiss-ai-center/image-rotate-service>          | <https://image-rotate-swiss-ai-center.kube.isc.heia-fr.ch/docs>          | <https://image-rotate.swiss-ai-center.ch/docs>        |
| [image-sam](./services/image-sam.md)                   | <https://github.com/swiss-ai-center/image-sam-service>             | <https://image-sam-swiss-ai-center.kube.isc.heia-fr.ch/docs>             | <https://image-sam.swiss-ai-center.ch/docs>           |
| [integrity-checker](./services/integrity-checker.md)   | <https://github.com/swiss-ai-center/integrity-checker-service>     | <https://intergrity-checker-swiss-ai-center.kube.isc.heia-fr.ch/docs>    | <https://intergrity-checker.swiss-ai-center.ch/docs>  |
| [doodle](./services/doodle.md)                         | <https://github.com/swiss-ai-center/doodle-service>                | <https://doodle-swiss-ai-center.kube.isc.heia-fr.ch/docs>                | <https://doodle.swiss-ai-center.ch/docs>              |
| [yolov8](./services/yolov8.md)                         | <https://github.com/swiss-ai-center/yolov8-service>                | <https://yolov8-swiss-ai-center.kube.isc.heia-fr.ch/docs>                | <https://yolov8.swiss-ai-center.ch/docs>              |

## Pipelines

| Name      | Services                      |
| --------- | ----------------------------- |
| Face Blur | Face detection, Image blur    |
