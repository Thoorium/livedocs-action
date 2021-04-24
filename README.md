# LiveDocs Generator action

This action generates the necessary documents to publish your documentation with LiveDocs.

## Inputs

### `documentation_folder`

**Required** Path to the folder containing your documentation. Default `"docs"`.

### `application_name`

Name of your project / application. Default `"Your project's name"`.

### `theme_css`

Comma (,) separated list of css files to add to the website.

### `theme_js`

Comma (,) separated list of javascript files to add to the website.

### `theme_resources`

Comma (,) separated list of resources files to add to the website.

## Example usage

```yaml
uses: thoorium/livedocs-action@v1
with:
  documentation_folder: 'docs'
```
