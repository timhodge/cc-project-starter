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

