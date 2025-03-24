# Feature Audit: book-template vs book-tools

This document compares the features of the current bespoke build system in `book-template` with the standardized `book-tools` package, identifying gaps that need to be addressed during the migration.

## Build System Comparison

| Feature | book-template | book-tools | Gap Analysis |
|---------|---------------|------------|--------------|
| **Core Functionality** |
| Basic PDF generation | ✅ | ✅ | No gap |
| EPUB generation | ✅ | ✅ | No gap |
| MOBI generation | ✅ | ✅ | No gap |
| HTML generation | ✅ | ✅ | No gap |
| Multi-language support | ✅ | ✅ | No gap |
| Command-line arguments | ✅ | ✅ | No gap |
| **Configuration** |
| YAML configuration | ✅ | ✅ | No gap |
| Custom templates | ✅ | ✅ | No gap |
| Custom CSS | ✅ | ✅ | No gap |
| PDF settings | ✅ | ❌ | book-tools needs to support PDF customization |
| EPUB settings | ✅ | ❌ | book-tools needs to support EPUB customization |
| HTML settings | ✅ | ❌ | book-tools needs to support HTML customization |
| **Advanced Features** |
| Interactive CLI | ❌ | ✅ | book-template could leverage this feature |
| Chapter creation | ❌ | ✅ | book-template could leverage this feature |
| Chapter verification | ❌ | ✅ | book-template could leverage this feature |
| Book information | ❌ | ✅ | book-template could leverage this feature |
| Clean build | ❌ | ✅ | book-template could leverage this feature |
| **Error Handling** |
| Missing image resilience | ✅ | ❌ | book-tools needs better error handling for missing resources |
| Build process recovery | ✅ | ❌ | book-tools needs more robust recovery mechanisms |
| **Structure** |
| Directory organization | ✅ | ✅ | Different but compatible |
| GitHub Actions integration | ✅ | ❌ | book-tools needs explicit GitHub Actions support |

## Configuration Format Differences

### book-template (current)
```yaml
# Basic Information
title: "Write and Publish Your First Book"
subtitle: "A Complete Guide to Using the Book Template System"
author: "Your Name"
publisher: "Publisher Name"
year: "2025"
language: "en"

# File naming
file_prefix: "write-and-publish"

# Output formats
outputs:
  pdf: true
  epub: true
  mobi: true
  html: true

# Languages to build
languages:
  - "en"
  # - "es"
```

### book-tools (target)
```yaml
title: "Untitled Book"
subtitle: ""
author: "Unknown Author"
filePrefix: "book"
languages: ["en"]

# Format configuration not yet available
```

## Feature Gap Priorities

Based on the audit, here are the features that need to be implemented in `book-tools` before migration can proceed:

### High Priority
1. **Extended Configuration Support** - Implement full support for PDF, EPUB, and HTML settings
2. **Error Handling Improvements** - Add missing image resilience and build process recovery
3. **GitHub Actions Integration** - Create explicit support for CI/CD workflows

### Medium Priority
1. **Directory Structure Compatibility** - Ensure consistent directory organization
2. **Configuration Format Alignment** - Standardize configuration between repositories

### Low Priority
1. **Documentation Improvements** - Add comprehensive documentation for the new approach

## Implementation Plan

1. Create issues in the `book-tools` repository for each missing feature
2. Implement high-priority features first
3. Add tests to verify feature parity
4. Create a migration guide
5. Implement changes in `book-template`

## Testing Strategy

To ensure successful migration, we'll implement:

1. **Output Comparison Testing** - Compare the output of both systems to ensure identical results
2. **Configuration Testing** - Verify all configurations are properly migrated
3. **Error Recovery Testing** - Test resilience against common errors
4. **Integration Testing** - Verify GitHub Actions workflows

This audit will guide the implementation of missing features in `book-tools` and ensure a smooth migration.
