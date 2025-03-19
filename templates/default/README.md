# Default Templates

This directory contains default templates and assets for the book build system.

## Default Cover

The `cover.png` in this directory is used as a fallback when no custom cover is provided in the `art/` directory.

## Using Custom Templates

To customize any of the default templates:

1. Copy the file you want to modify to the appropriate directory
2. Make your changes to the copy
3. Update your `book.yaml` to point to your custom template

For example, to use a custom LaTeX template:

```yaml
pdf:
  template: "templates/pdf/my-custom-template.latex"
```

## Template Structure

The template system is organized by output format:

- `templates/pdf/` - LaTeX templates for PDF output
- `templates/epub/` - CSS and templates for EPUB output
- `templates/html/` - HTML and CSS templates for web output
- `templates/default/` - Default assets like cover images
