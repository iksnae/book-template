# Troubleshooting Guide

This guide addresses common issues you might encounter when using Book Template and provides solutions to resolve them.

## GitHub Actions Build Failures

### Issue: Tools/Scripts Directory Not Found

**Symptoms**: Build fails with error `find: 'tools/scripts': No such file or directory`

**Solution**:
- Make sure you haven't deleted or renamed the `tools/scripts` directory
- Check that all script files have executable permissions:
  ```bash
  chmod +x build.sh
  chmod +x tools/scripts/*.sh
  ```

### Issue: Docker Image Not Found

**Symptoms**: Build fails with error `Unable to find image 'iksnae/book-builder:latest' locally`

**Solution**:
- Wait and retry - the image might be temporarily unavailable
- If building locally, pull the image manually:
  ```bash
  docker pull iksnae/book-builder:latest
  ```

### Issue: Missing Required Files

**Symptoms**: Build fails with error related to missing templates or configuration files

**Solution**:
- Check that you haven't deleted or modified essential template files
- Compare your repository structure with the original template
- Restore any missing files from the template repository

## Markdown Formatting Issues

### Issue: Images Not Displaying

**Symptoms**: Images appear broken in the output formats

**Solutions**:
- Check that the image path is correct and relative to the markdown file
- Verify that the image file exists in the specified location
- Ensure the image filename matches exactly (case-sensitive)
- Try using different formats (PNG, JPG, SVG) if a specific format isn't working

### Issue: Table of Contents Not Generated

**Symptoms**: No table of contents appears in the output

**Solution**:
- Make sure you have proper heading structure (# for chapter titles, ## for sections)
- Check `book.yaml` configuration to ensure `toc: true` is set

### Issue: Incorrect Heading Hierarchy

**Symptoms**: Sections appear with unexpected formatting or numbering

**Solution**:
- Ensure you're following the correct heading hierarchy:
  - `# Title` for chapter titles (h1)
  - `## Section` for major sections (h2)
  - `### Subsection` for subsections (h3)
- Don't skip levels (e.g., going from h1 directly to h3)

## PDF Generation Issues

### Issue: PDF Layout Problems

**Symptoms**: PDF has incorrect page breaks, overflowing text, or formatting issues

**Solutions**:
- Check for extremely long words or URLs that might not wrap properly
- Add manual page breaks using `<div class="page-break"></div>` where needed
- For tables, check that they aren't too wide for the page
- Verify LaTeX template customizations aren't causing conflicts

### Issue: Missing Special Characters

**Symptoms**: Special characters appear as boxes or are missing in PDF output

**Solution**:
- Ensure you're using UTF-8 encoding for all markdown files
- For complex symbols, consider using HTML entities or LaTeX commands

## EPUB/MOBI Issues

### Issue: Validation Errors

**Symptoms**: EPUB fails validation or doesn't work on certain e-readers

**Solutions**:
- Simplify complex layouts that may not be supported by all e-readers
- Avoid excessive use of HTML elements that aren't well-supported in EPUB
- Keep image sizes reasonable

### Issue: Cover Image Not Displaying

**Symptoms**: Cover image is missing or doesn't display properly

**Solution**:
- Check that `cover.png` exists in the expected location
- Ensure the cover image has reasonable dimensions (recommend 1600×2400 pixels)
- Verify the `epub.cover_image` path in `book.yaml` is correct

## Local Build Issues

### Issue: Docker Permission Problems

**Symptoms**: Permission denied errors when running Docker

**Solutions**:
- Run Docker with sudo if you don't have proper permissions
- Add your user to the Docker group:
  ```bash
  sudo usermod -aG docker $USER
  ```
  Then log out and back in

### Issue: File Ownership Problems

**Symptoms**: Files created by Docker have incorrect ownership

**Solution**:
- Use the correct user mapping when running Docker:
  ```bash
  docker run --rm -v $(pwd):/workspace --user $(id -u):$(id -g) iksnae/book-builder:latest /workspace/build.sh
  ```

## Customization Issues

### Issue: Custom Templates Not Applied

**Symptoms**: Custom templates don't affect the output

**Solutions**:
- Verify the paths in `book.yaml` are correct
- Check that template files are in the expected locations
- Ensure you're properly referencing template variables

## Getting More Help

If you're still experiencing issues:

1. **Check GitHub Issues**: Visit the [Book Template Issues](https://github.com/iksnae/book-template/issues) page to see if others have encountered and solved your problem
2. **Search Documentation**: Make sure you've read through all the documentation
3. **Create an Issue**: If you've found a bug or have a feature request, create a new issue on GitHub with detailed information about your problem
4. **Ask for Help**: Reach out to the community for assistance
