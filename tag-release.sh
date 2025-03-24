#!/bin/bash

# tag-release.sh - Script to tag a new release
# Usage: ./tag-release.sh v1.0.0 [--force]

set -e

# Check if a version was provided
if [ $# -lt 1 ]; then
  echo "❌ Error: No version tag specified!"
  echo "Usage: ./tag-release.sh v1.0.0 [--force]"
  exit 1
fi

VERSION=$1
FORCE=false

# Check if the force flag was provided
if [ "$2" = "--force" ]; then
  FORCE=true
fi

# Validate version format
if ! [[ $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "❌ Error: Invalid version format!"
  echo "Version must be in format v1.0.0"
  exit 1
fi

# Get the current date
DATE=$(date +"%Y-%m-%d")

echo "📄 Preparing to tag release $VERSION ($DATE)"

# Check if the tag already exists
if git rev-parse $VERSION >/dev/null 2>&1; then
  echo "⚠️ Warning: Tag $VERSION already exists!"
  
  if [ "$FORCE" = true ]; then
    echo "Force flag detected, deleting existing tag..."
    git tag -d $VERSION
    git push origin :refs/tags/$VERSION 2>/dev/null || true
  else
    echo "Use --force to overwrite the existing tag"
    exit 1
  fi
fi

# Update package.json version
if [ -f "package.json" ]; then
  echo "📦 Updating package.json version..."
  # Remove the 'v' prefix for package.json
  NPM_VERSION=${VERSION#v}
  sed -i.bak "s/\"version\": \".*\"/\"version\": \"$NPM_VERSION\"/" package.json
  rm package.json.bak
fi

# Create the tag with an annotation
echo "🏷️ Creating tag $VERSION..."
git tag -a $VERSION -m "Release $VERSION ($DATE)"

# Ask for confirmation before pushing
if [ "$FORCE" = false ]; then
  read -p "🚀 Push tag $VERSION to remote repository? [y/N] " CONFIRM
  
  if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo "❌ Operation cancelled. Tag was created locally but not pushed."
    echo "Run 'git push origin $VERSION' to push the tag manually."
    exit 0
  fi
fi

# Push the tag
echo "🚀 Pushing tag $VERSION to remote repository..."
git push origin $VERSION

echo "✅ Success! Tagged release $VERSION and pushed to remote repository."
echo "🔍 The release workflow will be triggered automatically."
