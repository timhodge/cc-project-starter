# Brochure Starter Kit - Master Plan

## Project Overview

A template Git repository for generating static-ish PHP brochure websites for small/local businesses. Includes an opinionated tech stack, design system, discovery workflow, quality gates, and Claude Code harness for long-running agent builds.

### Core Concepts Applied

1. **Anthropic Long-Running Agent Harness** - Initializer/Builder pattern, feature_list.json tracking, session handoffs via claude-progress.txt
2. **Claude Design Skills** - Borrowed from Anthropic's frontend-design skill and ClaudeKit's aesthetic directions
3. **Quality Gates** - PHPStan level 9, PHPCS PSR-12, Stylelint, ESLint, html-validate, pa11y, Lighthouse
4. **Sub-Agent Delegation** - Complex features dispatched to sub-agents, Builder maintains context

### Usage Pattern

```bash
# Clone template for new project
gh repo create client-site --template username/brochure-starter --clone
cd client-site

# Start Claude Code, it detects empty feature_list.json
claude "Build a website for [client description]"

# Claude runs discovery, generates feature list, builds incrementally
```

---

## Repository Structure

```
brochure-starter/
├── .claude/
│   └── skills/
│       └── brochure-design/
│           └── SKILL.md                 # Design system skill
├── CLAUDE.md                            # Master instructions for CC
├── onboarding-template.json             # Discovery questionnaire schema
├── feature_list.json                    # Empty, populated per-project
├── claude-progress.txt                  # Session handoffs (empty)
├── init.sh                              # Start dev server + deps
├── analyze.sh                           # Run all quality checks
├── composer.json                        # PHP dependencies
├── package.json                         # JS/CSS tooling
├── phpstan.neon                         # PHPStan config (level 9)
├── phpcs.xml                            # PHPCS config (PSR-12)
├── .php-cs-fixer.php                    # Auto-fixer config
├── .stylelintrc.json                    # CSS linting
├── .eslintrc.json                       # JS linting
├── .htmlvalidate.json                   # HTML validation
├── src/
│   ├── .htaccess                        # Apache security headers, clean URLs
│   ├── includes/
│   │   ├── .gitkeep
│   │   ├── schema.php.example           # JSON-LD template
│   │   └── meta.php.example             # OG/Twitter tags template
│   └── assets/
│       ├── css/
│       │   └── _variables.css           # CSS custom properties skeleton
│       ├── js/
│       │   └── .gitkeep
│       └── images/
│           └── .gitkeep
├── .gitignore
└── README.md                            # Human instructions
```

---

## Architectural Rules (Non-Negotiable)

### PHP
- All files: `declare(strict_types=1);`
- Global includes: header.php, footer.php, nav.php
- PSR-12 coding standard
- PHPStan level 9 compliance

### HTML
- Semantic HTML5 elements: `<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<aside>`, `<footer>`
- One `<h1>` per page, logical heading hierarchy
- All images have alt text (decorative: `alt=""`)
- Forms have associated labels
- Skip-to-content link

### CSS
- External stylesheets only (NO inline styles)
- CSS custom properties for theming
- Mobile-first approach
- No Bootstrap, Tailwind, or CSS frameworks
- Minimum 16px base font size
- Line height 1.5+ for body text

### JavaScript
- Vanilla JS for simple interactions
- Alpine.js for reactive components (tabs, accordions, modals)
- Approved libraries only: Swiper, GLightbox
- NO jQuery
- NO React/Vue/Svelte

### Approved Libraries

| Library | Purpose | Size | When to Use |
|---------|---------|------|-------------|
| Alpine.js | Reactive UI | ~15kb | Multiple interactive components, state, show/hide |
| Swiper | Sliders/carousels | ~40kb | When client needs slider |
| GLightbox | Lightbox galleries | ~12kb | When client needs gallery |
| AOS | Scroll animations | ~14kb | Optional, for "pop" |

---

## Baseline Standards (Every Site Gets These)

### SEO Structure

- `<title>` and `<meta name="description">` on every page
- Canonical URLs
- XML sitemap
- robots.txt
- Lazy loading images with width/height attributes

### Open Graph / Social Sharing

- `og:title`, `og:description`, `og:image`, `og:url`, `og:type`
- `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image`
- Default OG image 1200x630px
- Favicon set: favicon.ico, apple-touch-icon, manifest.json

### Accessibility (WCAG 2.1 AA)

- Color contrast: 4.5:1 normal text, 3:1 large text
- Touch targets: minimum 44x44px
- Keyboard navigation: logical tab order, visible focus states
- Screen readers: ARIA labels, landmark roles, skip link
- Motion: respects `prefers-reduced-motion`
- Font sizing: 16px minimum, rem/em units, respects zoom

### Schema.org Markup (JSON-LD)

| Type | When |
|------|------|
| LocalBusiness | Every site |
| Organization | Every site |
| WebSite | Every site |
| BreadcrumbList | Multi-page navigation |
| Service | Service pages |
| Event | Events/workshops |
| FAQPage | FAQ sections |
| ContactPage | Contact page |

### Local SEO

- NAP consistency (Name, Address, Phone)
- Geo meta tags
- Full LocalBusiness schema with geo coordinates
- Google Maps embed (lazy loaded, accessible iframe)

---

## Workflow

### Phase 1: Initialization (First Run)

1. User clones template, runs Claude with project description
2. Claude reads CLAUDE.md, sees empty feature_list.json
3. Claude enters **INITIALIZER** mode:
   - Asks discovery questions from onboarding-template.json
   - User answers (conversational)
   - Claude generates project-brief.json (captured answers)
   - Claude generates feature_list.json (all `passes: false`)
   - Claude scaffolds src/ structure (header.php, footer.php, etc.)
   - Claude runs analyze.sh to verify scaffolding
   - Claude commits: "Initial project setup from discovery"
   - Claude updates claude-progress.txt

### Phase 2: Building (Subsequent Runs)

Each session:
1. Claude reads CLAUDE.md, sees populated feature_list.json
2. Claude enters **BUILDER** mode:
   - `pwd`, read claude-progress.txt, `git log --oneline -10`
   - Run `./init.sh` (start dev server)
   - Sanity check: can site load in browser?
   - Read feature_list.json, pick ONE feature where `passes: false`
   - Implement feature (use sub-agent if complex)
   - Run `./analyze.sh`
   - **If errors IN SCOPE**: fix and re-run
   - **If errors OUT OF SCOPE**: STOP, report, do NOT commit
   - **If clean**: mark feature `passes: true`
   - Git commit with descriptive message
   - Update claude-progress.txt
   - Repeat or end session cleanly

### Sub-Agent Usage

For complex features, Builder dispatches sub-agents:

```
Builder (Opus): "Implement the image gallery component"
  → Sub-agent (Sonnet): Creates gallery.php, gallery.css, gallery.js
  → Returns to Builder
Builder: Reviews, runs analyze.sh, integrates, commits
```

Sub-agents get narrow scope. Builder maintains overall context.

---

## Quality Gates

### Tools

| Tool | Purpose | Fails Build |
|------|---------|-------------|
| php -l | PHP syntax check | Yes |
| PHPStan | Static analysis (level 9) | Yes |
| PHPCS | Code style (PSR-12) | Yes |
| PHP-CS-Fixer | Auto-fix style | No (helper) |
| Stylelint | CSS linting | Yes |
| ESLint | JS linting | Yes |
| html-validate | HTML structure/a11y | Yes |
| pa11y | Accessibility (WCAG 2.1 AA) | Yes |
| Lighthouse | SEO/a11y/perf scores | Advisory |

### analyze.sh Flow

```bash
#!/bin/bash
set -e

echo "=== PHP Syntax ==="
find src -name "*.php" -exec php -l {} \;

echo "=== PHPStan (Level 9) ==="
vendor/bin/phpstan analyse -l 9

echo "=== PHPCS (PSR-12) ==="
vendor/bin/phpcs --standard=PSR12 src/

echo "=== Stylelint ==="
npx stylelint "src/**/*.css"

echo "=== ESLint ==="
npx eslint "src/**/*.js"

echo "=== HTML Validate ==="
npx html-validate "src/**/*.php"

echo "=== Accessibility (pa11y) ==="
npx pa11y http://localhost:8000 --standard WCAG2AA

echo "=== Lighthouse ==="
npx lighthouse http://localhost:8000 \
  --only-categories=accessibility,seo,best-practices \
  --output=json --quiet

echo "=== All checks passed ==="
```

---

## Discovery Questions (onboarding-template.json)

### Business Info
- Business name
- Tagline
- Location (city, state)
- Industry/type

### Audience
- Target customer description
- Customer problems/needs

### Brand & Tone
- Tone: professional, friendly, bold, playful
- Existing brand colors (hex codes)
- Existing logo (yes/no, formats)
- Competitor examples (URLs)
- Inspiration sites (URLs)

### Local SEO
- Full business address
- Phone number
- Business hours
- Service area
- Google Business Profile URL

### Social Profiles
- Facebook, Instagram, LinkedIn, Twitter/X, YouTube

### Pages & Features
- Required pages (home, about, services, contact)
- Optional pages
- Features: contact form, testimonials, gallery, team section, blog

### Content
- Has existing copy?
- Has existing images?
- Needs AI-generated copy?
- Needs image prompts for SDXL/Flux?

### Email (Postmark)
- Postmark API key
- Sender email address
- Sender name
- Recipient email (where form submissions go)
- Recipient name

---

## Design System (SKILL.md Outline)

### Aesthetic Directions

Choose one per project:

1. **Clean Professional** - Law firms, consultants, B2B
2. **Warm & Friendly** - Local services, family businesses
3. **Modern Bold** - Tech, creative agencies
4. **Classic Elegant** - Luxury, established brands

### Anti-Patterns (NEVER)

- Inter, Roboto, Arial, Helvetica as primary
- System fonts as primary
- Purple gradients on white
- Generic "AI slop" aesthetics
- Inline CSS
- Bootstrap/Tailwind
- jQuery

### Typography System

Google Font pairings per aesthetic:

| Aesthetic | Display | Body |
|-----------|---------|------|
| Clean Professional | IBM Plex Sans | IBM Plex Sans |
| Warm & Friendly | Nunito | Open Sans |
| Modern Bold | Space Grotesk | Work Sans |
| Classic Elegant | Playfair Display | Crimson Pro |

CSS custom properties for scale:
- `--text-xs` through `--text-4xl`
- `--font-display`, `--font-body`, `--font-mono`

### Color System

CSS custom properties:
- `--color-primary`, `--color-primary-light`, `--color-primary-dark`
- `--color-secondary`
- `--color-accent`
- `--color-text`, `--color-text-muted`
- `--color-background`, `--color-surface`
- `--color-border`
- `--color-success`, `--color-warning`, `--color-error`

### Component Patterns

- Header: sticky option, logo + nav, mobile hamburger
- Footer: columns, social links, copyright
- Hero: full-width, headline + subhead + CTA
- Cards: image + title + description + link
- CTA buttons: primary, secondary, outline variants
- Forms: labeled inputs, validation states, honeypot spam protection, Postmark email delivery
- Testimonials: quote + name + role + photo
- FAQ accordion: Alpine.js powered

### Responsive Breakpoints

```css
--breakpoint-sm: 640px;
--breakpoint-md: 768px;
--breakpoint-lg: 1024px;
--breakpoint-xl: 1280px;
```

Mobile-first: base styles are mobile, then `@media (min-width: var(--breakpoint-md))` etc.

---

## Decisions (Finalized)

1. **Content Generation**: AI-generate copy during build based on discovery answers. For images: source stock photos, OR provide SDXL/Flux prompts for manual generation, OR placeholder with clear instructions as last resort.

2. **Deployment**: Include .htaccess with security headers + clean URLs.

3. **Contact Form**: Use Postmark for email delivery. Prompt for API key + sender domain during onboarding. Local JSON log for failed Postmark communication attempts.

4. **Visual Testing**: Manual browser check for now. Puppeteer MCP can be added later.

5. **Template Versioning**: Track `brochure-starter-version` in project-brief.json.

---

## Deliverables Checklist

See task_list.json for detailed breakdown with pass/fail tracking.

1. CLAUDE.md
2. .claude/skills/brochure-design/SKILL.md
3. onboarding-template.json
4. feature_list.json (empty template)
5. claude-progress.txt (empty)
6. init.sh
7. analyze.sh
8. composer.json
9. package.json
10. phpstan.neon
11. phpcs.xml
12. .php-cs-fixer.php
13. .stylelintrc.json
14. .eslintrc.json
15. .htmlvalidate.json
16. src/.htaccess
17. src/includes/schema.php.example
18. src/includes/meta.php.example
19. src/assets/css/_variables.css
20. src/includes/.gitkeep
21. src/assets/js/.gitkeep
22. src/assets/images/.gitkeep
23. .gitignore
24. README.md
