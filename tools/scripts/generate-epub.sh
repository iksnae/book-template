#!/bin/bash

# generate-epub.sh - Generates EPUB version of the book
# Usage: generate-epub.sh [language] [input_file] [output_file] [book_title] [book_subtitle] [resource_paths]

set -e  # Exit on error

# Get arguments
LANGUAGE=${1:-en}
INPUT_FILE=${2:-build/book.md}
OUTPUT_FILE=${3:-build/book.epub}
BOOK_TITLE=${4:-"My Book"}
BOOK_SUBTITLE=${5:-"A Book Built with the Template System"}
RESOURCE_PATHS=${6:-".:book:book/$LANGUAGE:build:book/$LANGUAGE/images:book/images:build/images:build/$LANGUAGE/images"}

echo "📱 Generating EPUB for $LANGUAGE..."
echo "  - Language: $LANGUAGE"
echo "  - Input file: $INPUT_FILE"
echo "  - Output file: $OUTPUT_FILE"

# Safety check to ensure input file exists
if [ ! -f "$INPUT_FILE" ]; then
  echo "❌ Error: Input file $INPUT_FILE does not exist"
  exit 1
fi

# Make sure the output directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Get EPUB settings from book.yaml if available
CSS_FILE=""
TOC_DEPTH=3
EPUB_COVER_IMAGE="$COVER_IMAGE"

if [ -f "book.yaml" ]; then
  # Read EPUB settings
  if grep -q "epub:" book.yaml; then
    # CSS file
    YAML_CSS=$(grep 'css:' book.yaml | grep -A 10 'epub:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_CSS" ] && [ -f "$YAML_CSS" ]; then
      CSS_FILE="$YAML_CSS"
      echo "Using custom CSS file: $CSS_FILE"
    fi
    
    # ToC depth
    YAML_TOC_DEPTH=$(grep 'toc_depth:' book.yaml | grep -A 10 'epub:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_TOC_DEPTH" ]; then
      TOC_DEPTH="$YAML_TOC_DEPTH"
    fi
    
    # Cover image - override the global one if specified here
    YAML_COVER_IMAGE=$(grep 'cover_image:' book.yaml | grep -A 10 'epub:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_COVER_IMAGE" ] && [ -f "$YAML_COVER_IMAGE" ]; then
      EPUB_COVER_IMAGE="$YAML_COVER_IMAGE"
      echo "Using EPUB-specific cover image: $EPUB_COVER_IMAGE"
    fi
  fi
fi

# Get publisher and author from book.yaml if not already defined
if [ -z "$BOOK_AUTHOR" ] && [ -f "book.yaml" ]; then
  BOOK_AUTHOR=$(grep 'author:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  if [ -z "$BOOK_AUTHOR" ]; then
    BOOK_AUTHOR="Author Name"
  fi
fi

if [ -z "$PUBLISHER" ] && [ -f "book.yaml" ]; then
  PUBLISHER=$(grep 'publisher:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  if [ -z "$PUBLISHER" ]; then
    PUBLISHER="Publisher Name"
  fi
fi

# Explicitly set language-specific cover image if available
LANG_COVER_IMAGE=""
if [ -f "book/$LANGUAGE/images/cover.png" ]; then
  LANG_COVER_IMAGE="book/$LANGUAGE/images/cover.png"
  echo "✅ Found language-specific cover image at $LANG_COVER_IMAGE"
elif [ -f "build/$LANGUAGE/images/cover.png" ]; then
  LANG_COVER_IMAGE="build/$LANGUAGE/images/cover.png"
  echo "✅ Found language-specific cover image at $LANG_COVER_IMAGE"
elif [ -n "$EPUB_COVER_IMAGE" ]; then
  LANG_COVER_IMAGE="$EPUB_COVER_IMAGE"
  echo "Using configured cover image at $LANG_COVER_IMAGE"
fi

# Build the pandoc command base
PANDOC_CMD="pandoc \"$INPUT_FILE\" -o \"$OUTPUT_FILE\" --toc --toc-depth=$TOC_DEPTH"

# Add metadata
PANDOC_CMD="$PANDOC_CMD --metadata title=\"$BOOK_TITLE\""
PANDOC_CMD="$PANDOC_CMD --metadata publisher=\"$PUBLISHER\""
PANDOC_CMD="$PANDOC_CMD --metadata creator=\"$BOOK_AUTHOR\""
PANDOC_CMD="$PANDOC_CMD --metadata language=\"$LANGUAGE\""

# Add CSS if specified
if [ -n "$CSS_FILE" ] && [ -f "$CSS_FILE" ]; then
  PANDOC_CMD="$PANDOC_CMD --css=\"$CSS_FILE\""
fi

# Add cover image if available
if [ -n "$LANG_COVER_IMAGE" ]; then
  echo "Including cover image in EPUB: $LANG_COVER_IMAGE"
  PANDOC_CMD="$PANDOC_CMD --epub-cover-image=\"$LANG_COVER_IMAGE\""
fi

# Add resource path
PANDOC_CMD="$PANDOC_CMD --resource-path=\"$RESOURCE_PATHS\""

# Add extraction of media to help with debugging
PANDOC_CMD="$PANDOC_CMD --extract-media=build/$LANGUAGE/epub-media"

# Execute the command
echo "Executing: $PANDOC_CMD"
eval $PANDOC_CMD

# Check if EPUB was generated successfully
if [ -s "$OUTPUT_FILE" ]; then
  FILE_SIZE=$(du -k "$OUTPUT_FILE" | cut -f1)
  echo "📊 EPUB file size: ${FILE_SIZE}KB"
  
  # Different thresholds for different content
  if [ "$FILE_SIZE" -lt 10 ]; then
    echo "⚠️ WARNING: EPUB file size is smaller than expected (${FILE_SIZE}KB). Content or images may be missing."
  else
    echo "✅ EPUB file size looks good (${FILE_SIZE}KB)."
  fi
  
  echo "✅ EPUB created successfully at $OUTPUT_FILE"
else
  echo "❌ Failed to create EPUB at $OUTPUT_FILE."
  
  # Try one more time with a simpler approach
  echo "⚠️ Attempting simplified EPUB generation..."
  pandoc "$INPUT_FILE" -o "$OUTPUT_FILE" \
    --toc \
    --metadata title="$BOOK_TITLE" \
    --metadata publisher="$PUBLISHER" \
    --metadata creator="$BOOK_AUTHOR" \
    --metadata language="$LANGUAGE" \
    --resource-path="$RESOURCE_PATHS"
  
  if [ -s "$OUTPUT_FILE" ]; then
    echo "✅ EPUB created with simplified settings at $OUTPUT_FILE"
  else
    echo "❌ All EPUB generation attempts failed."
    exit 1
  fi
fi
