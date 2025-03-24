# Agent-Specific FAQ: book-template Migration Project

## Project Overview

- **Task**: Migrate `iksnae/book-template` from its bespoke build system to the standardized `iksnae/book-tools` package
- **Status**: Phase 1 of migration plan (Feature Analysis and Upstream Development)
- **Last PR Merged**: PR #20 - Migration Analysis and Plan for book-tools Integration
- **Primary Documents**: `docs/FEATURE_AUDIT.md`, `docs/MIGRATION_PLAN.md`, `docs/TECHNICAL_DESIGN.md`

## Repository Structure

### iksnae/book-template (Current)
- **build.sh** - Main wrapper script calling tools/scripts/build.sh
- **book.yaml** - Configuration file for book details and build settings
- **tools/scripts/build.sh** - Core build logic 
- **docs/** - Contains migration documentation recently added

### iksnae/book-tools (Target)
- **bin/book.js** - CLI entry point
- **src/cli.js** - Command implementation
- **src/index.js** - Core functionality exports

## Current Migration Status

1. ✅ **Analysis Phase Complete**:
   - Feature comparison audit completed
   - Migration plan created
   - Technical design documented

2. 🔄 **Next Phase**: Implement missing features in book-tools
   - Create issue templates for feature implementation
   - Create issues in book-tools repository
   - Begin implementing high-priority features

## Feature Gaps to Address

### High Priority
1. **Extended Configuration Support**
   - PDF settings (paper size, margins, font)
   - EPUB settings (cover, CSS, TOC)
   - HTML settings (template, CSS, TOC)

2. **Error Handling Improvements**
   - Missing image resilience
   - Build process recovery
   - Verbose logging

3. **GitHub Actions Integration**
   - Workflow templates
   - CI/CD support

### Medium Priority
1. **Directory Structure Compatibility**
2. **Configuration Format Alignment**

## Implementation Approach

1. **Enhance book-tools first**:
   - Add extended configuration support
   - Improve error handling
   - Add GitHub Actions integration

2. **Then adapt book-template**:
   - Add book-tools dependency in package.json
   - Update build.sh as wrapper
   - Create config adapter
   - Update GitHub Actions workflow

## CLI Command Mapping

| book-template (current) | book-tools (target) |
|-------------------------|---------------------|
| `./build.sh` | `book build` |
| N/A | `book interactive` |
| N/A | `book create-chapter` |
| N/A | `book check-chapter` |
| N/A | `book info` |
| N/A | `book clean` |

## Configuration Format Differences

### Current (book-template)
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
```

### Target (book-tools)
```yaml
title: "Untitled Book"
subtitle: ""
author: "Unknown Author"
filePrefix: "book"
languages: ["en"]

# Format configuration not yet available
```

## Key Implementation Files to Create

1. **Configuration Adapter**
   - Converts between book-template and book-tools formats
   - Located in: `tools/config-adapter.js`

2. **Build Script Wrapper**
   - Updates `build.sh` to call book-tools CLI
   - Ensures backward compatibility

3. **Extended Configuration in book-tools**
   - Adds format-specific settings to `src/utils.js`

## Quick Reference FAQ

1. **Q: What repos are involved in this project?**
   - A: `iksnae/book-template` (being migrated) and `iksnae/book-tools` (target)

2. **Q: What is the current phase of the migration plan?**
   - A: Phase 1: Feature Analysis and Upstream Development

3. **Q: What files should I check first to understand the current state?**
   - A: `docs/FEATURE_AUDIT.md`, `docs/MIGRATION_PLAN.md`, `docs/TECHNICAL_DESIGN.md`

4. **Q: What are the highest priority features to implement?**
   - A: Extended configuration support, error handling improvements, GitHub Actions integration

5. **Q: What approach should be taken for implementation?**
   - A: First enhance book-tools with missing features, then adapt book-template to use book-tools

6. **Q: How to maintain compatibility during transition?**
   - A: Create wrapper scripts, support both configuration formats, keep directory structure

7. **Q: What is the structure of the book-tools CLI?**
   - A: Commands include: build, interactive, create-chapter, check-chapter, info, clean

8. **Q: How to test the implementation?**
   - A: Compare output files for equivalence, test with various configurations, verify error handling

9. **Q: What technical details should I focus on?**
   - A: Configuration adapter, wrapper scripts, error handling mechanisms
