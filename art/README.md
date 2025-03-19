# Art Directory

This directory is for cover art and promotional images for your book.

## Cover Image

The primary cover image should be named `cover.png` and placed in this directory. This image will be used for:

- EPUB cover
- PDF title page (if enabled in template)
- GitHub repository and release images
- Social media sharing

### Cover Image Requirements

For optimal results, your cover image should:

- Be in PNG format with a transparent background (if needed)
- Have a high resolution (recommended: 1600×2400 pixels, 2:3 aspect ratio)
- Be less than 2MB in size
- Use RGB color space (not CMYK)

## Other Promotional Art

You can also store other promotional art in this directory, such as:

- Social media banners
- Alternative cover designs
- Chapter header images
- Author photos

## Example Cover Art Structure

```
art/
├── cover.png              # Main cover image
├── social-banner.png      # Social media promotional banner
├── author-photo.jpg       # Author photograph
├── chapter-headers/       # Optional subdirectory for chapter header images
│   ├── chapter-1.png
│   ├── chapter-2.png
│   └── ...
└── promotional/           # Optional subdirectory for other promotional images
    ├── amazon-banner.png
    ├── instagram-post.png
    └── ...
```

## Using Art in Your Book

To reference images from this directory in your book content:

```markdown
![Book Cover](../../../art/cover.png)
```

Note that paths are relative to the markdown file, so adjust accordingly based on where your markdown file is located.
