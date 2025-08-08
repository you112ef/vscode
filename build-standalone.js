#!/usr/bin/env node

/**
 * Standalone Cloudflare Pages Build Script for VS Code Web
 * This script creates a minimal deployment without requiring npm install
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

console.log('🚀 Starting standalone VS Code Web build for Cloudflare Pages...');

function log(message) {
  console.log(`[INFO] ${message}`);
}

function success(message) {
  console.log(`[SUCCESS] ${message}`);
}

function error(message) {
  console.log(`[ERROR] ${message}`);
}

function copyFileSafe(source, target) {
  try {
    if (fs.existsSync(source)) {
      // Ensure target directory exists
      const targetDir = path.dirname(target);
      if (!fs.existsSync(targetDir)) {
        fs.mkdirSync(targetDir, { recursive: true });
      }
      fs.copyFileSync(source, target);
      return true;
    }
    return false;
  } catch (err) {
    log(`Failed to copy ${source}: ${err.message}`);
    return false;
  }
}

try {
  // Create out-build directory
  if (!fs.existsSync('out-build')) {
    fs.mkdirSync('out-build', { recursive: true });
    success('Created out-build directory');
  } else {
    // Clean previous build
    log('Cleaning previous build...');
    fs.rmSync('out-build', { recursive: true, force: true });
    fs.mkdirSync('out-build', { recursive: true });
    success('Previous build cleaned');
  }

  // Copy essential static files
  log('Copying essential static files...');
  
  const staticFiles = [
    'index.html',
    'service-worker.js',
    'manifest.json',
    '_headers',
    '_redirects'
  ];

  let copiedFiles = 0;
  staticFiles.forEach(file => {
    if (copyFileSafe(file, path.join('out-build', file))) {
      success(`${file} copied`);
      copiedFiles++;
    } else {
      log(`${file} not found, skipping...`);
    }
  });

  if (copiedFiles === 0) {
    throw new Error('No essential files found to copy');
  }

  // Create basic robots.txt
  const robotsContent = `User-agent: *
Allow: /`;
fs.writeFileSync(path.join('out-build', 'robots.txt'), robotsContent);
success('robots.txt created');

// Create basic sitemap
const sitemapContent = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://your-domain.pages.dev/</loc>
    <lastmod>${new Date().toISOString()}</lastmod>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>
</urlset>`;
fs.writeFileSync(path.join('out-build', 'sitemap.xml'), sitemapContent);
success('sitemap.xml created');

// Create a minimal VS Code Web structure
log('Creating minimal VS Code Web structure...');

// Create vs directory structure
const vsDirs = [
  'out-build/vs',
  'out-build/vs/workbench',
  'out-build/vs/workbench/browser',
  'out-build/vs/workbench/browser/media'
];

vsDirs.forEach(dir => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
});

// Create a minimal loader.js
const loaderContent = `// Minimal VS Code Web Loader
console.log('VS Code Web Loader initialized');
window.require = { paths: { 'vs': './vs' } };`;
fs.writeFileSync(path.join('out-build', 'vs', 'loader.js'), loaderContent);
success('Created minimal loader.js');

// Create a minimal workbench main file
const workbenchContent = `// Minimal VS Code Web Workbench
console.log('VS Code Web Workbench initialized');
document.getElementById('vscode-workbench').innerHTML = '<div style="padding: 20px; text-align: center; color: #cccccc; background: #1e1e1e; height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center;"><h1 style="color: #007acc; margin-bottom: 20px;">VS Code Web</h1><p>Loading VS Code Web Editor...</p><div style="margin-top: 20px; width: 40px; height: 40px; border: 3px solid #333; border-top: 3px solid #007acc; border-radius: 50%; animation: spin 1s linear infinite;"></div><style>@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }</style></div>';`;
fs.writeFileSync(path.join('out-build', 'vs', 'workbench', 'workbench.web.main.js'), workbenchContent);
success('Created minimal workbench.web.main.js');

// Copy any existing CSS files
const cssFiles = [
  'src/vs/workbench/browser/media/style.css',
  'src/vs/workbench/browser/media/mobile-android.css',
  'src/vs/workbench/browser/media/responsive-optimized.css'
];

let cssCopied = 0;
cssFiles.forEach(cssFile => {
  if (copyFileSafe(cssFile, path.join('out-build', 'vs', 'workbench', 'browser', 'media', path.basename(cssFile)))) {
    success(`${path.basename(cssFile)} copied`);
    cssCopied++;
  }
});

// Copy any existing icon files
const iconFiles = [
  'src/vs/workbench/browser/media/code-icon.svg',
  'resources/win32/code.ico',
  'resources/linux/code.png'
];

let iconsCopied = 0;
iconFiles.forEach(iconFile => {
  if (copyFileSafe(iconFile, path.join('out-build', 'vs', 'workbench', 'browser', 'media', path.basename(iconFile)))) {
    success(`${path.basename(iconFile)} copied`);
    iconsCopied++;
  }
});

// Create a simple placeholder icon if none exists
if (iconsCopied === 0) {
  const iconContent = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#007acc">
  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
</svg>`;
  fs.writeFileSync(path.join('out-build', 'vs', 'workbench', 'browser', 'media', 'code-icon.svg'), iconContent);
  success('Created placeholder code-icon.svg');
}

// Check final build output
if (fs.existsSync('out-build')) {
  const files = fs.readdirSync('out-build');
  success(`Build completed! Found ${files.length} files in out-build/`);
  
  console.log('');
  console.log('🎉 Standalone build completed!');
  console.log('📁 Build output: out-build/');
  console.log('📱 Ready for Cloudflare Pages deployment!');
  console.log('');
  console.log('📋 Files in build output:');
  
  function listFiles(dir, prefix = '') {
    const items = fs.readdirSync(dir);
    items.forEach(item => {
      const fullPath = path.join(dir, item);
      const stat = fs.statSync(fullPath);
      if (stat.isDirectory()) {
        console.log(`${prefix}📁 ${item}/`);
        listFiles(fullPath, prefix + '  ');
      } else {
        console.log(`${prefix}📄 ${item}`);
      }
    });
  }
  
  listFiles('out-build');
  
  // Summary
  console.log('');
  console.log('📊 Build Summary:');
  console.log(`  • Static files: ${copiedFiles}/${staticFiles.length}`);
  console.log(`  • CSS files: ${cssCopied}/${cssFiles.length}`);
  console.log(`  • Icon files: ${iconsCopied}/${iconFiles.length}`);
  console.log(`  • Total files: ${files.length} in root + subdirectories`);
  
} else {
  throw new Error('No build output generated');
}

} catch (err) {
  error(`Build failed: ${err.message}`);
  console.error('Stack trace:', err.stack);
  process.exit(1);
}