# About Python pitfalls

During the development of the [Core engine](../reference/core-engine.md) and all
the services, we have encountered some pitfalls that are worth mentioning.

## Pitfalls

- **Circular dependencies**: Because of the way Python imports modules, circular
  dependencies can be a problem. For example, if you have two modules that import
  each other, you will get an `ImportError`. To avoid this, we used what is called
  forward references. What it does is that it allows you to reference a class that
  is not yet defined, but will be defined later. This is done by using a string
  instead of the actual class. For example, if you have two classes, `A` and `B`,
  and `A` references `B`, you can do the following:
    ```python
    class A:
        b: 'B'
    class B:
        pass
    ``` This way, you can avoid the circular dependency problem.
- **Inheritance**: The
  [class diagram](../reference/core-engine.md/#uml-diagram-future-and-ideal-version)
  we created for the Core engine is a good example of this. We wanted a unique
  entity called ExecutionUnit to be the parent of Service and Pipeline but we
  couldn't do it because of the way SQLModel works with inheritance for the
  database. For now we have two separate entities, Service and Pipeline, that have
  the same attributes. This is not a big problem but it is something to keep in
  mind.

## How and why do we use Python

The [Core engine](../reference/core-engine.md) and all the services are
developed using Python.

## Install Python

Download the installation package for your operating system on the official
[Download center](https://www.python.org/downloads/) and install it (we
currently use 3.11 in our codebase).

## Configuration

_None._

## Resources and alternatives

These resources and alternatives are related to the current item (in
alphabetical order).

- [Python](./about-python.md)
- [SQLModel](./about-sqlmodel.md)
