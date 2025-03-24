#!/bin/bash

# Main build script for book-template
# This is a wrapper around the book-tools build system

# Make the script exit on error
set -e

# Parse command line arguments
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

# Check if we're in a Docker container or if using docker build
if [ -f "/.dockerenv" ] || [ "$1" = "--docker" ]; then
  echo "📦 Running in Docker container"
  
  # Create necessary directories
  mkdir -p build
  mkdir -p book/images
  mkdir -p templates/{pdf,epub,html}/
  
  # Use the original book-template scripts for Docker builds
  # This ensures compatibility with the Docker container
  if [ -f "tools/scripts/build.sh" ]; then
    echo "📚 Using legacy build script in Docker container"
    chmod +x tools/scripts/*.sh
    
    # Generate the build command using the original scripts
    if [ "$ALL_LANGUAGES" = true ]; then
      CMD="tools/scripts/build.sh --all-languages"
    elif [ -n "$SPECIFIC_LANGUAGE" ]; then
      CMD="tools/scripts/build.sh --lang=$SPECIFIC_LANGUAGE"
    else
      CMD="tools/scripts/build.sh"
    fi
    
    # Add skip flags if needed (convert to legacy format)
    if [[ $SKIP_FLAGS == *"--skip-pdf"* ]]; then
      CMD="$CMD --skip-pdf"
    fi
    
    if [[ $SKIP_FLAGS == *"--skip-epub"* ]]; then
      CMD="$CMD --skip-epub"
    fi
    
    if [[ $SKIP_FLAGS == *"--skip-mobi"* ]]; then
      CMD="$CMD --skip-mobi"
    fi
    
    if [[ $SKIP_FLAGS == *"--skip-html"* ]]; then
      CMD="$CMD --skip-html"
    fi
    
    echo "📚 Running build command: $CMD"
    eval $CMD
  else
    echo "❌ Error: Build scripts not found in Docker container"
    echo "Please ensure the book-template repository is properly set up"
    exit 1
  fi
else
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
  
  # Check if we should use Docker
  if command -v docker &> /dev/null; then
    echo "🐳 Docker detected, would you like to use the Docker container to build? (y/n)"
    read -r use_docker
    
    if [[ $use_docker =~ ^[Yy]$ ]]; then
      echo "🐳 Using Docker build..."
      
      # Use Docker to run the build
      docker run --rm -v "$(pwd):/book" iksnae/book-builder:latest bash -c "cd /book && ./build.sh --docker $*"
      exit $?
    fi
  fi
  
  # If we're here, we're using the Node.js implementation
  echo "📚 Building with book-tools..."
  
  # Convert arguments to book-tools format
  if [ "$ALL_LANGUAGES" = true ]; then
    CMD="npx book build --all-languages"
  elif [ -n "$SPECIFIC_LANGUAGE" ]; then
    CMD="npx book build --lang=$SPECIFIC_LANGUAGE"
  else
    CMD="npx book build"
  fi
  
  # Add skip flags
  if [[ $SKIP_FLAGS == *"--skip-pdf"* ]]; then
    CMD="$CMD --skip-pdf"
  fi
  
  if [[ $SKIP_FLAGS == *"--skip-epub"* ]]; then
    CMD="$CMD --skip-epub"
  fi
  
  if [[ $SKIP_FLAGS == *"--skip-mobi"* ]]; then
    CMD="$CMD --skip-mobi"
  fi
  
  if [[ $SKIP_FLAGS == *"--skip-html"* ]]; then
    CMD="$CMD --skip-html"
  fi
  
  # Add recovery flag
  CMD="$CMD --with-recovery"
  
  echo "📚 Running: $CMD"
  eval $CMD
fi

# List the build folder contents for verification
echo -e "\n📝 Contents of build/ directory:"
ls -la build/

# Show language-specific directories if they exist
for lang in $(ls -1 book/ 2>/dev/null || echo "en"); do
  if [ -d "build/$lang" ]; then
    echo -e "\n📝 Contents of build/$lang/ directory:"
    ls -la "build/$lang/"
  fi
done

echo "✅ Build process completed successfully!"
