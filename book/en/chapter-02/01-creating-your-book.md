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