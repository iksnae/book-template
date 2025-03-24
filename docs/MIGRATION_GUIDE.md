# Migration Guide: book-template to book-tools

This guide describes how to migrate from the original `book-template` build system to the standardized `book-tools` package.

## Overview

The `book-template` repository has been updated to use the `book-tools` package, which provides a standardized, more robust solution for building books in multiple formats. This migration improves maintainability, adds new features, and ensures consistency across all Khaos Studios book projects.

## What's Changed

1. **Build Process**: The build process now uses the `book-tools` CLI instead of the custom scripts in `tools/scripts/`.
2. **Configuration**: The `book.yaml` configuration has been extended to support more detailed format-specific settings.
3. **Commands**: New commands have been added for interactive building, chapter creation, and configuration validation.
4. **Error Handling**: Improved error handling and recovery mechanisms have been implemented.

## Migration Steps

### 1. Update Dependencies

If you've previously cloned the repository, update your dependencies:

```bash
# Install Node.js dependencies
npm install
```

### 2. Update Configuration

The `book.yaml` file now supports extended format-specific settings. If you have custom settings, you can convert them to the new format:

**Old Format:**
```yaml
pdf:
  paper_size: "letter"
  margin_top: "1in"
```

**New Format:**
```yaml
formatSettings:
  pdf:
    paperSize: "letter"
    marginTop: "1in"
```

For a complete reference, see the [Configuration Documentation](https://github.com/iksnae/book-tools/blob/main/docs/CONFIGURATION.md).

> **Note**: The old format is still supported for backward compatibility, but the new format is recommended for new projects.

### 3. Use the New Commands

Instead of using the `./build.sh` script, you can now use:

```bash
# Build the book
npm run build

# Interactive build
npm run interactive

# Create a new chapter
npm run create-chapter

# Check a chapter structure
npm run check-chapter

# Display book information
npm run info

# Clean build artifacts
npm run clean

# Validate configuration
npm run validate
```

The original `./build.sh` script is still available and will use the `book-tools` CLI by default. For backward compatibility, you can use `./build.sh --legacy` to use the original build process.

### 4. Update Custom Scripts

If you have custom scripts that interact with the build process, update them to use the new CLI commands:

**Old:**
```bash
./build.sh --all-languages
```

**New:**
```bash
npm run build -- --all-languages
```

Or:

```bash
node_modules/.bin/book build --all-languages
```

### 5. GitHub Actions

If you're using GitHub Actions, update your workflow to use the new build process:

```yaml
- name: Set up Node.js
  uses: actions/setup-node@v2
  with:
    node-version: '14.x'

- name: Install dependencies
  run: npm install

- name: Build book
  run: npm run build -- --all-languages
```

## New Features

The migration brings several new features:

1. **Interactive Mode**: Build your book interactively with `npm run interactive`
2. **Chapter Management**: Create and check chapters with `npm run create-chapter` and `npm run check-chapter`
3. **Configuration Validation**: Validate your configuration with `npm run validate`
4. **Format-Specific Settings**: Customize each format's output with detailed settings
5. **Improved Error Handling**: Better error messages and recovery mechanisms

## Troubleshooting

### Missing Dependencies

If you see errors about missing dependencies, make sure you've installed the Node.js dependencies:

```bash
npm install
```

### Configuration Errors

If you see configuration errors, use the validation command to identify issues:

```bash
npm run validate
```

### Legacy Mode

If you encounter issues with the new build process, you can temporarily use the legacy mode:

```bash
./build.sh --legacy
```

## Getting Help

If you need help with the migration, please open an issue on the [book-template](https://github.com/iksnae/book-template) repository.
