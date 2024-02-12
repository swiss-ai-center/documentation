# About GlitchTip

As the website of [GlitchTip](https://glitchtip.com/) mentions:

!!! quote

    `GlitchTip` makes monitoring software easy. Track errors, monitor performance,
    and check site uptime all in one place. Our app is compatible with Sentry client
    SDKs, but easier to run.

## How and why do we use GlitchTip

GlitchTip is a self-hosted error monitoring tool. It is a simple and easy to use
tool that allows you to monitor errors in your applications. It is designed to
be easy to use and to be integrated into your existing infrastructure.

We use it to catch the errors thrown by the
[Core engine](../reference/core-engine.md) and the services.

## Install GlitchTip

To launch your own instance of GlitchTip you can follow the
[official documentation](https://glitchtip.com/documentation/install#docker-compose)
to run it locally.

## Configuration

If you want to start it with the same settings as the Swiss AI Center you can
check the
[Kubernetes files](https://github.com/swiss-ai-center/core-engine/tree/main/backend/kubernetes)
and modify them as you need.

Once the instance is launched, create a project, copy the Sentry DSN variable
and paste it in the [Core engine](../reference/core-engine.md) env variables.

With that, the errors will automatically be sent to the interface and you can
configure notifications to be notified if something happens.

## Resources and alternatives

These resources and alternatives are related to the current item (in
alphabetical order).

[Sentry](https://sentry.io/welcome/) : A more complex and feature-rich error
monitoring tool.
