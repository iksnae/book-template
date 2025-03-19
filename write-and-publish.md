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



<!-- Start of section: 01-introduction.md -->

# Welcome to Book Template

Welcome to this simple guide to creating your first book with Book Template! This short guide will show you how to create beautiful books without needing to be a technical expert.

## What is Book Template?

Book Template is a simple system that lets you write your book using plain text files and automatically converts them into professional-looking books in different formats. No coding required!

## What can you create?

Using Book Template, you can create:

- Printed books (PDF files ready for printing)
- E-books for Kindle and other e-readers
- Web versions of your book
- Books with images, chapters, and nice formatting

## How this guide helps you

In the next few pages, we'll show you:

1. How to set up your book files
2. How to add your content and images
3. How to build your finished book
4. How to share your book with the world

Let's get started!




<!-- Start of section: 01-creating-your-book.md -->

# Creating Your Book

Creating a book with Book Template is easy! This chapter shows you the basics of adding content to your book.

## Setting Up Your Files

To start your book:

1. Copy the example directory structure
2. Edit the `book.yaml` file with your book's title and author
3. Start adding your content to the chapter files

## Adding Your Content

Your book content goes into markdown files (`.md`) in the chapter folders. Don't worry if you're not familiar with markdown - it's very simple!

Here are some basics:

```
# This is a chapter title
## This is a section heading

This is a normal paragraph.

**This text will be bold**
*This text will be italic*

- This is a bullet point
- Another bullet point
```

## Adding Images

To add images to your book:

1. Put your image files in the `book/images` folder or a chapter's `images` folder
2. Reference them in your markdown like this:

```
![Image description](images/my-image.png)
```

## Building Your Book

When you're ready to see your book:

1. Open a terminal or command prompt
2. Navigate to your book directory
3. Run `./build.sh`
4. Find your built book in the `build` folder

Don't worry if this sounds complicated - it's just one command to run, and your book will be created automatically!




<!-- Start of section: 01-publishing-your-book.md -->

# Publishing Your Book

Now that you've created your book, it's time to share it with the world!

## Creating a PDF

The PDF version of your book is perfect for:
- Printing physical copies
- Sharing a professional-looking document
- Preserving exact formatting

Your PDF is automatically created when you build your book and will be available in the `build` folder.

## Creating an E-book

The EPUB version of your book works with:
- Most e-readers
- Apple Books
- Google Play Books
- Many other reading apps

Like the PDF, your EPUB file is created automatically and will be in the `build` folder.

## Sharing Your Book

Here are some ways to share your finished book:

### Self-Publishing Options
- Amazon KDP for both print and Kindle versions
- IngramSpark for wide distribution
- Lulu, BookBaby, or other print-on-demand services

### Digital Sharing
- Email the files directly to friends and family
- Upload to your website for download
- Use services like Gumroad to sell digital copies

### Using GitHub
If you're using GitHub to store your book, you can:
- Use GitHub Releases to make your book available for download
- Use GitHub Pages to create a simple website for your book

Congratulations! You've now learned the basics of creating and publishing a book with Book Template!


