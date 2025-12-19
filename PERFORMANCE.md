# Performance Optimization Guide

This document provides recommendations and best practices for optimizing the Multiple Baltics website performance.

## Current Optimizations Applied

### JavaScript Optimizations
1. **DOM Query Caching**: Cached repeated DOM queries in `util.js` and `main.js` to avoid redundant lookups
   - Cached parent elements and attribute values in event handlers
   - Reduced multiple calls to `.parent()`, `.attr()`, and selector lookups
   - Impact: Faster event handler execution, reduced reflow/repaint

2. **Selector Performance**: Improved selector usage in main.js
   - Cached `$logo` and `$nav` selectors to avoid repeated jQuery queries
   - Benefit: Faster page initialization

## Recommended Future Optimizations

### 1. Image Optimization (High Priority)
The website contains several large unoptimized images that significantly impact page load time:

**Large Images:**
- `pic13.jpg`: 4.7 MB
- `riga2025.jpg`: 2.5 MB  
- Multiple DSC images: 1-1.6 MB each

**Recommendations:**
- Compress images to 200-300 KB for web use while maintaining visual quality
- Use modern formats like WebP with JPEG fallback
- Implement responsive images with `srcset` for different screen sizes
- Consider lazy loading for images below the fold

**Tools for Image Optimization:**
```bash
# Using ImageMagick
convert input.jpg -quality 85 -sampling-factor 4:2:0 -strip output.jpg

# Using cwebp for WebP format
cwebp -q 85 input.jpg -o output.webp

# Using squoosh-cli
npx @squoosh/cli --webp auto input.jpg
```

**Example HTML with responsive images:**
```html
<picture>
  <source type="image/webp" srcset="images/pic13-small.webp 800w, images/pic13-medium.webp 1200w, images/pic13-large.webp 1920w">
  <source type="image/jpeg" srcset="images/pic13-small.jpg 800w, images/pic13-medium.jpg 1200w, images/pic13-large.jpg 1920w">
  <img src="images/pic13.jpg" alt="Description" loading="lazy">
</picture>
```

### 2. JavaScript Minification
**Current State:**
- `util.js`: 12 KB (not minified)
- `main.js`: 1.3 KB (not minified)

**Recommendations:**
- Minify custom JavaScript files to reduce file size by ~40-60%
- Combine all custom JS into a single minified file to reduce HTTP requests

**Tools:**
```bash
# Using Terser
npm install -g terser
terser util.js main.js -o bundle.min.js -c -m

# Or using UglifyJS
npm install -g uglify-js
uglifyjs util.js main.js -o bundle.min.js -c -m
```

### 3. CSS Optimization
**Current State:**
- `main.css`: 50 KB (not minified)

**Recommendations:**
- Minify CSS to reduce file size
- Remove unused CSS rules
- Consider critical CSS inlining for above-the-fold content

**Tools:**
```bash
# Using cssnano
npm install -g cssnano-cli
cssnano main.css main.min.css

# Using clean-css
npm install -g clean-css-cli
cleancss -o main.min.css main.css
```

### 4. Resource Loading Optimizations

**Defer Non-Critical JavaScript:**
```html
<script src="assets/js/bundle.min.js" defer></script>
```

**Preload Critical Resources:**
```html
<link rel="preload" href="assets/css/main.min.css" as="style">
<link rel="preload" href="assets/js/jquery.min.js" as="script">
```

**Async Google Analytics:**
Already implemented correctly with async attribute on gtag.js

### 5. HTTP/2 and Caching
If using a web server configuration:

**Enable Gzip/Brotli Compression:**
```apache
# Apache .htaccess
<IfModule mod_deflate.c>
  AddOutputFilterByType DEFLATE text/html text/css application/javascript
</IfModule>
```

**Set Cache Headers:**
```apache
# Cache static assets for 1 year
<FilesMatch "\.(jpg|jpeg|png|gif|webp|css|js|woff|woff2)$">
  Header set Cache-Control "max-age=31536000, public"
</FilesMatch>
```

### 6. Font Loading Optimization

**Preload Font Files:**
```html
<link rel="preload" href="assets/webfonts/font.woff2" as="font" type="font/woff2" crossorigin>
```

**Use font-display:**
```css
@font-face {
  font-family: 'YourFont';
  src: url('font.woff2') format('woff2');
  font-display: swap;
}
```

## Performance Testing

Test website performance regularly using:
- [Google PageSpeed Insights](https://pagespeed.web.dev/)
- [GTmetrix](https://gtmetrix.com/)
- [WebPageTest](https://www.webpagetest.org/)
- Chrome DevTools Lighthouse

**Target Metrics:**
- First Contentful Paint (FCP): < 1.8s
- Largest Contentful Paint (LCP): < 2.5s
- Time to Interactive (TTI): < 3.8s
- Total Blocking Time (TBT): < 200ms
- Cumulative Layout Shift (CLS): < 0.1

## Implementation Priority

1. **Immediate (High Impact, Low Effort):**
   - ✅ Cache DOM queries (completed)
   - Add defer to non-critical scripts
   - Enable text compression on server

2. **Short-term (High Impact, Medium Effort):**
   - Optimize and compress images
   - Minify CSS and JavaScript
   - Implement lazy loading for images

3. **Long-term (Medium Impact, Higher Effort):**
   - Implement responsive images with srcset
   - Convert images to WebP format
   - Set up build pipeline for asset optimization

## Monitoring

Set up performance monitoring to track improvements:
- Use Google Analytics to monitor page load times
- Implement Real User Monitoring (RUM)
- Set up alerts for performance regressions

## Notes

The JavaScript optimizations implemented focus on caching DOM queries and reducing redundant operations. These provide immediate performance benefits without requiring a build process or changing the HTML structure.

For maximum performance gains, prioritize image optimization as the largest files (images) have the biggest impact on page load time.
