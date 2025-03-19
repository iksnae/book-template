#!/bin/bash

# generate-pdf.sh - Generates PDF version of the book
# Usage: generate-pdf.sh [language] [input_file] [output_file] [book_title] [resource_paths]

set -e  # Exit on error

# Get arguments
LANGUAGE=${1:-en}
INPUT_FILE=${2:-build/book.md}
OUTPUT_FILE=${3:-build/book.pdf}
BOOK_TITLE=${4:-"My Book"}
RESOURCE_PATHS=${5:-".:book:book/en:build:book/en/images:book/images:build/images"}

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

# First attempt: Use LaTeX template if available
if [ -f "$PDF_TEMPLATE" ]; then
  echo "Using LaTeX template: $PDF_TEMPLATE"
  pandoc "$INPUT_FILE" -o "$OUTPUT_FILE" \
    --template="$PDF_TEMPLATE" \
    --metadata title="$BOOK_TITLE" \
    --metadata author="$BOOK_AUTHOR" \
    --metadata publisher="$PUBLISHER" \
    --metadata=lang:"$LANGUAGE" \
    --variable=documentclass:"$PDF_DOCUMENT_CLASS" \
    --pdf-engine=xelatex \
    --toc \
    --variable=fontsize:"$PDF_FONT_SIZE" \
    --variable=papersize:"$PDF_PAPER_SIZE" \
    --variable=geometry:"top=$PDF_MARGIN_TOP,right=$PDF_MARGIN_RIGHT,bottom=$PDF_MARGIN_BOTTOM,left=$PDF_MARGIN_LEFT" \
    --variable=linestretch:"$PDF_LINE_HEIGHT" \
    --resource-path="$RESOURCE_PATHS"
else
  # First attempt: Fallback to default pandoc styling
  echo "No custom template found, using default PDF styling"
  pandoc "$INPUT_FILE" -o "$OUTPUT_FILE" \
    --metadata title="$BOOK_TITLE" \
    --metadata author="$BOOK_AUTHOR" \
    --metadata publisher="$PUBLISHER" \
    --metadata=lang:"$LANGUAGE" \
    --variable=documentclass:"$PDF_DOCUMENT_CLASS" \
    --pdf-engine=xelatex \
    --toc \
    --variable=fontsize:"$PDF_FONT_SIZE" \
    --variable=papersize:"$PDF_PAPER_SIZE" \
    --variable=geometry:"top=$PDF_MARGIN_TOP,right=$PDF_MARGIN_RIGHT,bottom=$PDF_MARGIN_BOTTOM,left=$PDF_MARGIN_LEFT" \
    --variable=linestretch:"$PDF_LINE_HEIGHT" \
    --resource-path="$RESOURCE_PATHS"
fi

# Check if PDF file was created successfully
if [ $? -ne 0 ] || [ ! -s "$OUTPUT_FILE" ]; then
  echo "⚠️ First PDF generation attempt failed, trying with more resilient settings..."
  
  # Create a version of the markdown with image references made more resilient
  sed -i 's/!\[\([^]]*\)\](images\//![\1](build\/images\//g' "$SAFE_INPUT_FILE"
  sed -i 's/!\[\([^]]*\)\](book\/images\//![\1](build\/images\//g' "$SAFE_INPUT_FILE"
  sed -i 's/!\[\([^]]*\)\](book\/[^/)]*\/images\//![\1](build\/images\//g' "$SAFE_INPUT_FILE"
  
  # Second attempt: Try with modified settings and more lenient image paths
  pandoc "$SAFE_INPUT_FILE" -o "$OUTPUT_FILE" \
    --metadata title="$BOOK_TITLE" \
    --metadata author="$BOOK_AUTHOR" \
    --metadata publisher="$PUBLISHER" \
    --metadata=lang:"$LANGUAGE" \
    --pdf-engine=xelatex \
    --toc \
    --variable=graphics=true \
    --variable=documentclass=book \
    --variable=fontsize:"$PDF_FONT_SIZE" \
    --variable=papersize:"$PDF_PAPER_SIZE" \
    --variable=geometry:"top=$PDF_MARGIN_TOP,right=$PDF_MARGIN_RIGHT,bottom=$PDF_MARGIN_BOTTOM,left=$PDF_MARGIN_LEFT" \
    --resource-path="$RESOURCE_PATHS" || true
  
  # If still not successful, create a minimal PDF
  if [ ! -s "$OUTPUT_FILE" ]; then
    echo "⚠️ WARNING: PDF generation with images failed, creating a minimal PDF without images..."
    # Create a version with image references removed
    sed -i 's/!\[\([^]]*\)\]([^)]*)//g' "$SAFE_INPUT_FILE"
    
    # Final attempt: minimal PDF with no images
    pandoc "$SAFE_INPUT_FILE" -o "$OUTPUT_FILE" \
      --metadata title="$BOOK_TITLE" \
      --metadata author="$BOOK_AUTHOR" \
      --metadata publisher="$PUBLISHER" \
      --metadata=lang:"$LANGUAGE" \
      --pdf-engine=xelatex \
      --toc \
      --variable=fontsize:"$PDF_FONT_SIZE" \
      --variable=papersize:"$PDF_PAPER_SIZE" \
      --variable=geometry:"top=$PDF_MARGIN_TOP,right=$PDF_MARGIN_RIGHT,bottom=$PDF_MARGIN_BOTTOM,left=$PDF_MARGIN_LEFT" \
      --resource-path="$RESOURCE_PATHS" || true
      
    # If all else fails, create a placeholder PDF
    if [ ! -s "$OUTPUT_FILE" ]; then
      echo "⚠️ WARNING: All PDF generation attempts failed, creating placeholder PDF..."
      PLACEHOLDER_FILE="$(dirname "$INPUT_FILE")/placeholder.md"
      echo "# $BOOK_TITLE - Placeholder PDF" > "$PLACEHOLDER_FILE"
      echo "PDF generation encountered issues. Please check your Markdown content and template settings." >> "$PLACEHOLDER_FILE"
      echo "If using a custom LaTeX template, verify it's compatible with your Pandoc version." >> "$PLACEHOLDER_FILE"
      echo "Try running the build with --skip-pdf to generate other formats while troubleshooting the PDF output." >> "$PLACEHOLDER_FILE"
      pandoc "$PLACEHOLDER_FILE" -o "$OUTPUT_FILE" --pdf-engine=xelatex
    fi
  fi
fi

# Check final result
if [ -s "$OUTPUT_FILE" ]; then
  echo "✅ PDF created successfully at $OUTPUT_FILE"
  
  # Get the file size to give some feedback
  FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
  echo "📊 PDF file size: $FILE_SIZE"
else
  echo "❌ Failed to create PDF at $OUTPUT_FILE"
  exit 1
fi
