# Claude Code Instructions - Brochure Starter Kit

## Overview

This is a template repository for generating static-ish PHP brochure websites for small/local businesses. You operate in one of two modes based on the state of `feature_list.json`.

---

## Mode Detection

On every session start:

1. Read this file (CLAUDE.md)
2. Check `feature_list.json`
   - **Empty array or file missing** → Enter INITIALIZER mode
   - **Populated with features** → Enter BUILDER mode

---

## INITIALIZER Mode

**Trigger**: `feature_list.json` is empty or missing.

**Purpose**: Conduct discovery, capture project requirements, scaffold initial structure.

### Steps

1. **Greet the user** and explain you'll ask discovery questions
2. **Load questions** from `onboarding-template.json`
3. **Conduct discovery** conversationally:
   - Ask questions in logical groups (business info, then brand, then features)
   - Allow the user to skip optional questions
   - Clarify ambiguous answers
4. **Generate outputs**:
   - `project-brief.json` - All captured answers
   - `feature_list.json` - Features to build (all `passes: false`)
5. **Scaffold src/ structure**:
   - `src/index.php` - Homepage shell
   - `src/includes/header.php` - Global header
   - `src/includes/footer.php` - Global footer
   - `src/includes/nav.php` - Navigation component
   - `src/includes/config.php` - Site configuration
   - `src/assets/css/main.css` - Main stylesheet (imports _variables.css)
6. **Run `./analyze.sh`** to verify scaffolding passes quality gates
7. **Commit**: `git commit -m "Initial project setup from discovery"`
8. **Update `claude-progress.txt`** with session summary

### feature_list.json Generation

Based on discovery answers, generate features like:

```json
{
  "features": [
    {
      "id": "homepage-hero",
      "name": "Homepage Hero Section",
      "description": "Full-width hero with headline, subhead, and CTA button",
      "passes": false
    },
    {
      "id": "contact-form",
      "name": "Contact Form",
      "description": "Form with name, email, phone, message. Postmark email delivery.",
      "passes": false
    }
  ]
}
```

---

## BUILDER Mode

**Trigger**: `feature_list.json` contains features.

**Purpose**: Incrementally build features, run quality gates, commit progress.

### Session Start Checklist

1. `pwd` - Verify working directory
2. Read `claude-progress.txt` - Understand previous session state
3. `git log --oneline -10` - Review recent commits
4. Run `./init.sh` - Start dev server
5. Verify site loads at http://localhost:8000

### Build Loop

For each session, repeat:

1. **Read `feature_list.json`**
2. **Select ONE feature** where `passes: false`
3. **Implement the feature**:
   - For complex features, delegate to sub-agent (see below)
   - Follow architectural rules (see below)
   - Use the brochure-design skill for styling guidance
4. **Run `./analyze.sh`**
5. **Handle results**:
   - **Errors IN SCOPE** (in files you just touched): Fix and re-run
   - **Errors OUT OF SCOPE** (pre-existing issues): STOP, report to user, do NOT commit
   - **All checks pass**: Continue
6. **Update `feature_list.json`**: Set `passes: true` for completed feature
7. **Commit**: `git commit -m "feat: [feature name]"`
8. **Update `claude-progress.txt`**
9. **Repeat or end session** cleanly

### Sub-Agent Delegation

For complex features (galleries, forms, interactive components):

1. Clearly scope the sub-agent task
2. Provide relevant context (design system, existing patterns)
3. Sub-agent creates component files
4. You (Builder) review, integrate, run quality gates, commit

Example delegation:
```
"Implement the testimonial carousel component.
Use Swiper.js. Follow the design system in SKILL.md.
Create: testimonials.php, testimonials.css, testimonials.js"
```

---

## Architectural Rules (Non-Negotiable)

### PHP

- Every file: `declare(strict_types=1);`
- PSR-12 coding standard
- PHPStan level 9 compliance
- Use includes for shared components (header, footer, nav)

### HTML

- Semantic HTML5: `<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<aside>`, `<footer>`
- One `<h1>` per page
- Logical heading hierarchy (no skipping levels)
- All `<img>` have `alt` attribute (decorative images: `alt=""`)
- All form inputs have associated `<label>`
- Include skip-to-content link

### CSS

- External stylesheets only - NO inline styles
- CSS custom properties for theming (from `_variables.css`)
- Mobile-first approach
- NO Bootstrap, Tailwind, or CSS frameworks
- Minimum 16px base font size
- Line height 1.5+ for body text

### JavaScript

- Vanilla JS for simple interactions
- Alpine.js for reactive components (tabs, accordions, modals)
- Approved libraries ONLY:
  - Alpine.js (~15kb) - Reactive UI
  - Swiper (~40kb) - Sliders/carousels
  - GLightbox (~12kb) - Lightbox galleries
  - AOS (~14kb) - Scroll animations (optional)
- NO jQuery
- NO React/Vue/Svelte

### Accessibility (WCAG 2.1 AA)

- Color contrast: 4.5:1 normal text, 3:1 large text
- Touch targets: minimum 44x44px
- Keyboard navigation: logical tab order, visible focus states
- Screen readers: ARIA labels where needed, landmark roles
- Motion: respect `prefers-reduced-motion`
- Font sizing: rem/em units, respect browser zoom

### Schema.org (JSON-LD)

Every site includes:
- LocalBusiness
- Organization
- WebSite

Add as needed:
- BreadcrumbList (multi-page sites)
- Service (service pages)
- FAQPage (FAQ sections)
- ContactPage (contact page)

---

## Quality Gates

All checks must pass before committing:

| Tool | Purpose | Blocks Commit |
|------|---------|---------------|
| `php -l` | PHP syntax | Yes |
| PHPStan | Static analysis (level 9) | Yes |
| PHPCS | Code style (PSR-12) | Yes |
| Stylelint | CSS linting | Yes |
| ESLint | JS linting | Yes |
| html-validate | HTML structure/a11y | Yes |
| pa11y | WCAG 2.1 AA | Yes |
| Lighthouse | Performance/SEO/a11y | Advisory only |

Run all checks: `./analyze.sh`

---

## File Structure

```
src/
├── index.php              # Homepage
├── about.php              # About page (if needed)
├── services.php           # Services page (if needed)
├── contact.php            # Contact page (if needed)
├── .htaccess              # Apache config
├── includes/
│   ├── config.php         # Site configuration
│   ├── header.php         # Global header
│   ├── footer.php         # Global footer
│   ├── nav.php            # Navigation
│   ├── schema.php         # JSON-LD output
│   └── meta.php           # OG/Twitter meta tags
└── assets/
    ├── css/
    │   ├── _variables.css # CSS custom properties
    │   └── main.css       # Main stylesheet
    ├── js/
    │   └── main.js        # Main JavaScript
    └── images/
        └── ...            # Site images
```

---

## Session Handoff

At the end of every session, update `claude-progress.txt`:

```
## Session: YYYY-MM-DD HH:MM

### Completed
- [List of completed features/tasks]

### In Progress
- [Current feature being worked on]

### Blockers
- [Any issues preventing progress]

### Next Steps
- [What the next session should focus on]
```

---

## Error Recovery

### If `analyze.sh` fails

1. Read the error output carefully
2. Identify which tool failed and why
3. If error is in YOUR code: fix it
4. If error is pre-existing: STOP and report to user
5. Re-run `./analyze.sh` after fixes

### If stuck on a feature

1. Document what you've tried in `claude-progress.txt`
2. Ask the user for clarification
3. Consider breaking the feature into smaller pieces

### If git conflict

1. Do NOT force push
2. Report conflict to user
3. Wait for user resolution

---

## Commands Reference

```bash
# Start development
./init.sh

# Run quality checks
./analyze.sh

# Auto-fix PHP style issues
vendor/bin/php-cs-fixer fix src/

# Auto-fix CSS issues
npx stylelint "src/**/*.css" --fix

# Auto-fix JS issues
npx eslint "src/**/*.js" --fix
```
