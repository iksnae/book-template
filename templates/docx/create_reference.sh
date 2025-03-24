#!/bin/bash

# Create a reference.docx file for DOCX output templates
set -e

echo "Creating reference.docx template file..."

# Create a temporary markdown file for conversion
TEMP_MD="temp-reference.md"

cat > "$TEMP_MD" << 'EOF'
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6

This is normal paragraph text. **This is bold text**. *This is italic text*. 

> This is a block quote.

- This is a list item
- This is another list item
  - This is a nested list item
  - This is another nested list item

1. This is a numbered list item
2. This is another numbered list item
   1. This is a nested numbered list item
   2. This is another nested numbered list item

`This is inline code`

```
This is a code block
Multiple lines
```

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |
EOF

# Convert the markdown to a reference.docx
PANDOC_CMD="pandoc \"$TEMP_MD\" -o reference.docx"
echo "Running: $PANDOC_CMD"

eval "$PANDOC_CMD"

# Check if the file was created successfully
if [ -f "reference.docx" ]; then
  echo "✅ Successfully created reference.docx template"
  
  # Clean up temporary file
  rm "$TEMP_MD"
else
  echo "❌ Failed to create reference.docx template"
  exit 1
fi 