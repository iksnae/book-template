#!/bin/bash

# Script to generate DOCX files from markdown
# Part of the book-template system

# Exit on error
set -e

# Default values
LANGUAGE="en"
VERBOSE=false
REFERENCE_DOC="templates/docx/reference.docx"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --lang=*)
      LANGUAGE="${key#*=}"
      ;;
    --verbose)
      VERBOSE=true
      ;;
    --reference=*)
      REFERENCE_DOC="${key#*=}"
      ;;
    *)
      echo "Unknown option: $key"
      exit 1
      ;;
  esac
  shift
done

# Load configuration
if [ -f "book.yaml" ]; then
  echo "📚 Loading configuration from book.yaml..."
  
  # Extract book title
  BOOK_TITLE=$(grep 'title:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/\"//g')
  
  # Extract book author
  BOOK_AUTHOR=$(grep 'author:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/\"//g')
  
  # Extract file prefix
  FILE_PREFIX=$(grep 'file_prefix:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/\"//g')
  if [ -z "$FILE_PREFIX" ]; then
    FILE_PREFIX=$(echo "$BOOK_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
  fi
else
  echo "⚠️ No book.yaml found, using default values"
  BOOK_TITLE="My Book"
  BOOK_AUTHOR="Author Name"
  FILE_PREFIX="my-book"
fi

# Set up paths
BUILD_DIR="build/$LANGUAGE"
COMBINED_MD="$BUILD_DIR/combined.md"
OUTPUT_FILE="$BUILD_DIR/$FILE_PREFIX.docx"

# Check if combined markdown exists
if [ ! -f "$COMBINED_MD" ]; then
  echo "❌ Error: Combined markdown file not found at $COMBINED_MD"
  echo "Please run combine-markdown.sh first"
  exit 1
fi

# Create reference.docx if it doesn't exist
if [ ! -f "$REFERENCE_DOC" ]; then
  echo "📝 Creating default reference.docx..."
  mkdir -p "$(dirname "$REFERENCE_DOC")"
  pandoc -o "$REFERENCE_DOC" --print-default-data-file reference.docx
fi

echo "📝 Generating DOCX file..."
echo "   Input: $COMBINED_MD"
echo "   Output: $OUTPUT_FILE"
echo "   Reference: $REFERENCE_DOC"

# Build pandoc command
CMD="pandoc \"$COMBINED_MD\" \
  -f markdown \
  -t docx \
  -o \"$OUTPUT_FILE\" \
  --reference-doc=\"$REFERENCE_DOC\" \
  --table-of-contents \
  --toc-depth=3 \
  --metadata title=\"$BOOK_TITLE\" \
  --metadata author=\"$BOOK_AUTHOR\" \
  --number-sections \
  --standalone"

if [ "$VERBOSE" = true ]; then
  echo "🔍 Running command: $CMD"
fi

# Run pandoc
eval $CMD

# Check if the file was created
if [ -f "$OUTPUT_FILE" ]; then
  echo "✅ DOCX file generated successfully: $OUTPUT_FILE"
  
  # Get file size
  if command -v du &> /dev/null; then
    SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
    echo "📊 File size: $SIZE"
  fi
else
  echo "❌ Error: Failed to generate DOCX file"
  exit 1
fi 