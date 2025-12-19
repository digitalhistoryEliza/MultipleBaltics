#!/bin/bash
# Image Optimization Helper Script
# This script demonstrates how to optimize images for the Multiple Baltics website
# Usage: ./optimize-images.sh [input_directory] [output_directory]

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed."
    echo "Install with: sudo apt-get install imagemagick (Ubuntu/Debian)"
    echo "Or: brew install imagemagick (macOS)"
    exit 1
fi

INPUT_DIR="${1:-./images}"
OUTPUT_DIR="${2:-./images-optimized}"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Optimizing images from $INPUT_DIR to $OUTPUT_DIR"
echo "================================================"

# Process JPG files
for img in "$INPUT_DIR"/*.jpg "$INPUT_DIR"/*.jpeg; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        echo "Processing: $filename"
        
        # Get original size
        original_size=$(du -h "$img" | cut -f1)
        
        # Optimize JPG: reduce quality to 85%, use optimal sampling, strip metadata
        convert "$img" \
            -quality 85 \
            -sampling-factor 4:2:0 \
            -strip \
            -interlace Plane \
            -resize '1920x1920>' \
            "$OUTPUT_DIR/$filename"
        
        # Get optimized size
        optimized_size=$(du -h "$OUTPUT_DIR/$filename" | cut -f1)
        
        echo "  Original: $original_size -> Optimized: $optimized_size"
    fi
done

# Process PNG files
for img in "$INPUT_DIR"/*.png; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        echo "Processing: $filename"
        
        original_size=$(du -h "$img" | cut -f1)
        
        # Optimize PNG: strip metadata, reduce colors if possible
        convert "$img" \
            -strip \
            -resize '1920x1920>' \
            "$OUTPUT_DIR/$filename"
        
        optimized_size=$(du -h "$OUTPUT_DIR/$filename" | cut -f1)
        
        echo "  Original: $original_size -> Optimized: $optimized_size"
    fi
done

echo ""
echo "Optimization complete!"
echo "Optimized images are in: $OUTPUT_DIR"
echo ""
echo "Next steps:"
echo "1. Review the optimized images for quality"
echo "2. If satisfied, backup originals and replace with optimized versions"
echo "3. Consider converting to WebP format for even better compression"
echo ""
echo "WebP conversion command:"
echo "  cwebp -q 85 input.jpg -o output.webp"
