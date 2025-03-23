#!/usr/bin/env node

const { program } = require('commander');
const inquirer = require('inquirer');
const chalk = require('chalk');
const ora = require('ora');
const fs = require('fs');
const { execSync } = require('child_process');
const path = require('path');
const YAML = require('yaml');

// Helper to find the project root (where build.sh is located)
function findProjectRoot() {
  // Start from the current directory
  let currentDir = process.cwd();
  
  // Keep going up until we find build.sh or hit the root
  while (currentDir !== '/') {
    if (fs.existsSync(path.join(currentDir, 'build.sh'))) {
      return currentDir;
    }
    currentDir = path.dirname(currentDir);
  }
  
  // If we reach here, we didn't find the project root
  console.error(chalk.red('Error: Could not find project root (build.sh file)'));
  console.error(chalk.yellow('Make sure you\'re running this command within a book-template project.'));
  process.exit(1);
}

// Run a command in the project root
function runCommand(command, silent = false) {
  const projectRoot = findProjectRoot();
  
  try {
    const output = execSync(command, { 
      cwd: projectRoot,
      stdio: silent ? 'pipe' : 'inherit'
    });
    
    return silent ? output.toString() : '';
  } catch (error) {
    if (silent) {
      return null;
    } else {
      console.error(chalk.red(`Error executing command: ${command}`));
      console.error(error.toString());
      process.exit(1);
    }
  }
}

// Load the book.yaml config
function loadConfig() {
  const projectRoot = findProjectRoot();
  const configPath = path.join(projectRoot, 'book.yaml');
  
  try {
    if (fs.existsSync(configPath)) {
      const yamlContent = fs.readFileSync(configPath, 'utf8');
      return YAML.parse(yamlContent);
    } else {
      console.warn(chalk.yellow('Warning: book.yaml not found, using default configuration.'));
      return {
        title: "My Book",
        subtitle: "A Book Built with the Template System",
        author: "Author Name",
        file_prefix: "my-book",
        languages: ["en"]
      };
    }
  } catch (error) {
    console.error(chalk.red('Error parsing book.yaml:'), error.message);
    process.exit(1);
  }
}

// Set up the CLI
program
  .name('book')
  .description('CLI tool for the book template system')
  .version('1.0.0');

// Build command
program
  .command('build')
  .description('Build the book in specified formats')
  .option('--all-languages', 'Build all configured languages')
  .option('--lang <language>', 'Build specific language')
  .option('--skip-pdf', 'Skip PDF generation')
  .option('--skip-epub', 'Skip EPUB generation')
  .option('--skip-mobi', 'Skip MOBI generation')
  .option('--skip-html', 'Skip HTML generation')
  .action((options) => {
    console.log(chalk.blue('📚 Building book...'));
    
    let command = './build.sh';
    
    if (options.allLanguages) {
      command += ' --all-languages';
    }
    
    if (options.lang) {
      command += ` --lang=${options.lang}`;
    }
    
    if (options.skipPdf) {
      command += ' --skip-pdf';
    }
    
    if (options.skipEpub) {
      command += ' --skip-epub';
    }
    
    if (options.skipMobi) {
      command += ' --skip-mobi';
    }
    
    if (options.skipHtml) {
      command += ' --skip-html';
    }
    
    const spinner = ora('Building book...').start();
    runCommand(command);
    spinner.succeed(chalk.green('Book built successfully!'));
  });

// Interactive build command
program
  .command('interactive')
  .description('Build the book with interactive prompts')
  .action(async () => {
    console.log(chalk.blue('📚 Interactive Book Builder'));
    
    const config = loadConfig();
    console.log(chalk.cyan(`Book Title: ${config.title}`));
    console.log(chalk.cyan(`Author: ${config.author}`));
    
    // Get the languages
    const languages = config.languages || ['en'];
    
    // Prompt the user for options
    const answers = await inquirer.prompt([
      {
        type: 'list',
        name: 'language',
        message: 'Which language would you like to build?',
        choices: [
          { name: 'All languages', value: 'all' },
          ...languages.map(lang => ({ name: lang, value: lang }))
        ],
        default: 'en'
      },
      {
        type: 'checkbox',
        name: 'formats',
        message: 'Which formats would you like to build?',
        choices: [
          { name: 'PDF', value: 'pdf', checked: true },
          { name: 'EPUB', value: 'epub', checked: true },
          { name: 'MOBI', value: 'mobi', checked: true },
          { name: 'HTML', value: 'html', checked: true }
        ]
      }
    ]);
    
    // Build the command
    let command = './build.sh';
    
    if (answers.language === 'all') {
      command += ' --all-languages';
    } else if (answers.language !== 'en') {
      command += ` --lang=${answers.language}`;
    }
    
    // Add skip flags for formats not selected
    const allFormats = ['pdf', 'epub', 'mobi', 'html'];
    for (const format of allFormats) {
      if (!answers.formats.includes(format)) {
        command += ` --skip-${format}`;
      }
    }
    
    console.log(chalk.yellow(`Running command: ${command}`));
    const spinner = ora('Building book...').start();
    
    try {
      runCommand(command);
      spinner.succeed(chalk.green('Book built successfully!'));
    } catch (error) {
      spinner.fail(chalk.red('Build failed'));
      console.error(error);
    }
  });

// New command to create a chapter
program
  .command('create-chapter')
  .description('Create a new chapter directory structure')
  .option('-n, --number <number>', 'Chapter number (e.g., 04)')
  .option('-t, --title <title>', 'Chapter title')
  .option('-l, --lang <language>', 'Language code', 'en')
  .action(async (options) => {
    console.log(chalk.blue('📚 Creating New Chapter'));
    
    // If number or title not provided, prompt for them
    const answers = await inquirer.prompt([
      {
        type: 'input',
        name: 'number',
        message: 'Chapter number (e.g., 04):',
        default: options.number || '',
        validate: input => /^\d{2}$/.test(input) ? true : 'Please enter a two-digit number (e.g., 04)'
      },
      {
        type: 'input',
        name: 'title',
        message: 'Chapter title:',
        default: options.title || '',
        validate: input => input.trim() ? true : 'Please enter a chapter title'
      },
      {
        type: 'input',
        name: 'lang',
        message: 'Language code:',
        default: options.lang || 'en'
      }
    ]);
    
    const chapterNumber = answers.number;
    const chapterTitle = answers.title;
    const language = answers.lang;
    
    // Format the chapter folder name
    const chapterFolder = `chapter-${chapterNumber}`;
    
    // Create the full path
    const projectRoot = findProjectRoot();
    const chapterPath = path.join(projectRoot, 'book', language, chapterFolder);
    const imagesPath = path.join(chapterPath, 'images');
    
    // Create the chapter directory structure
    const spinner = ora('Creating chapter structure...').start();
    
    try {
      // Create chapter directory if it doesn't exist
      if (!fs.existsSync(chapterPath)) {
        fs.mkdirSync(chapterPath, { recursive: true });
      }
      
      // Create images directory if it doesn't exist
      if (!fs.existsSync(imagesPath)) {
        fs.mkdirSync(imagesPath);
      }
      
      // Create the introduction file
      const introContent = `# ${chapterTitle}\n\nThis is the introduction to your chapter.\n`;
      fs.writeFileSync(path.join(chapterPath, '00-introduction.md'), introContent);
      
      // Create a sample section file
      const sectionContent = `## First Section\n\nThis is the first section of your chapter.\n`;
      fs.writeFileSync(path.join(chapterPath, '01-section.md'), sectionContent);
      
      // Create a README in the images folder
      const readmeContent = `# Images for Chapter ${chapterNumber}: ${chapterTitle}\n\nPlace chapter-specific images in this directory.\n`;
      fs.writeFileSync(path.join(imagesPath, 'README.md'), readmeContent);
      
      spinner.succeed(chalk.green(`Chapter ${chapterNumber}: "${chapterTitle}" created successfully at ${chapterPath}`));
      console.log(chalk.cyan('\nCreated files:'));
      console.log(`  - ${chapterPath}/00-introduction.md`);
      console.log(`  - ${chapterPath}/01-section.md`);
      console.log(`  - ${chapterPath}/images/README.md`);
      
    } catch (error) {
      spinner.fail(chalk.red('Failed to create chapter structure'));
      console.error(error);
    }
  });

// Check-chapter command
program
  .command('check-chapter')
  .description('Check the structure of a specific chapter')
  .option('-n, --number <number>', 'Chapter number (e.g., 04)', '')
  .option('-l, --lang <language>', 'Language code', 'en')
  .action((options) => {
    console.log(chalk.blue('📚 Checking Chapter Structure'));
    
    // Get the chapter number and language
    const chapterNumber = options.number;
    const language = options.lang;
    
    // Format the chapter folder name
    const chapterFolder = chapterNumber ? `chapter-${chapterNumber}` : '';
    
    // Create the full path
    const projectRoot = findProjectRoot();
    const langPath = path.join(projectRoot, 'book', language);
    
    // Check if the language directory exists
    if (!fs.existsSync(langPath)) {
      console.error(chalk.red(`Language directory not found: ${langPath}`));
      process.exit(1);
    }
    
    // If no specific chapter was provided, list all chapters
    if (!chapterNumber) {
      console.log(chalk.cyan(`\nAvailable chapters in ${language}:`));
      
      // List all chapter directories
      const items = fs.readdirSync(langPath);
      const chapters = items.filter(item => {
        const itemPath = path.join(langPath, item);
        return fs.statSync(itemPath).isDirectory() && item.startsWith('chapter-');
      });
      
      if (chapters.length === 0) {
        console.log(chalk.yellow('No chapters found.'));
      } else {
        chapters.forEach(chapter => {
          const chapterPath = path.join(langPath, chapter);
          const files = fs.readdirSync(chapterPath);
          const sectionCount = files.filter(file => file.endsWith('.md')).length;
          
          console.log(chalk.green(`  ${chapter}: ${sectionCount} section(s)`));
        });
      }
      
      return;
    }
    
    // Check a specific chapter
    const chapterPath = path.join(langPath, chapterFolder);
    
    if (!fs.existsSync(chapterPath)) {
      console.error(chalk.red(`Chapter directory not found: ${chapterPath}`));
      process.exit(1);
    }
    
    console.log(chalk.cyan(`\nStructure of ${chapterFolder} in ${language}:`));
    
    // List all files in the chapter directory
    const items = fs.readdirSync(chapterPath);
    
    // Check for required files and directories
    const hasIntro = items.some(item => item === '00-introduction.md');
    const hasSection = items.some(item => /^\d+-section\.md$/.test(item) || /^\d+-[a-z0-9-]+\.md$/.test(item));
    const hasImagesDir = items.some(item => item === 'images' && fs.statSync(path.join(chapterPath, item)).isDirectory());
    
    // Display the structure
    const markFiles = (exists) => exists ? chalk.green('✅') : chalk.red('❌');
    
    console.log(`${markFiles(hasIntro)} Introduction file (00-introduction.md)`);
    console.log(`${markFiles(hasSection)} Section file(s)`);
    console.log(`${markFiles(hasImagesDir)} Images directory`);
    
    // List all markdown files
    console.log(chalk.cyan('\nMarkdown files:'));
    items.filter(item => item.endsWith('.md')).forEach(file => {
      // Read the first line of the file to get the title
      const filePath = path.join(chapterPath, file);
      const firstLine = fs.readFileSync(filePath, 'utf8').split('\n')[0].trim();
      const title = firstLine.startsWith('#') ? firstLine.replace(/^#+\s*/, '') : 'Untitled';
      
      console.log(`  ${file}: ${title}`);
    });
    
    // Check images directory if it exists
    if (hasImagesDir) {
      const imagesPath = path.join(chapterPath, 'images');
      const imageFiles = fs.readdirSync(imagesPath);
      
      console.log(chalk.cyan('\nImages:'));
      if (imageFiles.length === 0) {
        console.log(chalk.yellow('  No images found.'));
      } else {
        imageFiles.forEach(file => {
          const filePath = path.join(imagesPath, file);
          const stats = fs.statSync(filePath);
          const fileSizeMB = (stats.size / (1024 * 1024)).toFixed(2);
          
          console.log(`  ${file} (${fileSizeMB} MB)`);
        });
      }
    }
  });

// Info command to show book details
program
  .command('info')
  .description('Display information about the current book')
  .action(() => {
    const config = loadConfig();
    
    console.log(chalk.blue('📚 Book Information'));
    console.log(chalk.cyan(`Title: ${config.title || 'Not set'}`));
    console.log(chalk.cyan(`Subtitle: ${config.subtitle || 'Not set'}`));
    console.log(chalk.cyan(`Author: ${config.author || 'Not set'}`));
    console.log(chalk.cyan(`File Prefix: ${config.file_prefix || 'Not set'}`));
    console.log(chalk.cyan(`Languages: ${(config.languages || ['en']).join(', ')}`));
    
    // Show output formats
    console.log(chalk.cyan(`Output Formats:`));
    console.log(`  PDF: ${config.pdf === false ? 'Disabled' : 'Enabled'}`);
    console.log(`  EPUB: ${config.epub === false ? 'Disabled' : 'Enabled'}`);
    console.log(`  MOBI: ${config.mobi === false ? 'Disabled' : 'Enabled'}`);
    console.log(`  HTML: ${config.html === false ? 'Disabled' : 'Enabled'}`);
    
    // Check if build directory exists and show built files
    const projectRoot = findProjectRoot();
    const buildDir = path.join(projectRoot, 'build');
    
    if (fs.existsSync(buildDir)) {
      const files = fs.readdirSync(buildDir)
        .filter(file => !fs.statSync(path.join(buildDir, file)).isDirectory());
      
      if (files.length > 0) {
        console.log(chalk.cyan('\nBuilt Files:'));
        files.forEach(file => {
          const stats = fs.statSync(path.join(buildDir, file));
          const fileSizeMB = (stats.size / (1024 * 1024)).toFixed(2);
          console.log(`  ${file} (${fileSizeMB} MB)`);
        });
      } else {
        console.log(chalk.yellow('\nNo built files found.'));
      }
    } else {
      console.log(chalk.yellow('\nBuild directory does not exist yet.'));
    }
  });

// Clean command
program
  .command('clean')
  .description('Clean build artifacts')
  .action(() => {
    const spinner = ora('Cleaning build artifacts...').start();
    
    try {
      const projectRoot = findProjectRoot();
      const buildDir = path.join(projectRoot, 'build');
      
      if (fs.existsSync(buildDir)) {
        // Delete all files in the build directory
        const files = fs.readdirSync(buildDir);
        for (const file of files) {
          const filePath = path.join(buildDir, file);
          try {
            if (fs.statSync(filePath).isDirectory()) {
              // Use recursive deletion for directories
              fs.rmSync(filePath, { recursive: true, force: true });
            } else {
              // Simple delete for files
              fs.unlinkSync(filePath);
            }
          } catch (err) {
            spinner.warn(chalk.yellow(`Could not delete ${file}: ${err.message}`));
          }
        }
        spinner.succeed(chalk.green('Build artifacts cleaned successfully'));
      } else {
        spinner.info(chalk.yellow('No build directory found'));
      }
    } catch (error) {
      spinner.fail(chalk.red('Failed to clean build artifacts'));
      console.error(error);
    }
  });

program.parse(process.argv);

// If no command is provided, show help
if (!process.argv.slice(2).length) {
  program.outputHelp();
} 