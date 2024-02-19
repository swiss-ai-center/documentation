# About databases

We use two databases in the Swiss AI Center: PostgreSQL and SQLite.

As the website of [PostgreSQL](https://flake8.pycqa.org/en/latest/index.html)
mentions:

!!! quote

    `PostgreSQL` is a powerful, open source object-relational database system
    with over 35 years of active development that has earned it
    a strong reputation for reliability, feature robustness, and performance.

As the website of [SQLite](https://www.sqlite.org/index.html) mentions:

!!! quote

    `SQLite` is a C-language library that implements a small, fast,
    self-contained, high-reliability, full-featured, SQL database engine.

## How and why do we use databases

We use databases to store data in a structured way. Our models are automatically created in the database using the
`SQLModel` library. We use `PostgreSQL` for production and `SQLite` for development.

!!! note

    `PostgreSQL` can be used for development as well.

## Install databases

### Install PostgreSQL

Follow the
[_PostgreSQL installation tutorial_ - postgresqltutorial.com](https://www.postgresqltutorial.com/install-postgresql/).

### Install SQLite

SQLite is already installed in Python by default.

## Configuration

PostgreSQL use the port `5432` by default. The database name, user and password are set in the environment variables.

SQLite does not require any configuration.

## Resources and alternatives

These resources and alternatives are related to the current item (in
alphabetical order).

_None at the moment._
