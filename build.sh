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

# Make the build script executable
chmod +x tools/scripts/build.sh

# Forward all arguments to the main build script
tools/scripts/build.sh "$@"
