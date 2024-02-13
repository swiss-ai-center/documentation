# About flake8

As the website of [flake8](https://flake8.pycqa.org/en/latest/index.html)
mentions:

!!! quote

    `flake8` is a command-line utility for enforcing style consistency across Python
    projects.

## How and why do we use flake8

`flake8` is used in the CI/CD pipeline to ensure that the code quality is
maintained and that the code is consistent across the project.

## Install flake8

flake8 is a Python package, so it can be installed using pip:

```bash
pip install flake8
```

## Configuration

You can configure flake8 by creating a `.flake8` file in the root of your
project. In the Swiss AI Center, we use the following configuration:

```ini
[flake8]
exclude = .git,__pycache__,venv,.venv
max-line-length = 120
```

## Resources and alternatives

These resources and alternatives are related to the current item (in
alphabetical order).

_None at the moment._
