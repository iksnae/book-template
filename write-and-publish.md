---
title: "Write and Publish Your First Book"
subtitle: "A Complete Guide to Using the Book Template System"
author: "Your Name"
publisher: "Publisher Name"
language: "en"
toc: true
rights: "Copyright © 2025 Your Name. All rights reserved."
description: "A comprehensive guide to writing and publishing books using Markdown and the Book Template system."
cover-image: "book/images/cover.png"
---

# Chapter 1: Getting Started with Book Template

## Welcome to Your Book Project

Welcome to your new book project! This file is a template to help you get started writing your book using the Book Template system.

### About This Template

This template is designed to help authors write and publish books using Markdown, a simple formatting syntax that's easy to learn and use. Whether you're writing fiction, non-fiction, technical documentation, or educational content, this template provides everything you need to produce professional-quality books in multiple formats.

## Getting Started

To begin writing your book:

1. Replace this introduction text with your own content
2. Create additional markdown files in this directory using the naming pattern `01-section-name.md`, `02-section-name.md`, etc.
3. Add images to the `images` directory
4. Run the build script to see your book in multiple formats

> **Tip**: Files are processed in alphanumeric order, so numbering your files (like `00-`, `01-`, etc.) ensures they appear in the correct sequence in your book.

## Basic Markdown Formatting

Here are some examples of Markdown formatting you can use in your book:

### Text Formatting

You can make text **bold** or *italic* or ***both***. You can also add ~~strikethrough~~ text.

### Lists

Unordered lists:

* Item one
* Item two
  * Sub-item A
  * Sub-item B
* Item three

Numbered lists:

1. First item
2. Second item
3. Third item

### Images

To add an image, use this syntax:

```markdown
![Image description](images/filename.jpg)
```

For example, you can reference an image from the book's main images directory:

![Book cover](../../images/cover.jpg)

### Tables

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |

### Code Blocks

```python
def hello_world():
    print("Hello, world!")

hello_world()
```

## Next Steps

Now that you understand the basics, you're ready to start writing your book! Here are some recommended next steps:

1. Customize your book details in the `book.yaml` file
2. Plan your chapter structure
3. Add content to this chapter or create new chapters
4. Build your book to see how it looks using `./build.sh`

Happy writing!




<!-- Start of section: 01-installation.md -->

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


