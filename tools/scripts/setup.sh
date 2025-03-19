#!/bin/bash

# setup.sh - Sets up the environment for building the book
# This script is sourced by build.sh and should not be run directly

# This is a placeholder script until the actual implementation is completed
# See IMPLEMENTATION_PLAN.md for details on the implementation timeline

echo "🔧 Setting up build environment (placeholder script)"

# Create necessary directories
mkdir -p build
mkdir -p build/images

# Set environment variables
export BOOK_TITLE="Book Template"
export BOOK_AUTHOR="Template Author"
export BUILD_DATE=$(date +'%Y-%m-%d')
export VERSION=$(date +'v%Y.%m.%d')

# Override with values from book.yaml if it exists
if [ -f "book.yaml" ]; then
  echo "📄 Loading configuration from book.yaml"
  
  # Extract book title
  if grep -q 'title:' book.yaml; then
    BOOK_TITLE=$(grep 'title:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//')
    echo "   Title: $BOOK_TITLE"
  fi
  
  # Extract book author
  if grep -q 'author:' book.yaml; then
    BOOK_AUTHOR=$(grep 'author:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//')
    echo "   Author: $BOOK_AUTHOR"
  fi
  
  # Extract file prefix
  if grep -q 'file_prefix:' book.yaml; then
    FILE_PREFIX=$(grep 'file_prefix:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//')
  else
    # Default to lowercase book title with hyphens
    FILE_PREFIX=$(echo "$BOOK_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
  fi
  
  echo "   File Prefix: $FILE_PREFIX"
  export FILE_PREFIX
else
  # Default file prefix if book.yaml doesn't exist
  export FILE_PREFIX="book-template"
fi

echo "✅ Build environment setup complete"
