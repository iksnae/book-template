# Technical Design: book-tools Integration

This document outlines the technical design for integrating the `book-tools` package into the `book-template` repository, detailing the architecture, interfaces, and implementation approach.

## System Architecture

### Current Architecture

```
┌─────────────────────────┐
│     book-template       │
├─────────────────────────┤
│                         │
│  ┌───────────────────┐  │
│  │     build.sh      │  │
│  └─────────┬─────────┘  │
│            │            │
│  ┌─────────▼─────────┐  │
│  │ tools/scripts/... │  │
│  └─────────┬─────────┘  │
│            │            │
│  ┌─────────▼─────────┐  │
│  │      Output       │  │
│  └───────────────────┘  │
│                         │
└─────────────────────────┘
```

### Target Architecture

```
┌─────────────────────────┐         ┌─────────────────────────┐
│     book-template       │         │       book-tools        │
├─────────────────────────┤         ├─────────────────────────┤
│                         │         │                         │
│  ┌───────────────────┐  │         │  ┌───────────────────┐  │
│  │     build.sh      │  │         │  │       CLI         │  │
│  └─────────┬─────────┘  │         │  └─────────┬─────────┘  │
│            │            │         │            │            │
│            │            │         │  ┌─────────▼─────────┐  │
│            │            │ ======> │  │  Core Functions   │  │
│            │            │         │  └─────────┬─────────┘  │
│            │            │         │            │            │
│  ┌─────────▼─────────┐  │         │  ┌─────────▼─────────┐  │
│  │      Output       │  │         │  │   Build Scripts   │  │
│  └───────────────────┘  │         │  └───────────────────┘  │
│                         │         │                         │
└─────────────────────────┘         └─────────────────────────┘
```

## Integration Components

### 1. Dependency Management

**package.json**
```json
{
  "name": "book-template",
  "version": "1.0.0",
  "dependencies": {
    "book-tools": "^0.1.0"
  },
  "scripts": {
    "build": "book build",
    "interactive": "book interactive",
    "create-chapter": "book create-chapter",
    "check-chapter": "book check-chapter",
    "info": "book info",
    "clean": "book clean"
  }
}
```

### 2. Build Script Wrapper

**build.sh (updated)**
```bash
#!/bin/bash

# Main build script for book-template
# This is a compatibility wrapper around the book-tools CLI

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
  echo "❌ Error: Node.js is required but not installed."
  echo "Please install Node.js and npm, then run 'npm install' to install dependencies."
  exit 1
fi

# Check if npm dependencies are installed
if [ ! -d "node_modules" ]; then
  echo "📦 Installing dependencies..."
  npm install
fi

# Create necessary directories
mkdir -p build
mkdir -p book/images

# Forward all arguments to the book-tools CLI
node_modules/.bin/book "$@"
```

### 3. Configuration Adapter

To handle the differences in configuration format between `book-template` and `book-tools`, we'll implement a configuration adapter. This adapter will convert the existing format to the new format during the build process.

**tools/config-adapter.js**
```javascript
const fs = require('fs');
const yaml = require('yaml');

// Load current configuration
const currentConfig = yaml.parse(fs.readFileSync('book.yaml', 'utf8'));

// Transform to book-tools format
const newConfig = {
  title: currentConfig.title,
  subtitle: currentConfig.subtitle || '',
  author: currentConfig.author,
  filePrefix: currentConfig.file_prefix || 'book',
  languages: Array.isArray(currentConfig.languages) 
    ? currentConfig.languages 
    : [currentConfig.language || 'en'],
  
  // Convert format-specific configurations
  formats: {
    pdf: currentConfig.outputs?.pdf !== false,
    epub: currentConfig.outputs?.epub !== false,
    mobi: currentConfig.outputs?.mobi !== false,
    html: currentConfig.outputs?.html !== false
  },
  
  // Add format-specific settings
  formatSettings: {
    pdf: currentConfig.pdf || {},
    epub: currentConfig.epub || {},
    html: currentConfig.html || {}
  }
};

// Write to temporary config for book-tools
fs.writeFileSync('book-tools-config.yaml', yaml.stringify(newConfig));
```

### 4. GitHub Actions Workflow

**Updated .github/workflows/build.yml**
```yaml
name: Build Book

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Use Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '14.x'
    
    - name: Install dependencies
      run: npm install
    
    - name: Build book
      run: npm run build -- --all-languages
      
    - name: Upload artifacts
      uses: actions/upload-artifact@v2
      with:
        name: book-outputs
        path: build/**/*
```

## Feature Implementation in book-tools

The following features need to be added to `book-tools`:

### 1. Extended Configuration Support

**Add to src/utils.js:**
```javascript
/**
 * Load extended format-specific configuration
 * 
 * @param {Object} config - Base configuration 
 * @returns {Object} - Configuration with format settings
 */
function loadFormatSettings(config) {
  // Add default format settings if not present
  config.formatSettings = config.formatSettings || {};
  
  // PDF defaults
  config.formatSettings.pdf = config.formatSettings.pdf || {};
  config.formatSettings.pdf.paperSize = config.formatSettings.pdf.paperSize || 'letter';
  config.formatSettings.pdf.marginTop = config.formatSettings.pdf.marginTop || '1in';
  config.formatSettings.pdf.marginRight = config.formatSettings.pdf.marginRight || '1in';
  config.formatSettings.pdf.marginBottom = config.formatSettings.pdf.marginBottom || '1in';
  config.formatSettings.pdf.marginLeft = config.formatSettings.pdf.marginLeft || '1in';
  config.formatSettings.pdf.fontSize = config.formatSettings.pdf.fontSize || '11pt';
  config.formatSettings.pdf.lineHeight = config.formatSettings.pdf.lineHeight || '1.5';
  
  // EPUB defaults
  config.formatSettings.epub = config.formatSettings.epub || {};
  config.formatSettings.epub.coverImage = config.formatSettings.epub.coverImage || 'book/images/cover.png';
  config.formatSettings.epub.css = config.formatSettings.epub.css || 'templates/epub/style.css';
  config.formatSettings.epub.tocDepth = config.formatSettings.epub.tocDepth || 3;
  
  // HTML defaults
  config.formatSettings.html = config.formatSettings.html || {};
  config.formatSettings.html.template = config.formatSettings.html.template || 'templates/html/default.html';
  config.formatSettings.html.css = config.formatSettings.html.css || 'templates/html/style.css';
  config.formatSettings.html.toc = config.formatSettings.html.toc !== false;
  config.formatSettings.html.tocDepth = config.formatSettings.html.tocDepth || 3;
  
  return config;
}
```

### 2. Error Handling Improvements

**Add to src/index.js:**
```javascript
/**
 * Build book with improved error handling
 * 
 * @param {Object} options - Build options
 * @returns {Promise<Object>} - Build result
 */
async function buildBookWithRecovery(options = {}) {
  try {
    // First try the normal build
    return await buildBook(options);
  } catch (primaryError) {
    console.warn(`Primary build attempt failed: ${primaryError.message}`);
    console.warn('Attempting recovery build...');
    
    try {
      // Try again with minimal settings
      const recoveryOptions = {
        ...options,
        recovery: true // Flag to indicate recovery mode
      };
      
      return await buildBook(recoveryOptions);
    } catch (recoveryError) {
      console.error(`Recovery build also failed: ${recoveryError.message}`);
      
      // Create emergency minimal output
      return {
        success: false,
        error: primaryError,
        recoveryError,
        emergencyFiles: await createEmergencyOutput(options)
      };
    }
  }
}

/**
 * Create emergency minimal output files
 * 
 * @param {Object} options - Build options
 * @returns {Promise<Object>} - Emergency files created
 */
async function createEmergencyOutput(options) {
  const projectRoot = findProjectRoot();
  const language = options.language || 'en';
  const fileNames = buildFileNames(language, projectRoot);
  
  // Create a minimal emergency output
  // This ensures the build process completes with at least some output
  const emergencyFiles = {};
  
  try {
    // Create minimal HTML file
    const htmlContent = `<!DOCTYPE html>
<html>
<head>
  <title>Emergency Output</title>
</head>
<body>
  <h1>Emergency Output</h1>
  <p>The build process encountered errors. This is an emergency output.</p>
</body>
</html>`;
    
    fs.writeFileSync(fileNames.html, htmlContent);
    emergencyFiles.html = fileNames.html;
  } catch (e) {
    // Ignore errors during emergency output
  }
  
  return emergencyFiles;
}
```

### 3. GitHub Actions Integration

**Add to src/cli.js:**
```javascript
// GitHub Actions command
program
  .command('github-action')
  .description('Run as GitHub Action')
  .option('--all-languages', 'Build for all configured languages')
  .option('--create-release', 'Create GitHub release')
  .action(async (options) => {
    try {
      console.log(chalk.blue('Running as GitHub Action'));
      
      // Set CI environment variable for downstream scripts
      process.env.CI = 'true';
      
      const spinner = ora('Building book...').start();
      
      const buildOptions = {
        allLanguages: options.allLanguages,
        formats: ['pdf', 'epub', 'mobi', 'html']
      };
      
      const result = await buildBook(buildOptions);
      
      if (result.success) {
        spinner.succeed(chalk.green('Book built successfully!'));
        
        if (options.createRelease) {
          // Logic for GitHub Release creation
          console.log(chalk.blue('Creating GitHub Release...'));
        }
      } else {
        spinner.fail(chalk.red('Failed to build book'));
        if (result.error) {
          console.error(chalk.red(result.error.message));
        }
        process.exit(1);
      }
    } catch (error) {
      console.error(chalk.red(`Error: ${error.message}`));
      process.exit(1);
    }
  });
```

## Implementation Approach

The integration will follow this step-by-step approach:

1. **Enhance book-tools**
   - Add extended configuration support
   - Improve error handling
   - Add GitHub Actions integration

2. **Adapt book-template**
   - Implement `package.json` with book-tools dependency
   - Update `build.sh` as a wrapper script
   - Create configuration adapter
   - Update GitHub Actions workflow

3. **Maintain Compatibility**
   - Keep existing directory structure
   - Support both old and new configuration formats
   - Provide backward-compatible scripts

4. **Test and Document**
   - Test with various configurations
   - Document migration process
   - Provide examples

## Testing Strategy

Testing will ensure that the migration proceeds smoothly:

1. **Feature Parity Tests**
   - Test that all features from the old system work in the new system
   - Compare output files for equivalence

2. **Configuration Tests**
   - Test with various configuration formats
   - Verify that all settings are properly applied

3. **Error Handling Tests**
   - Test with missing resources
   - Verify recovery mechanisms

4. **CI/CD Tests**
   - Test GitHub Actions integration
   - Verify release creation

## Conclusion

This technical design outlines the approach for migrating from the bespoke build system in `book-template` to the standardized `book-tools` package. By following this design, we will ensure a smooth transition while maintaining compatibility and enhancing functionality.
