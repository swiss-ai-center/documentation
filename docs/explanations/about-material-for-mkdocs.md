# About Material for MkDocs

[Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) is a
documentation framework based on [MkDocs](https://www.mkdocs.org/).

It has a better looking interface than plain MkDocs and offers various features
to help organize your documentation with Markdown.

## How and why do we use Material for MkDocs

We use Material for MkDocs to generate the documentation website.

## Install Material for MkDocs

Following the instructions in the
[documentation](https://github.com/swiss-ai-center/documentation) repository to
install and run Material for MkDocs.

## Configuration

The configuration for Material for MkDocs is located in the `mkdocs.yml`
configuration file.

## Common tasks

### Add a new page

Add a new page by creating a new file/directory in the `docs` directory. All
pages must have a `.md` file extension.

### Add a new navigation entry

Add a new entry to the navigation in the `mkdocs.yml` file under the `nav`
property.

### Add a new glossary entry

Add a new entry to the glossary in the `docs/glossary.md` file.

The format must be as follow.

``` markdown
*[Abbr]: The full definition of the abbreviation
```

Each word that Material for MkDocs will find in the documentation will have a
tooltip with the definition for the word.

## Resources and alternatives

These resources and alternatives are related to the current item (in
alphabetical order).

- [Docsify](https://docsify.js.org/)
- [Docusaurus](https://docusaurus.io/)
- [GitBook](https://www.gitbook.com/)
- [Hugo](https://gohugo.io/)
- [Material for MkDocs - Icons, Emojis](https://squidfunk.github.io/mkdocs-material/reference/icons-emojis/)
- [PyMdown Extensions Documentation - Keys](https://facelessuser.github.io/pymdown-extensions/extensions/keys/)
- [VuePress](https://vuepress.vuejs.org/)
