# Docker Configuration

> **IMPORTANT NOTE**: This project uses the external Docker image `iksnae/book-builder` which is maintained in a separate repository. The image is pulled during CI/CD pipeline execution and can also be used for local builds.

## Using the Docker Image

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

The project's GitHub Actions workflows automatically use this image as specified in `.github/workflows/build-book.yml`:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: iksnae/book-builder:latest
    steps:
      # Build steps here
```

### What's Included in the Docker Image

The `iksnae/book-builder` image includes:

- Ubuntu as the base OS
- Pandoc (latest version) for document conversion
- LaTeX for PDF generation
- Calibre for EPUB/MOBI conversion
- Node.js and Python for scripting
- Git, ImageMagick, and other essential tools
- Various fonts and language support packages

For more details, please refer to the Docker image repository.