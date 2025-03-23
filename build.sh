#!/bin/bash

# Main build script for book-template
# This is a convenience wrapper around tools/scripts/build.sh

# Make the script exit on error
set -e

# Make sure the tools/scripts directory exists
if [ ! -d "tools/scripts" ]; then
  echo "❌ Error: tools/scripts directory not found!"
  echo "Make sure you're running this script from the root of the book-template repository."
  exit 1
fi

# Create build directory if it doesn't exist
mkdir -p build

# Create a directory for templates if it doesn't exist
mkdir -p templates/{pdf,epub,html}/

# Ensure directory structure is in place
mkdir -p build/images
mkdir -p book/images

# Make the build script executable
chmod +x tools/scripts/build.sh

# Forward all arguments to the main build script
tools/scripts/build.sh "$@"
