# Book Template Build Scripts

This directory contains the scripts used to build books from markdown source files. These scripts are designed to be flexible, configurable, and support multiple output formats and languages.

## Main Scripts

### build.sh

The main entry point for the build process. It processes command-line arguments and the book.yaml configuration file.

**Usage:**
```bash
./build.sh [--all-languages] [--lang=XX] [--skip-pdf] [--skip-epub] [--skip-mobi] [--skip-html]
```

**Options:**
- `--all-languages`: Build all languages defined in book.yaml
- `--lang=XX`: Build only the specified language (e.g., `--lang=es` for Spanish)
- `--skip-pdf`: Skip PDF generation
- `--skip-epub`: Skip EPUB generation
- `--skip-mobi`: Skip MOBI generation
- `--skip-html`: Skip HTML generation

### setup.sh

Sets up the environment for building the book. This includes creating necessary directories, checking for cover images, and preparing resources.

### build-language.sh

Builds a specific language version of the book. This script is called by build.sh for each language being built.

### combine-markdown.sh

Combines multiple markdown files into a single document for processing. Supports different directory structures and includes metadata from book.yaml.

## Format Generation Scripts

### generate-pdf.sh

Generates a PDF version of the book using pandoc with LaTeX.

### generate-epub.sh

Generates an EPUB version of the book.

### generate-html.sh

Generates an HTML version of the book.

### generate-mobi.sh

Generates a MOBI (Kindle) version of the book from the EPUB version.

## Configuration

All scripts read configuration from the `book.yaml` file in the root directory. This includes:

- Basic metadata (title, author, etc.)
- Format-specific settings (PDF size, margins, etc.)
- Languages to build
- Output formats to generate

## Directory Structure

The scripts support two main directory structures:

1. **Chapter-based structure:**
   ```
   book/
     en/
       chapter-01/
         00-introduction.md
         01-section.md
         02-section.md
       chapter-02/
         00-introduction.md
         01-section.md
       glossary.md
       appendices/
         appendix-a.md
   ```

2. **Simple file-based structure:**
   ```
   book/
     en/
       01-introduction.md
       02-chapter-one.md
       03-chapter-two.md
       04-conclusion.md
       glossary.md
   ```

The scripts automatically detect which structure you're using.

## Dependencies

The build process requires the following dependencies:

- Pandoc (for document conversion)
- LaTeX (for PDF generation)
- Calibre's ebook-convert (for MOBI generation)

These are all included in the `iksnae/book-builder` Docker image, which is used by the GitHub Actions workflow.

## Customization

Most aspects of the build process can be customized through the `book.yaml` file. This includes:

- Output formats and filenames
- PDF settings (paper size, margins, font size)
- EPUB and HTML settings (CSS, templates)
- Directory structure and organization

See the `book.yaml` file in the root directory for more details and examples.
