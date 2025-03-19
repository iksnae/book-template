# Multilingual Book Guide

This guide explains how to create books in multiple languages using the Book Template system.

## Understanding Multilingual Support

The Book Template system is designed to support books in multiple languages from a single repository. Each language has its own directory structure, while sharing the same build system and templates.

Key features:

- Separate content organization for each language
- Language-specific metadata
- Independent publishing for each language
- Shared templates and styling (customizable per language if needed)

## Directory Structure

Here's how the directory structure works for multilingual books:

```
your-book-repo/
├── book/
│   ├── en/                   # English content
│   │   ├── chapter-01/
│   │   ├── chapter-02/
│   │   └── images/
│   ├── es/                   # Spanish content
│   │   ├── chapter-01/
│   │   ├── chapter-02/
│   │   └── images/
│   ├── fr/                   # French content
│   │   ├── chapter-01/
│   │   └── images/
│   └── images/               # Global images shared across languages
```

## Adding a New Language

To add a new language to your book:

1. Create a new directory under `book/` with the appropriate language code:
   ```bash
   mkdir -p book/fr/chapter-01 book/fr/images
   ```

2. Update the `book.yaml` file to include the new language:
   ```yaml
   languages:
     - "en"  # English
     - "es"  # Spanish
     - "fr"  # French
   ```

3. Create the initial content for the new language:
   ```bash
   # Create an introduction file
   touch book/fr/chapter-01/00-introduction.md
   ```

## Language Codes

Use standard ISO 639-1 two-letter language codes:

- `en` - English
- `es` - Spanish
- `fr` - French
- `de` - German
- `it` - Italian
- `ja` - Japanese
- `ko` - Korean
- `pt` - Portuguese
- `ru` - Russian
- `zh` - Chinese

## Language-Specific Configuration

You can customize settings for specific languages by creating language-specific YAML files:

1. Create a language-specific configuration file, e.g., `book.es.yaml` for Spanish
2. Override any settings from the main `book.yaml` file

Example `book.es.yaml` for Spanish:

```yaml
title: "Inteligencia Real"
subtitle: "Una Guía Práctica para Usar la IA en la Vida Cotidiana"
author: "Nombre del Autor"
file_prefix: "inteligencia-real"
```

## Translation Workflow

Here's a recommended workflow for managing translations:

1. **Create the primary language content first**:
   - Develop your content completely in your primary language (e.g., English)
   - Finalize structure and organization
   - Review and edit for clarity

2. **Set up the translation structure**:
   - Create the directory structure for the new language
   - Copy the organization (file names and structure) from the primary language

3. **Translate the content**:
   - Translate each file, maintaining the same Markdown formatting
   - Keep the same file names for corresponding content
   - Update any language-specific references or examples

4. **Handle images**:
   - For images with text, create translated versions in the language-specific images directory
   - For images without text, you can reference the global images

5. **Test the build**:
   - Build the book with the `--lang=XX` option to test a specific language
   - Review the output to ensure formatting is preserved

## Building Multilingual Books

To build all language versions:

```bash
./build.sh --all-languages
```

To build a specific language:

```bash
./build.sh --lang=es  # Build Spanish version
```

## URL Structure for Web Version

The web version of your multilingual book will have the following URL structure:

- Primary language (usually English): `https://username.github.io/repo-name/`
- Other languages: `https://username.github.io/repo-name/XX/` (where XX is the language code)

For example:
- English: `https://username.github.io/repo-name/`
- Spanish: `https://username.github.io/repo-name/es/`
- French: `https://username.github.io/repo-name/fr/`

## Language Switcher

The HTML output includes a language switcher in the navigation bar. This allows readers to switch between available languages easily.

## RTL Languages Support

For right-to-left (RTL) languages like Arabic (`ar`) and Hebrew (`he`), add the `rtl: true` property to your language-specific YAML file:

```yaml
# book.ar.yaml
title: "عنوان الكتاب"
rtl: true
```

The template system will automatically adjust layouts and styling for RTL languages.

## Tips for Multilingual Content

1. **Maintain consistent structure**: Keep the same chapter and section organization across all languages.

2. **Handle language-specific examples**: Some examples or cultural references may need to be adapted for different languages.

3. **Use Unicode correctly**: Ensure proper character encoding for languages with non-Latin alphabets.

4. **Be mindful of text expansion/contraction**: Some languages require more or less space than others (e.g., German text is often 30% longer than English).

5. **Consider using translation tools**: For initial drafts, tools like DeepL or Google Translate can be helpful, but always have a fluent speaker review.

6. **Language-specific typography**: Pay attention to typography rules specific to each language (e.g., quotation marks, number formatting).

## Example: Adding a Spanish Translation

Here's a complete example of adding a Spanish translation to your book:

1. Create the directory structure:
   ```bash
   mkdir -p book/es/chapter-01/images
   ```

2. Create a language-specific configuration:
   ```yaml
   # book.es.yaml
   title: "Título del Libro"
   subtitle: "Subtítulo del Libro"
   author: "Nombre del Autor"
   file_prefix: "titulo-del-libro"
   ```

3. Translate the introduction file:
   ```markdown
   # Capítulo 1: Introducción
   
   Bienvenido a este libro. Este es el primer capítulo...
   ```

4. Build and test the Spanish version:
   ```bash
   ./build.sh --lang=es
   ```

5. Check the output:
   - PDF: `build/titulo-del-libro.pdf`
   - Web: `build/es/index.html`
