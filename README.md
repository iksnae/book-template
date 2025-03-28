![](./art/image.jpg)

# DIY Book Starter Kit

Create and publish your own professional-looking books with this easy-to-use starter kit. Simply write in plain Markdown text, and automatically generate beautiful books in multiple formats ready for distribution.

## Our Philosophy: Write, Push, Forget

We believe book creation should be simple: **Write your content, Push to GitHub, and Forget about the technical details**. The system automatically handles everything else, delivering beautifully formatted books ready for distribution.

## 📚 Template Guide Book

<div align="center">

[![Download PDF](https://img.shields.io/badge/Download-PDF%20Version-blue?style=for-the-badge&logo=adobe-acrobat-reader)](https://github.com/iksnae/book-template/releases/latest/download/write-and-publish.pdf)
[![Download EPUB](https://img.shields.io/badge/Download-EPUB%20Version-green?style=for-the-badge&logo=apple)](https://github.com/iksnae/book-template/releases/latest/download/write-and-publish.epub)
[![Download MOBI](https://img.shields.io/badge/Download-Kindle%20Version-orange?style=for-the-badge&logo=amazon)](https://github.com/iksnae/book-template/releases/latest/download/write-and-publish.mobi)
[![Read Online](https://img.shields.io/badge/Read-Web%20Version-purple?style=for-the-badge&logo=html5)](https://iksnae.github.io/book-template/)

</div>

## Why Use This Starter Kit?

- **Simple Writing Experience**: Write in Markdown - if you can create a text document, you can create a book
- **Multiple Book Formats**: Automatically generate PDF, e-readers (EPUB, MOBI), and web versions
- **No Technical Knowledge Required**: Everything is set up and ready to use
- **Support for Multiple Languages**: Create books in any language
- **Free and Open Source**: No expensive publishing tools needed
- **Docker-based Build System**: Consistent builds across all environments
- **Seamless GitHub Integration**: Automatic builds, releases, and website deployment

## Getting Started in 3 Easy Steps

1. Click the green **Use this template** button at the top of this page
2. Name your new book project and create it
3. Start writing in the provided chapter templates

Need a quick guide? Check out [QUICK-START.md](./QUICK-START.md) for step-by-step instructions.

## What's Included

This starter kit gives you everything you need to create a professional book:

- Ready-to-use chapter structure
- Professional formatting for all book formats
- Automatic table of contents generation
- Cover page setup
- Publishing to multiple formats with a single command
- Cloud-based build system - no installations required
- Docker-based local build system for consistent results

## How It Works

1. **Set Up Your Book**: Fill in your book details in the simple `book.yaml` file
2. **Write Your Content**: Add your text to the Markdown files in the chapter folders
3. **Publish Changes**: Push your changes to GitHub to trigger the automated build
4. **Get Your Books**: Download beautifully formatted PDF, EPUB, MOBI, and HTML files

## Writing Your Book

Your book content goes in the `book/en/` folder (or other language folders):

- Each chapter has its own folder (`chapter-01`, `chapter-02`, etc.)
- Add your chapter introduction in the `00-introduction.md` file
- Add sections to your chapter in numbered files (`01-section.md`, `02-section.md`, etc.)
- Place images in the `images/` folder within each chapter

## Building Your Book Locally

You have two main options to build your book locally:

### Option 1: Using Docker (Recommended)

The easiest way to build your book is using Docker, which includes all required dependencies:

```bash
# Simply run the build script
./build.sh
```

The build script will detect Docker is installed and ask if you'd like to use it. This ensures a consistent build environment with all dependencies pre-installed.

### Option 2: Using Node.js

If you prefer not to use Docker:

```bash
# Install Node.js dependencies
npm install

# Run the build script
./build.sh
```

When prompted about using Docker, select "no" to use the Node.js implementation.

### Build Command Options

The build command supports several options:

```bash
# Build all languages
./build.sh --all-languages

# Build a specific language
./build.sh --lang=en

# Skip specific formats
./build.sh --skip-pdf --skip-epub
```

## Automatic Publishing

The process happens automatically without any intervention:

1. Push your changes to GitHub
2. GitHub Actions will automatically build all formats
3. Your books will be available with beautiful download buttons like these:

<div align="center">

[![Download PDF](https://img.shields.io/badge/Download-PDF%20Version-blue?style=for-the-badge&logo=adobe-acrobat-reader)](https://github.com/yourusername/your-repo/releases/latest/download/your-book.pdf)
[![Download EPUB](https://img.shields.io/badge/Download-EPUB%20Version-green?style=for-the-badge&logo=apple)](https://github.com/yourusername/your-repo/releases/latest/download/your-book.epub)
[![Download MOBI](https://img.shields.io/badge/Download-Kindle%20Version-orange?style=for-the-badge&logo=amazon)](https://github.com/yourusername/your-repo/releases/latest/download/your-book.mobi)
[![Read Online](https://img.shields.io/badge/Read-Web%20Version-purple?style=for-the-badge&logo=html5)](https://yourusername.github.io/your-repo/)

</div>

Just write and push - we handle the rest!

## Creating Releases

To create a new release with all formats:

```bash
./tag-release.sh v1.0.0
```

This will:
1. Tag your repository with the version
2. Push the tag to GitHub
3. Trigger the release workflow
4. Create a GitHub release with all book formats
5. Deploy the web version to GitHub Pages

## Customizing Your Book

### Basic Settings

Edit `book.yaml` to change:

- Book title and subtitle
- Author name
- Publisher
- Output formats
- Page size and margins

### Advanced Customization

Want to change the look and feel? Edit the templates:

- `templates/pdf/` - Control how the PDF version looks
- `templates/epub/` - Style the e-reader versions
- `templates/html/` - Customize the web version

## Docker-based Build System

This project uses the `iksnae/book-builder` Docker image, which contains:

- Pandoc (for markdown conversion)
- LaTeX (for PDF generation)
- Calibre (for EPUB/MOBI handling)
- Node.js with book-tools
- All necessary dependencies

This ensures consistent builds across different environments and eliminates the need to install dependencies locally.

## Migration Notes

This repository has been migrated to use the standardized book-tools package. For details about the migration, see [MIGRATION_GUIDE.md](./docs/MIGRATION_GUIDE.md).

## License

This starter kit is open source and available under the MIT License.

## Credits

Developed in partnership with [Khaos Studio](http://khaos.studio).
