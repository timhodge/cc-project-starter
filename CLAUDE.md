# Claude Code Instructions - Universal Project Starter

## Overview

This is a universal project starter kit that supports multiple project types. It guides you through onboarding, scaffolds the appropriate structure, and provides type-specific quality gates and workflows.

**Supported Project Types:**
- WordPress Plugin
- Laravel App
- Brochure Website (static-ish PHP)
- Complex Website (multi-stack)
- Bespoke Side Project

**Getting Started:** When a user opens this project and says "read CLAUDE.md and let's go", begin the onboarding process.

---

## Mode Detection

On every session start:

1. Read this file (CLAUDE.md)
2. Check for `project-config.json`:
   - **Missing** → Enter INITIALIZER mode
   - **Exists** → Check `feature_list.json`:
     - **Empty or missing** → Continue INITIALIZER (scaffolding phase)
     - **Populated with features** → Enter BUILDER mode

---

## INITIALIZER Mode

**Trigger**: `project-config.json` is missing or incomplete.

**Purpose**: Conduct discovery, determine project type, scaffold appropriate structure.

### Phase 1: Initial Discovery

1. **Greet the user** and explain you'll ask some questions to set up their project
2. **Load questions** from `onboarding/initial-onboarding.json`
3. **Conduct discovery** conversationally:
   - Start with project type selection
   - Ask common questions (name, description, deployment target)
   - Allow the user to skip optional questions

### Phase 2: Type-Specific Discovery

4. Based on the selected project type, load the appropriate onboarding file:
   - `onboarding/wordpress-plugin.json`
   - `onboarding/laravel-app.json`
   - `onboarding/brochure-website.json`
   - `onboarding/complex-website.json`
   - `onboarding/bespoke-project.json`

5. **Continue discovery** with type-specific questions

### Phase 3: Explain Tooling Choices

6. **Present the quality gates selection** - Before setting up, explain what tools will be used.

   Reference `docs/quality-gates-palette.md` for the full tool catalog by project type.

   **You MUST tell the user:**
   - **What we ARE using** and why (e.g., "PHPStan at level 8 because WordPress plugins need some flexibility for hooks")
   - **What we are NOT using** and why (e.g., "Skipping pa11y because WordPress themes handle frontend accessibility")

   **Format your explanation like this:**
   ```
   Based on [project type], here's the quality gate setup:

   ✅ USING:
   - [Tool]: [Why it's appropriate for this project]
   - [Tool]: [Why it's appropriate for this project]

   ❌ NOT USING:
   - [Tool]: [Why it's excluded for this project type]
   - [Tool]: [Why it doesn't apply]

   Does this look right, or would you like to adjust anything?
   ```

   **Wait for user confirmation** before proceeding. They may want to add/remove tools.

### Phase 4: Setup

7. **Generate outputs**:
   - `project-config.json` - Project type and configuration
   - `project-brief.json` - All captured answers
   - `feature_list.json` - Features to build (all `passes: false`)
   - Copy `lessons-learned.json` template for this project

7. **Copy type-specific scaffolding** from `project-types/{type}/scaffolding/`

8. **Copy type-specific configs** from `project-types/{type}/config/` to project root

9. **Run `./analyze.sh`** to verify scaffolding passes quality gates

10. **Setup GitHub Actions** if requested:
    - Copy appropriate templates from `templates/github-actions/`
    - Customize based on deployment target

11. **Commit**: `git commit -m "Initial project setup: {project_type}"`

12. **Update `claude-progress.txt`** with session summary

### project-config.json Format

```json
{
  "project_type": "brochure-website",
  "project_name": "My Project",
  "project_slug": "my-project",
  "created_at": "2025-12-09",
  "starter_version": "2.0.0",
  "scripts": {
    "init": "project-types/brochure-website/init.sh",
    "analyze": "project-types/brochure-website/analyze.sh"
  },
  "deployment": {
    "target": "runcloud",
    "github_actions": true
  }
}
```

---

## BUILDER Mode

**Trigger**: `project-config.json` exists AND `feature_list.json` has features.

**Purpose**: Incrementally build features, run quality gates, commit progress.

### Session Start Checklist

1. `pwd` - Verify working directory
2. Read `project-config.json` - Know project type and configuration
3. Read `claude-progress.txt` - Understand previous session state
4. `git log --oneline -10` - Review recent commits
5. Run `./init.sh` - Start dev environment (delegates to type-specific script)
6. Verify environment is running

### Build Loop

For each session, repeat:

1. **Read `feature_list.json`**
2. **Select ONE feature** where `passes: false`
3. **Implement the feature**:
   - For complex features, delegate to sub-agent
   - Follow type-specific architectural rules
   - Reference type-specific skill files in `.claude/skills/`
4. **Run `./analyze.sh`** (delegates to type-specific quality gates)
5. **Handle results**:
   - **Errors IN SCOPE** (in files you just touched): Fix and re-run
   - **Errors OUT OF SCOPE** (pre-existing issues): STOP, report to user, do NOT commit
   - **All checks pass**: Continue
6. **Update `feature_list.json`**: Set `passes: true` for completed feature
7. **Commit**: `git commit -m "feat: [feature name]"`
8. **Update `claude-progress.txt`**
9. **Check for lessons learned** (see below)
10. **Repeat or end session** cleanly

### Sub-Agent Delegation

For complex features:

1. Clearly scope the sub-agent task
2. Provide relevant context (patterns, existing code)
3. Sub-agent creates component files
4. You (Builder) review, integrate, run quality gates, commit

---

## Lessons Learned

During development, capture improvements for the starter kit in `lessons-learned.json`:

**When to add an entry:**
- You discover a missing onboarding question
- A quality gate rule would have caught an issue earlier
- A common pattern should be in the scaffolding
- A useful GitHub Action template would help future projects
- Documentation was unclear or missing

**Format:**
```json
{
  "id": "lesson-001",
  "category": "quality-gates",
  "title": "Short description",
  "description": "What was discovered",
  "suggested_change": "What to do in cc-project-starter",
  "files_affected": ["path/to/file"],
  "priority": "high|medium|low",
  "addressed": false
}
```

**Categories:** onboarding, scaffolding, quality-gates, deployment, skills, documentation, architectural-rules

---

## Type-Specific Rules

Each project type has its own architectural rules and quality gates. After `project-config.json` is created, follow the rules for that type:

### Brochure Website
- See `project-types/brochure-website/` for configs
- Skill: `.claude/skills/brochure-design/SKILL.md`
- Quality gates: PHPStan (L9), PHPCS (PSR-12), Stylelint, ESLint, html-validate, pa11y

### WordPress Plugin
- See `project-types/wordpress-plugin/` for configs
- Skill: `.claude/skills/wordpress-plugin/SKILL.md` (when available)
- Quality gates: PHPCS (WordPress standard), PHPStan (L6-8)
- Follow WordPress Coding Standards
- Prefix all functions/classes with plugin slug

### Laravel App
- See `project-types/laravel-app/` for configs
- Skill: `.claude/skills/laravel/SKILL.md` (when available)
- Quality gates: PHPStan (L8), Laravel Pint, Pest/PHPUnit
- Follow Laravel conventions

### Complex Website
- Quality gates determined by frontend/backend stacks chosen
- May have separate configs for frontend and backend

### Bespoke Project
- Quality gates based on chosen language and structure level
- Minimal scaffolding for throwaway projects
- Full structure for long-term projects

---

## File Structure

```
cc-project-starter/
├── CLAUDE.md                          # This file
├── feature_list.json                  # Features to build
├── project-config.json                # Project configuration (after onboarding)
├── project-brief.json                 # Discovery answers (after onboarding)
├── lessons-learned.json               # Feedback for starter kit
├── claude-progress.txt                # Session handoff
├── init.sh                            # Delegator → type-specific init
├── analyze.sh                         # Delegator → type-specific analyze
│
├── onboarding/
│   ├── initial-onboarding.json        # Project type + common questions
│   ├── brochure-website.json
│   ├── wordpress-plugin.json
│   ├── laravel-app.json
│   ├── complex-website.json
│   └── bespoke-project.json
│
├── project-types/
│   ├── brochure-website/
│   │   ├── init.sh
│   │   ├── analyze.sh
│   │   ├── config/                    # Linter configs
│   │   └── scaffolding/               # Template files
│   ├── wordpress-plugin/
│   ├── laravel-app/
│   ├── complex-website/
│   └── bespoke-project/
│
├── templates/
│   └── github-actions/
│       ├── push-to-runcloud.yml
│       ├── create-release-zip.yml
│       ├── laravel-deploy.yml
│       ├── wordpress-plugin-release.yml
│       └── run-tests.yml
│
└── .claude/
    └── skills/
        ├── brochure-design/SKILL.md
        ├── wordpress-plugin/SKILL.md
        └── laravel/SKILL.md
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

### Lessons Learned
- [Any entries added to lessons-learned.json]
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
# Start development (delegates to type-specific)
./init.sh

# Run quality checks (delegates to type-specific)
./analyze.sh

# View project configuration
cat project-config.json

# View feature progress
cat feature_list.json
```

---

## Version

Starter Kit Version: 2.0.0
