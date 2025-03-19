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

To add an image:

![Example image description](images/example-image.jpg)

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