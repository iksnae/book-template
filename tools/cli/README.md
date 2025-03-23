# Book CLI Tool

A command-line interface for the book-template system that makes it easy to build, manage, and publish your book.

## Installation

You can install the CLI tool globally, making it available from anywhere in your system:

```bash
# Navigate to the CLI directory
cd tools/cli

# Install globally
npm install -g .
```

Or, if you prefer to use it without global installation:

```bash
# Navigate to the CLI directory
cd tools/cli

# Install dependencies
npm install

# Run using npx
npx book
```

## Usage

The CLI provides several commands to help you manage your book:

### Build your book

Build your book with specified options:

```bash
# Basic build (uses defaults)
book build

# Build all languages
book build --all-languages

# Build specific language
book build --lang fr

# Skip specific formats
book build --skip-pdf --skip-mobi
```

### Interactive mode

Launch an interactive wizard to configure your build:

```bash
book interactive
```

### Create a new chapter

Create a new chapter with the required directory structure:

```bash
# Interactive mode
book create-chapter

# Specify options directly
book create-chapter -n 04 -t "Advanced Techniques" -l en
```

This will create:
- The chapter directory with the correct numbering
- Introduction file (00-introduction.md)
- First section file (01-section.md)
- Images directory with a README

### Check chapter structure

Check the structure of a specific chapter or list all chapters:

```bash
# List all chapters in the default language
book check-chapter

# Check a specific chapter
book check-chapter -n 01

# Check in a different language
book check-chapter -n 01 -l fr
```

This will show:
- A checklist of required files and directories
- A list of all markdown files with their titles
- A list of all images with their sizes

### View book information

Display information about the current book configuration:

```bash
book info
```

### Clean build artifacts

Remove all build artifacts:

```bash
book clean
```

## Docker Integration

You can also use the CLI tool inside the Docker container:

```bash
# Run the CLI inside Docker
docker run -it --rm -v $(pwd):/workspace iksnae/book-builder:latest bash -c "cd /workspace && cd tools/cli && npm i && node index.js"
```

## Help

Get help with the available commands:

```bash
book --help
```

Or get help for a specific command:

```bash
book build --help
```

## Additional Information

The CLI tool is a wrapper around the build.sh script and provides the same functionality with a more user-friendly interface. It reads configuration from the book.yaml file in your project root. 