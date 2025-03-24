/**
 * Configuration adapter for book-template to book-tools
 * 
 * This script reads the existing book.yaml format and 
 * creates a temporary configuration compatible with book-tools.
 */

const fs = require('fs');
const yaml = require('yaml');

// Read the current configuration
try {
  // Read the book.yaml file
  const configContent = fs.readFileSync('book.yaml', 'utf8');
  const currentConfig = yaml.parse(configContent);

  // Transform to book-tools format
  const newConfig = {
    title: currentConfig.title || 'Untitled Book',
    subtitle: currentConfig.subtitle || '',
    author: currentConfig.author || 'Unknown Author',
    filePrefix: currentConfig.file_prefix || 'book',
    
    // Handle languages array
    languages: Array.isArray(currentConfig.languages) 
      ? currentConfig.languages 
      : (currentConfig.language ? [currentConfig.language] : ['en']),
    
    // Format configurations
    formats: {
      pdf: currentConfig.outputs?.pdf !== false,
      epub: currentConfig.outputs?.epub !== false,
      mobi: currentConfig.outputs?.mobi !== false,
      html: currentConfig.outputs?.html !== false
    },
    
    // Format-specific settings
    formatSettings: {
      pdf: {
        paperSize: currentConfig.pdf?.paper_size || 'letter',
        marginTop: currentConfig.pdf?.margin_top || '1in',
        marginRight: currentConfig.pdf?.margin_right || '1in',
        marginBottom: currentConfig.pdf?.margin_bottom || '1in',
        marginLeft: currentConfig.pdf?.margin_left || '1in',
        fontSize: currentConfig.pdf?.font_size || '11pt',
        lineHeight: currentConfig.pdf?.line_height || '1.5',
        template: currentConfig.pdf?.template || 'templates/pdf/default.latex'
      },
      epub: {
        coverImage: currentConfig.epub?.cover_image || 'book/images/cover.png',
        css: currentConfig.epub?.css || 'templates/epub/style.css',
        tocDepth: currentConfig.epub?.toc_depth || 3
      },
      html: {
        template: currentConfig.html?.template || 'templates/html/default.html',
        css: currentConfig.html?.css || 'templates/html/style.css',
        toc: currentConfig.html?.toc !== false,
        tocDepth: currentConfig.html?.toc_depth || 3,
        sectionDivs: currentConfig.html?.section_divs !== false,
        selfContained: currentConfig.html?.self_contained !== false
      }
    },
    
    // Metadata
    metadata: {
      publisher: currentConfig.publisher || '',
      year: currentConfig.year || new Date().getFullYear().toString(),
      rights: currentConfig.metadata?.rights || `Copyright © ${currentConfig.year || new Date().getFullYear()}`,
      description: currentConfig.metadata?.description || '',
      subject: currentConfig.metadata?.subject || '',
      keywords: currentConfig.metadata?.keywords || ''
    }
  };

  // Create the temporary configuration directory if it doesn't exist
  if (!fs.existsSync('.book-tools')) {
    fs.mkdirSync('.book-tools');
  }

  // Write the transformed configuration
  fs.writeFileSync('.book-tools/config.yaml', yaml.stringify(newConfig));
  console.log('✅ Book configuration transformed for book-tools');

} catch (error) {
  console.error('❌ Error processing configuration:', error.message);
  process.exit(1);
}
