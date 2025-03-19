#!/bin/bash

# build-language.sh - Builds a specific language version of the book
# Usage: build-language.sh [language] [--skip-pdf] [--skip-epub] [--skip-mobi] [--skip-html]

set -e  # Exit on error

# Get the language from the first argument
LANGUAGE=${1:-en}

# Define skip flags with defaults
SKIP_PDF=false
SKIP_EPUB=false
SKIP_MOBI=false
SKIP_HTML=false

# Process additional arguments
shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-pdf) SKIP_PDF=true ;;
    --skip-epub) SKIP_EPUB=true ;;
    --skip-mobi) SKIP_MOBI=true ;;
    --skip-html) SKIP_HTML=true ;;
  esac
  shift
done

echo "📚 Building $LANGUAGE version of the book..."

# Check if this language directory exists
if [ ! -d "book/$LANGUAGE" ]; then
  echo "⚠️ Error: Language directory book/$LANGUAGE doesn't exist!"
  ls -la book/
  exit 1
fi

# Debug: List content of the language directory
echo "Content of book/$LANGUAGE:"
ls -la "book/$LANGUAGE/"

# Get file names for output based on language and configuration
# Use FILE_PREFIX from book.yaml if available, otherwise use language-specific defaults
if [ -n "$FILE_PREFIX" ]; then
  if [ "$LANGUAGE" = "en" ]; then
    # For English, use the file prefix directly
    PDF_FILENAME="$FILE_PREFIX.pdf"
    EPUB_FILENAME="$FILE_PREFIX.epub"
    MOBI_FILENAME="$FILE_PREFIX.mobi"
    HTML_FILENAME="$FILE_PREFIX.html"
    MARKDOWN_FILENAME="$FILE_PREFIX.md"
  else
    # For other languages, add language suffix to avoid conflicts
    PDF_FILENAME="$FILE_PREFIX-$LANGUAGE.pdf"
    EPUB_FILENAME="$FILE_PREFIX-$LANGUAGE.epub"
    MOBI_FILENAME="$FILE_PREFIX-$LANGUAGE.mobi"
    HTML_FILENAME="$FILE_PREFIX-$LANGUAGE.html"
    MARKDOWN_FILENAME="$FILE_PREFIX-$LANGUAGE.md"
  fi
else
  # Default fallback filenames if FILE_PREFIX is not set
  if [ "$LANGUAGE" = "en" ]; then
    PDF_FILENAME="book.pdf"
    EPUB_FILENAME="book.epub"
    MOBI_FILENAME="book.mobi"
    HTML_FILENAME="book.html"
    MARKDOWN_FILENAME="book.md"
  else
    PDF_FILENAME="book-$LANGUAGE.pdf"
    EPUB_FILENAME="book-$LANGUAGE.epub"
    MOBI_FILENAME="book-$LANGUAGE.mobi"
    HTML_FILENAME="book-$LANGUAGE.html"
    MARKDOWN_FILENAME="book-$LANGUAGE.md"
  fi
fi

# Debug output of paths
echo "Output filenames:"
echo "  - Markdown: $MARKDOWN_FILENAME"
echo "  - PDF: $PDF_FILENAME"
echo "  - EPUB: $EPUB_FILENAME"
echo "  - MOBI: $MOBI_FILENAME"
echo "  - HTML: $HTML_FILENAME"

# Define output paths
MARKDOWN_PATH="build/$MARKDOWN_FILENAME"
PDF_PATH="build/$PDF_FILENAME"
EPUB_PATH="build/$EPUB_FILENAME"
MOBI_PATH="build/$MOBI_FILENAME"
HTML_PATH="build/$HTML_FILENAME"

# Create a language directory for web pages if needed
if [ "$LANGUAGE" != "en" ]; then
  mkdir -p "build/$LANGUAGE"
  mkdir -p "build/$LANGUAGE/images"
fi

# Set up resource paths for pandoc
# Improve path handling - list all possible resource paths explicitly
RESOURCE_PATHS=".:book:book/$LANGUAGE:build:book/$LANGUAGE/images:book/images:build/images:build/$LANGUAGE/images"

# Step 1: Generate combined markdown file from source files
echo "📝 Combining markdown files for $LANGUAGE..."
source tools/scripts/combine-markdown.sh "$LANGUAGE" "$MARKDOWN_PATH" "$BOOK_TITLE" "$BOOK_SUBTITLE"

# Verify the combined markdown file was created
if [ ! -f "$MARKDOWN_PATH" ] || [ ! -s "$MARKDOWN_PATH" ]; then
  echo "⚠️ Error: Combined markdown file wasn't created or is empty!"
  exit 1
fi

# Create a safety copy for fallbacks
cp "$MARKDOWN_PATH" "${MARKDOWN_PATH%.*}-safe.md"

# Step 2: Generate PDF
if [ "$SKIP_PDF" = false ]; then
  echo "📄 Generating PDF for $LANGUAGE..."
  source tools/scripts/generate-pdf.sh "$LANGUAGE" "$MARKDOWN_PATH" "$PDF_PATH" "$BOOK_TITLE" "$RESOURCE_PATHS"
  # Verify PDF was created
  if [ -f "$PDF_PATH" ]; then
    echo "✅ PDF created successfully: $PDF_PATH"
    du -h "$PDF_PATH"
  else
    echo "⚠️ PDF generation failed!"
  fi
fi

# Step 3: Generate EPUB
if [ "$SKIP_EPUB" = false ]; then
  echo "📱 Generating EPUB for $LANGUAGE..."
  source tools/scripts/generate-epub.sh "$LANGUAGE" "$MARKDOWN_PATH" "$EPUB_PATH" "$BOOK_TITLE" "$BOOK_SUBTITLE" "$RESOURCE_PATHS"
  # Verify EPUB was created
  if [ -f "$EPUB_PATH" ]; then
    echo "✅ EPUB created successfully: $EPUB_PATH"
    du -h "$EPUB_PATH"
  else
    echo "⚠️ EPUB generation failed!"
  fi
fi

# Step 4: Generate MOBI
if [ "$SKIP_MOBI" = false ] && [ "$SKIP_EPUB" = false ]; then
  echo "📚 Generating MOBI for $LANGUAGE..."
  source tools/scripts/generate-mobi.sh "$LANGUAGE" "$EPUB_PATH" "$MOBI_PATH" "$BOOK_TITLE"
  # Verify MOBI was created
  if [ -f "$MOBI_PATH" ]; then
    echo "✅ MOBI created successfully: $MOBI_PATH"
    du -h "$MOBI_PATH"
  else
    echo "⚠️ MOBI generation failed or was skipped!"
  fi
fi

# Step 5: Generate HTML
if [ "$SKIP_HTML" = false ]; then
  echo "🌐 Generating HTML for $LANGUAGE..."
  source tools/scripts/generate-html.sh "$LANGUAGE" "$MARKDOWN_PATH" "$HTML_PATH" "$BOOK_TITLE" "$RESOURCE_PATHS"
  
  # Create index.html in appropriate directory
  if [ "$LANGUAGE" = "en" ]; then
    cp "$HTML_PATH" "build/index.html"
    echo "Created index.html for English"
  else
    mkdir -p "build/$LANGUAGE"
    cp "$HTML_PATH" "build/$LANGUAGE/index.html"
    echo "Created index.html for $LANGUAGE"
  fi
fi

# List final build directory contents for this language
echo "📂 Contents of build directory for $LANGUAGE:"
ls -la "build/" | grep -E "$MARKDOWN_FILENAME|$PDF_FILENAME|$EPUB_FILENAME|$MOBI_FILENAME|$HTML_FILENAME" 2>/dev/null || echo "No output files found!"

echo "✅ Successfully built $LANGUAGE version of the book"
