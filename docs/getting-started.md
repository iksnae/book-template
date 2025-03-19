# Getting Started with Book Template

This guide will walk you through the process of creating and publishing your first book using the Book Template system.

## Prerequisites

Before you begin, make sure you have:

1. **GitHub Account**: You'll need a GitHub account to create and host your book repository.
2. **Git**: Basic knowledge of Git and GitHub is helpful but not required.
3. **Markdown**: Familiarity with Markdown syntax will make writing your book easier.

## Step 1: Create Your Book Repository

1. Go to the [Book Template repository](https://github.com/iksnae/book-template)
2. Click the green "Use this template" button at the top of the page
3. Give your new repository a name (e.g., "my-awesome-book")
4. Choose whether to make it public or private
5. Click "Create repository from template"

## Step 2: Clone Your Repository

Next, clone your new repository to your local machine:

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

## Step 3: Configure Your Book

Edit the `book.yaml` file in the root of your repository to customize your book's metadata:

```yaml
title: "Your Book Title"
subtitle: "Your Book Subtitle"
author: "Your Name"
publisher: "Your Publisher Name"
year: "2025"
```

## Step 4: Write Your Book

1. Navigate to the `book/en/chapter-01` directory
2. Edit the existing markdown files or create new ones
3. Files are processed in alphanumeric order, so name them accordingly:
   - `00-introduction.md`
   - `01-first-section.md`
   - `02-second-section.md`
   - etc.

### Adding Images

1. Place your images in the appropriate `images` directory:
   - `book/en/chapter-01/images/` for chapter-specific images
   - `book/images/` for images used across multiple chapters
2. Reference images in your markdown using relative paths:
   ```markdown
   ![Image description](images/your-image.jpg)
   ```

### Creating New Chapters

To create a new chapter:

1. Create a new directory under `book/en/` (e.g., `book/en/chapter-02`)
2. Add your markdown files to the new directory
3. Create an `images` subdirectory if needed

## Step 5: Preview Your Book Locally (Optional)

You can build your book locally using Docker:

```bash
# Pull the book-builder image
docker pull iksnae/book-builder:latest

# Run the build script inside the container
docker run --rm -v $(pwd):/workspace iksnae/book-builder:latest /workspace/build.sh
```

The built files will be in the `build/` directory.

## Step 6: Commit and Push Your Changes

Commit your changes and push them to GitHub:

```bash
git add .
git commit -m "Add initial book content"
git push origin main
```

## Step 7: Let GitHub Actions Build Your Book

After pushing to GitHub:

1. Go to your repository on GitHub
2. Click on the "Actions" tab
3. You should see the "Build Book" workflow running
4. Wait for it to complete

## Step 8: Access Your Book

Once the workflow completes successfully:

1. **Web Version**: Available at `https://your-username.github.io/your-repo-name/`
2. **Download Formats**: Available from the latest release on your GitHub repository

## Next Steps

Now that you have your book set up, you can:

- **Add more content**: Continue writing and organizing your chapters
- **Customize appearance**: Modify templates and styles in the `templates/` directory
- **Add translations**: Create content in other languages in the `book/[language-code]/` directories
- **Share your book**: Distribute the PDF, EPUB, or MOBI versions, or share the web URL

For more detailed information, check out the other documentation files:

- [Customization Guide](customization.md)
- [Multilingual Guide](multilingual.md)
- [Troubleshooting](troubleshooting.md)

Happy writing!
