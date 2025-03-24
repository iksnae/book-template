# Migration Guide: Using book-tools in book-template

This guide explains how the book-template repository has been migrated to use the standardized book-tools package instead of its custom build scripts.

## Overview of Changes

The following changes have been made:

1. Added `package.json` to use the book-tools package
2. Updated `build.sh` to act as a wrapper around the book-tools CLI
3. Created a configuration adapter to convert between the formats
4. Updated GitHub Actions workflows for building and releasing
5. Added scripts to support the migration process

## What You Need to Know

### For Users

If you're just using the book-template to build your books, very little has changed:

- The same `build.sh` command will still work as before
- The directory structure remains the same
- The `book.yaml` format is still supported

You may notice a few improvements:

- Enhanced error handling
- Better build output
- More detailed configuration options
- Additional commands accessible through npm scripts

### For Contributors

If you're contributing to the codebase:

- The build logic now lives in the book-tools repository
- The book-template repository now acts as a client of book-tools
- Future feature development should happen in book-tools
- Configuration adapter handles format differences

## Using the New System

### Prerequisites

You now need Node.js installed to build the book. If you don't have it already:

1. Install Node.js (version 14.x or higher)
2. Run `npm install` in the book-template directory

### Building the Book

The build command remains the same:

```bash
./build.sh
```

You can also use the npm scripts:

```bash
npm run build
npm run build:all  # Build all languages
```

### Additional Commands

The migration introduces some new commands:

```bash
# Interactive build with prompts
npm run interactive

# Create a new chapter
npm run create-chapter

# Check a chapter structure
npm run check-chapter

# Display book information
npm run info

# Clean build artifacts
npm run clean
```

### Releasing a New Version

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

## Configuration Format

The original `book.yaml` format is still supported, but the book-tools package uses a slightly different format internally. The configuration adapter handles the conversion automatically.

### Legacy Configuration (Still Supported)

```yaml
title: "Your Book Title"
subtitle: "Your Book Subtitle"
author: "Your Name"
file_prefix: "your-book"
languages:
  - "en"
outputs:
  pdf: true
  epub: true
  mobi: true
  html: true
```

### New Configuration Format (Used Internally)

```yaml
title: "Your Book Title"
subtitle: "Your Book Subtitle"
author: "Your Name"
filePrefix: "your-book"
languages: ["en"]
formats:
  pdf: true
  epub: true
  mobi: true
  html: true
```

## Directory Structure

The directory structure remains the same:

```
your-book-project/
├── book.yaml           # Book configuration
├── book/               # Source content
│   ├── en/             # English content
│   │   ├── 01-chapter-one/  # Chapter directories
│   │   │   ├── 01-section.md
│   │   │   └── 02-section.md
│   │   ├── 02-chapter-two/
│   │   ├── appendices/     # Optional appendices
│   │   ├── glossary.md     # Optional glossary
│   │   └── images/         # Language-specific images
│   └── es/             # Spanish content (similar structure)
├── templates/          # Templates directory
│   ├── pdf/            # PDF templates
│   ├── epub/           # EPUB templates
│   └── html/           # HTML templates
└── build/              # Output directory (created automatically)
```

## GitHub Actions Integration

The GitHub Actions workflows have been updated:

1. **Build Workflow**: Triggered on push or pull request when content files change
2. **Release Workflow**: Triggered when a new tag is pushed or manually from the Actions tab

## Troubleshooting

If you encounter issues:

1. **Missing Dependencies**: Run `npm install` to install book-tools
2. **Build Errors**: Check the error message. The new system provides better error reporting.
3. **Configuration Issues**: Ensure your `book.yaml` follows the format described above
4. **Directory Structure**: Verify your directory structure matches the expected format

For more in-depth troubleshooting, check the book-tools repository and documentation.

## Rollback Plan

If you need to roll back to the previous build system:

1. Use the legacy scripts in `tools/scripts/` directly
2. Check out an earlier version of the repository (before the migration)

However, the new system is designed to be fully backward compatible, so rollback should not be necessary.
