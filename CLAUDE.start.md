# Claude Code Instructions

## Important: File Structure

- **CLAUDE.md** (this file) - Standard workflow and behavioral rules. May be updated from cc-project-starter. **Do not add project-specific information here.**
- **CLAUDE.project.md** - Your project-specific knowledge (API locations, client preferences, deployment notes, etc.). Create this file for local customizations. It will never be overwritten.

Always check for and read `CLAUDE.project.md` if it exists.

---

## Overview

This project was created from cc-project-starter. It provides type-specific quality gates, scaffolding, and workflows.

**Getting Started:** When the user opens this project and says "read CLAUDE.md and let's go", check the mode and proceed accordingly.

---

## Mode Detection

On every session start:

1. Read this file (CLAUDE.md)
2. Read `CLAUDE.project.md` if it exists
3. Check for `project-config.json`:
   - **Missing** → This file shouldn't be missing (project wasn't initialized correctly)
   - **Exists** → Check `feature_list.json`:
     - **Empty or missing** → Continue INITIALIZER (scaffolding phase)
     - **Populated with features** → Enter BUILDER mode

---

## INITIALIZER Mode

**Trigger**: `project-config.json` is missing or incomplete.

**Purpose**: Conduct discovery, determine project type, scaffold appropriate structure.

### Phase 0: Check /spec Folder

Before asking questions, check what the user has already provided:

1. **If `/spec` has content:**
   - Analyze what's there (proposals, existing code, assets, etc.)
   - Use findings to pre-fill onboarding questions
   - Ask confirming questions: "It looks like this is a BWG WordPress plugin project. Is that right?"
   - Continue through remaining discovery using spec as context

2. **If `/spec` is empty:**
   - Prompt: "Do you have a spec, proposal, or any assets you can drop in `/spec` now? I'll wait. Tell me about what you put there."
   - User can describe what they added: "Look in spec/ for a proposal and an existing plugin"
   - If user has nothing: "No problem - we'll work through discovery together."

**Important:** The `/spec` folder is user-managed. You may only read from it and copy files out to `src/`. Never modify, delete, or add files to `/spec`.

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

   **Shaping feature_list.json based on new vs existing code:**

   If `has_existing_code` is **true** (importing existing code from `/spec`):
   - Add analysis TODOs: "Analyze existing code structure", "Identify dependencies to exclude", "Review for compatibility with tooling"
   - Add migration TODOs: "Copy code from /spec to src/", "Update namespace/paths if needed"

   If `has_existing_code` is **false** (new project from scratch):
   - Add scaffolding TODOs based on project type
   - Standard feature TODOs from discovery

8. **Copy type-specific scaffolding** from `project-types/{type}/scaffolding/`

9. **Copy type-specific configs** from `project-types/{type}/config/` to project root

10. **Run `./analyze.sh`** to verify scaffolding passes quality gates
    - **If it fails, you are not done initializing.** Fix the issues before proceeding.
    - Do not move to BUILDER mode until analyze.sh passes cleanly.

11. **Setup GitHub Actions** if requested:
    - Copy appropriate templates from `templates/github-actions/`
    - Customize based on deployment target

12. **Commit**: `git commit -m "Initial project setup: {project_type}"`

13. **Update `claude-progress.txt`** with session summary

### Staying Focused During Init

**Do not get distracted.** The user may mention code they want to work on, features they're excited about, or ask "while we're here, can you just..."

**Your response:** "Let's finish initialization first - it ensures our tools are set up correctly. Once analyze.sh passes, we'll be ready to build."

Initialization must complete before building. This is a two-way accountability:
- **You** don't skip ahead, even if the user seems eager
- **User** doesn't tempt you with side tasks during init

### Handling Re-initialization Requests

If the user says "we need to run through init again" during BUILD mode:

**Do NOT:**
- Delete everything and start over (preserve src/, feature_list.json, work done)
- Just run analyze.sh, see it pass, and say "we're done!"

**DO:**
- Ask: "What specifically isn't working? What do we need to redo?"
- Understand the problem before taking action
- Surgically fix what's wrong, preserve what's right
- Walk through only the relevant init steps together

Re-initialization is a conversation, not a reset button.

### project-config.json Format

```json
{
  "project_type": "brochure-website",
  "project_name": "My Project",
  "project_slug": "my-project",
  "created_at": "2025-12-09",
  "starter_version": "2.1.0",
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

### Philosophy

A lesson learned is not just a bug to fix - it's a signal that something in our process needed attention. When processing lessons:

- **Think holistically** about the stated issue and anything related
- **Ask "what else?"** - if this was a problem, what similar problems might exist?
- **Improve the system**, not just the symptom
- We're building quality and making future work easier, not racing through a checklist

### Capturing Lessons (in derived projects)

During development, capture improvements for the starter kit in the project's `lessons-learned.json`:

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
  "addressed": false,
  "addressed_in_starter_version": null
}
```

**Categories:** onboarding, scaffolding, quality-gates, deployment, skills, documentation, architectural-rules

### Processing Lessons (in cc-project-starter)

#### Trigger
User says: "Fetch lessons from ~/projects/project-name"

#### Step 1: Import
1. Read source project's `lessons-learned.json`
2. For each lesson where `addressed: false`:
   - Check if similar lesson already exists in `feature_list.json`
   - If duplicate: note the additional source project (mark all as addressed when done)
   - If new: add to `feature_list.json` with generic ID (e.g., `lesson-brochure-schema-org`)
3. Report to user: "Found X new lessons, Y duplicates"

#### Step 2: Process (with care)
For each imported lesson:
1. **Understand the root issue** - not just the symptom described
2. **Consider related improvements** - what else might benefit from attention here?
3. **Discuss with user** and decide:
   - **Implement**: Do the work thoughtfully
   - **Skip**: Add a `"note"` field explaining why, still mark as addressed
   - **Merge**: Combine with related items
4. Proceed to Step 3

#### Step 3: Close the Loop
Before marking `passes: true` in `feature_list.json`:
1. Ask user to confirm write access to source project
2. Update source project's `lessons-learned.json`:
   - Set `"addressed": true`
   - Set `"addressed_in_starter_version"` to current version (e.g., "2.1.0")
3. Then mark `passes: true` in starter kit's `feature_list.json`

**Important:** Do NOT mark a lesson as `passes: true` until the source project's file has been updated. This prevents re-processing the same lesson.

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

## Project Structure: Workshop vs Product

This project follows a clear separation between **workshop** (tooling) and **product** (deliverable code):

```
project-root/                  ← WORKSHOP (development tooling)
├── CLAUDE.md
├── feature_list.json
├── project-config.json
├── analyze.sh
├── init.sh
├── vendor/                    ← Dev dependencies (not shipped)
├── node_modules/              ← Dev dependencies (not shipped)
│
├── spec/                      ← INPUT (user-provided materials)
│   └── ... proposals, existing code, assets
│
├── src/                       ← PRODUCT (shipping code)
│   └── ... your actual code
│
└── dist/                      ← DISTRIBUTION (packaged releases)
    └── my-project-v1.0.0.zip
```

### Folder Ownership

| Folder | User | Claude | Purpose |
|--------|------|--------|---------|
| `/spec` | read/write | **read only** | Input materials - specs, proposals, existing code |
| `/src` | read | read/write | Product code - the deliverable |
| `/dist` | read | write | Packaged releases |
| workshop root | read | read/write | Tooling, configs, CLAUDE.md |

### Key Principles

1. **All deliverable code lives in `src/`**
   - WordPress plugins: `src/` IS the plugin folder
   - Laravel apps: `src/` contains the full Laravel structure (`src/app/`, `src/routes/`, etc.)
   - Brochure sites: `src/` IS the website root

2. **`analyze.sh` only scans `src/`**
   - Workshop files are never scanned
   - This prevents template placeholders or dev tooling from causing false failures

3. **Distribution packages go in `dist/`**
   - When releasing, package `src/` contents into `dist/`
   - Example: `dist/my-plugin-v1.0.0.zip`

4. **Deployment pushes `src/` contents**
   - Deploy `src/` to your server, not the repo root
   - Workshop tooling stays in the repo, never ships

### Why This Matters

- Clean separation prevents accidental inclusion of dev files in production
- Quality gates focus only on code that actually ships
- Workshop can evolve without affecting the product
- Distribution is straightforward: package what's in `src/`

### Creating Distribution Packages

When packaging `src/` for distribution:

1. **Always create fresh archives** - Never update existing zips
   ```bash
   # Correct: remove old archive first
   rm -f dist/my-plugin-v1.0.0.zip
   zip -r dist/my-plugin-v1.0.0.zip src/

   # Wrong: zip -r updates existing archives, leaving deleted files behind
   zip -r dist/my-plugin-v1.0.0.zip src/
   ```

2. **Use `dist/` for all release artifacts**
   - Keep `dist/` in `.gitignore`
   - Create `dist/` directory if it doesn't exist

3. **Version your archives** - Include version in filename
   - `my-plugin-v1.0.0.zip` not `my-plugin.zip`

4. **Exclude dev artifacts** from the archive
   - No `.git/`, `node_modules/`, `vendor/` (unless production deps)
   - No test files, config files, or documentation meant for devs

---

## Full File Structure

```
project-root/
├── CLAUDE.md                          # This file
├── CLAUDE.project.md                  # Project-specific notes (create as needed)
├── feature_list.json                  # Features to build
├── project-config.json                # Project configuration (after onboarding)
├── project-brief.json                 # Discovery answers (after onboarding)
├── lessons-learned.json               # Feedback for starter kit
├── claude-progress.txt                # Session handoff
├── init.sh                            # Delegator → type-specific init
├── analyze.sh                         # Delegator → type-specific analyze
│
├── spec/                              # INPUT: Specs, proposals, existing code (user-managed)
│   └── ...                            # CC reads only, never modifies
│
├── src/                               # YOUR CODE (the product)
│   └── ...                            # Structure depends on project type
│
├── dist/                              # Packaged releases
│   └── ...
│
├── onboarding/                        # Setup questions (can delete after init)
├── project-types/                     # Type configs (can delete after init)
├── templates/                         # Action templates (can delete after init)
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

## Critical Behavioral Rules

These rules are **non-negotiable**. Violating them undermines the entire quality system.

### 1. Never Lower Test Standards to Pass Tests

When quality gates fail, you must **fix the code**, not weaken the quality gate.

**Forbidden actions:**
- Changing a linter rule from `error` to `warn` or `off`
- Lowering PHPStan level (e.g., from 9 to 6)
- Removing accessibility checks that flag real issues
- Adding `@phpstan-ignore` or `// phpcs:ignore` without explicit user approval
- Commenting out failing tests

**Correct response to failing quality gates:**
1. Read the error message carefully
2. Understand what violation it's flagging
3. Fix the underlying code issue
4. Re-run the quality gate

**If you believe a rule is wrong:**
1. Explain your reasoning to the user
2. Get explicit approval BEFORE making any config change
3. Document why the change was made in a comment

### 2. Feature List Immutability

The `feature_list.json` is immutable except for the `passes` field.

**You may only:**
- Set `passes: true` when a feature is **fully complete** as originally defined
- Set `passes: false` if a previously passing feature regresses

**You may NOT:**
- Edit feature names, descriptions, or requirements
- Change "Postmark integration" to "email integration"
- Mark `passes: true` with caveats like "mostly done" or "sub-items pending"
- Add new features without user approval
- Remove features without user approval

**If a feature definition seems wrong:**
1. Discuss with the user
2. Get explicit approval before modifying anything other than `passes`

### 3. Verify Quality Gates After Scaffolding

After scaffolding a new project, verify ALL quality gates work **before** building features.

**In INITIALIZER mode, after scaffolding:**
1. Run `./analyze.sh` immediately
2. Verify all tools install and run successfully
3. If tools fail to install, ask the user to install dependencies
4. Scaffolding must pass all gates before moving to BUILDER mode

**In BUILDER mode, after each feature:**
1. Run `./analyze.sh` immediately after completing a feature
2. Fix any errors before starting the next feature
3. Never accumulate technical debt across features

This prevents pattern propagation (one bad color on 5 pages = 10 errors instead of 2).

### 4. Ask User to Install Missing Tools

When a standard system tool is missing and a command fails, **ask the user to install it** rather than creating workarounds.

**Example scenario:**
- You need to create a ZIP file but `zip` isn't installed
- ❌ WRONG: Create a tar.gz file instead
- ✅ RIGHT: "Can you install zip? Run: `sudo apt install zip`"

**Common tools users can easily install:**
- `zip`, `unzip` - Archive tools
- `jq` - JSON processing
- `curl`, `wget` - HTTP clients
- `composer` - PHP dependency management
- `node`, `npm` - JavaScript runtime

Workarounds waste time and often don't fit the actual use case.

### 5. Never Add Exclusions to Silence Errors

The `analyze_exclude` list in `project-config.json` exists for legitimate exclusions (vendor dependencies, generated files, caches). **You may NOT add exclusions to make errors go away.**

**Forbidden actions:**
- Adding a directory to `analyze_exclude` because it has linting errors
- Excluding a file because PHPStan can't analyze it
- Adding exclusions without explicit user approval

**Legitimate exclusions (set during initialization):**
- `vendor` - Third-party dependencies
- `node_modules` - npm dependencies
- `.phpstan-cache` - Generated cache files

**If you believe an exclusion is needed:**
1. Explain to the user what directory and why
2. Get explicit approval BEFORE modifying `analyze_exclude`
3. Document the reason in a comment or CLAUDE.project.md

Adding an exclusion to hide errors is the same as lowering a linter rule - it undermines the quality system.

### 6. Never Modify Imported Code During Initialization

When importing existing code from `/spec`, **you lack the context** of what the code is actually meant to do. Making ANY changes during initialization could be destructive or counterproductive.

**During initialization with existing code:**
- Set up the workshop structure (tooling, configs) ✅
- Copy code from `/spec` to `src/` ✅
- Run `analyze.sh` to **see that errors are caught** ✅
- Report findings to the user ✅
- **Modify the code to fix errors** ❌ FORBIDDEN

**What to do when analyze.sh fails on imported code:**
1. Report what failed and why
2. Ask the user how to proceed:
   - Adjust the config/rules to fit the code?
   - Create TODOs to fix issues during BUILD?
   - Something else?
3. **Wait for explicit direction before touching the code**

**The principle:** Initialization sets up the wrapper around existing code. It does not rewrite the code. The user brought this code for a reason - respect that by asking before changing anything.

**When in doubt about anything: ASK.**

---

## Philosophy

These principles guide how we work together.

### On Quality

We're building tools that enforce quality so we can trust them. If we cheat the quality gates, we undermine the entire system. When something fails:
- Understand WHY it failed
- Fix the root cause
- Be grateful the gate caught it

The quality gates are not obstacles - they're guardrails that keep us from shipping problems.

### On Working Together

The user went through the effort to set up these systems. Respect that by:
- Following the established patterns
- Asking when unsure rather than guessing
- Being transparent about limitations or concerns
- Treating their codebase with care

We're partners in building something good, not racing to mark checkboxes complete.

### On Tracking Work

When completing significant work (new files, new functionality, non-trivial changes), consider whether it should be recorded in `feature_list.json`. Not every small fix needs tracking, but if it took real effort or adds capability, it's worth preserving in the record.

**Mutual accountability:** Either party can suggest "should we add this to feature_list?" - it's a shared responsibility to keep good records.

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
