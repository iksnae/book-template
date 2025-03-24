# Migration Plan: book-template to book-tools

This document outlines the detailed plan for migrating the `book-template` repository from its current bespoke build system to the standardized `book-tools` package.

## Overview

The migration will follow a three-phase approach:

1. **Feature Analysis and Upstream Development** - Enhance book-tools to support all required features
2. **Migration Implementation** - Update book-template to use book-tools
3. **Testing, Documentation, and Release** - Ensure a smooth transition for users

## Phase 1: Feature Analysis and Upstream Development

### 1.1. Feature Audit (Days 1-3)
- ✅ Complete [Feature Audit](./FEATURE_AUDIT.md) document
- Create issue templates for feature implementation
- Establish test criteria for each feature

### 1.2. Issue Creation in book-tools (Days 3-5)
Create the following issues in the book-tools repository:

1. **Extended Configuration Support**
   - Implement PDF settings support (paper size, margins, font)
   - Implement EPUB settings support (cover, CSS, TOC)
   - Implement HTML settings support (template, CSS, TOC)

2. **Error Handling Improvements**
   - Add missing image resilience
   - Implement build process recovery mechanisms
   - Add verbose logging options

3. **GitHub Actions Integration**
   - Create workflow templates
   - Add CI/CD support
   - Document integration process

### 1.3. Upstream Feature Implementation (Days 6-19)
Implement the required features in book-tools:

1. **Week 1**
   - Extend configuration schema to support all settings
   - Improve error handling
   - Begin GitHub Actions integration

2. **Week 2**
   - Complete configuration implementation
   - Add tests for all new features
   - Prepare for release

### 1.4. book-tools Release (Day 19)
- Version bump for book-tools
- Create release with documentation
- Publish to npm

## Phase 2: Migration Implementation 

### 2.1. Dependency Setup (Days 20-22)
- Add book-tools as a dependency to book-template
- Create basic wrapper scripts
- Test basic integration

### 2.2. Build Script Migration (Days 23-28)
- Update main build.sh to use book-tools
- Create compatibility layer for existing scripts
- Test with various configurations

### 2.3. Configuration Migration (Days 29-31)
- Create configuration adapter
- Update book.yaml format
- Document differences

### 2.4. GitHub Actions Update (Days 32-35)
- Update GitHub Actions workflows
- Test CI/CD integration
- Document workflow changes

## Phase 3: Testing, Documentation, and Release

### 3.1. Comprehensive Testing (Days 36-40)
- Test all build configurations
- Test multi-language support
- Test error handling
- Compare output quality and correctness

### 3.2. Documentation Updates (Days 41-45)
- Update README.md
- Create migration guide for users
- Document new features and workflows
- Create examples

### 3.3. Release Preparation (Days 46-48)
- Final testing
- Create release notes
- Prepare for coordinated release
- Version bump

### 3.4. Release and Announcement (Day 49)
- Release new version of book-template
- Announce migration to users
- Provide support channels

## Pull Request Schedule

### book-tools Repository PRs
1. PR #1: Configuration Schema Extension
2. PR #2: Error Handling Improvements
3. PR #3: GitHub Actions Integration
4. PR #4: Documentation Updates

### book-template Repository PRs
1. PR #1: Add book-tools Dependency
2. PR #2: Build Script Migration
3. PR #3: Configuration Format Update
4. PR #4: GitHub Actions Workflow Update
5. PR #5: Documentation and Examples

## Migration Guide

The migration guide for users will include:

1. Overview of changes
2. Step-by-step migration instructions
3. Configuration format changes
4. New commands and features
5. Troubleshooting
6. FAQ

## Versioning Strategy

To ensure compatibility during and after the migration:

1. **book-tools**
   - Use semantic versioning (MAJOR.MINOR.PATCH)
   - Breaking changes will increment MAJOR version
   - New features will increment MINOR version
   - Bug fixes will increment PATCH version

2. **book-template**
   - Use semantic versioning with book-tools dependency
   - Lock to specific MINOR version of book-tools
   - Document compatibility requirements

## Rollback Plan

In case of issues during the migration:

1. Maintain backward compatibility during transition
2. Keep old build scripts as fallback
3. Document rollback procedures for users
4. Provide tool to convert between old and new configurations

## Success Criteria

The migration will be considered successful when:

1. All features from the old system are supported in the new system
2. All output formats are generated correctly
3. Build performance is equal or better
4. Error handling is improved
5. Documentation is comprehensive
6. CI/CD integration is seamless

This plan will be updated as the migration progresses, with status updates and any changes to the timeline or approach.
