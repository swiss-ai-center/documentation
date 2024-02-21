# About Pydantic

As the website of [Pydantic](https://pydantic-docs.helpmanual.io/) mentions:

!!! quote

    Data validation and settings management using Python type annotations.

## How and why do we use Pydantic

`Pydantic` is used to create models and validate data. It is wrapped by
`SQLModel` to create models and interact with the database.

## Install Pydantic

Pydantic can be installed using pip:

```bash
pip install pydantic
```

## Configuration

The configuration of Pydantic is done through the models and the database
connection.

```python
from pydantic import BaseModel

class User(BaseModel):
    id: int
    name: str
    email: str
```

## Resources and alternatives

These resources and alternatives are related to the current item (in
alphabetical order).

- [PostgreSQL](./about-postgresql.md)
- [SQLAlchemy](./about-sqlalchemy.md)
- [SQLite](./about-sqlite.md)
- [SQLModel](./about-sqlmodel.md)
