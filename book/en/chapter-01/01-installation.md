## Setting Up Your Environment

Before you start writing your book, you'll need to set up your environment. This section will guide you through the necessary steps.

### Prerequisites

To use this book template effectively, you'll need:

1. **Git**: For version control and pushing changes to GitHub
2. **GitHub Account**: To host your book repository
3. **Basic Markdown Knowledge**: To write your content (don't worry, we'll cover the basics)
4. **Docker** (optional): For local building and testing

### Creating Your Book Repository

The easiest way to get started is to create a new repository from this template:

1. Go to the [Book Template repository](https://github.com/iksnae/book-template)
2. Click the "Use this template" button
3. Name your new repository and click "Create repository from template"
4. Clone your new repository to your local machine:

```bash
git clone https://github.com/yourusername/your-repo-name.git
cd your-repo-name
```

### Installing Required Software

#### For Local Building (Optional)

While GitHub Actions will automatically build your book when you push changes, you may want to build it locally for testing.

**Option 1: Using Docker (Recommended)**

The simplest approach is to use Docker, which packages all dependencies in a container:

```bash
# Pull the book-builder image
docker pull iksnae/book-builder:latest

# Run the build script inside the container
docker run --rm -v $(pwd):/workspace iksnae/book-builder:latest /workspace/build.sh
```

**Option 2: Manual Installation**

If you prefer not to use Docker, you'll need to install:

1. **Pandoc**: The document conversion tool
2. **LaTeX**: For PDF generation
3. **Calibre**: For EPUB/MOBI conversion

Installation instructions vary by operating system. Please refer to each tool's documentation:

- [Pandoc Installation Guide](https://pandoc.org/installing.html)
- [LaTeX Installation Guide](https://www.latex-project.org/get/)
- [Calibre Installation Guide](https://calibre-ebook.com/download)

### Verify Your Setup

To verify your setup:

1. Make a small change to one of the markdown files
2. Build the book locally (if you've installed the necessary tools)
3. Commit and push your changes to GitHub
4. Check the GitHub Actions tab to see the build in progress
5. Once complete, download the artifacts or check the latest release

In the next section, we'll explore the book's directory structure and learn how to organize your content.