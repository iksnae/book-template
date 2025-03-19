# Customization Guide

This guide explains how to customize your book's appearance, layout, and behavior.

## Book Configuration (book.yaml)

The `book.yaml` file in the root of your repository is the main configuration file for your book. It controls metadata, output formats, and appearance settings.

### Basic Metadata

```yaml
# Basic Information
title: "Your Book Title"
subtitle: "Your Book Subtitle"
author: "Your Name"
publisher: "Publisher Name"
year: "2025"
language: "en"  # Main language code (ISO 639-1)

# File naming
file_prefix: "your-book"  # Output filenames (e.g., your-book.pdf)
```

### Output Format Settings

You can enable or disable specific output formats:

```yaml
# Output formats
outputs:
  pdf: true
  epub: true
  mobi: true
  html: true
```

### PDF Settings

```yaml
# PDF settings
pdf:
  paper_size: "letter"  # letter, a4, etc.
  margin_top: "1in"
  margin_right: "1in"
  margin_bottom: "1in"
  margin_left: "1in"
  font_size: "11pt"
  line_height: "1.5"
  template: "templates/pdf/default.latex"  # Custom LaTeX template
  
  # Additional PDF settings
  mainfont: "DejaVu Serif"
  sansfont: "DejaVu Sans"
  monofont: "DejaVu Sans Mono"
  linkcolor: "blue"
  urlcolor: "blue"
  toc_depth: 3
```

### EPUB Settings

```yaml
# EPUB settings
epub:
  cover_image: "art/cover.png"
  css: "templates/epub/style.css"
  toc_depth: 3
  chapter_level: 1
  fonts:
    - "templates/epub/fonts/libertinus-serif.ttf"
```

### HTML Settings

```yaml
# HTML settings
html:
  template: "templates/html/default.html"
  css: "templates/html/style.css"
  toc: true
  toc_depth: 3
  section_divs: true
  self_contained: true
  syntax_highlighting: true
  math_output: "mathjax"
```

### Advanced Metadata

```yaml
# Metadata
metadata:
  rights: "Copyright © 2025 Your Name. All rights reserved."
  description: "A comprehensive guide to book publishing."
  subject: "Writing, Publishing, Technology"
  keywords: "writing, publishing, markdown, digital books"
  identifier: "978-0-9000000-0-0"  # ISBN or other identifier
```

## Customizing Templates

### PDF/LaTeX Customization

1. **Copy the default template**: Start by copying the default LaTeX template from `templates/pdf/default.latex` to create your own (e.g., `templates/pdf/custom.latex`).

2. **Update your configuration**: Point to your custom template in `book.yaml`:
   ```yaml
   pdf:
     template: "templates/pdf/custom.latex"
   ```

3. **Modify the template**: Edit your custom template to change:
   - Page layout and margins
   - Typography and fonts
   - Headers and footers
   - Title page design
   - Chapter and section styling

4. **Common LaTeX customizations**:
   - Font family: `\setmainfont{Font Name}`
   - Page numbering style: `\pagenumbering{roman}` or `\pagenumbering{arabic}`
   - Header/footer style: Modify the `\fancyhead` and `\fancyfoot` commands
   - Title page: Modify the `titlepage` environment

### HTML Customization

1. **CSS Styling**: Edit the `templates/html/style.css` file to change:
   - Colors and typography
   - Layout and spacing
   - Navigation bar appearance
   - Mobile responsiveness

2. **HTML Template**: Modify `templates/html/default.html` to change:
   - Page structure
   - Navigation elements
   - JavaScript functionality
   - Meta tags and SEO elements

3. **Example CSS changes**:
   ```css
   /* Change colors */
   :root {
     --text-color: #333;
     --link-color: #007bff;
     --background-color: #fff;
   }
   
   /* Modify typography */
   body {
     font-family: "Noto Serif", serif;
     line-height: 1.8;
   }
   
   /* Adjust layout */
   .book-content {
     max-width: 42rem;
     padding: 2rem 1.5rem;
   }
   ```

### EPUB Customization

1. **CSS Styling**: Edit the `templates/epub/style.css` file to change the appearance of your EPUB.

2. **Custom Fonts**: Add custom fonts to `templates/epub/fonts/` and reference them in your CSS:
   ```css
   @font-face {
     font-family: "My Custom Font";
     src: url("fonts/my-custom-font.ttf");
   }
   ```

3. **Keep it simple**: E-readers have limited CSS support, so keep styles minimal and focused on readability.

## Advanced Customization

### Creating Custom Pandoc Filters

For advanced customization, you can create custom Pandoc filters:

1. Create a new filter in the `tools/filters/` directory:
   ```lua
   -- tools/filters/custom.lua
   function Header(el)
     -- Modify headers
     return el
   end
   ```

2. Add the filter to your build process by editing the build scripts or specifying it in your configuration.

### Custom Build Scripts

You can customize the build process by modifying the scripts in `tools/scripts/`:

1. **Customizing the PDF generation**: Edit `tools/scripts/generate-pdf.sh`
2. **Customizing the EPUB generation**: Edit `tools/scripts/generate-epub.sh`
3. **Customizing the HTML generation**: Edit `tools/scripts/generate-html.sh`

### Adding Custom Front Matter

To add custom front matter (e.g., dedication, copyright page):

1. Create a new file `book/en/front-matter/dedication.md`:
   ```markdown
   # Dedication
   
   To my family and friends...
   ```

2. Modify the `tools/scripts/combine-markdown.sh` script to include your front matter files.

### Customizing the Table of Contents

You can control the table of contents through the `toc_depth` setting in your configuration. To customize beyond that:

1. For PDF: Modify the LaTeX template
2. For HTML: Edit the CSS and HTML template
3. For EPUB: Adjust the CSS and EPUB settings

## Styling Examples

### Modern Clean Style

```yaml
# book.yaml
pdf:
  paper_size: "a5"
  margin_top: "0.75in"
  margin_right: "0.75in"
  margin_bottom: "0.75in"
  margin_left: "0.75in"
  mainfont: "Roboto"
  sansfont: "Roboto"
  monofont: "Roboto Mono"
  fontsize: "11pt"
```

```css
/* templates/html/style.css */
:root {
  --text-color: #333;
  --link-color: #0366d6;
  --background-color: #fff;
  --code-background: #f6f8fa;
  --heading-color: #24292e;
  --font-main: "Segoe UI", Roboto, -apple-system, sans-serif;
}

body {
  line-height: 1.65;
}

h1, h2, h3 {
  font-weight: 600;
}
```

### Academic Style

```yaml
# book.yaml
pdf:
  paper_size: "a4"
  margin_top: "1.5in"
  margin_right: "1.2in"
  margin_bottom: "1.5in"
  margin_left: "1.2in"
  mainfont: "Linux Libertine O"
  fontsize: "12pt"
```

```css
/* templates/html/style.css */
:root {
  --text-color: #222;
  --link-color: #2a5db0;
  --font-main: "Libre Baskerville", Georgia, serif;
}

body {
  line-height: 1.8;
}

h1, h2, h3 {
  font-family: "Libre Baskerville", Georgia, serif;
  margin-top: 2.5rem;
}

p {
  text-align: justify;
}
```

### Novel Style

```yaml
# book.yaml
pdf:
  paper_size: "5.5in x 8.5in"
  margin_top: "0.75in"
  margin_right: "0.75in"
  margin_bottom: "0.75in"
  margin_left: "0.75in"
  mainfont: "Crimson Pro"
  fontsize: "11.5pt"
```

```css
/* templates/html/style.css */
:root {
  --text-color: #2e2e2e;
  --background-color: #fefbf7;
  --font-main: "Crimson Pro", Georgia, serif;
}

body {
  line-height: 1.7;
}

h1, h2, h3 {
  font-family: "Crimson Pro", Georgia, serif;
}

p:first-of-type::first-letter {
  font-size: 3.5em;
  float: left;
  line-height: 0.8;
  margin-right: 0.1em;
}
```

## Further Customization Resources

For more advanced customization, refer to these resources:

- [Pandoc User Guide](https://pandoc.org/MANUAL.html)
- [LaTeX Documentation](https://www.latex-project.org/help/documentation/)
- [EPUB Specifications](https://www.w3.org/publishing/epub3/epub-spec.html)
