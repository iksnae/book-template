#!/bin/bash

# generate-html.sh - Generates HTML version of the book
# Usage: generate-html.sh [language] [input_file] [output_file] [book_title] [resource_paths]

set -e  # Exit on error

# Get arguments
LANGUAGE=${1:-en}
INPUT_FILE=${2:-build/book.md}
OUTPUT_FILE=${3:-build/book.html}
BOOK_TITLE=${4:-"My Book"}
RESOURCE_PATHS=${5:-".:book:book/en:build:book/en/images:book/images:build/images"}

echo "🌐 Generating HTML for $LANGUAGE..."

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

# Make sure the output directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Get HTML settings from book.yaml if available
HTML_TEMPLATE=""
CSS_FILE=""
TOC=true
TOC_DEPTH=3
SECTION_DIVS=true
SELF_CONTAINED=true

if [ -f "book.yaml" ]; then
  # Extract HTML settings
  if grep -q "html:" book.yaml; then
    # Template
    YAML_TEMPLATE=$(grep 'template:' book.yaml | grep -A 10 'html:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_TEMPLATE" ] && [ -f "$YAML_TEMPLATE" ]; then
      HTML_TEMPLATE="$YAML_TEMPLATE"
      echo "Using HTML template: $HTML_TEMPLATE"
    fi
    
    # CSS file
    YAML_CSS=$(grep 'css:' book.yaml | grep -A 10 'html:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_CSS" ] && [ -f "$YAML_CSS" ]; then
      CSS_FILE="$YAML_CSS"
      echo "Using custom CSS file: $CSS_FILE"
    fi
    
    # ToC setting
    if grep -q "toc: *false" book.yaml; then
      TOC=false
      echo "Table of contents disabled"
    fi
    
    # ToC depth
    YAML_TOC_DEPTH=$(grep 'toc_depth:' book.yaml | grep -A 10 'html:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -n "$YAML_TOC_DEPTH" ]; then
      TOC_DEPTH="$YAML_TOC_DEPTH"
    fi
    
    # Section divs
    if grep -q "section_divs: *false" book.yaml; then
      SECTION_DIVS=false
    fi
    
    # Self-contained
    if grep -q "self_contained: *false" book.yaml; then
      SELF_CONTAINED=false
    fi
  fi
fi

# Check for author and publisher if not already set
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

# Build pandoc command
PANDOC_CMD="pandoc \"$INPUT_FILE\" -o \"$OUTPUT_FILE\" --standalone"

# Add template if specified
if [ -n "$HTML_TEMPLATE" ] && [ -f "$HTML_TEMPLATE" ]; then
  PANDOC_CMD="$PANDOC_CMD --template=\"$HTML_TEMPLATE\""
fi

# Add CSS if specified
if [ -n "$CSS_FILE" ] && [ -f "$CSS_FILE" ]; then
  PANDOC_CMD="$PANDOC_CMD --css=\"$CSS_FILE\""
fi

# Add ToC if enabled
if [ "$TOC" = true ]; then
  PANDOC_CMD="$PANDOC_CMD --toc --toc-depth=$TOC_DEPTH"
fi

# Add section divs if enabled
if [ "$SECTION_DIVS" = true ]; then
  PANDOC_CMD="$PANDOC_CMD --section-divs"
fi

# Make self-contained if enabled
if [ "$SELF_CONTAINED" = true ]; then
  PANDOC_CMD="$PANDOC_CMD --self-contained"
fi

# Fix image paths to ensure they point to the correct location
sed -i 's/!\[\([^]]*\)\](images\//![\1](build\/images\//g' "$SAFE_INPUT_FILE"
sed -i 's/!\[\([^]]*\)\](book\/images\//![\1](build\/images\//g' "$SAFE_INPUT_FILE"
sed -i 's/!\[\([^]]*\)\](book\/[^/)]*\/images\//![\1](build\/images\//g' "$SAFE_INPUT_FILE"

# Add metadata and resource path
PANDOC_CMD="$PANDOC_CMD --metadata title=\"$BOOK_TITLE\" --metadata author=\"$BOOK_AUTHOR\" --metadata publisher=\"$PUBLISHER\" --metadata=lang:\"$LANGUAGE\" --resource-path=\"$RESOURCE_PATHS\""

# Execute the command
echo "Executing: $PANDOC_CMD"
eval $PANDOC_CMD || true

# Check if HTML file was created successfully
if [ ! -s "$OUTPUT_FILE" ]; then
  echo "⚠️ First HTML generation attempt failed, trying with simpler settings..."
  
  # Second attempt: Try with simplified settings
  pandoc "$SAFE_INPUT_FILE" -o "$OUTPUT_FILE" \
    --standalone \
    --toc \
    --toc-depth=2 \
    --metadata title="$BOOK_TITLE" \
    --metadata author="$BOOK_AUTHOR" \
    --metadata publisher="$PUBLISHER" \
    --metadata=lang:"$LANGUAGE" \
    --resource-path="$RESOURCE_PATHS" || true
    
  # If still fails, create minimal HTML
  if [ ! -s "$OUTPUT_FILE" ]; then
    echo "⚠️ All HTML generation attempts failed, creating minimal HTML..."
    cat > "$OUTPUT_FILE" << EOF
<!DOCTYPE html>
<html lang="$LANGUAGE">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$BOOK_TITLE</title>
  <style>
    body { 
      font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; 
      line-height: 1.6; 
      max-width: 800px; 
      margin: 0 auto; 
      padding: 2rem; 
    }
    h1 { text-align: center; margin-bottom: 2rem; color: #333; }
    h2 { color: #444; margin-top: 2rem; }
    p { margin-bottom: 1rem; }
    .author { text-align: center; font-style: italic; margin-bottom: 2rem; }
    .publisher { text-align: center; font-size: 0.9rem; color: #666; margin-bottom: 3rem; }
  </style>
</head>
<body>
  <h1>$BOOK_TITLE</h1>
  <div class="author">By $BOOK_AUTHOR</div>
  <div class="publisher">$PUBLISHER</div>
  
  <p>This is a minimal HTML version created when normal generation failed. The content may be incomplete.</p>
  
  <h2>Troubleshooting</h2>
  <p>HTML generation encountered issues. Possible reasons include:</p>
  <ul>
    <li>Missing dependencies in the build environment</li>
    <li>Issues with image paths or references</li>
    <li>Problems with the HTML template or CSS</li>
    <li>Markdown syntax issues in the source content</li>
  </ul>
  
  <p>Try running the build with <code>--skip-html</code> to generate other formats while troubleshooting.</p>
</body>
</html>
EOF
  fi
fi

# Check final result
if [ -s "$OUTPUT_FILE" ]; then
  echo "✅ HTML created successfully at $OUTPUT_FILE"
  
  # Check file size as a basic sanity check
  FILE_SIZE=$(du -k "$OUTPUT_FILE" | cut -f1)
  echo "📊 HTML file size: ${FILE_SIZE}KB"
  
  if [ "$FILE_SIZE" -lt 5 ]; then
    echo "⚠️ WARNING: HTML file is very small (${FILE_SIZE}KB), content may be missing."
  fi
else
  echo "❌ Failed to create HTML at $OUTPUT_FILE"
  exit 1
fi

# Create index.html if needed
echo "Creating index.html reference..."
if [ "$LANGUAGE" = "en" ]; then
  cp "$OUTPUT_FILE" "$(dirname "$OUTPUT_FILE")/index.html"
  echo "✅ Created main index.html for English"
else
  mkdir -p "build/$LANGUAGE"
  cp "$OUTPUT_FILE" "build/$LANGUAGE/index.html"
  echo "✅ Created language-specific index.html for $LANGUAGE"
fi
