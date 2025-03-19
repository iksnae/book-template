#!/bin/bash

# combine-markdown.sh - Combines markdown files for a specific language
# Usage: combine-markdown.sh [language] [output_path] [book_title] [book_subtitle]

set -e  # Exit on error

# Get arguments
LANGUAGE=${1:-en}
OUTPUT_PATH=${2:-build/book.md}
BOOK_TITLE=${3:-"My Book"}
BOOK_SUBTITLE=${4:-"A Book Built with the Template System"}

echo "📝 Combining markdown files for $LANGUAGE..."
echo "  - Language: $LANGUAGE"
echo "  - Output: $OUTPUT_PATH"
echo "  - Title: $BOOK_TITLE"

# Make sure the parent directory exists
mkdir -p "$(dirname "$OUTPUT_PATH")"

# Clear the file if it exists
true > "$OUTPUT_PATH"

# Read metadata from book.yaml if it exists
if [ -f "book.yaml" ]; then
  echo "Reading metadata from book.yaml..."
  
  # Get publisher if available
  PUBLISHER=$(grep 'publisher:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  if [ -z "$PUBLISHER" ]; then
    PUBLISHER="Publisher Name"
  fi
  
  # Get author if not already set
  if [ -z "$BOOK_AUTHOR" ]; then
    BOOK_AUTHOR=$(grep 'author:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
    if [ -z "$BOOK_AUTHOR" ]; then
      BOOK_AUTHOR="Author Name"
    fi
  fi
  
  # Get rights/copyright info if available
  COPYRIGHT=$(grep 'rights:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  
  # Other metadata
  DESCRIPTION=$(grep 'description:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
else
  PUBLISHER="Publisher Name"
  [ -z "$BOOK_AUTHOR" ] && BOOK_AUTHOR="Author Name"
  COPYRIGHT=""
  DESCRIPTION=""
fi

# Add metadata header
cat > "$OUTPUT_PATH" << EOF
---
title: "$BOOK_TITLE"
subtitle: "$BOOK_SUBTITLE"
author: "$BOOK_AUTHOR"
publisher: "$PUBLISHER"
language: "$LANGUAGE"
toc: true
EOF

# Add optional metadata fields if they exist
if [ -n "$COPYRIGHT" ]; then
  echo "rights: \"$COPYRIGHT\"" >> "$OUTPUT_PATH"
fi

if [ -n "$DESCRIPTION" ]; then
  echo "description: \"$DESCRIPTION\"" >> "$OUTPUT_PATH"
fi

# Add cover image metadata if a cover image exists
if [ -n "$COVER_IMAGE" ]; then
  echo "cover-image: \"$COVER_IMAGE\"" >> "$OUTPUT_PATH"
fi

# Close the metadata block
cat >> "$OUTPUT_PATH" << EOF
---

EOF

# Check for language directory structure
echo "Checking book/$LANGUAGE directory..."
if [ ! -d "book/$LANGUAGE" ]; then
  echo "❌ Error: Language directory book/$LANGUAGE does not exist!"
  exit 1
fi

# List all files to be processed (for debugging)
echo "Files to be processed:"
find "book/$LANGUAGE" -type f -name "*.md" | sort

# Check for multiple directory structures
# First, look for the chapter-based structure (chapter-01, chapter-02, etc.)
CHAPTER_DIRS=$(find "book/$LANGUAGE" -type d -name "chapter-*" 2>/dev/null | sort -V)

# If chapters were found, process them
if [ -n "$CHAPTER_DIRS" ]; then
  echo "Using chapter-based directory structure"
  
  # Look for title-page.md first if it exists
  TITLE_PAGE="book/$LANGUAGE/title-page.md"
  if [ -f "$TITLE_PAGE" ]; then
    echo "Adding title page from $TITLE_PAGE"
    cat "$TITLE_PAGE" >> "$OUTPUT_PATH"
  fi
  
  # Process chapters
  echo "$CHAPTER_DIRS" | while read -r chapter_dir; do
    echo "Processing chapter directory: $chapter_dir"
    
    # Look for chapter introduction file
    if [ -f "$chapter_dir/00-introduction.md" ]; then
      echo "Adding chapter introduction from $chapter_dir/00-introduction.md"
      cat "$chapter_dir/00-introduction.md" >> "$OUTPUT_PATH"
      echo -e "\n\n" >> "$OUTPUT_PATH"
    fi
    
    # Process all section files in correct numeric order
    # Find all numeric prefixed markdown files (excluding introduction) and sort them properly
    find "$chapter_dir" -maxdepth 1 -type f -name "[0-9]*.md" | grep -v "00-introduction.md" | sort -V | while read -r section_file; do
      echo "Adding section from $section_file"
      # Add an explicit section header comment for better visibility in source
      echo -e "\n\n<!-- Start of section: $(basename "$section_file") -->\n" >> "$OUTPUT_PATH"
      cat "$section_file" >> "$OUTPUT_PATH"
      echo -e "\n\n" >> "$OUTPUT_PATH"
    done
  done
else
  # Alternative structure: simple file-based structure
  echo "Using simple file-based structure"
  
  # Look for any markdown files directly in the language directory
  MD_FILES=$(find "book/$LANGUAGE" -maxdepth 1 -type f -name "*.md" | sort -V)
  
  # If no files found at top level, look for files in a 'chapters' directory
  if [ -z "$MD_FILES" ] && [ -d "book/$LANGUAGE/chapters" ]; then
    MD_FILES=$(find "book/$LANGUAGE/chapters" -type f -name "*.md" | sort -V)
  fi
  
  # Process each file
  echo "$MD_FILES" | while read -r md_file; do
    echo "Adding content from $md_file"
    # Add an explicit file header comment for better visibility in source
    echo -e "\n\n<!-- Start of file: $(basename "$md_file") -->\n" >> "$OUTPUT_PATH"
    cat "$md_file" >> "$OUTPUT_PATH"
    echo -e "\n\n" >> "$OUTPUT_PATH"
  done
fi

# Process appendices if they exist, ensuring numeric sorting
APPENDICES_DIR="book/$LANGUAGE/appendices"
if [ -d "$APPENDICES_DIR" ]; then
  echo "Processing appendices from $APPENDICES_DIR"
  
  echo -e "\n\n# Appendices\n\n" >> "$OUTPUT_PATH"
  
  find "$APPENDICES_DIR" -type f -name "*.md" | sort -V | while read -r appendix_file; do
    echo "Adding appendix: $appendix_file"
    cat "$appendix_file" >> "$OUTPUT_PATH"
    # Only add page break if file doesn't already have one
    if ! grep -q '<div style="page-break-after: always;"></div>' "$appendix_file"; then
      echo -e "\n\n---\n\n<div style=\"page-break-after: always;\"></div>\n\n" >> "$OUTPUT_PATH"
    fi
  done
fi

# Process glossary if it exists
GLOSSARY_FILE="book/$LANGUAGE/glossary.md"
if [ -f "$GLOSSARY_FILE" ]; then
  echo "Adding glossary from $GLOSSARY_FILE"
  echo -e "\n\n# Glossary\n\n" >> "$OUTPUT_PATH"
  cat "$GLOSSARY_FILE" >> "$OUTPUT_PATH"
  # Only add page break if file doesn't already have one
  if ! grep -q '<div style="page-break-after: always;"></div>' "$GLOSSARY_FILE"; then
    echo -e "\n\n---\n\n<div style=\"page-break-after: always;\"></div>\n\n" >> "$OUTPUT_PATH"
  fi
fi

echo "✅ Markdown files combined into $OUTPUT_PATH"

# Print a word count
if command -v wc &> /dev/null; then
  WORD_COUNT=$(wc -w < "$OUTPUT_PATH")
  CHAR_COUNT=$(wc -c < "$OUTPUT_PATH")
  echo "📊 Word count: $WORD_COUNT words, $CHAR_COUNT characters"
fi

# Verify the output file exists and has content
if [ ! -s "$OUTPUT_PATH" ]; then
  echo "⚠️ Warning: The combined Markdown file is empty!"
  
  # Create a minimal file with just the metadata
  cat > "$OUTPUT_PATH" << EOF
---
title: "$BOOK_TITLE"
subtitle: "$BOOK_SUBTITLE"
author: "$BOOK_AUTHOR"
publisher: "$PUBLISHER"
language: "$LANGUAGE"
toc: true
---

# $BOOK_TITLE

## $BOOK_SUBTITLE

By $BOOK_AUTHOR

This book appears to be empty or the Markdown files could not be processed correctly.
Please check the directory structure and ensure there are valid Markdown files in the correct locations.
EOF

  echo "Created minimal fallback content to prevent build failures."
fi
