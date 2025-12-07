# Brochure Design Skill

You are an expert web designer specializing in small business brochure websites. This skill provides design guidelines, component patterns, and aesthetic directions for building professional, accessible websites.

---

## Aesthetic Directions

Choose ONE direction per project based on client industry and preferences.

### 1. Clean Professional

**Best for**: Law firms, consultants, B2B services, financial advisors, medical practices

**Characteristics**:
- Generous whitespace
- Muted color palette with one accent color
- Strong typography hierarchy
- Minimal decorative elements
- Grid-based layouts

**Typography**: IBM Plex Sans / IBM Plex Sans
**Colors**: Navy, charcoal, white, with gold or blue accent

### 2. Warm & Friendly

**Best for**: Local services, family businesses, restaurants, childcare, pet services

**Characteristics**:
- Rounded corners on elements
- Warm, inviting colors
- Friendly imagery with people
- Approachable typography
- Subtle shadows for depth

**Typography**: Nunito / Open Sans
**Colors**: Warm neutrals, terracotta, sage green, soft blues

### 3. Modern Bold

**Best for**: Tech companies, creative agencies, startups, fitness, entertainment

**Characteristics**:
- High contrast
- Bold typography
- Geometric shapes
- Dynamic layouts
- Minimal but impactful color

**Typography**: Space Grotesk / Work Sans
**Colors**: Black, white, with one vibrant accent (electric blue, hot pink, lime)

### 4. Classic Elegant

**Best for**: Luxury brands, established businesses, boutiques, fine dining, real estate

**Characteristics**:
- Refined typography with serifs
- Sophisticated color palette
- Elegant spacing and proportions
- Quality imagery emphasis
- Subtle animations

**Typography**: Playfair Display / Crimson Pro
**Colors**: Deep jewel tones, cream, gold accents

---

## Typography System

### Google Font Pairings

| Aesthetic | Display Font | Body Font | Weights |
|-----------|--------------|-----------|---------|
| Clean Professional | IBM Plex Sans | IBM Plex Sans | 400, 500, 600, 700 |
| Warm & Friendly | Nunito | Open Sans | 400, 600, 700, 800 |
| Modern Bold | Space Grotesk | Work Sans | 400, 500, 600, 700 |
| Classic Elegant | Playfair Display | Crimson Pro | 400, 500, 600, 700 |

### Type Scale

Use CSS custom properties for consistent sizing:

```css
:root {
  --text-xs: 0.75rem;    /* 12px */
  --text-sm: 0.875rem;   /* 14px */
  --text-base: 1rem;     /* 16px - minimum body text */
  --text-lg: 1.125rem;   /* 18px */
  --text-xl: 1.25rem;    /* 20px */
  --text-2xl: 1.5rem;    /* 24px */
  --text-3xl: 1.875rem;  /* 30px */
  --text-4xl: 2.25rem;   /* 36px */
  --text-5xl: 3rem;      /* 48px */
  --text-6xl: 3.75rem;   /* 60px */
}
```

### Line Heights

- Headings: 1.2
- Body text: 1.6 minimum
- Small text: 1.5

### Font Loading

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DISPLAY_FONT:wght@WEIGHTS&family=BODY_FONT:wght@WEIGHTS&display=swap" rel="stylesheet">
```

---

## Color System

### CSS Custom Properties

```css
:root {
  /* Primary brand color */
  --color-primary: #2563eb;
  --color-primary-light: #3b82f6;
  --color-primary-dark: #1d4ed8;

  /* Secondary color */
  --color-secondary: #64748b;

  /* Accent for CTAs */
  --color-accent: #f59e0b;

  /* Text colors */
  --color-text: #1e293b;
  --color-text-muted: #64748b;
  --color-text-inverted: #ffffff;

  /* Background colors */
  --color-background: #ffffff;
  --color-surface: #f8fafc;
  --color-surface-elevated: #ffffff;

  /* Border */
  --color-border: #e2e8f0;

  /* Semantic colors */
  --color-success: #22c55e;
  --color-warning: #f59e0b;
  --color-error: #ef4444;

  /* Focus state */
  --color-focus: var(--color-primary);
}
```

### Contrast Requirements

- Normal text (< 18px): 4.5:1 minimum contrast ratio
- Large text (>= 18px bold or >= 24px): 3:1 minimum contrast ratio
- UI components and graphics: 3:1 minimum

Use tools like WebAIM Contrast Checker to verify.

---

## Spacing System

```css
:root {
  --space-1: 0.25rem;   /* 4px */
  --space-2: 0.5rem;    /* 8px */
  --space-3: 0.75rem;   /* 12px */
  --space-4: 1rem;      /* 16px */
  --space-5: 1.25rem;   /* 20px */
  --space-6: 1.5rem;    /* 24px */
  --space-8: 2rem;      /* 32px */
  --space-10: 2.5rem;   /* 40px */
  --space-12: 3rem;     /* 48px */
  --space-16: 4rem;     /* 64px */
  --space-20: 5rem;     /* 80px */
  --space-24: 6rem;     /* 96px */
}
```

---

## Responsive Breakpoints

```css
:root {
  --breakpoint-sm: 640px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 1024px;
  --breakpoint-xl: 1280px;
}

/* Usage - Mobile First */
.element {
  /* Mobile styles (default) */
  padding: var(--space-4);
}

@media (min-width: 768px) {
  .element {
    /* Tablet and up */
    padding: var(--space-8);
  }
}

@media (min-width: 1024px) {
  .element {
    /* Desktop and up */
    padding: var(--space-12);
  }
}
```

---

## Component Patterns

### Header

```html
<header class="site-header">
  <a href="#main-content" class="skip-link">Skip to content</a>
  <div class="header-container">
    <a href="/" class="logo">
      <img src="/assets/images/logo.svg" alt="Company Name" width="150" height="40">
    </a>
    <nav class="main-nav" aria-label="Main navigation">
      <ul class="nav-list">
        <li><a href="/">Home</a></li>
        <li><a href="/about.php">About</a></li>
        <li><a href="/services.php">Services</a></li>
        <li><a href="/contact.php">Contact</a></li>
      </ul>
    </nav>
    <button class="mobile-menu-toggle" aria-expanded="false" aria-controls="mobile-menu">
      <span class="sr-only">Menu</span>
      <span class="hamburger-icon" aria-hidden="true"></span>
    </button>
  </div>
</header>
```

### Hero Section

```html
<section class="hero">
  <div class="hero-content">
    <h1 class="hero-title">Main Headline Here</h1>
    <p class="hero-subtitle">Supporting text that elaborates on the value proposition.</p>
    <div class="hero-actions">
      <a href="/contact.php" class="btn btn-primary">Primary CTA</a>
      <a href="/services.php" class="btn btn-secondary">Secondary CTA</a>
    </div>
  </div>
</section>
```

### Card Component

```html
<article class="card">
  <img src="/assets/images/card-image.jpg" alt="Description" class="card-image" width="400" height="300" loading="lazy">
  <div class="card-content">
    <h3 class="card-title">Card Title</h3>
    <p class="card-description">Brief description of the card content.</p>
    <a href="/link" class="card-link">Learn more<span class="sr-only"> about Card Title</span></a>
  </div>
</article>
```

### Button Styles

```css
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: var(--space-3) var(--space-6);
  font-size: var(--text-base);
  font-weight: 600;
  line-height: 1.5;
  text-decoration: none;
  border-radius: 0.375rem;
  border: 2px solid transparent;
  cursor: pointer;
  transition: background-color 0.2s, border-color 0.2s, color 0.2s;
  min-height: 44px; /* Touch target */
  min-width: 44px;
}

.btn-primary {
  background-color: var(--color-primary);
  color: var(--color-text-inverted);
}

.btn-primary:hover {
  background-color: var(--color-primary-dark);
}

.btn-primary:focus {
  outline: 2px solid var(--color-focus);
  outline-offset: 2px;
}

.btn-secondary {
  background-color: transparent;
  border-color: var(--color-primary);
  color: var(--color-primary);
}

.btn-secondary:hover {
  background-color: var(--color-primary);
  color: var(--color-text-inverted);
}
```

### Form Component

```html
<form action="/submit.php" method="POST" class="contact-form">
  <!-- Honeypot for spam protection -->
  <div class="hp-field" aria-hidden="true">
    <label for="website">Website</label>
    <input type="text" name="website" id="website" tabindex="-1" autocomplete="off">
  </div>

  <div class="form-group">
    <label for="name">Name <span class="required">*</span></label>
    <input type="text" id="name" name="name" required autocomplete="name">
  </div>

  <div class="form-group">
    <label for="email">Email <span class="required">*</span></label>
    <input type="email" id="email" name="email" required autocomplete="email">
  </div>

  <div class="form-group">
    <label for="phone">Phone</label>
    <input type="tel" id="phone" name="phone" autocomplete="tel">
  </div>

  <div class="form-group">
    <label for="message">Message <span class="required">*</span></label>
    <textarea id="message" name="message" rows="5" required></textarea>
  </div>

  <button type="submit" class="btn btn-primary">Send Message</button>
</form>
```

```css
.hp-field {
  position: absolute;
  left: -9999px;
}

.form-group {
  margin-bottom: var(--space-4);
}

.form-group label {
  display: block;
  margin-bottom: var(--space-2);
  font-weight: 500;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: var(--space-3);
  font-size: var(--text-base);
  border: 1px solid var(--color-border);
  border-radius: 0.375rem;
  background-color: var(--color-background);
}

.form-group input:focus,
.form-group textarea:focus {
  outline: 2px solid var(--color-focus);
  outline-offset: 2px;
  border-color: var(--color-primary);
}

.required {
  color: var(--color-error);
}
```

### Testimonial Component

```html
<blockquote class="testimonial">
  <p class="testimonial-quote">"Quote from the customer about their experience."</p>
  <footer class="testimonial-attribution">
    <img src="/assets/images/avatar.jpg" alt="" class="testimonial-avatar" width="48" height="48">
    <div class="testimonial-info">
      <cite class="testimonial-name">Customer Name</cite>
      <span class="testimonial-role">Job Title, Company</span>
    </div>
  </footer>
</blockquote>
```

### FAQ Accordion (Alpine.js)

```html
<div class="faq-section" x-data="{ openItem: null }">
  <h2>Frequently Asked Questions</h2>

  <div class="faq-item">
    <button
      class="faq-question"
      :aria-expanded="openItem === 1"
      @click="openItem = openItem === 1 ? null : 1"
    >
      <span>Question text here?</span>
      <span class="faq-icon" aria-hidden="true" :class="{ 'rotated': openItem === 1 }">+</span>
    </button>
    <div
      class="faq-answer"
      x-show="openItem === 1"
      x-collapse
    >
      <p>Answer text here.</p>
    </div>
  </div>
</div>
```

### Footer

```html
<footer class="site-footer">
  <div class="footer-container">
    <div class="footer-info">
      <img src="/assets/images/logo.svg" alt="Company Name" width="120" height="32">
      <address class="footer-address">
        123 Main Street<br>
        City, State 12345<br>
        <a href="tel:+15551234567">(555) 123-4567</a><br>
        <a href="mailto:info@example.com">info@example.com</a>
      </address>
    </div>

    <nav class="footer-nav" aria-label="Footer navigation">
      <h3>Quick Links</h3>
      <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/about.php">About</a></li>
        <li><a href="/services.php">Services</a></li>
        <li><a href="/contact.php">Contact</a></li>
      </ul>
    </nav>

    <div class="footer-social">
      <h3>Follow Us</h3>
      <ul class="social-links">
        <li><a href="#" aria-label="Facebook"><svg>...</svg></a></li>
        <li><a href="#" aria-label="Instagram"><svg>...</svg></a></li>
        <li><a href="#" aria-label="LinkedIn"><svg>...</svg></a></li>
      </ul>
    </div>
  </div>

  <div class="footer-bottom">
    <p>&copy; <?php echo date('Y'); ?> Company Name. All rights reserved.</p>
  </div>
</footer>
```

---

## Schema.org Templates

### LocalBusiness

```php
<?php
declare(strict_types=1);

function renderLocalBusinessSchema(array $business): string
{
    $schema = [
        '@context' => 'https://schema.org',
        '@type' => 'LocalBusiness',
        'name' => $business['name'],
        'description' => $business['description'],
        'url' => $business['url'],
        'telephone' => $business['phone'],
        'email' => $business['email'],
        'address' => [
            '@type' => 'PostalAddress',
            'streetAddress' => $business['address']['street'],
            'addressLocality' => $business['address']['city'],
            'addressRegion' => $business['address']['state'],
            'postalCode' => $business['address']['zip'],
            'addressCountry' => 'US',
        ],
        'geo' => [
            '@type' => 'GeoCoordinates',
            'latitude' => $business['geo']['lat'],
            'longitude' => $business['geo']['lng'],
        ],
        'openingHoursSpecification' => $business['hours'],
    ];

    if (isset($business['logo'])) {
        $schema['logo'] = $business['logo'];
    }

    if (isset($business['image'])) {
        $schema['image'] = $business['image'];
    }

    if (isset($business['priceRange'])) {
        $schema['priceRange'] = $business['priceRange'];
    }

    return '<script type="application/ld+json">' . json_encode($schema, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT) . '</script>';
}
```

### FAQPage

```php
<?php
declare(strict_types=1);

function renderFAQSchema(array $faqs): string
{
    $mainEntity = [];

    foreach ($faqs as $faq) {
        $mainEntity[] = [
            '@type' => 'Question',
            'name' => $faq['question'],
            'acceptedAnswer' => [
                '@type' => 'Answer',
                'text' => $faq['answer'],
            ],
        ];
    }

    $schema = [
        '@context' => 'https://schema.org',
        '@type' => 'FAQPage',
        'mainEntity' => $mainEntity,
    ];

    return '<script type="application/ld+json">' . json_encode($schema, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT) . '</script>';
}
```

---

## Accessibility Checklist

Before marking any feature complete, verify:

### Keyboard Navigation
- [ ] All interactive elements reachable via Tab
- [ ] Logical tab order (visual order matches DOM order)
- [ ] Visible focus indicators on all focusable elements
- [ ] Escape closes modals/dropdowns
- [ ] Arrow keys navigate within components (menus, sliders)

### Screen Readers
- [ ] Images have appropriate alt text
- [ ] Decorative images use `alt=""`
- [ ] Form inputs have associated labels
- [ ] Buttons have accessible names
- [ ] Landmarks used appropriately (header, nav, main, footer)
- [ ] ARIA attributes used correctly (only when HTML semantics insufficient)

### Visual
- [ ] Color contrast meets WCAG AA (4.5:1 text, 3:1 large text)
- [ ] Information not conveyed by color alone
- [ ] Text resizable to 200% without loss of content
- [ ] Minimum 16px font size for body text
- [ ] Touch targets minimum 44x44px

### Motion
- [ ] Animations respect `prefers-reduced-motion`
- [ ] No content flashes more than 3 times per second
- [ ] Carousels have pause controls

### Forms
- [ ] Error messages are descriptive
- [ ] Required fields clearly indicated
- [ ] Inline validation provides immediate feedback
- [ ] Form submission feedback is announced to screen readers

---

## Anti-Patterns (NEVER DO)

### Typography
- Using Inter, Roboto, Arial, or Helvetica as primary font
- Using system fonts as primary display font
- Font sizes below 16px for body text
- Line heights below 1.5 for body text

### Colors
- Purple gradients on white backgrounds
- Low contrast text
- Information conveyed only by color
- Generic "AI slop" color schemes (purple/blue gradients everywhere)

### CSS
- Inline styles
- !important overrides (except for utility classes)
- Bootstrap, Tailwind, or other CSS frameworks
- Non-responsive designs

### JavaScript
- jQuery
- React, Vue, Svelte, or other SPA frameworks
- Unapproved libraries
- JavaScript that breaks when disabled (essential content must work)

### HTML
- Skipping heading levels (h1 → h3)
- Multiple h1 elements per page
- Missing alt attributes on images
- Form inputs without labels
- Tables for layout

### General
- Auto-playing media with sound
- Aggressive popups or modals
- Infinite scroll without pagination option
- Removing browser zoom functionality
- Text in images (except logos)

---

## Image Guidelines

### Formats
- **Photos**: WebP with JPEG fallback
- **Graphics/Icons**: SVG preferred, PNG fallback
- **Logos**: SVG preferred

### Optimization
- Compress all images (use squoosh.app or similar)
- Provide width and height attributes (prevents layout shift)
- Use lazy loading for below-fold images
- Provide responsive images with srcset for photos

### Alt Text
- Describe the content and function of the image
- Keep it concise (125 characters max)
- Don't start with "Image of" or "Picture of"
- For decorative images: `alt=""`

```html
<!-- Informative image -->
<img src="team-photo.jpg" alt="Our team of five smiling staff members in the office" width="800" height="600" loading="lazy">

<!-- Decorative image -->
<img src="decorative-line.svg" alt="" width="200" height="20" aria-hidden="true">

<!-- Linked image -->
<a href="/about.php">
  <img src="about-us.jpg" alt="Learn more about our company" width="400" height="300">
</a>
```

---

## Performance Guidelines

### Critical CSS
- Inline critical above-fold CSS
- Defer non-critical CSS loading

### Images
- Always specify dimensions
- Use lazy loading
- Serve appropriately sized images
- Use modern formats (WebP)

### Fonts
- Preconnect to Google Fonts
- Use font-display: swap
- Limit font weights loaded

### JavaScript
- Load scripts with defer or async
- Bundle and minify for production
- Only load libraries when needed

### General
- Enable gzip compression (via .htaccess)
- Set appropriate cache headers
- Minimize HTTP requests
