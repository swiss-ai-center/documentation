# Common code

- [:material-account-group: Main author - HEIA-FR & HEIG-VD](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/common-code)

## Description

The common code contains code that is shared between the Core AI Engine and the
services.

The following elements are shared:

- Python Models
- Task execution and HTTP storage integration
- GitHub Actions

## Service task storage

The shared `ServiceTask` model contains:

- `storage_url`: the Core AI Engine's `/storage` endpoint;
- `task`: the task metadata and input object keys;
- `callback_url`: the Core AI Engine endpoint used to report the task result.

Services do not receive the Core AI Engine's S3-compatible storage credentials.
The common-code task runner downloads every input with
`GET {storage_url}/{key}`, processes the task, and uploads every output as
multipart form data with `POST {storage_url}`. The Core AI Engine returns a
storage key for each uploaded result, which common-code includes in the task
update sent to `callback_url`.

Consequently, a service needs outbound HTTP access to each Core AI Engine where
it is registered.
