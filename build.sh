#!/bin/bash

# Main build script for book-template
# This wrapper script uses the book-tools system

# Make the script exit on error
set -e

# Parse command line arguments
ALL_LANGUAGES=false
SPECIFIC_LANGUAGE=""
SKIP_PDF=false
SKIP_EPUB=false
SKIP_MOBI=false
SKIP_HTML=false
SKIP_DOCX=false

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
      SKIP_PDF=true
      ;;
    --skip-epub)
      SKIP_EPUB=true
      ;;
    --skip-mobi)
      SKIP_MOBI=true
      ;;
    --skip-html)
      SKIP_HTML=true
      ;;
    --skip-docx)
      SKIP_DOCX=true
      ;;
  esac
done

# Create necessary directories
mkdir -p build
mkdir -p book/images
mkdir -p templates/{pdf,epub,html,docx}/

# Check if we're in a Docker container or if using Docker build
if [ -f "/.dockerenv" ] || [ "$1" = "--docker" ]; then
  echo "📦 Running in Docker container"

  if [ -f "/usr/local/bin/book" ]; then
    echo "📚 Using book-tools in Docker container"
    
    # Build command with book-tools CLI
    if [ "$ALL_LANGUAGES" = true ]; then
      CMD="book build --all-languages"
    elif [ -n "$SPECIFIC_LANGUAGE" ]; then
      CMD="book build --lang=$SPECIFIC_LANGUAGE"
    else
      CMD="book build"
    fi
    
    # Add skip flags
    if [ "$SKIP_PDF" = true ]; then
      CMD="$CMD --skip-pdf"
    fi
    
    if [ "$SKIP_EPUB" = true ]; then
      CMD="$CMD --skip-epub"
    fi
    
    if [ "$SKIP_MOBI" = true ]; then
      CMD="$CMD --skip-mobi"
    fi
    
    if [ "$SKIP_HTML" = true ]; then
      CMD="$CMD --skip-html"
    fi
    
    if [ "$SKIP_DOCX" = true ]; then
      CMD="$CMD --skip-docx"
    fi
    
    echo "📚 Running book-tools: $CMD"
    eval $CMD
  else
    # Fallback to legacy scripts if book-tools is not installed
    echo "📚 Using legacy build scripts in Docker container"
    chmod +x tools/scripts/*.sh
    
    # Generate the build command using the original scripts
    if [ "$ALL_LANGUAGES" = true ]; then
      CMD="tools/scripts/build.sh --all-languages"
    elif [ -n "$SPECIFIC_LANGUAGE" ]; then
      CMD="tools/scripts/build.sh --lang=$SPECIFIC_LANGUAGE"
    else
      CMD="tools/scripts/build.sh"
    fi
    
    # Add skip flags if needed
    if [ "$SKIP_PDF" = true ]; then
      CMD="$CMD --skip-pdf"
    fi
    
    if [ "$SKIP_EPUB" = true ]; then
      CMD="$CMD --skip-epub"
    fi
    
    if [ "$SKIP_MOBI" = true ]; then
      CMD="$CMD --skip-mobi"
    fi
    
    if [ "$SKIP_HTML" = true ]; then
      CMD="$CMD --skip-html"
    fi
    
    if [ "$SKIP_DOCX" = true ]; then
      CMD="$CMD --skip-docx"
    fi
    
    echo "📚 Running build command: $CMD"
    eval $CMD
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
  
  # Check if we should use Docker
  if command -v docker &> /dev/null; then
    echo "🐳 Docker detected, would you like to use the Docker container to build? (y/n)"
    read -r use_docker
    
    if [[ $use_docker =~ ^[Yy]$ ]]; then
      echo "🐳 Using Docker build..."
      
      # Use Docker to run the build
      CMD="docker run --rm -v \"$(pwd):/book\" iksnae/book-builder:latest bash -c \"cd /book && ./build.sh --docker"
      
      # Add all languages flag
      if [ "$ALL_LANGUAGES" = true ]; then
        CMD="$CMD --all-languages"
      fi
      
      # Add language selection
      if [ -n "$SPECIFIC_LANGUAGE" ]; then
        CMD="$CMD --lang=$SPECIFIC_LANGUAGE"
      fi
      
      # Add skip flags
      if [ "$SKIP_PDF" = true ]; then
        CMD="$CMD --skip-pdf"
      fi
      
      if [ "$SKIP_EPUB" = true ]; then
        CMD="$CMD --skip-epub"
      fi
      
      if [ "$SKIP_MOBI" = true ]; then
        CMD="$CMD --skip-mobi"
      fi
      
      if [ "$SKIP_HTML" = true ]; then
        CMD="$CMD --skip-html"
      fi
      
      if [ "$SKIP_DOCX" = true ]; then
        CMD="$CMD --skip-docx"
      fi
      
      CMD="$CMD\""
      echo "📚 Running: $CMD"
      eval $CMD
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
  if [ "$SKIP_PDF" = true ]; then
    CMD="$CMD --skip-pdf"
  fi
  
  if [ "$SKIP_EPUB" = true ]; then
    CMD="$CMD --skip-epub"
  fi
  
  if [ "$SKIP_MOBI" = true ]; then
    CMD="$CMD --skip-mobi"
  fi
  
  if [ "$SKIP_HTML" = true ]; then
    CMD="$CMD --skip-html"
  fi
  
  if [ "$SKIP_DOCX" = true ]; then
    CMD="$CMD --skip-docx"
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
