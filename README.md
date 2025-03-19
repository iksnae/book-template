![](./art/image.jpg)

# DIY Book Starter Kit

A flexible, Markdown-based book writing and publishing system that generates professional quality books in multiple formats. Perfect for authors, educators, and documentation writers who want full control over their publishing process.

## Features

- Write your book in simple Markdown format
- Generate PDF, EPUB, MOBI, and HTML outputs
- Support for multiple languages
- Customizable templates and styling
- Built-in configuration system
- GitHub Actions integration for automatic builds

## Getting Started

### Using the Template (Recommended)

This is a template repository. The easiest way to get started is:

1. Click the **Use this template** button at the top of this page
2. Name your new repository and create it
3. Clone your new repository and start customizing

For a quick introduction, check out the [QUICK-START.md](./QUICK-START.md) guide.

### Manual Clone

Alternatively, you can clone this repository directly:

```
git clone https://github.com/iksnae/book-template.git my-book
cd my-book
```

## Next Steps

1. Edit the book configuration in `book.yaml`
2. Write your content in the `book/en/` directory (or other language directories)
3. Build your book:
   ```
   ./build.sh
   ```
4. Find your book outputs in the `build/` directory

## Directory Structure

```
.
├── art/                   # Cover images and artwork
├── book/                  # Book content in Markdown
│   ├── en/                # English content
│   │   ├── chapter-01/    # First chapter
│   │   │   ├── 00-introduction.md
│   │   │   ├── 01-section.md
│   │   │   └── images/    # Chapter-specific images
│   │   ├── chapter-02/    # Second chapter
│   │   └── images/        # Language-specific images
│   └── es/                # Spanish content (optional)
├── build/                 # Output directory (created during build)
├── templates/             # Templates for output formats
│   ├── default/           # Default assets and fallbacks
│   ├── epub/              # EPUB-specific templates
│   ├── html/              # HTML-specific templates
│   └── pdf/               # PDF/LaTeX templates
└── tools/                 # Build tools and scripts
    └── scripts/           # Build scripts
```

## Configuration

The `book.yaml` file controls all aspects of your book build:

```yaml
# Basic Information
title: "Your Book Title"
subtitle: "An Optional Subtitle"
author: "Your Name"
publisher: "Your Publisher"
language: "en"  # Main language code

# File naming
file_prefix: "your-book"  # Used for output filenames

# Output formats to generate
outputs:
  pdf: true
  epub: true
  mobi: true
  html: true

# Languages to build
languages:
  - "en"  # English
  # - "es"  # Spanish (uncomment to add)

# Format-specific settings
pdf:
  paper_size: "letter"  # letter, a4, etc.
  template: "templates/pdf/default.latex"
  
epub:
  cover_image: "art/cover.png"
  css: "templates/epub/style.css"

html:
  template: "templates/html/default.html"
  css: "templates/html/style.css"
```

## Writing Content

Content is written in standard Markdown with a few conventions:

1. **Chapter Structure**: Create directories named `chapter-XX` where XX is a number (01, 02, etc.)
2. **Chapter Introduction**: Use `00-introduction.md` for chapter introductions
3. **Content Sections**: Name content files with numeric prefixes (e.g., `01-section.md`, `02-section.md`)
4. **Images**: Place images in the `images/` directory within each chapter or language directory

## Build Options

The build script accepts several options:

```
./build.sh [--all-languages] [--lang=XX] [--skip-pdf] [--skip-epub] [--skip-mobi] [--skip-html]
```

Options:
- `--all-languages`: Build all languages defined in book.yaml
- `--lang=XX`: Build only the specified language (e.g., `--lang=es` for Spanish)
- `--skip-pdf`, `--skip-epub`, etc.: Skip generating specific output formats

## Output Customization

### PDF/LaTeX

Edit `templates/pdf/default.latex` to customize the PDF appearance.

### EPUB

Edit `templates/epub/style.css` to customize the EPUB styling.

### HTML

Edit `templates/html/default.html` and `templates/html/style.css` to customize the HTML output.

## Requirements

To build books locally, you'll need:

1. **Docker** (recommended approach):
   - Use the `iksnae/book-builder` Docker image which contains all dependencies

2. **Manual Installation**:
   - Pandoc (document conversion)
   - LaTeX (for PDF generation)
   - Calibre's ebook-convert tool (for MOBI generation)

## GitHub Actions Integration

This template includes GitHub Actions workflows that automatically build your book when you push changes. The workflow:

1. Builds all languages and formats
2. Creates GitHub releases with book files
3. Deploys the HTML version to GitHub Pages

## License

This template is open source and available under the MIT License.

## Credits

Developed in partneship with [Khaos Studio](http://khaos.studio).
