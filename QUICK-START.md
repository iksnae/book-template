# Quick Start Guide

This guide will help you get your book project up and running in just a few minutes.

## Initial Setup

After creating your repository from this template:

1. **Clone your new repository locally**:
   ```bash
   git clone https://github.com/yourusername/your-book-repo.git
   cd your-book-repo
   ```

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
   - Replace `art/cover.png` with your book cover (keep the same filename)

## Building Your Book

### Using Docker (Recommended)

```bash
# Pull the book builder image
docker pull iksnae/book-builder

# Build your book
docker run --rm -v $(pwd):/book iksnae/book-builder
```

### Using GitHub Actions

GitHub Actions will automatically build your book when you push changes to the main branch. The built files will be available as GitHub release assets.

## Output Files

After building, you'll find your book in the following formats in the `build/` directory:

- PDF: `build/your-book-en.pdf`
- EPUB: `build/your-book-en.epub`
- MOBI: `build/your-book-en.mobi` (for Kindle)
- HTML: `build/your-book-en.html`

## Next Steps

For more advanced customization, refer to the full documentation in README.md.
