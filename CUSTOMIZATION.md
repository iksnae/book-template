# Customizing Your Book

This guide explains how to customize various aspects of your book built with the Book Template system.

## Basic Customization

The easiest way to customize your book is through the `book.yaml` configuration file in the root of your repository. This file controls:

- Book metadata (title, author, etc.)
- Output formats (PDF, EPUB, MOBI, HTML)
- Language settings
- Format-specific configurations

## Book Metadata

Edit these values in `book.yaml` to change your book's metadata:

```yaml
title: "Your Book Title"
subtitle: "Your Book Subtitle"
author: "Your Name"
publisher: "Publisher Name"
year: "2025"
```

This information appears on the title page, in file metadata, and in e-reader metadata.

## Output File Names

The `file_prefix` in `book.yaml` controls the output filenames:

```yaml
file_prefix: "your-book"
```

This will generate files like `your-book.pdf`, `your-book.epub`, etc.

## PDF Customization

### Page Size and Margins

```yaml
pdf:
  paper_size: "letter"  # Options: letter, a4, a5, etc.
  margin_top: "1in"
  margin_right: "1in"
  margin_bottom: "1in"
  margin_left: "1in"
```

### Font and Typography

```yaml
pdf:
  font_size: "11pt"     # Options: 10pt, 11pt, 12pt
  line_height: "1.5"
  mainfont: "DejaVu Serif"
  sansfont: "DejaVu Sans"
  monofont: "DejaVu Sans Mono"
```

### Custom LaTeX Template

For advanced PDF customization, you can create a custom LaTeX template:

1. Copy the default template from `templates/pdf/default.latex` to a new file
2. Modify the template as needed
3. Update the path in `book.yaml`:

```yaml
pdf:
  template: "templates/pdf/your-custom-template.latex"
```

## EPUB Customization

### Metadata and Cover

```yaml
epub:
  cover_image: "art/cover.png"
  css: "templates/epub/style.css"
  toc_depth: 3
```

### Custom CSS

Create a custom CSS file at `templates/epub/style.css` to control the appearance of your EPUB.

## HTML Customization

```yaml
html:
  template: "templates/html/default.html"
  css: "templates/html/style.css"
  toc: true
  toc_depth: 3
  section_divs: true
  self_contained: true
```

### Custom CSS

Create a custom CSS file at `templates/html/style.css` to control the appearance of your HTML output.

## Advanced Customization

### Custom Templates

The template system supports full customization of the output formats through custom templates:

- **LaTeX Template**: Controls PDF appearance
- **HTML Template**: Controls HTML appearance
- **EPUB Template**: Controls EPUB appearance

Templates are stored in the `templates/` directory.

### Custom Build Scripts

For advanced customization, you can modify the build scripts in the `tools/scripts/` directory:

- `build.sh`: Main build script
- `build-language.sh`: Language-specific build script
- Various format-specific scripts

### Custom Pandoc Options

You can add custom Pandoc options by modifying the build scripts or creating a `pandoc-options.yaml` file.

## Page Breaks and Layout Control

### Forcing Page Breaks

Add a page break with this HTML:

```markdown
<div class="page-break"></div>
```

### Preventing Page Breaks

Keep content together with:

```markdown
<div class="no-break">
Content that should stay together...
</div>
```

## Examples

See the [example/](example/) directory for complete customization examples.

## Need More Help?

- Check the [docs/](docs/) directory for more detailed guides
- See the [Pandoc documentation](https://pandoc.org/MANUAL.html) for advanced options
- Review the [LaTeX documentation](https://www.latex-project.org/help/documentation/) for PDF customization
