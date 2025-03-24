#!/bin/bash

# Main build script for book-template
# This is a compatibility wrapper around the book-tools CLI

# Make the script exit on error
set -e

# Print banner
echo "📚 Book Template Build System (using book-tools)"

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

# Forward all arguments to the book-tools CLI
if [ "$1" == "--legacy" ]; then
  # Use the original scripts for legacy mode
  echo "⚠️ Using legacy build process..."
  shift
  # Check if the tools/scripts directory exists
  if [ ! -d "tools/scripts" ]; then
    echo "❌ Error: tools/scripts directory not found!"
    echo "Make sure you're running this script from the root of the book-template repository."
    exit 1
  fi
  
  # Make the build script executable
  chmod +x tools/scripts/build.sh
  
  # Forward all arguments to the main build script
  tools/scripts/build.sh "$@"
else
  echo "🔨 Using book-tools build process..."
  node_modules/.bin/book "$@"
fi
