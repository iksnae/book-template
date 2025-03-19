![](./art/image.jpg)

# DIY Book Starter Kit

Create and publish your own professional-looking books with this easy-to-use starter kit. Simply write in plain Markdown text, and automatically generate beautiful books in multiple formats ready for distribution.

## Why Use This Starter Kit?

- **Simple Writing Experience**: Write in Markdown - if you can create a text document, you can create a book
- **Multiple Book Formats**: Automatically generate PDF, e-readers (EPUB, MOBI), and web versions
- **No Technical Knowledge Required**: Everything is set up and ready to use
- **Support for Multiple Languages**: Create books in any language
- **Free and Open Source**: No expensive publishing tools needed

## Getting Started in 3 Easy Steps

1. Click the green **Use this template** button at the top of this page
2. Name your new book project and create it
3. Start writing in the provided chapter templates

Need a quick guide? Check out [QUICK-START.md](./QUICK-START.md) for step-by-step instructions.

## What's Included

This starter kit gives you everything you need to create a professional book:

- Ready-to-use chapter structure
- Professional formatting for all book formats
- Automatic table of contents generation
- Cover page setup
- Publishing to multiple formats with a single command
- Cloud-based build system - no installations required

## How It Works

1. **Set Up Your Book**: Fill in your book details in the simple `book.yaml` file
2. **Write Your Content**: Add your text to the Markdown files in the chapter folders
3. **Publish Changes**: Push your changes to GitHub to trigger the automated build
4. **Get Your Books**: Download beautifully formatted PDF, EPUB, MOBI, and HTML files

## Writing Your Book

Your book content goes in the `book/en/` folder (or other language folders):

- Each chapter has its own folder (`chapter-01`, `chapter-02`, etc.)
- Add your chapter introduction in the `00-introduction.md` file
- Add sections to your chapter in numbered files (`01-section.md`, `02-section.md`, etc.)
- Place images in the `images/` folder within each chapter

## Building Your Book

The process is fully automated:

1. Push your changes to GitHub
2. GitHub Actions will automatically build all formats
3. Download the finished books from the releases page

No local setup or technical knowledge required - everything happens in the cloud!

## Customizing Your Book

### Basic Settings

Edit `book.yaml` to change:

- Book title and subtitle
- Author name
- Publisher
- Output formats
- Page size and margins

### Advanced Customization

Want to change the look and feel? Edit the templates:

- `templates/pdf/` - Control how the PDF version looks
- `templates/epub/` - Style the e-reader versions
- `templates/html/` - Customize the web version

## Ready-To-Use Solution

Everything is already set up - all dependencies and tools are publicly available:

- All building happens through GitHub's automation system
- Pre-configured workflows handle all technical details
- No need to install any specialized software on your computer

## License

This starter kit is open source and available under the MIT License.

## Credits

Developed in partnership with [Khaos Studio](http://khaos.studio).
