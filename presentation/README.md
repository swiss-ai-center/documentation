---
marp: true
---

<!--
theme: uncover
size: 16:9
paginate: true
author: Swiss AI Center contributors
title: 'Core AI Engine - Presentation'
description: 'Presentation of the Swiss AI Center project Core AI Engine'
url: https://docs.swiss-ai-center.ch/presentation/
footer: '**Swiss AI Center** - 2022-2026 - Apache License 2.0'
style: |
    blockquote {
        font-style: italic;
    }
    table {
        width: 100%;
    }
    th:first-child {
        width: 15%;
    }
    h1, h2, h3, h4, h5, h6 {
        color: var(--color-headings);
    }
    h2, h3, h4, h5, h6 {
        text-transform: uppercase;
        font-size: 1.5rem;
    }
    h1 a:link, h2 a:link, h3 a:link, h4 a:link, h5 a:link, h6 a:link {
        text-decoration: none;
    }
    hr {
        border: 1px solid var(--color-foreground);
        margin-top: 50px;
        margin-bottom: 50px
    }
    .center {
        text-align: center;
    }
    .left-text{
        text-align: left;
    }
    .normal-text {
        text-align: justify;
    }
headingDivider: 4
-->
[illustration]: ./images/logo.png
[license]: https://github.com/swiss-ai-center/core-engine/blob/main/LICENSE
[website]: https://swiss-ai-center.ch
[website-qrcode]:
    https://quickchart.io/qr?format=png&ecLevel=Q&size=400&margin=1&text=https://swiss-ai-center.ch
[github]: https://github.com/swiss-ai-center/core-engine
[documentation]: https://docs.swiss-ai-center.ch/core-engine/
[guide]: https://mlops.swiss-ai-center.ch/

# Core AI Engine

<!--
_class: lead
_paginate: false
-->

[Website][website] · [GitHub][github] · [Documentation][documentation] · [Guide][guide]

<small>Swiss AI Center contributors</small>

<small>This work is licensed under the [Apache License 2.0][license] license.</small>

![](./images/logo.png)
## Introduction

<!--
_class: lead
_paginate: false
-->

## Swiss AI Center

<!-- _class: normal-text -->
<small>

- **Five schools from the HES-SO**
(HEIG-VD, HEIA-FR, HE-Arc, HEVS and HEPIA)
- Project called **Centre Suisse d’Intelligence Artificiel à destination des PMEs (CSIA-PME)**, also known as the **Swiss AI Center**.
- The center’s mission is to **accelerate the adoption of artificial
intelligence in the digital transition of Swiss SMEs**.

</small>

## AIOnDemand Positioning

<!-- _class: normal-text -->
<small>

- The platform at [app.swiss-ai-center.ch](https://app.swiss-ai-center.ch) is a Swiss/regional implementation aligned with the **AI on Demand (AIoD)** concept.
- It is not the official pan-European AIoD platform, but it is technically and strategically aligned with it.
- In the context of **AI4EU** and **AI4Europe**, AIoD is a marketplace and sandbox where companies, especially SMEs, can access pre-trained models, datasets, and compute without building massive infrastructure.

</small>

## AIOnDemand in Switzerland

<!-- _class: normal-text -->
<small>

- The Swiss AI Center and its **Core AI Engine** perform this exact role for the Swiss ecosystem.
- It provides a catalog of AI assets (algorithms, tools, and services) that SMEs can call upon to build prototypes.

</small>

## Features

<!--
_class: lead
_paginate: false
-->

---

<!-- _class: lead -->

- Centralize **ML services**
- Unify ML services specifications with a **HTTP REST API**
- **Orchestrate** multiple ML services **through pipelines**

![bg right:39% 80%](./images/webapp.png)

---

- Beautiful **frontend to visualize** services and pipelines
- Extensive **documentation** available
- Best practices regarding software development (code reviews, CI/CD)
- **Open source**

![bg right:39% 80%](./images/webapp.png)

## Infrastructure

<!--
_class: lead
_paginate: false
-->

---

<img src="images/infrastructure.png" alt="drawing" width="85%"
justify="center"/>

## Service specification

<!--
_class: lead
_paginate: false
-->

---

<!-- _class: lead -->

<small>

- Can be in **any language** that can implement a **REST API**
- Must have the **required routes** to be “engine” compliant
- The /compute route must accept the **“Task” model**
- Can have its own routes (for specific purposes)
- Can be auto-scaled with **KEDA** on Kubernetes

</small>

![bg right:50% 95%](./images/service.png)


## Pipeline specification

<!--
_class: lead
_paginate: false
-->

---

<!-- _class: lead -->

<small>

A JSON file containing base information:
- Name
- Slug
- Summary
- Description
- Input/Output
- Tags


</small>

![bg right:45% 90%](./images/pipeline.png)

---

<!-- _class: normal-text -->

<small>

<p class="left-text">And a list of “Steps” representing the sequel of services to run with the following data:</p>

- **Identifier** (used in the “needs”, “conditions” and “inputs” values)
- **Needs** (used to wait until all the services in the array finished their task)

</small>

![bg right:45% 90%](./images/pipeline.png)

---


- **Condition** ([optional] if this specific step should match a condition before being run)
- **Inputs** (which data should be put in the entry of the service)


![bg right:45% 90%](./images/pipeline.png)

---


![bg 90%](./images/pipeline-creation-complete.png)

## Next steps

<!--
_class: lead
_paginate: false
-->

---

<!-- _class: lead -->

<small>

- Pipeline branching
- Auto-update of services based on the Github Template
- Toy datasets
- And many more…


</small>

![bg right:45% 90%](./images/pipe.png)

## Any questions? 😄

<!--
_class: lead
_paginate: false
-->

## Useful links

<!-- _class: lead -->

<small>

- [Official website](https://swiss-ai-center.ch)
- [Documentation](https://docs.swiss-ai-center.ch)
- [Frontend demo](https://app.swiss-ai-center.ch)
- [Backend demo](https://core-engine.swiss-ai-center.ch)
- [Guide to MLOps](https://mlops.swiss-ai-center.ch)
- [Chatbot](https://chatbot.swiss-ai-center.ch)
- [GitHub](https://github.com/swiss-ai-center/)

</small>

![bg right:45% 90%](./images/pipe.png)
