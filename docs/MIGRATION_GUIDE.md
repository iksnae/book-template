# Migration Guide: Using book-tools in book-template

This guide explains how the book-template repository has been migrated to use the standardized book-tools package instead of its custom build scripts.

## Overview of Changes

The following changes have been made:

1. Updated `build.sh` to use the book-tools CLI in the Docker container
2. Added package.json with book-tools dependency for local development
3. Updated GitHub Actions workflows to use the Docker-based approach
4. Maintained backward compatibility with the existing configuration format

## What You Need to Know

### For Users

If you're just using the book-template to build your books, you have two options:

#### Option 1: Using Docker (Recommended)

The simplest way to build your book is using Docker, which includes all required dependencies:

```bash
./build.sh
```

The script will detect if Docker is installed and ask if you want to use the Docker-based build. If you choose yes, it will run the book-tools build process in a Docker container with all dependencies pre-installed.

This approach ensures consistent builds across different environments and eliminates the need to install dependencies locally.

#### Option 2: Using Node.js

If you prefer not to use Docker:

1. Install Node.js (version 14.x or higher)
2. Run `npm install` in the book-template directory
3. Run `./build.sh` (and select "no" when asked about Docker)

This will use the Node.js implementation of book-tools to build your book.

### Command-Line Options

The command-line options remain the same as before:

```bash
# Build all languages
./build.sh --all-languages

# Build a specific language
./build.sh --lang=en

# Skip specific formats
./build.sh --skip-pdf --skip-epub
```

### For Contributors

If you're contributing to the codebase:

- The book-tools package provides the core functionality
- For local development, both Docker and Node.js options are available
- The legacy scripts in `tools/scripts/` are kept for backward compatibility
- GitHub Actions workflows use the Docker container for CI/CD

## Directory Structure

The directory structure remains unchanged:

```
book-template/
├── book.yaml           # Book configuration
├── book/               # Source content
│   ├── en/             # English content
│   │   ├── 01-chapter-one/  # Chapter directories
│   ├── es/             # Spanish content (similar structure)
│   └── images/         # Common images
├── templates/          # Templates directory
│   ├── pdf/            # PDF templates
│   ├── epub/           # EPUB templates
│   └── html/           # HTML templates
└── build/              # Output directory (created automatically)
```

## Configuration Format

The `book.yaml` format remains unchanged and compatible with both systems:

```yaml
# Basic Information
title: "Your Book Title"
subtitle: "Your Book Subtitle"
author: "Your Name"
publisher: "Publisher Name"
year: "2025"
language: "en"

# File naming
file_prefix: "your-book"

# Output formats
outputs:
  pdf: true
  epub: true
  mobi: true
  html: true

# Languages to build
languages:
  - "en"
  # - "es"
```

## GitHub Actions Integration

Two GitHub Actions workflows are now available:

1. **Build Workflow**: Triggered when content changes or manually from the Actions tab
   - Uses the book-tools CLI in the Docker container
   - Uploads build artifacts for review
   - Creates detailed build summaries

2. **Release Workflow**: Triggered when a tag is pushed or manually from the Actions tab
   - Builds all formats in all languages
   - Creates a GitHub release with release notes
   - Attaches book files to the release
   - Deploys to GitHub Pages for web reading

## Creating Releases

To create a new release:

```bash
# Tag and create a release
./tag-release.sh v1.0.0
```

This will:
1. Tag the repository with the version
2. Push the tag to GitHub
3. Trigger the release workflow in GitHub Actions
4. Build all formats and create a GitHub release
5. Deploy to GitHub Pages for web reading

## Docker Container Details

The `iksnae/book-builder` Docker image contains:

- The book-tools CLI
- Pandoc (for Markdown conversion)
- LaTeX (for PDF generation)
- Calibre (for EPUB/MOBI handling)
- All other required dependencies

This ensures consistent builds regardless of the local environment.

## Troubleshooting

If you encounter issues:

1. **Docker Issues**: 
   - Ensure Docker is installed and running
   - Check if you have permission to run Docker commands

2. **Node.js Issues**:
   - Ensure Node.js (v14+) is installed
   - Run `npm install` to install dependencies
   - Check if all required dependencies are available (Pandoc, LaTeX, etc.)

3. **Build Errors**:
   - Check the error message for specific details
   - Verify that your directory structure follows the expected format
   - Ensure your `book.yaml` follows the correct format

4. **GitHub Actions Issues**:
   - Check the GitHub Actions logs for detailed error information
   - Verify that your repository has the correct permissions

## Legacy Scripts

The original build scripts in the `tools/scripts/` directory are kept for backward compatibility. These scripts are used as a fallback in the Docker container if the book-tools CLI is not available. This ensures that existing projects continue to work.

## Future Improvements

Future improvements to the build system will be implemented in the `iksnae/book-tools` repository, which can be used by book-template through the Docker container or as a Node.js dependency.

This approach ensures that all book projects benefit from enhancements and bug fixes without requiring manual updates to individual repositories.
