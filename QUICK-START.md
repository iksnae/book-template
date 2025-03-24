# Quick Start Guide

This guide will help you get your book project up and running in just a few minutes.

## Initial Setup

After creating your repository from this template:

1. **Set up your GitHub repository**:
   - After clicking "Use this template", name your repository (e.g., "my-amazing-book")
   - Clone your new repository to your computer or edit directly on GitHub

2. **Edit the book configuration**:
   Open `book.yaml` and update:
   - Title
   - Subtitle
   - Author
   - Publisher
   - File prefix (used for output filenames)

## Writing Your Book

1. **Create your first chapter**:
   - Navigate to `book/en/chapter-01/`
   - Edit `00-introduction.md` to write your chapter introduction
   - Create or edit `01-section.md`, `02-section.md`, etc. for additional content

2. **Add images**:
   - Place chapter-specific images in `book/en/chapter-01/images/`
   - Place general images in `book/en/images/`

3. **Add your book cover**:
   - Replace `book/images/cover.png` with your book cover (keep the same filename)

## Building Your Book Locally

You have several options to build and test your book locally:

### Option 1: Using the CLI Tool (Recommended)

The project uses the `book-tools` package with a convenient CLI:

```bash
# Install dependencies first
npm install

# Build your book
npm run build

# Or build interactively
npm run interactive

# Create a new chapter
npm run create-chapter

# Validate configuration
npm run validate
```

### Option 2: Using Docker

If you have Docker installed:

```bash
docker pull iksnae/book-builder:latest
docker run --rm -v $(pwd):/workspace iksnae/book-builder:latest /workspace/build.sh
```

### Option 3: Direct Build Script

```bash
./build.sh
```

## Publishing Your Book

The process is fully automated:

1. **Push your changes to GitHub**:
   - Commit and push your updates to your repository
   - GitHub Actions will automatically detect changes and build your book

2. **Access your books**:
   - Go to your repository's "Actions" tab to see the build progress
   - After the build completes, find your formatted books in the "Releases" section
   - All formats (PDF, EPUB, MOBI, HTML) will be automatically generated

## Available Formats

Each time you publish changes, your book will be available in these formats:

- PDF: Perfect for printing or professional distribution
- EPUB: For most e-readers (Apple Books, Kobo, Nook, etc.)
- MOBI: For Kindle devices
- HTML: Online web version

## Managing Chapters

You can use the CLI to manage your chapters:

```bash
# Create a new chapter
npm run create-chapter

# Check chapter structure
npm run check-chapter
```

## Customizing Format Settings

The `book.yaml` file supports detailed format-specific settings:

```yaml
formatSettings:
  pdf:
    paperSize: "letter"
    marginTop: "1in"
    fontSize: "11pt"
  
  epub:
    coverImage: "book/images/cover.png"
    tocDepth: 3
  
  html:
    toc: true
    selfContained: true
```

## Sharing Your Book

Once built, you can:

1. Share direct links to the release files
2. Download and distribute the files yourself
3. Enable GitHub Pages to host the HTML version online

## Next Steps

For more advanced customization, refer to:
- The full documentation in [README.md](./README.md)
- The [Configuration Documentation](https://github.com/iksnae/book-tools/blob/main/docs/CONFIGURATION.md)
- The [Migration Guide](./docs/MIGRATION_GUIDE.md) if you're upgrading
