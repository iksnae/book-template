#!/bin/bash

# setup.sh - Prepares the environment for book building
# This script handles initial setup, directories and cover image detection

set -e  # Exit on error

echo "🔄 Running setup script..."

# Create build directory if it doesn't exist
mkdir -p build
mkdir -p build/images

# Create directories for each language
for lang in "${LANGUAGES[@]}"; do
  if [ "$lang" != "en" ]; then
    mkdir -p "build/$lang"
    mkdir -p "build/$lang/images"
  fi
done

# Create templates directory if it doesn't exist
mkdir -p templates
mkdir -p templates/default

# Check that source book directories exist
echo "📚 Verifying language directories..."

for lang in "${LANGUAGES[@]}"; do
  if [ ! -d "book/$lang" ]; then
    echo "⚠️ ERROR: $lang content directory (book/$lang) not found!"
    exit 1
  else
    echo "✅ Found $lang content directory"
    echo "$lang content:"
    ls -la "book/$lang/" || echo "Directory is empty"
  fi
done

# Process cover image
echo "🔎 Checking for cover image..."
COVER_IMAGE=""

# Try to find cover image from book.yaml configuration
if [ -f "book.yaml" ]; then
  # Extract cover image path from EPUB settings if available
  YAML_COVER=$(grep 'cover_image:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  if [ -n "$YAML_COVER" ] && [ -f "$YAML_COVER" ]; then
    echo "✅ Found cover image from book.yaml configuration: $YAML_COVER"
    COVER_IMAGE="$YAML_COVER"
    # Copy to build directory
    cp "$COVER_IMAGE" build/images/cover.png
  fi
fi

# If no cover image found in configuration, look in standard locations
if [ -z "$COVER_IMAGE" ]; then
  # Try to find cover image in standard locations
  if [ -f "art/cover.png" ]; then
    echo "✅ Found cover image at art/cover.png"
    COVER_IMAGE="art/cover.png"
    cp "$COVER_IMAGE" build/images/cover.png
    
  elif [ -f "book/images/cover.png" ]; then
    echo "✅ Found cover image at book/images/cover.png"
    COVER_IMAGE="book/images/cover.png"
    cp "$COVER_IMAGE" build/images/cover.png
    
  elif [ -f "book/images/cover.jpg" ]; then
    echo "✅ Found cover image at book/images/cover.jpg"
    COVER_IMAGE="book/images/cover.jpg"
    # Convert jpg to png if possible, otherwise just copy it
    if command -v convert &> /dev/null; then
      convert "$COVER_IMAGE" build/images/cover.png
      echo "  Converted JPG to PNG for compatibility"
    else
      cp "$COVER_IMAGE" build/images/cover.jpg
      ln -sf build/images/cover.jpg build/images/cover.png 2>/dev/null || true
    fi
    
  else
    # Look in language-specific directories
    for lang in "${LANGUAGES[@]}"; do
      if [ -f "book/$lang/images/cover.png" ]; then
        echo "✅ Found cover image at book/$lang/images/cover.png"
        COVER_IMAGE="book/$lang/images/cover.png"
        cp "$COVER_IMAGE" build/images/cover.png
        break
      elif [ -f "book/$lang/images/cover.jpg" ]; then
        echo "✅ Found cover image at book/$lang/images/cover.jpg"
        COVER_IMAGE="book/$lang/images/cover.jpg"
        # Convert jpg to png if possible, otherwise just copy it
        if command -v convert &> /dev/null; then
          convert "$COVER_IMAGE" build/images/cover.png
          echo "  Converted JPG to PNG for compatibility"
        else
          cp "$COVER_IMAGE" build/images/cover.jpg
          ln -sf build/images/cover.jpg build/images/cover.png 2>/dev/null || true
        fi
        break
      fi
    done
  fi
fi

# Still no cover image found - create a default template placeholder
if [ -z "$COVER_IMAGE" ]; then
  # Check for default template cover
  if [ -f "templates/default/cover.png" ]; then
    echo "⚠️ No custom cover image found. Using default template cover."
    COVER_IMAGE="templates/default/cover.png"
    cp "$COVER_IMAGE" build/images/cover.png
  else
    # Create a simple text file indicating no cover image
    echo "⚠️ No cover image found. Building book without cover."
    
    # Create placeholder text file for cover
    echo "# No Cover Image Available" > build/images/cover-placeholder.txt
    echo "This book was built without a cover image." >> build/images/cover-placeholder.txt
    echo "To add a cover image, place cover.png in the art/ directory" >> build/images/cover-placeholder.txt
    echo "or specify a path in the book.yaml configuration." >> build/images/cover-placeholder.txt
  fi
fi

# Export the cover image path as an environment variable
export COVER_IMAGE

# Copy images to the build directory
echo "🖼️ Copying images to build directory..."

# Copy language-specific images
for lang in "${LANGUAGES[@]}"; do
  if [ -d "book/$lang/images" ]; then
    echo "Copying $lang images..."
    cp -r "book/$lang/images/"* "build/images/" 2>/dev/null || true
    
    # If not English, also copy to language-specific directory
    if [ "$lang" != "en" ]; then
      cp -r "book/$lang/images/"* "build/$lang/images/" 2>/dev/null || true
    fi
  fi
done

# Copy common images
if [ -d "book/images" ]; then
  echo "Copying common images..."
  cp -r book/images/* build/images/ 2>/dev/null || true
fi

# Check for PDF template
PDF_TEMPLATE=""
if [ -f "book.yaml" ]; then
  # Try to extract PDF template from configuration
  YAML_TEMPLATE=$(grep 'template:' book.yaml | grep -A 3 'pdf:' | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  if [ -n "$YAML_TEMPLATE" ] && [ -f "$YAML_TEMPLATE" ]; then
    echo "✅ Using PDF template from book.yaml: $YAML_TEMPLATE"
    PDF_TEMPLATE="$YAML_TEMPLATE"
  fi
fi

# If no PDF template found in configuration, look for default template
if [ -z "$PDF_TEMPLATE" ] && [ -f "templates/pdf/default.latex" ]; then
  echo "✅ Using default PDF template: templates/pdf/default.latex"
  PDF_TEMPLATE="templates/pdf/default.latex"
fi

export PDF_TEMPLATE

# Check EPUB processor
if command -v ebook-convert &> /dev/null; then
  echo "✅ Found ebook-convert utility for MOBI generation"
else
  echo "⚠️ ebook-convert utility not found, MOBI generation may fail"
fi

echo "📋 Environment Summary:"
echo "   - BOOK_TITLE: $BOOK_TITLE"
echo "   - FILE_PREFIX: $FILE_PREFIX"
echo "   - COVER_IMAGE: $COVER_IMAGE"
echo "   - PDF_TEMPLATE: $PDF_TEMPLATE"
echo "   - Working Directory: $(pwd)"
echo "   - Build directories:"
ls -la build/
echo "   - Images directory:"
ls -la build/images/

echo "✅ Setup completed successfully"