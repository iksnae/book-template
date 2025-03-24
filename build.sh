#!/bin/bash

# Main build script for book-template
# This is a compatibility wrapper around the book-tools CLI

# Make the script exit on error
set -e

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
  echo "❌ Error: Node.js is required but not installed."
  echo "Please install Node.js and npm, then run 'npm install' to install dependencies."
  exit 1
fi

# Check if npm dependencies are installed
if [ ! -d "node_modules" ]; then
  echo "📦 Installing dependencies..."
  npm install
fi

# Create necessary directories
mkdir -p build
mkdir -p book/images
mkdir -p templates/{pdf,epub,html}/

# First, run the config adapter to convert book.yaml to book-tools format
echo "📋 Converting configuration format..."
node tools/config-adapter.js

# Parse arguments to maintain compatibility with old script
ALL_LANGUAGES=false
SPECIFIC_LANGUAGE=""
SKIP_FLAGS=""

for arg in "$@"
do
  case $arg in
    --all-languages)
      ALL_LANGUAGES=true
      ;;
    --lang=*)
      SPECIFIC_LANGUAGE="${arg#*=}"
      ;;
    --skip-pdf)
      SKIP_FLAGS="$SKIP_FLAGS --skip-pdf"
      ;;
    --skip-epub)
      SKIP_FLAGS="$SKIP_FLAGS --skip-epub"
      ;;
    --skip-mobi)
      SKIP_FLAGS="$SKIP_FLAGS --skip-mobi"
      ;;
    --skip-html)
      SKIP_FLAGS="$SKIP_FLAGS --skip-html"
      ;;
  esac
done

# Add the --with-recovery flag for better error handling
SKIP_FLAGS="$SKIP_FLAGS --with-recovery"

# Generate the command to run book-tools CLI
if [ "$ALL_LANGUAGES" = true ]; then
  CMD="npx book build --all-languages $SKIP_FLAGS"
elif [ -n "$SPECIFIC_LANGUAGE" ]; then
  CMD="npx book build --lang=$SPECIFIC_LANGUAGE $SKIP_FLAGS"
else
  CMD="npx book build $SKIP_FLAGS"
fi

echo "📚 Running book-tools build: $CMD"
eval $CMD

# List the build folder contents for verification
echo -e "\n📝 Contents of build/ directory:"
ls -la build/

# Copy or symlink legacy structure if needed
# This ensures backward compatibility with tools expecting the old format

# Show a success message
echo "✅ Build process completed successfully!"
