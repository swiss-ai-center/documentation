# About SQLAlchemy

As the website of [SQLAlchemy](https://www.sqlalchemy.org/) mentions:

!!! quote

    `SQLAlchemy` is the Python SQL toolkit and Object Relational Mapper that gives
    application developers the full power and flexibility of SQL.

## How and why do we use SQLAlchemy

`SQLAlchemy` is used to create a simple and robust ORM for SQL databases. It is
wrapped by `SQLModel` to create models and interact with the database.

## Install SQLAlchemy

SQLAlchemy can be installed using pip:

```bash
pip install sqlalchemy
```

## Configuration

Since `SQLAlchemy` is used by `SQLModel`, the configuration is done through the
models and the database connection.

```python
from sqlalchemy import create_engine

# Define the database URL
DATABASE_URL = "sqlite:///./test.db"

# Create the database engine
engine = create_engine(DATABASE_URL, echo=True)
```

## Resources and alternatives

These resources and alternatives are related to the current item (in
alphabetical order).

- [PostgreSQL](./about-postgresql.md)
- [Pydantic](./about-pydantic.md)
- [SQLite](./about-sqlite.md)
- [SQLModel](./about-sqlmodel.md)
