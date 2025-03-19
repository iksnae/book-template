# Default Templates

This directory contains default templates and assets used when specific ones are not provided in the book's configuration.

## Contents

- `cover.png` - A default cover image used when no custom cover is provided
- Other default assets will be added as needed

## Usage

These files are used automatically by the build system when specific assets are not found in the locations specified in `book.yaml`.

For example, if the `epub.cover_image` path in `book.yaml` points to a file that doesn't exist, the build system will fall back to using `templates/default/cover.png`.

## Customization

It's recommended to provide your own custom assets rather than using these defaults. See the main documentation for details on how to specify custom templates and assets in your `book.yaml` file.
