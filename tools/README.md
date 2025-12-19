# Performance Optimization Tools

This directory contains helper scripts and tools for optimizing the Multiple Baltics website.

## optimize-images.sh

A bash script to automatically optimize images for web use.

### Prerequisites
- ImageMagick (convert command)
  - Ubuntu/Debian: `sudo apt-get install imagemagick`
  - macOS: `brew install imagemagick`
  - Windows: Download from https://imagemagick.org/

### Usage

```bash
# Optimize all images in the images directory
./tools/optimize-images.sh

# Specify custom input and output directories
./tools/optimize-images.sh ./images ./images-optimized

# After reviewing optimized images, replace originals
# (Make sure to backup first!)
cp -r images images-backup
cp images-optimized/* images/
```

### What it does
- Compresses JPG files to 85% quality with optimal settings
- Strips metadata to reduce file size
- Resizes images to max 1920px while maintaining aspect ratio
- Preserves original files by creating optimized versions in a separate directory

### Expected Results
- JPG files: 60-80% size reduction (e.g., 4.7MB → 500-800KB)
- Maintains good visual quality suitable for web
- Faster page load times

## Future Tools

Consider adding:
- WebP conversion script
- Automated minification script for JS/CSS
- Performance testing automation
- Image lazy-loading implementation helper
