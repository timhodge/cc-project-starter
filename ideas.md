# Ideas

Speculative ideas for improving the starter kit. Not committed work - just captured thoughts.

**Archive:** Promoted, parked, and rejected ideas are moved to `ideas_archive.md` to keep this file lean.

## Quick Reference

| Status | Meaning |
|--------|---------|
| `new` | Just captured, not yet discussed |
| `exploring` | Actively thinking through |
| `promoted` | Moved to feature_list.json |
| `parked` | Good idea, not now |
| `rejected` | Decided against (keep for context) |

## Workflow

1. Capture quickly - just title + description is fine
2. Reference by ID: "let's explore IDEA-003"
3. Add notes as we discuss
4. Promote to feature_list.json when ready to commit

---

## IDEA-011: Spec-Driven Planning for Complex Projects
**Status:** new
**Added:** 2025-12-10

Evaluate spec-driven approaches for Laravel and complex website types.

### Details
These project types may benefit from structured specification before scaffolding.

**Candidates to evaluate:**
1. GitHub's spec-kit (github.com/github/spec-kit)
2. Fission AI's OpenSpec (github.com/Fission-AI/OpenSpec)

**Options if we decide to integrate:**
a) Keep separate - use externally when needed
b) Create lightweight 'spec mode' for complex projects
c) Pull useful concepts into onboarding

### Notes
- Test on a real project first to see if it adds value over freeform Claude conversation
- Originally added directly to feature_list.json, moved here since it's exploratory

---

## IDEA-012: Custom Fields Package for Laravel/Filament Projects
**Status:** new
**Added:** 2025-12-10

Include or recommend a custom fields package (like relaticle.com/custom-fields) for easy dynamic field creation in Laravel Filament projects.

### Details
Reference: https://custom-fields.relaticle.com/v2/introduction

### Notes
- Would apply to Laravel app type when using Filament admin panel
- Could be an optional onboarding question: "Will you need dynamic/user-defined custom fields?"

---

## IDEA-014: Visual Review with Puppeteer Screenshots
**Status:** new
**Added:** 2025-12-10

Use Puppeteer to capture screenshots of rendered pages, then have Claude visually review them as part of quality gates.

### Details
Static analysis (html-validate, stylelint, pa11y) catches code issues but not visual issues. Puppeteer can render the page and screenshot it at multiple breakpoints. Claude, being multimodal, can then "look" at the screenshots and flag obvious problems:
- Broken layouts
- Overlapping elements
- Unreadable text/contrast issues
- Mobile view problems
- Cut-off content

### Implementation Ideas
- Add `visual-check.sh` or integrate into `analyze.sh`
- Capture at key breakpoints: mobile (375px), tablet (768px), desktop (1200px)
- Store screenshots in `.tmp/` for Claude to review
- Could be optional quality gate (requires Node.js + Puppeteer)

### Notes
- Primarily useful for brochure-website type
- Could extend to other types with web UIs
- Playwright is an alternative to Puppeteer

---

## IDEA-015: Enhanced Laravel Starter with TALL Stack Patterns
**Status:** new
**Added:** 2025-12-10
**Updated:** 2025-12-11

Establish a clear, opinionated Laravel starter based on real-world projects (fun-bobby, bwg-ops-dash).

### The Standard Stack (TALL)

| Layer | Technology | Purpose |
|-------|------------|---------|
| **T**ailwind CSS | Styling | Mobile-first, utility classes |
| **A**lpine.js | Micro-interactions | Dropdowns, modals, toggles, keyboard shortcuts |
| **L**aravel 11 | Backend | Auth, ORM, queues, policies |
| **L**ivewire 3 | Reactive UI | Forms, tables, real-time updates without JS framework |

**Optional additions:**
- **Filament** → Admin panel / CRUD generation
- **Reverb** → Real-time WebSocket features (collaborative boards, live updates)

### Environment Setup

| Environment | Tool | Database |
|-------------|------|----------|
| **Local dev** | Laravel Herd | Match production (see below) |
| **Production** | RunCloud | SQLite or MariaDB |

**Key principle:** Dev matches prod. No environment surprises.

### Onboarding Questions

1. **Database?**
   - SQLite (simple apps, file-based, zero config)
   - MariaDB (team apps, external integrations, complex queries)
   - *Answer configures both Herd and RunCloud identically*

2. **Admin panel?**
   - Yes → Install Filament, generate admin user
   - No → Skip

3. **User-facing reactive UI?**
   - Yes → Livewire component structure, Alpine patterns
   - No → Traditional Blade templates

4. **Real-time collaboration?**
   - Yes → Reverb WebSocket setup
   - No → Skip (can add later)

5. **User roles?**
   - Admin only
   - Admin + User
   - Custom (specify roles) → generates Role enum

6. **External database connections?**
   - Yes → Multi-connection config template
   - No → Single database

### Authentication (Same for All)

All Laravel projects use the same auth pattern:
- **Laravel Breeze** for scaffolding (login, logout, password reset)
- **Role enum** on users table (`admin`, `user`, or custom)
- **Policies** for authorization (who can do what)

```php
// Same pattern whether 2 roles or 5
enum Role: string {
    case Admin = 'admin';
    case User = 'user';
    // Add more as needed
}
```

No Spatie permissions package needed. Policies handle it.

### Scaffolding to Generate

Based on onboarding answers:
- `.env.example` configured for chosen database
- `app/Enums/Role.php` with specified roles
- `app/Enums/Status.php` template (with label/icon pattern)
- Policy stubs with role checks
- Livewire directory structure (if using Livewire)
- `config/database.php` multi-connection (if needed)

### Skill File Topics

- Livewire patterns (component structure, wire:model, events, polling)
- Alpine.js patterns (x-data, x-show, x-on, keyboard shortcuts)
- Policy authorization patterns
- PHP 8.1+ enum best practices
- Tinker-first development workflow
- Mobile-first Tailwind breakpoints
- Reverb/broadcasting setup (optional section)
- Multiple database connections (optional section)
- RunCloud deployment checklist

### Informed By

- **fun-bobby**: Personal app, SQLite, Livewire UI, privacy scopes
- **bwg-ops-dash**: Team app, MariaDB, Reverb real-time, external DB integration, complex roles

---

## IDEA-016: Onboarding Existing Laravel Projects
**Status:** new
**Added:** 2025-12-11

Handle importing/inheriting existing Laravel codebases - different from new project scaffolding.

### The Problem

Existing projects come with:
- Unknown dev environment (README may not match reality)
- Unknown prod environment (where's the actual latest code?)
- Pre-chosen dependencies (Spatie permissions, JWT, etc. - we inherit them)
- Unknown testing status (tests may not exist or may not pass)
- Technical debt (code on server differs from repo)

We can't apply "new project" rules. We need discovery-first onboarding.

### Onboarding Questions for Existing Projects

**1. What's the goal?**
- Quick bug fix / minor change → minimal setup needed
- Major feature work → need working dev env
- Full maintenance takeover → need everything
- *Determines how much setup effort is worth it*

**2. Dev environment needs?**
- Just read/edit code (no local run)
- Run locally for testing
- Full database with realistic data
- *Quick fixes might not need full env*

**3. Where is production?**
- RunCloud / cPanel / other hosting
- How is it currently deployed? (git pull, rsync, CI/CD)
- Where is the actual latest code? (repo may be stale)

**4. Testing expectations?**
- No tests exist → don't block on testing initially
- Tests exist, unknown state → run them, document what fails
- Tests must pass → fix or explicitly skip broken ones
- *Don't block ourselves on inherited tech debt*

**5. Database situation?**
- What DB in prod? (MySQL/MariaDB/PostgreSQL/SQLite)
- Do we have a sanitized data dump for dev?
- Can we work with empty/seeded data?
- *Match dev to prod when possible*

**6. What do we NOT touch?**
- Core functionality that works (don't fix what ain't broke)
- Integrations we don't understand yet
- *Define the safe zone before making changes*

### Quality Gates for Existing Projects

Different from new projects - graduated approach:

**Level 0: Survival Mode**
- No quality gates
- Just make the change, test manually, deploy
- For: emergency fixes, unfamiliar codebases

**Level 1: Basic Hygiene**
- Pint for code style (autofix, non-blocking)
- Manual testing before deploy
- For: small changes, getting familiar

**Level 2: Standard**
- Pint (must pass)
- PHPStan at inherited level (don't raise it yet)
- Run existing tests (document failures, don't block)
- For: regular maintenance work

**Level 3: Full**
- All quality gates from new project template
- For: after codebase is understood and cleaned up

### Init Flow for Existing Projects

1. Clone/access the codebase
2. Answer discovery questions above
3. Document findings in `CLAUDE.project.md`:
   - Actual tech stack (what's really being used)
   - Deployment process (how code gets to prod)
   - Known issues / tech debt
   - Safe zones / danger zones
4. Set quality gate level based on goal
5. Set up dev environment IF needed for the goal
6. Proceed with work

### Informed By

- **bwg-event-hub**: Laravel 11 + Filament + JWT API, Sail in README but unclear if used, cPanel deployment config, repo behind prod

---

## IDEA-019: ow-ops-dash for Project Command and Control
**Status:** new
**Added:** 2025-12-11

Consider creating a new project ow-ops-dash for command and control of entire projects structure. Use THAT to build the cc-starter-kit as a true template that exists only to BE a template and not ALSO run itself. ow-ops could also track things like lists of known projects and personal workflows.

### Details


### Notes
- Would separate "meta tooling" from "project template"
- cc-project-starter could become a pure template with no self-management concerns
- ow-ops-dash could manage: project registry, cross-project updates, personal workflows

---

## IDEA-020: Reduce Token Burn on Large Tracking Files
**Status:** new
**Added:** 2025-12-11

Reading increasingly lengthy feature_list.json and ideas.md burns tokens on old information we don't need. Finding 1 pending task requires reading 63 complete tasks. Options: a) move to SQLite for dynamic queries, or b) archive completed items to separate files (feature_list_archive.json, ideas_archive.md).

### Details


### Notes
- SQLite would enable efficient queries without reading entire file
- Archive approach keeps JSON simple, moves historical data to markdown
- Either way, active files stay small and focused
- Relates to IDEA-019 (ow-ops-dash could own the database)

---

## IDEA-021: ClickUp Integration
**Status:** new
**Added:** 2025-12-11

Add ClickUp integration to possibly replace feature_list.json and ideas.md.

### Details


### Notes
- Would solve the JSON vs markdown archive question entirely
- ClickUp has API - could sync or just use directly
- Relates to IDEA-019 (ow-ops-dash) and IDEA-020 (token burn)

---

## IDEA-001: Template
**Status:** new
**Added:** YYYY-MM-DD

One-liner description.

### Details
More context if needed.

### Notes
- Discussion points go here

---

