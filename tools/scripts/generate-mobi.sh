#!/bin/bash

# generate-mobi.sh - Generates MOBI (Kindle) version of the book from EPUB
# Usage: generate-mobi.sh [language] [input_epub] [output_mobi] [book_title]

set -e  # Exit on error

# Get arguments
LANGUAGE=${1:-en}
INPUT_EPUB=${2:-build/book.epub}
OUTPUT_MOBI=${3:-build/book.mobi}
BOOK_TITLE=${4:-"My Book"}

echo "📚 Generating MOBI for $LANGUAGE..."

# Safety check to ensure input EPUB exists
if [ ! -f "$INPUT_EPUB" ]; then
  echo "❌ Error: Input EPUB file $INPUT_EPUB does not exist"
  exit 1
fi

# Make sure the output directory exists
mkdir -p "$(dirname "$OUTPUT_MOBI")"

# Check for ebook-convert utility
if ! command -v ebook-convert &> /dev/null; then
  echo "❌ Error: ebook-convert utility (Calibre) not found"
  echo "Please install Calibre or make sure the utility is in your PATH"
  exit 1
fi

# Get publisher and author information from YAML if available
PUBLISHER="Publisher Name"
BOOK_AUTHOR="Author Name"

if [ -f "book.yaml" ]; then
  YAML_PUBLISHER=$(grep 'publisher:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  if [ -n "$YAML_PUBLISHER" ]; then
    PUBLISHER="$YAML_PUBLISHER"
  fi
  
  YAML_AUTHOR=$(grep 'author:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  if [ -n "$YAML_AUTHOR" ]; then
    BOOK_AUTHOR="$YAML_AUTHOR"
  fi
fi

# Use Calibre's ebook-convert to convert EPUB to MOBI
echo "Converting EPUB to MOBI using Calibre's ebook-convert..."
ebook-convert "$INPUT_EPUB" "$OUTPUT_MOBI" \
  --title="$BOOK_TITLE" \
  --authors="$BOOK_AUTHOR" \
  --publisher="$PUBLISHER" \
  --language="$LANGUAGE" \
  --pretty-print \
  --change-justification=justify \
  || true

# Check if MOBI file was created successfully
if [ -s "$OUTPUT_MOBI" ]; then
  FILE_SIZE=$(du -k "$OUTPUT_MOBI" | cut -f1)
  echo "📊 MOBI file size: ${FILE_SIZE}KB"
  
  echo "✅ MOBI created successfully at $OUTPUT_MOBI"
else
  # Try one more time with simplified settings
  echo "⚠️ MOBI generation failed with full settings, trying with minimal settings..."
  ebook-convert "$INPUT_EPUB" "$OUTPUT_MOBI" --title="$BOOK_TITLE" || true
  
  if [ -s "$OUTPUT_MOBI" ]; then
    echo "✅ MOBI created with minimal settings at $OUTPUT_MOBI"
  else
    echo "❌ All MOBI generation attempts failed."
    
    # Create a placeholder file explaining the issue
    echo "Creating placeholder MOBI file with error message..."
    
    # Create a temporary HTML file
    TEMP_HTML=$(mktemp --suffix=.html)
    
    cat > "$TEMP_HTML" << EOF
<!DOCTYPE html>
<html>
<head>
  <title>$BOOK_TITLE - MOBI Generation Failed</title>
</head>
<body>
  <h1>$BOOK_TITLE</h1>
  <h2>MOBI Generation Failed</h2>
  <p>The conversion from EPUB to MOBI format failed. This could be due to:</p>
  <ul>
    <li>Issues with the Calibre ebook-convert utility</li>
    <li>Problems with the source EPUB file</li>
    <li>Missing dependencies for MOBI conversion</li>
  </ul>
  <p>Please try reading the EPUB version instead, or consult the HTML version online.</p>
</body>
</html>
EOF
    
    # Try converting the HTML to MOBI
    ebook-convert "$TEMP_HTML" "$OUTPUT_MOBI" --title="$BOOK_TITLE - Error" || true
    
    # Clean up temporary file
    rm "$TEMP_HTML"
    
    if [ -s "$OUTPUT_MOBI" ]; then
      echo "✅ Created placeholder MOBI with error message"
    else
      echo "❌ Failed to create even a placeholder MOBI file."
      # Create an empty file to prevent further errors in the build process
      touch "$OUTPUT_MOBI"
    fi
    
    exit 1
  fi
fi
