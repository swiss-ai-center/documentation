# About dotenv support

As the website of
[pydantic](https://docs.pydantic.dev/latest/concepts/pydantic_settings/#dotenv-env-support)
mentions:

!!! quote

    `Dotenv` files (generally named `.env`) are a common pattern that make it easy
    to use environment variables in a platform-independent manner.

## How and why do we use dotenv

`dotenv` is used to store environment variables in a file called `.env` and load
them into the environment when the application starts. This is useful for local
development. It is then overridden by the environment variables set in the
repository secrets.

## Install dotenv

dotenv has no installation requirements. It is a simple file that is read by the
application.

## Configuration

The `.env` file should be placed in the root of the project. Pydantic will
automatically read the file and load the environment variables into the
application when using the `BaseSettings` class.

## Resources and alternatives

These resources and alternatives are related to the current item (in
alphabetical order).

_None at the moment._
