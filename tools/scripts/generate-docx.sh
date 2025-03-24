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
  BOOK_TITLE=$(grep 'title:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/\"//g')
  AUTHOR=$(grep 'author:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/\"//g')
  FILE_PREFIX=$(grep 'file_prefix:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/\"//g')
  
  if [ -z "$FILE_PREFIX" ]; then
    FILE_PREFIX=$(echo "$BOOK_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
  fi
else
  echo "⚠️ No book.yaml found, using default values"
  BOOK_TITLE="My Book"
  AUTHOR="Author"
  FILE_PREFIX="book"
fi

# Setup paths
BUILD_DIR="build"
INPUT_FILE="$BUILD_DIR/$FILE_PREFIX.md"
OUTPUT_FILE="$BUILD_DIR/$FILE_PREFIX.docx"

echo "📝 Generating DOCX for $LANGUAGE..."
echo "  - Input file: $INPUT_FILE"
echo "  - Output file: $OUTPUT_FILE"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
  echo "❌ Error: Input file $INPUT_FILE not found!"
  exit 1
fi

# Create default reference doc if it doesn't exist
if [ ! -f "$REFERENCE_DOC" ]; then
  echo "📄 Creating default reference document..."
  mkdir -p "$(dirname "$REFERENCE_DOC")"
  pandoc -o "$REFERENCE_DOC" --print-default-data-file reference.docx
fi

# Generate DOCX file
echo "📄 Generating DOCX file..."
pandoc "$INPUT_FILE" \
  -o "$OUTPUT_FILE" \
  --from markdown \
  --to docx \
  --reference-doc="$REFERENCE_DOC" \
  --toc \
  --toc-depth=3 \
  --metadata title="$BOOK_TITLE" \
  --metadata author="$AUTHOR" \
  --metadata lang="$LANGUAGE" \
  --resource-path=".:book:book/$LANGUAGE:build:book/$LANGUAGE/images:book/images:build/images:build/$LANGUAGE/images"

if [ $? -eq 0 ]; then
  echo "✅ DOCX created successfully at $OUTPUT_FILE"
  echo "📊 DOCX file size: $(du -h "$OUTPUT_FILE" | cut -f1)"
else
  echo "❌ Error: DOCX generation failed!"
  exit 1
fi 