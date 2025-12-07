# Brochure Starter Kit

A template repository for generating static-ish PHP brochure websites for small/local businesses. Designed to work with Claude Code for AI-assisted website development.

## Features

- **Claude Code Integration**: INITIALIZER and BUILDER modes for guided development
- **Quality Gates**: PHPStan, PHPCS, Stylelint, ESLint, html-validate, pa11y, Lighthouse
- **Design System**: Four aesthetic directions with typography and color presets
- **SEO Ready**: Schema.org JSON-LD, Open Graph, Twitter Cards, canonical URLs
- **Accessibility**: WCAG 2.1 AA compliant by default
- **Performance**: Clean URLs, compression, caching headers

## Quick Start

### 1. Create a New Project

```bash
# Clone this template for a new client project
gh repo create client-site --template username/brochure-starter --clone
cd client-site
```

### 2. Start Claude Code

```bash
claude "Build a website for [describe the business]"
```

Claude will:
1. Ask discovery questions about the business
2. Generate a project brief and feature list
3. Scaffold the initial site structure
4. Build features incrementally with quality checks

### 3. Manual Development

If developing without Claude:

```bash
# Install dependencies
composer install
npm install

# Start development server
./init.sh

# Visit http://localhost:8000

# Run quality checks
./analyze.sh
```

## Project Structure

```
brochure-starter/
├── .claude/
│   └── skills/
│       └── brochure-design/
│           └── SKILL.md           # Design system guidelines
├── CLAUDE.md                      # Claude Code instructions
├── onboarding-template.json       # Discovery questionnaire
├── feature_list.json              # Feature tracking (generated)
├── project-brief.json             # Project details (generated)
├── claude-progress.txt            # Session handoffs
├── init.sh                        # Start dev server
├── analyze.sh                     # Run quality checks
├── composer.json                  # PHP dependencies
├── package.json                   # Node.js dependencies
├── phpstan.neon                   # PHPStan config
├── phpcs.xml                      # PHPCS config
├── .php-cs-fixer.php              # PHP-CS-Fixer config
├── .stylelintrc.json              # Stylelint config
├── .eslintrc.json                 # ESLint config
├── .htmlvalidate.json             # HTML validator config
└── src/
    ├── index.php                  # Homepage (generated)
    ├── .htaccess                  # Apache security/routing
    ├── includes/
    │   ├── header.php             # Global header (generated)
    │   ├── footer.php             # Global footer (generated)
    │   ├── nav.php                # Navigation (generated)
    │   ├── config.php             # Site config (generated)
    │   ├── schema.php.example     # JSON-LD template
    │   └── meta.php.example       # Meta tags template
    └── assets/
        ├── css/
        │   ├── _variables.css     # Design tokens
        │   └── main.css           # Main stylesheet (generated)
        ├── js/
        │   └── main.js            # Main JavaScript (generated)
        └── images/
            └── ...                # Site images
```

## Requirements

- PHP 8.1+
- Composer
- Node.js 18+
- npm

## Quality Gates

All checks must pass before committing:

| Tool | Purpose |
|------|---------|
| `php -l` | PHP syntax check |
| PHPStan | Static analysis (level 9) |
| PHPCS | Code style (PSR-12) |
| Stylelint | CSS linting |
| ESLint | JavaScript linting |
| html-validate | HTML structure/a11y |
| pa11y | WCAG 2.1 AA accessibility |
| Lighthouse | Performance/SEO (advisory) |

Run all checks:

```bash
./analyze.sh
```

## Architectural Rules

### PHP
- `declare(strict_types=1);` in every file
- PSR-12 coding standard
- PHPStan level 9 compliance

### HTML
- Semantic HTML5 elements
- One `<h1>` per page
- All images have `alt` attributes
- Forms have associated labels

### CSS
- External stylesheets only (no inline styles)
- CSS custom properties for theming
- Mobile-first approach
- No CSS frameworks (Bootstrap, Tailwind)
- Minimum 16px base font size

### JavaScript
- Vanilla JS for simple interactions
- Alpine.js for reactive components
- Approved libraries: Swiper, GLightbox, AOS
- No jQuery or SPA frameworks

### Accessibility
- Color contrast: 4.5:1 (normal text), 3:1 (large text)
- Touch targets: minimum 44x44px
- Keyboard navigation support
- Screen reader compatibility
- Respects `prefers-reduced-motion`

## Design System

Four aesthetic directions available:

1. **Clean Professional** - Law firms, consultants, B2B
2. **Warm & Friendly** - Local services, family businesses
3. **Modern Bold** - Tech, creative agencies
4. **Classic Elegant** - Luxury, established brands

See `.claude/skills/brochure-design/SKILL.md` for full details.

## Contact Form

Uses [Postmark](https://postmarkapp.com) for email delivery. Configure during discovery:

1. Create a Postmark account
2. Add and verify your sender domain
3. Get your Server API Token
4. Provide credentials during onboarding

## Commands

```bash
# Development
./init.sh                              # Start dev server

# Quality checks
./analyze.sh                           # Run all checks
vendor/bin/phpstan analyse             # PHP static analysis
vendor/bin/phpcs src/                  # PHP code style
vendor/bin/php-cs-fixer fix src/       # Auto-fix PHP style

# CSS/JS
npx stylelint "src/**/*.css" --fix     # Fix CSS issues
npx eslint "src/**/*.js" --fix         # Fix JS issues
```

## License

MIT
