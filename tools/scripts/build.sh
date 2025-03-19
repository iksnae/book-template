#!/bin/bash

# build.sh - Main entry point for the book building process
# Usage: build.sh [--all-languages] [--lang=XX] [--skip-pdf] [--skip-epub] [--skip-mobi] [--skip-html]

set -e  # Exit on error

echo "📚 Book Building System"

# Parse command line arguments
BUILD_ALL_LANGUAGES=false
SPECIFIC_LANGUAGE=""
SKIP_FLAGS=""

for arg in "$@"
do
  case $arg in
    --all-languages)
      BUILD_ALL_LANGUAGES=true
      ;;
    --lang=*)
      SPECIFIC_LANGUAGE="${arg#*=}"
      ;;
    --skip-*)
      SKIP_FLAGS="$SKIP_FLAGS $arg"
      ;;
  esac
done

# Make scripts executable
chmod +x tools/scripts/*.sh

# Load configuration from book.yaml
if [ -f "book.yaml" ]; then
  echo "📝 Loading configuration from book.yaml..."
  
  # Extract book title
  BOOK_TITLE=$(grep 'title:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  echo "Book Title: $BOOK_TITLE"
  
  # Extract book subtitle
  BOOK_SUBTITLE=$(grep 'subtitle:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  echo "Book Subtitle: $BOOK_SUBTITLE"
  
  # Extract author
  BOOK_AUTHOR=$(grep 'author:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  echo "Author: $BOOK_AUTHOR"
  
  # Extract file prefix
  FILE_PREFIX=$(grep 'file_prefix:' book.yaml | head -n 1 | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/"//g')
  if [ -z "$FILE_PREFIX" ]; then
    # Default to lowercase book title with hyphens if not specified
    FILE_PREFIX=$(echo "$BOOK_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
  fi
  echo "File Prefix: $FILE_PREFIX"
  
  # Extract languages
  CONFIGURED_LANGUAGES=()
  in_languages_section=false
  while IFS= read -r line; do
    if [[ $line == "languages:" ]]; then
      in_languages_section=true
    elif [[ $in_languages_section == true ]]; then
      if [[ $line =~ ^[[:space:]]*- ]]; then
        lang=$(echo $line | sed 's/^[[:space:]]*- //' | sed 's/"//g' | sed "s/'//g" | tr -d '[:space:]')
        CONFIGURED_LANGUAGES+=("$lang")
      elif [[ $line =~ ^[a-zA-Z] ]]; then
        # We've reached a new section, stop parsing
        in_languages_section=false
      fi
    fi
  done < book.yaml
  
  # Check if configured languages were found
  if [ ${#CONFIGURED_LANGUAGES[@]} -eq 0 ]; then
    echo "⚠️ No languages found in book.yaml configuration, defaulting to 'en'"
    CONFIGURED_LANGUAGES=("en")
  else
    echo "Configured Languages: ${CONFIGURED_LANGUAGES[*]}"
  fi
  
  # Extract output formats
  SKIP_PDF=false
  SKIP_EPUB=false
  SKIP_MOBI=false
  SKIP_HTML=false
  
  # Check if PDF is enabled
  if grep -q "pdf: *false" book.yaml; then
    SKIP_PDF=true
    SKIP_FLAGS="$SKIP_FLAGS --skip-pdf"
    echo "PDF output is disabled in configuration"
  fi
  
  # Check if EPUB is enabled
  if grep -q "epub: *false" book.yaml; then
    SKIP_EPUB=true
    SKIP_FLAGS="$SKIP_FLAGS --skip-epub"
    echo "EPUB output is disabled in configuration"
  fi
  
  # Check if MOBI is enabled
  if grep -q "mobi: *false" book.yaml; then
    SKIP_MOBI=true
    SKIP_FLAGS="$SKIP_FLAGS --skip-mobi"
    echo "MOBI output is disabled in configuration"
  fi
  
  # Check if HTML is enabled
  if grep -q "html: *false" book.yaml; then
    SKIP_HTML=true
    SKIP_FLAGS="$SKIP_FLAGS --skip-html"
    echo "HTML output is disabled in configuration"
  fi
else
  echo "⚠️ No book.yaml found, using default configuration"
  BOOK_TITLE="My Book"
  BOOK_SUBTITLE="A Book Built with the Template System"
  BOOK_AUTHOR="Author Name"
  FILE_PREFIX="my-book"
  CONFIGURED_LANGUAGES=("en")
fi

# Export configuration variables for use in other scripts
export BOOK_TITLE
export BOOK_SUBTITLE
export BOOK_AUTHOR
export FILE_PREFIX

# Run the setup script
source tools/scripts/setup.sh

# Determine which languages to build
if [ "$BUILD_ALL_LANGUAGES" = true ]; then
  echo "Building all languages..."
  LANGUAGES=("${CONFIGURED_LANGUAGES[@]}")
elif [ -n "$SPECIFIC_LANGUAGE" ]; then
  echo "Building specific language: $SPECIFIC_LANGUAGE"
  # Verify that the requested language exists
  language_exists=false
  for lang in "${CONFIGURED_LANGUAGES[@]}"; do
    if [ "$lang" = "$SPECIFIC_LANGUAGE" ]; then
      language_exists=true
      break
    fi
  done
  
  if [ "$language_exists" = true ]; then
    LANGUAGES=("$SPECIFIC_LANGUAGE")
  else
    echo "⚠️ Warning: Requested language '$SPECIFIC_LANGUAGE' is not configured!"
    echo "Configured languages: ${CONFIGURED_LANGUAGES[*]}"
    exit 1
  fi
else
  # By default, build all languages in CI or just English locally
  if [ -n "$CI" ]; then
    echo "Running in CI environment, building all languages by default"
    LANGUAGES=("${CONFIGURED_LANGUAGES[@]}")
  else
    echo "Building only the first configured language by default"
    LANGUAGES=("${CONFIGURED_LANGUAGES[0]}")
  fi
fi

echo "Languages to build: ${LANGUAGES[*]}"

# Build each language
for lang in "${LANGUAGES[@]}"; do
  echo "📚 Building $lang version..."
  source tools/scripts/build-language.sh "$lang" $SKIP_FLAGS
done

# List the build folder contents for verification
echo -e "\n📝 Contents of build/ directory:"
ls -la build/

# Show language-specific directories if they exist
for lang in "${LANGUAGES[@]}"; do
  if [ -d "build/$lang" ]; then
    echo -e "\n📝 Contents of build/$lang/ directory:"
    ls -la "build/$lang/"
  fi
done

echo "✅ Build process completed successfully!"
