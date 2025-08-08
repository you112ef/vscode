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

  staticFiles.forEach(file => {
    if (fs.existsSync(file)) {
      fs.copyFileSync(file, path.join('out-build', file));
      success(`${file} copied`);
    } else {
      log(`${file} not found, skipping...`);
    }
  });

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
document.getElementById('vscode-workbench').innerHTML = '<div style="padding: 20px; text-align: center;"><h1>VS Code Web</h1><p>Loading...</p></div>';`;
fs.writeFileSync(path.join('out-build', 'vs', 'workbench', 'workbench.web.main.js'), workbenchContent);
success('Created minimal workbench.web.main.js');

// Copy any existing CSS files
const cssFiles = [
  'src/vs/workbench/browser/media/style.css',
  'src/vs/workbench/browser/media/mobile-android.css',
  'src/vs/workbench/browser/media/responsive-optimized.css'
];

cssFiles.forEach(cssFile => {
  if (fs.existsSync(cssFile)) {
    const targetPath = path.join('out-build', 'vs', 'workbench', 'browser', 'media', path.basename(cssFile));
    fs.copyFileSync(cssFile, targetPath);
    success(`${path.basename(cssFile)} copied`);
  }
});

// Copy any existing icon files
const iconFiles = [
  'src/vs/workbench/browser/media/code-icon.svg',
  'resources/win32/code.ico',
  'resources/linux/code.png'
];

iconFiles.forEach(iconFile => {
  if (fs.existsSync(iconFile)) {
    const targetPath = path.join('out-build', 'vs', 'workbench', 'browser', 'media', path.basename(iconFile));
    fs.copyFileSync(iconFile, targetPath);
    success(`${path.basename(iconFile)} copied`);
  }
});

// Create a simple placeholder icon if none exists
if (!fs.existsSync(path.join('out-build', 'vs', 'workbench', 'browser', 'media', 'code-icon.svg'))) {
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
} else {
  throw new Error('No build output generated');
}

} catch (err) {
  error(`Build failed: ${err.message}`);
  process.exit(1);
}