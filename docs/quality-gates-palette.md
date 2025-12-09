# Quality Gates Palette

Reference guide for available quality gates by project type. Use this when setting up a new project to choose appropriate tools.

---

## PHP Quality Gates

### Static Analysis

| Tool | Level | When to Use | Config File |
|------|-------|-------------|-------------|
| **php -l** | Syntax | Always | None (built-in) |
| **PHPStan** | Level 6 | WordPress plugins | `phpstan.neon` |
| **PHPStan** | Level 8 | Laravel apps | `phpstan.neon` |
| **PHPStan** | Level 9/max | Brochure sites, strict projects | `phpstan.neon` |
| **PHPStan + strict-rules** | Max + extras | High-quality production code | `phpstan.neon` |

### Code Style

| Tool | Standard | When to Use | Config File |
|------|----------|-------------|-------------|
| **PHPCS** | PSR-12 | All PHP projects (default) | `phpcs.xml` |
| **PHPCS** | WordPress | WordPress plugins/themes | `phpcs.xml` |
| **PHPCS** | WordPress-Extra | WP with best practices | `phpcs.xml` |
| **PHP-CS-Fixer** | PSR-12 | Auto-fix style issues | `.php-cs-fixer.php` |
| **Laravel Pint** | Laravel | Laravel projects | `pint.json` |

### Testing

| Tool | When to Use | Config File |
|------|-------------|-------------|
| **PHPUnit** | Traditional PHP projects | `phpunit.xml` |
| **Pest** | Laravel projects, modern PHP | `phpunit.xml` + `tests/Pest.php` |

---

## JavaScript Quality Gates

| Tool | When to Use | Config File |
|------|-------------|-------------|
| **ESLint** | All JS projects | `.eslintrc.json` |
| **TypeScript** | TS projects | `tsconfig.json` |
| **Jest** | React/Node testing | `jest.config.js` |
| **Vitest** | Vue/modern projects | `vitest.config.js` |

### ESLint Globals by Framework

```json
{
  "globals": {
    "Alpine": "readonly",      // Alpine.js
    "Swiper": "readonly",      // Swiper.js
    "GLightbox": "readonly",   // GLightbox
    "AOS": "readonly",         // Animate on Scroll
    "wp": "readonly",          // WordPress
    "jQuery": "readonly"       // jQuery (if needed)
  }
}
```

---

## CSS Quality Gates

| Tool | When to Use | Config File |
|------|-------------|-------------|
| **Stylelint** | All CSS projects | `.stylelintrc.json` |
| **Stylelint + order** | Enforce property order | `.stylelintrc.json` |

### Recommended Stylelint Rules

```json
{
  "rules": {
    "max-nesting-depth": 3,
    "selector-max-id": 1,
    "selector-max-compound-selectors": 4,
    "declaration-no-important": true,
    "property-no-vendor-prefix": true
  }
}
```

---

## HTML & Accessibility

| Tool | When to Use | Config File |
|------|-------------|-------------|
| **html-validate** | PHP/HTML projects | `.htmlvalidate.json` |
| **pa11y** | WCAG 2.1 AA compliance | None (CLI flags) |
| **Lighthouse** | Performance/SEO audit | None (advisory) |

### html-validate WCAG Rules

```json
{
  "rules": {
    "wcag/h30": "error",
    "wcag/h32": "error",
    "wcag/h36": "error",
    "wcag/h37": "error",
    "wcag/h63": "error",
    "wcag/h67": "error",
    "wcag/h71": "error"
  }
}
```

---

## Composer Scripts Pattern

Add to `composer.json` for consistent quality gate entry points:

```json
{
  "scripts": {
    "lint": "php -l src/",
    "phpstan": "phpstan analyse",
    "phpcs": "phpcs",
    "phpcbf": "phpcbf",
    "test": "phpunit",
    "check": ["@phpstan", "@phpcs", "@test"]
  }
}
```

**Usage:**
- `composer check` - Run all quality gates
- `composer phpstan` - Static analysis only
- `composer phpcs` - Code style only
- `composer phpcbf` - Auto-fix style issues
- `composer test` - Run tests only

---

## npm Scripts Pattern

Add to `package.json`:

```json
{
  "scripts": {
    "lint": "npm run eslint && npm run stylelint",
    "lint:fix": "npm run eslint:fix && npm run stylelint:fix",
    "eslint": "eslint 'src/**/*.js'",
    "eslint:fix": "eslint 'src/**/*.js' --fix",
    "stylelint": "stylelint 'src/**/*.css'",
    "stylelint:fix": "stylelint 'src/**/*.css' --fix",
    "test": "jest"
  }
}
```

---

## Quality Gate Levels by Project Type

### Brochure Website (Strictest)

```
✓ php -l
✓ PHPStan Level 9
✓ PHPCS PSR-12
✓ Stylelint (strict)
✓ ESLint
✓ html-validate
✓ pa11y (WCAG 2.1 AA)
○ Lighthouse (advisory)
```

### WordPress Plugin

```
✓ php -l
✓ PHPStan Level 6-8 + WordPress extension
✓ PHPCS WordPress-Extra
✓ ESLint (if using blocks/JS)
○ PHPUnit (optional but recommended)
```

### Laravel App

```
✓ php -l
✓ PHPStan Level 8 + Larastan
✓ Laravel Pint
✓ Pest or PHPUnit
✓ ESLint (if using Inertia/Vue/React)
```

### Bespoke Project (Flexible)

```
✓ php -l (if PHP)
○ PHPStan (based on structure level)
○ PHPCS (based on structure level)
○ ESLint (if JS)
○ Tests (if long-term project)
```

---

## Security Checks (Manual)

These aren't automated tools but patterns to include:

| Check | Implementation |
|-------|----------------|
| **CSRF Protection** | Token in forms, validate on POST |
| **Honeypot Fields** | Hidden field, reject if filled |
| **Form Timing** | Record load time, reject fast submissions |
| **Rate Limiting** | IP-based, file or Redis storage |
| **Input Sanitization** | `htmlspecialchars()`, prepared statements |
| **Output Escaping** | Always escape user data in HTML |

---

## CI/CD Integration

### GitHub Actions - Lint Job

```yaml
- name: Run quality gates
  run: |
    composer install
    composer check
    npm ci
    npm run lint
```

### Pre-commit Hook (optional)

```bash
#!/bin/sh
composer phpcs
npm run lint
```

---

## Version Requirements

| Tool | Minimum Version | Notes |
|------|-----------------|-------|
| PHP | 8.1+ | For modern type hints |
| PHPStan | 1.10+ or 2.0+ | Level max support |
| PHPCS | 3.7+ | PSR-12 support |
| Node.js | 18+ | ESLint 8+ support |
| Stylelint | 15+ | Modern CSS support |
