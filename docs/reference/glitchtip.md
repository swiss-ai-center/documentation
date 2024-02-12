# Glitchtip

- [:material-account-group: Main author - HEIA-FR](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/core-engine/tree/main/backend/kubernetes)
- [:material-kubernetes: Deployment configuration](https://github.com/swiss-ai-center/core-engine/tree/main/backend/kubernetes)
- [:material-test-tube: Staging](https://monitor-swiss-ai-center.kube.isc.heia-fr.ch)

## Description

Glitchtip is a self-hosted error monitoring tool. It is a simple and easy to use
tool that allows you to monitor errors in your applications. It is designed to
be easy to use and to be integrated into your existing infrastructure.

## Start locally

To launch your own instance of Glitchtip you can follow the
[official documentation](https://glitchtip.com/documentation/install#docker-compose)
to run it locally. If you want to start it with the same settings as the Swiss
AI Center you can check the
[Kubernetes files](https://github.com/swiss-ai-center/core-engine/tree/main/backend/kubernetes)
and modify them as you need.

Once the instance is launched. Create a Project and copy the Sentry DSN variable
and paste it in the Core Engine env variables.

With that, the errors will automatically be sent to the interface and you can
configure notifications to be notified if something happens.
