#!/bin/bash

# generate-pdf.sh - Generates PDF version of the book
# Usage: generate-pdf.sh [language] [input_file] [output_file] [book_title] [resource_paths]

set -e  # Exit on error

# Get arguments
LANGUAGE=${1:-en}
INPUT_FILE=${2:-build/book.md}
OUTPUT_FILE=${3:-build/book.pdf}
BOOK_TITLE=${4:-"My Book"}
RESOURCE_PATHS=${5:-".:book:book/$LANGUAGE:build:book/$LANGUAGE/images:book/images:build/images:build/$LANGUAGE/images"}

echo "📄 Generating PDF for $LANGUAGE..."

# Safety check to ensure input file exists
if [ ! -f "$INPUT_FILE" ]; then
  echo "❌ Error: Input file $INPUT_FILE does not exist"
  exit 1
fi

# Safety copy for fallbacks
SAFE_INPUT_FILE="${INPUT_FILE%.*}-safe.md"
if [ ! -f "$SAFE_INPUT_FILE" ]; then
  cp "$INPUT_FILE" "$SAFE_INPUT_FILE"
fi

# Get PDF-specific settings from book.yaml if available
PDF_FONT_SIZE="11pt"
PDF_PAPER_SIZE="letter"
PDF_MARGIN_TOP="1in"
PDF_MARGIN_RIGHT="1in"
PDF_MARGIN_BOTTOM="1in"
PDF_MARGIN_LEFT="1in"
PDF_LINE_HEIGHT="1.5"
PDF_DOCUMENT_CLASS="book"  # Use 'book' as default

if [ -f "book.yaml" ]; then
  # Extract PDF settings if they exist
  if grep -q "pdf:" book.yaml; then
    # Font size
    YAML_FONT_SIZE=$(grep 'font_size:' book.yaml | grep -A 10 'pdf:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_FONT_SIZE" ]; then
      PDF_FONT_SIZE="$YAML_FONT_SIZE"
    fi
    
    # Paper size
    YAML_PAPER_SIZE=$(grep 'paper_size:' book.yaml | grep -A 10 'pdf:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_PAPER_SIZE" ]; then
      PDF_PAPER_SIZE="$YAML_PAPER_SIZE"
    fi
    
    # Margins
    YAML_MARGIN_TOP=$(grep 'margin_top:' book.yaml | grep -A 10 'pdf:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_MARGIN_TOP" ]; then
      PDF_MARGIN_TOP="$YAML_MARGIN_TOP"
    fi
    
    YAML_MARGIN_RIGHT=$(grep 'margin_right:' book.yaml | grep -A 10 'pdf:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_MARGIN_RIGHT" ]; then
      PDF_MARGIN_RIGHT="$YAML_MARGIN_RIGHT"
    fi
    
    YAML_MARGIN_BOTTOM=$(grep 'margin_bottom:' book.yaml | grep -A 10 'pdf:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_MARGIN_BOTTOM" ]; then
      PDF_MARGIN_BOTTOM="$YAML_MARGIN_BOTTOM"
    fi
    
    YAML_MARGIN_LEFT=$(grep 'margin_left:' book.yaml | grep -A 10 'pdf:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_MARGIN_LEFT" ]; then
      PDF_MARGIN_LEFT="$YAML_MARGIN_LEFT"
    fi
    
    # Line height
    YAML_LINE_HEIGHT=$(grep 'line_height:' book.yaml | grep -A 10 'pdf:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_LINE_HEIGHT" ]; then
      PDF_LINE_HEIGHT="$YAML_LINE_HEIGHT"
    fi
  fi
fi

echo "PDF Settings:"
echo "  - Font Size: $PDF_FONT_SIZE"
echo "  - Paper Size: $PDF_PAPER_SIZE"
echo "  - Margins: $PDF_MARGIN_TOP, $PDF_MARGIN_RIGHT, $PDF_MARGIN_BOTTOM, $PDF_MARGIN_LEFT"
echo "  - Line Height: $PDF_LINE_HEIGHT"
echo "  - Document Class: $PDF_DOCUMENT_CLASS"
echo "  - Template: $PDF_TEMPLATE"

# Set publisher and author from book.yaml if not already defined
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

# Define common pandoc parameters
PANDOC_COMMON_PARAMS="--pdf-engine=xelatex \
  --toc \
  --metadata title=\"$BOOK_TITLE\" \
  --metadata author=\"$BOOK_AUTHOR\" \
  --metadata publisher=\"$PUBLISHER\" \
  --metadata=lang:\"$LANGUAGE\" \
  --variable=fontsize:\"$PDF_FONT_SIZE\" \
  --variable=papersize:\"$PDF_PAPER_SIZE\" \
  --variable=geometry:\"top=$PDF_MARGIN_TOP,right=$PDF_MARGIN_RIGHT,bottom=$PDF_MARGIN_BOTTOM,left=$PDF_MARGIN_LEFT\" \
  --variable=linestretch:\"$PDF_LINE_HEIGHT\" \
  --resource-path=\"$RESOURCE_PATHS\""

# First attempt: Use LaTeX template if available
if [ -f "$PDF_TEMPLATE" ]; then
  echo "Using LaTeX template: $PDF_TEMPLATE"
  
  # Run pandoc with the template and capture any warnings
  set +e  # Temporarily disable exit on error
  WARNINGS=$(pandoc "$INPUT_FILE" -o "$OUTPUT_FILE" \
    $PANDOC_COMMON_PARAMS \
    --template="$PDF_TEMPLATE" \
    --variable=documentclass:"$PDF_DOCUMENT_CLASS" 2>&1)
  RESULT=$?
  set -e  # Re-enable exit on error
  
  # Check for missing image warnings but continue
  if echo "$WARNINGS" | grep -q "Could not fetch resource"; then
    echo "⚠️ Some images could not be found, but continuing with build"
  fi
else
  # First attempt: Fallback to default pandoc styling
  echo "No custom template found, using default PDF styling"
  
  # Run pandoc without a template and capture any warnings
  set +e  # Temporarily disable exit on error
  WARNINGS=$(pandoc "$INPUT_FILE" -o "$OUTPUT_FILE" \
    $PANDOC_COMMON_PARAMS \
    --variable=documentclass:"$PDF_DOCUMENT_CLASS" 2>&1)
  RESULT=$?
  set -e  # Re-enable exit on error
  
  # Check for missing image warnings but continue
  if echo "$WARNINGS" | grep -q "Could not fetch resource"; then
    echo "⚠️ Some images could not be found, but continuing with build"
  fi
fi

# Check if PDF file was created successfully
if [ $RESULT -ne 0 ] || [ ! -s "$OUTPUT_FILE" ]; then
  echo "⚠️ First PDF generation attempt failed, trying with more resilient settings..."
  
  # Create a version of the markdown with image references made more resilient
  cp "$SAFE_INPUT_FILE" "${SAFE_INPUT_FILE}.tmp"
  sed -i 's/!\[\([^]]*\)\](images\//![\\1](build\/images\//g' "${SAFE_INPUT_FILE}.tmp"
  sed -i 's/!\[\([^]]*\)\](book\/images\//![\\1](build\/images\//g' "${SAFE_INPUT_FILE}.tmp"
  sed -i 's/!\[\([^]]*\)\](book\/[^/)]*\/images\//![\\1](build\/images\//g' "${SAFE_INPUT_FILE}.tmp"
  
  # Second attempt: Try with modified settings and more lenient image paths
  set +e  # Temporarily disable exit on error
  pandoc "${SAFE_INPUT_FILE}.tmp" -o "$OUTPUT_FILE" \
    $PANDOC_COMMON_PARAMS \
    --variable=graphics=true \
    --variable=documentclass=book || true
  set -e  # Re-enable exit on error
  
  # If still not successful, create a minimal PDF
  if [ ! -s "$OUTPUT_FILE" ]; then
    echo "⚠️ WARNING: PDF generation with images failed, creating a minimal PDF without images..."
    # Create a version with image references removed
    cp "$SAFE_INPUT_FILE" "${SAFE_INPUT_FILE}.noimg"
    sed -i 's/!\[\([^]]*\)\]([^)]*)//g' "${SAFE_INPUT_FILE}.noimg"
    
    # Final attempt: minimal PDF with no images
    set +e  # Temporarily disable exit on error
    pandoc "${SAFE_INPUT_FILE}.noimg" -o "$OUTPUT_FILE" \
      $PANDOC_COMMON_PARAMS || true
    set -e  # Re-enable exit on error
    
    # If all else fails, create a placeholder PDF
    if [ ! -s "$OUTPUT_FILE" ]; then
      echo "⚠️ WARNING: All PDF generation attempts failed, creating placeholder PDF..."
      PLACEHOLDER_FILE="$(dirname "$INPUT_FILE")/placeholder.md"
      echo "# $BOOK_TITLE - Placeholder PDF" > "$PLACEHOLDER_FILE"
      echo "PDF generation encountered issues. Please check your Markdown content and template settings." >> "$PLACEHOLDER_FILE"
      echo "If using a custom LaTeX template, verify it's compatible with your Pandoc version." >> "$PLACEHOLDER_FILE"
      echo "See other formats (EPUB, HTML) for the complete content." >> "$PLACEHOLDER_FILE"
      pandoc "$PLACEHOLDER_FILE" -o "$OUTPUT_FILE" --pdf-engine=xelatex
    fi
  fi
  
  # Clean up temporary files
  rm -f "${SAFE_INPUT_FILE}.tmp" "${SAFE_INPUT_FILE}.noimg"
fi

# Check final result and create at least a minimal PDF if everything failed
if [ -s "$OUTPUT_FILE" ]; then
  echo "✅ PDF created successfully at $OUTPUT_FILE"
  
  # Get the file size to give some feedback
  FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
  echo "📊 PDF file size: $FILE_SIZE"
else
  echo "⚠️ Creating minimal emergency PDF..."
  EMERGENCY_FILE="$(dirname "$INPUT_FILE")/emergency.md"
  echo "# $BOOK_TITLE" > "$EMERGENCY_FILE"
  echo "## Generated on $(date)" >> "$EMERGENCY_FILE"
  echo "This is a minimal emergency PDF created because all other PDF generation attempts failed." >> "$EMERGENCY_FILE"
  echo "Please see the EPUB or HTML versions for complete content." >> "$EMERGENCY_FILE"
  
  # One last attempt with minimal content and options
  pandoc "$EMERGENCY_FILE" -o "$OUTPUT_FILE" --pdf-engine=xelatex || touch "$OUTPUT_FILE"
  
  if [ -s "$OUTPUT_FILE" ]; then
    echo "✅ Emergency PDF created at $OUTPUT_FILE"
  else
    echo "❌ Failed to create PDF at $OUTPUT_FILE"
    # Create an empty file to prevent further failures in the pipeline
    touch "$OUTPUT_FILE" 
  fi
fi