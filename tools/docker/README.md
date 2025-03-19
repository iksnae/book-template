# Book Builder Docker Image

This document outlines the plan for creating the `iksnae/book-builder` Docker image that will be used in the book template system.

## Purpose

The Docker image serves several critical functions:

1. Provides a consistent build environment for all book projects
2. Includes all necessary dependencies pre-installed
3. Simplifies local development and testing
4. Ensures GitHub Actions builds work reliably
5. Removes the need for users to install complex dependencies

## Required Components

The Docker image needs to include:

### Core Components
- Ubuntu as the base OS
- Pandoc (latest version) for document conversion
- LaTeX for PDF generation
- Calibre for EPUB/MOBI conversion
- Node.js for potential scripting needs

### Additional Tools
- Git for version control
- Python for utility scripts
- ImageMagick for image processing
- Ghostscript for PDF manipulation
- FontConfig and custom fonts
- Language support packages for multilingual books

### Optimization Features
- Caching for faster builds
- Minimized image size where possible
- Proper tagging system for versioning

## Dockerfile

Here's the Dockerfile that will create the book-builder image:

```dockerfile
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set up locale
RUN apt-get update && apt-get install -y locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8

# Install core dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    apt-transport-https \
    wget \
    curl \
    git \
    zip \
    unzip \
    python3 \
    python3-pip \
    nodejs \
    npm \
    fontconfig \
    imagemagick \
    ghostscript \
    fonts-liberation \
    fonts-noto \
    fonts-noto-cjk \
    fonts-dejavu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install LaTeX
RUN apt-get update && apt-get install -y \
    texlive-full \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Pandoc (latest version)
RUN wget https://github.com/jgm/pandoc/releases/download/3.1.11/pandoc-3.1.11-1-amd64.deb \
    && dpkg -i pandoc-3.1.11-1-amd64.deb \
    && rm pandoc-3.1.11-1-amd64.deb

# Install Calibre (for EPUB to MOBI conversion)
RUN wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin

# Install additional Python packages
RUN pip3 install \
    pyyaml \
    markdown \
    pygments \
    pillow

# Install additional Node.js packages
RUN npm install -g \
    markdown-toc \
    prettier

# Set up work directory
WORKDIR /workspace

# Display versions of key components
RUN echo "Installed versions:" && \
    pandoc --version | head -n 1 && \
    pdflatex --version | head -n 1 && \
    ebook-convert --version | head -n 1 && \
    python3 --version && \
    node --version

# Default command
CMD ["/bin/bash"]
```

## Building and Publishing the Image

To build and publish the Docker image:

1. Create a dedicated repository `iksnae/book-builder-docker` to store the Dockerfile and related assets
2. Set up GitHub Actions to automatically build and push the image to Docker Hub
3. Implement versioning system with tags (latest, vX.Y.Z, etc.)
4. Create comprehensive documentation for the image

## GitHub Actions Workflow

The following GitHub Actions workflow will build and publish the Docker image:

```yaml
name: Build and Publish Docker Image

on:
  push:
    branches: [main]
    paths:
      - 'Dockerfile'
      - '.github/workflows/docker-build.yml'
  workflow_dispatch:

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to DockerHub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Extract version from git
        id: version
        run: |
          VERSION=$(date +'v%Y.%m.%d')
          echo "version=$VERSION" >> $GITHUB_OUTPUT

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            iksnae/book-builder:latest
            iksnae/book-builder:${{ steps.version.outputs.version }}
          cache-from: type=registry,ref=iksnae/book-builder:buildcache
          cache-to: type=registry,ref=iksnae/book-builder:buildcache,mode=max
```

## Usage Instructions

Instructions for using the Docker image will be included in the book template documentation:

### Local Usage

```bash
# Pull the image
docker pull iksnae/book-builder:latest

# Run a build in the current directory
docker run --rm -v $(pwd):/workspace iksnae/book-builder:latest /workspace/build.sh

# Run an interactive shell in the container
docker run -it --rm -v $(pwd):/workspace iksnae/book-builder:latest /bin/bash
```

### GitHub Actions Usage

The `.github/workflows/build-book.yml` file will reference this image:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: iksnae/book-builder:latest
    steps:
      # Build steps here
```

## Maintenance Plan

To ensure the Docker image remains up-to-date and functional:

1. Schedule quarterly updates to refresh dependencies
2. Subscribe to security alerts for base image and key components
3. Test with the template repository before publishing new versions
4. Maintain backwards compatibility where possible
5. Document any breaking changes clearly

## Implementation Timeline

1. Week 1: Create initial Dockerfile and test locally
2. Week 1: Set up Docker Hub repository and GitHub Actions workflow
3. Week 2: Test with book template projects
4. Week 2: Create documentation
5. Week 3: Publish first release version