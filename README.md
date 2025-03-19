# Book Template

A complete starter kit for writing and publishing books in multiple formats using Markdown, Pandoc, and GitHub Actions.

## Features

- **Multi-format Publishing**: Generate PDF, EPUB, MOBI, and HTML versions of your book from a single source
- **Multilingual Support**: Write in multiple languages with full internationalization support
- **Automated Builds**: GitHub Actions workflow for continuous integration and publishing
- **Responsive Design**: HTML output works on all devices
- **Customizable**: Extensively customizable templates for all output formats
- **Minimal Setup**: Start writing immediately with minimal technical knowledge
- **Docker Support**: Consistent builds using Docker container
- **Releases & Distribution**: Automatic GitHub releases and GitHub Pages deployment

## Quick Start

1. **Create a new repository** from this template by clicking the "Use this template" button
2. **Clone your new repository** to your local machine
3. **Start writing** your book in the `book/en/chapter-01` directory (or create new chapters)
4. **Commit and push** your changes to GitHub
5. **GitHub Actions will automatically build** your book in all formats
6. **Download the artifacts** from the GitHub Actions workflow or the latest release

That's it! You'll have a beautifully formatted book in multiple formats.

## Directory Structure

```
your-book-repo/
├── book/                  # Your book content
│   ├── en/                # English content
│   │   ├── chapter-01/    # Chapter files in markdown
│   │   ├── chapter-02/
│   │   └── images/        # Language-specific images
│   ├── es/                # Spanish (or other languages)
│   └── images/            # Global images
├── art/                   # Cover and promotional art
├── templates/             # Customizable templates
├── tools/                 # Build scripts and utilities
├── build.sh               # Main build script
└── README.md              # Project documentation
```

## Writing Your Book

1. Start by creating or editing markdown files in the `book/en/chapter-01` directory
2. Files are processed in alphanumeric order, so name them accordingly (e.g., `00-introduction.md`, `01-first-section.md`)
3. Use standard markdown formatting with support for:
   - Headers (# for chapter titles, ## for sections, etc.)
   - Images, links, tables
   - Code blocks with syntax highlighting
   - And more!

## Building Locally

You can build your book locally using Docker:

```bash
# Pull the book-builder image
docker pull iksnae/book-builder:latest

# Run the build script inside the container
docker run --rm -v $(pwd):/workspace iksnae/book-builder:latest /workspace/build.sh
```

Or directly if you have the required dependencies installed:

```bash
./build.sh
```

## Customization

This template is highly customizable. See [CUSTOMIZATION.md](CUSTOMIZATION.md) for complete details on:

- Changing book metadata (title, author, etc.)
- Customizing page layout and styling
- Adding custom fonts
- Modifying the build process
- And more!

## Multilingual Support

To add a new language:

1. Create a new directory under `book/` with the language code (e.g., `book/fr/` for French)
2. Copy or create content following the same structure as the English version
3. The build system will automatically detect and build all languages

See [docs/multilingual.md](docs/multilingual.md) for more details.

## GitHub Pages

Your book's HTML version will be automatically deployed to GitHub Pages. Access it at:
`https://yourusername.github.io/your-repo-name/`

## Examples

See the [example/](example/) directory for a complete example book.

## Documentation

- [Getting Started Guide](docs/getting-started.md)
- [Customization Guide](docs/customization.md)
- [Multilingual Guide](docs/multilingual.md)
- [Troubleshooting](docs/troubleshooting.md)

## About This Template

This template was created by extracting and enhancing the build system from the [Actual Intelligence](https://github.com/iksnae/actual-intelligence) book project, a practical guide to using AI in everyday life.

## License

This template is released under the MIT License. See [LICENSE](LICENSE) for details.