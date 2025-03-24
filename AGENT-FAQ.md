# Agent-Specific FAQ: book-template Migration Project

## Project Overview

- **Task**: Migrate `iksnae/book-template` from its bespoke build system to the standardized `iksnae/book-tools` package
- **Status**: Phase 1 of migration plan (Feature Analysis and Upstream Development)
- **Last PR Merged**: PR #20 - Migration Analysis and Plan for book-tools Integration
- **Primary Documents**: `docs/FEATURE_AUDIT.md`, `docs/MIGRATION_PLAN.md`, `docs/TECHNICAL_DESIGN.md`
- **GitHub Project RFP**: Issue #18 - Migration from Bespoke Build System to book-tools Based Solution

## Agent Work Principles

### Focus Areas
1. **Prioritize Upstream Development**: Work on enhancing `book-tools` with missing features before making changes to `book-template`.
2. **Follow Established Plan**: Adhere to the phases outlined in `docs/MIGRATION_PLAN.md`.
3. **Cross-Repository Approach**: Implement features in `book-tools` that are needed for `book-template` migration.
4. **Incremental Progress**: Complete one step at a time, focusing on feature development rather than multiple PR exploration.

### Resource Optimization
1. **Avoid Redundant Repository Exploration**: Use this FAQ as primary reference instead of searching for additional issues and PRs.
2. **Reference Documentation**: Prioritize using the technical documents under `docs/` folder for implementation details.
3. **Focus on Task Completion**: Tackle one missing feature at a time until it's completely implemented.
4. **Stepwise Implementation**: Follow the phase approach rather than trying to implement the entire migration at once.

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

2. 🔄 **Next Immediate Tasks**:
   - Create issue templates for feature implementation in `book-tools`
   - Begin implementing "Extended Configuration Support" feature in `book-tools`
   - Establish test criteria for features

## Feature Gaps to Address (In Priority Order)

### 1. Extended Configuration Support
   - PDF settings (paper size, margins, font)
   - EPUB settings (cover, CSS, TOC)
   - HTML settings (template, CSS, TOC)
   - Implementation details in `docs/TECHNICAL_DESIGN.md` section 1

### 2. Error Handling Improvements
   - Missing image resilience
   - Build process recovery
   - Verbose logging
   - Implementation details in `docs/TECHNICAL_DESIGN.md` section 2

### 3. GitHub Actions Integration
   - Workflow templates
   - CI/CD support
   - Implementation details in `docs/TECHNICAL_DESIGN.md` section 3

## Implementation Approach

### Current Phase Focus (Phase 1: Feature Analysis and Upstream Development)
1. **Create issue templates for tracking feature implementation**
2. **Implement missing features in book-tools**:
   - Start with Extended Configuration Support
   - Then implement Error Handling Improvements
   - Finally add GitHub Actions Integration

### What Not To Do
1. **Don't skip to later phases** before completing current phase tasks
2. **Don't make changes to book-template** until all required features are implemented in book-tools
3. **Don't spend time exploring unrelated issues** or repository areas
4. **Don't use puppeteer for accessing GitHub repos** as specified in the instruction
5. **Don't attempt to create images or artwork** - create descriptive text files in the resource directory instead

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

## Development Workflow

1. **For each feature to implement**:
   - Reference the technical design in `docs/TECHNICAL_DESIGN.md`
   - Create a complete implementation with tests
   - Update documentation

2. **PR Creation Process**:
   - Create targeted PRs addressing one feature at a time
   - Include comprehensive tests and documentation
   - Reference the relevant section from the migration plan

3. **Testing Approach**:
   - Write unit tests for each new feature
   - Test against the requirements specified in feature audit
   - Verify compatibility with book-template's needs

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

10. **Q: Where should I implement features first?**
    - A: Always implement in book-tools first, then adapt book-template once features are available

11. **Q: How do I avoid wasting resources?**
    - A: Focus on one feature at a time, refer to documentation instead of searching repositories, follow the established plan

12. **Q: What should I do if I encounter an undocumented requirement?**
    - A: Note it in the FAQ, implement according to technical design principles, and follow up with updates

13. **Q: How to prioritize work when multiple tasks are pending?**
    - A: Follow the priority order in the Feature Gaps section of this document
