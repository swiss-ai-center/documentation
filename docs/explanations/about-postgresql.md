# About PostgreSQL

As the website of [PostgreSQL](https://flake8.pycqa.org/en/latest/index.html)
mentions:

!!! quote

    `PostgreSQL` is a powerful, open source object-relational database system with
    over 35 years of active development that has earned it a strong reputation for
    reliability, feature robustness, and performance.

## How and why do we use PostgreSQL

We use databases to store data in a structured way. Our models are automatically
created in the database using the `SQLModel` library. We use `PostgreSQL` for
production.

!!! note

    `PostgreSQL` can be used for development as well.

## Install PostgreSQL

Follow the
[_PostgreSQL installation tutorial_ - postgresqltutorial.com](https://www.postgresqltutorial.com/install-postgresql/).

## Configuration

PostgreSQL use the port `5432` by default. The database name, user and password
are set in the environment variables.

## Resources and alternatives

These resources and alternatives are related to the current item (in
alphabetical order).

- [Pydantic](./about-pydantic.md)
- [SQLAlchemy](./about-sqlalchemy.md)
- [SQLite](./about-sqlite.md)
- [SQLModel](./about-sqlmodel.md)
