# Legacy Scripts (Deprecated)

⚠️ **Important**: These scripts are maintained for backward compatibility but are **deprecated**. Please use the main `build.sh` script in the repository root which now uses the standardized book-tools system.

## Migration Notice

The book-template repository has been migrated to use the standardized `book-tools` package, which provides a more robust and flexible build system. The scripts in this directory are kept for backward compatibility but will not receive further updates.

## Using the New System

To use the new build system:

```bash
# In the repository root
./build.sh [options]
```

See the [Migration Guide](../docs/MIGRATION_GUIDE.md) for more information about the new system.

## Legacy Scripts

The following legacy scripts are still available:

- `build.sh` - Main entry point for the legacy build process
- `build-language.sh` - Builds a specific language
- `combine-markdown.sh` - Combines markdown files into a single document
- `generate-epub.sh` - Generates EPUB format
- `generate-html.sh` - Generates HTML format
- `generate-mobi.sh` - Generates MOBI format
- `generate-pdf.sh` - Generates PDF format

These scripts may not be maintained going forward and could be removed in a future update.
