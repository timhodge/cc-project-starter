# Claude Code Instructions - cc-project-starter

## What This Is

This is **cc-project-starter**, a universal project starter kit. You are not building a project FROM this kit - you are building THE KIT ITSELF.

Your job is to improve the templates, scaffolding, quality gates, skills, and workflows that will be used to create new projects.

---

## Key Files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | This file - instructions for working on the starter kit |
| `startup/` | Templates for derived projects (CLAUDE.md, feature_list.json, etc.) |
| `CLAUDE.project.md` | Template for project-specific notes in derived projects |
| `feature_list.json` | Tracks starter kit features to build/improve |
| `claude-progress.txt` | Session handoff notes |
| `lessons-learned.json` | Template, also captures lessons from THIS project |

---

## How Derived Projects Are Created

When a user creates a new project from this kit:

1. Clone/copy the repo (or use `gh repo create --template`)
2. Run: `./startup/startup.sh` (copies templates to root, then deletes itself)
3. The new project now has builder instructions, not kit-builder instructions
4. User runs through INITIALIZER mode (onboarding, scaffolding)
5. User enters BUILDER mode (feature development)

---

## Working on the Starter Kit

### Session Start

1. Read this file
2. Read `claude-progress.txt` for previous session context
3. Read `feature_list.json` to see what needs work
4. `git status` / `git log --oneline -5` for recent changes

### What You Might Work On

- **Onboarding files** (`onboarding/*.json`) - Discovery questions for each project type
- **Scaffolding** (`project-types/*/scaffolding/`) - Template files copied to new projects
- **Config files** (`project-types/*/config/`) - Linter configs, quality gate settings
- **Init/Analyze scripts** (`project-types/*/init.sh`, `analyze.sh`) - Setup and quality gates
- **Skills** (`.claude/skills/*/SKILL.md`) - Type-specific guidance
- **GitHub Actions** (`templates/github-actions/`) - CI/CD workflow templates
- **Documentation** (`docs/`) - Quality gates palette, security patterns, etc.
- **startup/** - Templates for derived projects (CLAUDE.md.template, etc.)

### Feature Tracking

Features are tracked in `feature_list.json` with sequential IDs and dependency management.

**Schema:**
```json
{
  "id": "FEAT-001",
  "name": "Brief descriptive name",
  "description": "What this feature does",
  "status": "pending|in_progress|complete|blocked",
  "depends_on": ["FEAT-000"],
  "references": ["IDEA-001", "FEAT-002"]
}
```

**Fields:**
- `id` - Sequential ID (FEAT-XXX), permanent once assigned
- `name` - Brief name (3-5 words)
- `description` - What this feature does
- `status` - `pending`, `in_progress`, `complete`, or `blocked`
- `depends_on` - FEAT-XXX IDs that must be `complete` before work can start
- `references` - IDEA-XXX this implements, or related FEAT-XXX (informational)

**Rules:**
- Only change `status` without asking; other fields need user approval
- `depends_on` is enforced by analyze.sh - unmet dependencies trigger STOP AND ASK
- New features get the next sequential FEAT-XXX ID
- IDs are permanent - never reuse or renumber

---

## Project Structure Convention

Derived projects follow a **workshop/product separation**:

```
derived-project/
├── CLAUDE.md, analyze.sh, etc.    ← Workshop (tooling)
├── src/                            ← Product (shipping code)
└── dist/                           ← Distribution (packaged releases)
```

### Implications for Scaffolding

When creating scaffolding in `project-types/*/scaffolding/`:

1. **Scaffolding contents get copied to `src/`** in derived projects
2. **Design scaffolding as the product structure**, not the repo root
3. **`analyze.sh` scripts scan `src/` only** - they won't see workshop files

Example for WordPress plugin:
```
scaffolding/                  → Copied to → derived-project/src/
├── plugin-name.php                        ├── plugin-name.php
├── includes/                              ├── includes/
└── readme.txt                             └── readme.txt
```

### Why This Matters

- Prevents scaffolding templates (with `{{PLACEHOLDERS}}`) from being scanned
- Clean separation between dev tooling and shipping code
- Deployment is simple: push `src/` contents to server
- Distribution is simple: package `src/` into `dist/`

---

## Lessons Learned Workflow

When the user says "Fetch lessons from ~/projects/project-name":

### Step 1: Import and Capture
1. Read source project's `lessons-learned.json`
2. For each lesson where `addressed: false`:
   - Check if similar lesson already exists in `feature_list.json`
   - If duplicate: note the source project
   - If new: add to `feature_list.json` with generic ID and `"source": "project-name"`
3. Report: "Found X new lessons, Y duplicates"
4. **Mark captured lessons as addressed immediately** in the source project:
   - Set `"addressed": true`
   - Set `"addressed_in_starter_version"` to current version
   - This means "captured in starter kit's backlog" - not "implemented"

### Step 2: Discuss (when ready to implement)
For each lesson:
1. **Understand the root issue** - not just the symptom
2. **Consider related improvements** - what else might benefit?
3. **Discuss with user**: Implement now, or leave in backlog

### Step 3: Implement
1. Make the changes
2. Mark `status: "complete"` in `feature_list.json`

**Key distinction:**
- `addressed: true` in source project = "we've captured this, won't lose it"
- `status: "complete"` in feature_list.json = "we've actually implemented the fix"

---

## Critical Behavioral Rules

These apply whether you're working on the starter kit OR a derived project.

### 1. Never Lower Test Standards to Pass Tests

Fix the code, not the quality gate.

**Forbidden:**
- Changing rules from `error` to `warn` or `off`
- Lowering PHPStan levels
- Adding `phpcs:ignore` without explicit user approval
- Commenting out failing tests

**Correct response:** Read the error, understand it, fix the underlying code.

**If you believe a rule is wrong:** Explain your reasoning to the user, get explicit approval BEFORE making any config change.

### 2. Feature List Immutability

Only modify the `status` field without approval. Never edit names, descriptions, or requirements without user approval.

**You may NOT:**
- Change "Postmark integration" to "email integration"
- Mark `status: "complete"` with caveats like "mostly done"
- Add or remove features without asking

### 3. Verify Quality Gates Early

After scaffolding or significant changes, run quality checks immediately. Don't accumulate errors across features - one bad pattern on 5 pages = 10 errors instead of 2.

### 4. Ask User to Install Missing Tools

When a tool is missing, ask the user to install it. Don't create workarounds.

```
"Can you install zip? Run: sudo apt install zip"
```

Workarounds waste time and often don't fit the actual use case.

---

## Philosophy

### On Quality

We're building tools that enforce quality so we can trust them. If we cheat the quality gates, we undermine the entire system. When something fails:
- Understand WHY it failed
- Fix the root cause
- Be grateful the gate caught it

### On Lessons Learned

A lesson learned is not just a bug to fix - it's a signal that something in our process needed attention. When processing lessons:
- **Think holistically** about the stated issue and anything related
- **Ask "what else?"** - if this was a problem, what similar problems might exist?
- **Improve the system**, not just the symptom
- We're building quality and making future work easier, not racing through a checklist

### On Working Together

The user went through the effort to set up these systems. Respect that by:
- Following the established patterns
- Asking when unsure rather than guessing
- Being transparent about limitations or concerns
- Treating their codebase with care

### On Tracking Work

When completing significant work (new files, new functionality, non-trivial changes), consider whether it should be recorded in `feature_list.json`. Not every small fix needs tracking, but if it took real effort or adds capability, it's worth preserving in the record.

**Mutual accountability:** Either party can suggest "should we add this to feature_list?" - it's a shared responsibility to keep good records.

---

## Session Handoff

Update `claude-progress.txt` at session end:

```
## Session: YYYY-MM-DD HH:MM

### Completed
- [What was done]

### In Progress
- [Current work]

### Next Steps
- [What to tackle next]

### Stats
- Features: X/Y passing
```

---

## Version

Starter Kit Version: 2.1.0
