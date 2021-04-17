# LiveDocs Generator action

This action generates the necessary documents to publish your documentation with LiveDocs.

## Inputs

### `documentation_folder`

**Required** Path to the folder containing your documentation. Default `"docs"`.

### `application_name`

Name of your project / application. Default `"Your project's name"`.

## Example usage

```yaml
uses: thoorium/livedocs-action@v1
with:
  documentation_folder: 'docs'
```
