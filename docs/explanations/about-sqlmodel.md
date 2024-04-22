# About SQLModel

As the website of [SQLModel](https://sqlmodel.tiangolo.com/) mentions:

!!! quote

    `SQLModel`, SQL databases in Python, designed for simplicity, compatibility, and
    robustness.

## How and why do we use SQLModel

`SQLModel` is used to create a simple and robust ORM for SQL databases. It is
used to create models and interact with the database. It is a framework based on
`Pydantic` and `SQLAlchemy`.

## Install SQLModel

SQLModel can be installed using pip:

```bash
pip install sqlmodel
```

## Configuration

The configuration of SQLModel is done through the models and the database
connection.

```python
from sqlmodel import SQLModel, create_engine

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
- [Python pitfalls](./about-python-pitfalls.md)
- [SQLite](./about-sqlite.md)
- [SQLModel](./about-sqlmodel.md)
