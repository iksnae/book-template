# Chapter Images Directory

This directory is for images specific to Chapter 1.

## How to Use Images in Your Book

### Adding Images

1. Place your image files (PNG, JPG, SVG) in this directory
2. Reference them in your markdown using relative paths:

```markdown
![Image description](images/your-image-name.png)
```

### Image Best Practices

- Use descriptive filenames (e.g., `installation-diagram.png` instead of `img1.png`)
- Include alt text for accessibility (the text in square brackets)
- Optimize images for file size without sacrificing necessary quality
- Prefer vector formats (SVG) for diagrams and illustrations
- Use PNG for screenshots or images with transparency
- Use JPG for photographs

### Image Placement

Images will be placed where they are referenced in the text. For optimal layout in PDF output:

- Place images after the paragraph that references them
- Add a blank line before and after the image reference
- For large images, consider adding a page break before the image:

```markdown
Some text describing the image...

<div class="page-break"></div>

![Large diagram showing the process](images/large-diagram.png)
```

### Chapter-Specific vs. Global Images

- Place images specific to a chapter in that chapter's `images/` directory
- Place images used across multiple chapters in the main `book/images/` directory
- Reference global images with a path that includes the parent directory:

```markdown
![Global image](../../../images/global-image.png)
```

## Image Processing

During the build process, images are automatically:

- Copied to the output directories
- Embedded in EPUB and HTML outputs
- Properly referenced in PDF output

No manual image processing is typically needed.
