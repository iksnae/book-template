#!/bin/bash

# Main build script for book-template
# Uses the book-tools package for building books

# Make the script exit on error
set -e

# Check if book-tools is installed locally
if ! command -v npx &> /dev/null; then
  echo "❌ Error: npx not found, please install Node.js and npm"
  exit 1
fi

# Create build directory if it doesn't exist
mkdir -p build

# Create a directory for templates if it doesn't exist
mkdir -p templates/{pdf,epub,html}/

# Ensure directory structure is in place
mkdir -p build/images
mkdir -p book/images

echo "📚 Building book using book-tools package..."

# Process command line arguments
ARGS=""
for arg in "$@"
do
  ARGS="$ARGS $arg"
done

# Use npx to run book-tools
npx book build $ARGS

echo "✅ Build completed successfully!"