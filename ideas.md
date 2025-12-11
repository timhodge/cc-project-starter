# Ideas

Speculative ideas for improving the starter kit. Not committed work - just captured thoughts.

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

## IDEA-002: Init Must Run First, Even With Existing Code
**Status:** promoted
**Added:** 2025-12-10
**Implemented:** 2025-12-10 - Via spec-folder-init-flow feature (existing code goes in /spec, init runs, then code copied to src/)

When importing existing code, initialization must still run first to establish the workshop structure.

### Details
bwg-post-grid became a mess because CC shortcut the init process when importing an existing plugin. Result: dev tools ended up in src/plugin/vendor/, brochure tooling at root, WordPress plugin nested inside - a hybrid that confuses analyze.sh.

The lesson: even when you're bringing in your own code, run INITIALIZER first to set up the workshop (tooling, configs, quality gates). THEN move your code into src/. Don't skip init just because code already exists.

### Notes
- See related ideas: IDEA-003 through IDEA-008

---

## IDEA-003: /spec Folder for Bringing Your Own Stuff
**Status:** promoted
**Added:** 2025-12-10
**Implemented:** 2025-12-10 - Via spec-folder-init-flow feature in CLAUDE.start.md

A designated place to drop specs, assets, or existing code BEFORE initialization processes it.

### Details
When starting a project you might have:
- A proposal or requirements doc
- spec-kit output
- An existing plugin or Laravel codebase
- Images or other assets

Where do these go? A `/spec` folder that CC checks at the START of INITIALIZER.

### Proposed Flow

**At init start, CC checks /spec:**

1. **If /spec has content:**
   - CC analyzes what's there (proposal, existing code, assets)
   - Uses findings to pre-fill onboarding questions
   - Asks confirming questions: "It looks like this is a BWG WordPress plugin project, is that right?"
   - Continues through remaining onboarding using spec as context
   - Later: pull items into feature_list, copy assets to src/ as needed

2. **If /spec is empty:**
   - CC prompts: "Do you have a spec, proposal, or any assets you can drop in /spec now? I'll wait. Tell me about what you put there."
   - User can describe: "Look in spec/ for a proposal and a plugin we're basing this on"
   - CC now knows what to expect and how to approach it
   - "You can also add stuff later and tell me about it - we can adjust from there."
   - Proceeds with standard onboarding if user says no

### Notes
- Keeps src/ pure (only shipping code)
- Gives CC context without polluting the product
- Transforms onboarding from "answer 20 questions" to "confirm what I found"

### /spec Ownership Rules
- **/spec is user-managed** - like a client drop folder
- **CC only reads and copies out** - never modifies, deletes, or adds to /spec
- User can add new content anytime and tell CC to look
- If code needs changes, copy to src/ first, work on it there
- Stays in repo permanently for reference

---

## IDEA-004: WordPress Plugin - New vs Existing
**Status:** promoted
**Added:** 2025-12-10
**Implemented:** 2025-12-10 - Via new-vs-existing-discovery feature. Question already in onboarding, added guidance on shaping TODOs.

Discovery question that affects what TODOs get generated, not necessarily the init path itself.

### Details
During discovery, learn whether this is a new plugin or existing code. Init can be the same, but outputs differ:

**New plugin:**
- TODOs for scaffolding (boilerplate, structure, etc.)

**Existing plugin:**
- TODOs for deep analysis (structure, dependencies, vendor exclusions, etc.)

The work doesn't happen AT init - just triggers appropriate TODOs for BUILD phase.

### Notes
- Relates to IDEA-002 (init must run first)
- Relates to IDEA-003 (existing code goes in /spec first)
- Simpler than originally thought - just a discovery question that shapes the TODO list

---

## IDEA-005: BWG vs Off Walter Branding
**Status:** promoted
**Added:** 2025-12-10
**Implemented:** 2025-12-10 - Added organization question to initial-onboarding.json

Onboarding question: who's putting their name on the project?

### Details
Simple discovery question - BWG or Off Walter? Answer populates:
- Plugin header (Author, Author URI)
- Copyright notices
- License info
- Maybe package.json author field

For WP plugins, generate standard header block with correct branding.

### Notes
- Just an onboarding question with predefined answer options
- Could store brand configs somewhere (author name, URL, license preference)
- Might generalize later to support other organizations

---

## IDEA-006: Init Gates - Hard Block on BUILD
**Status:** promoted
**Added:** 2025-12-10
**Implemented:** 2025-12-10 - Added to CLAUDE.start.md (step 9 + "Staying Focused During Init" section)

INITIALIZER must complete before BUILD. Enforced through clear language and mutual accountability.

### Details
Most gates collapse into one: **"analyze.sh passes."** The other checks (project-config.json, feature_list.json, dev tools, src/ structure) are either already part of mode detection or caught by analyze.sh.

### Approach: Strong Language + Mutual Accountability

**For CC (in CLAUDE.md):**
- "At the end of INITIALIZER, run `./analyze.sh`. If it fails, you are not done initializing."
- "Do not get distracted or sidetracked diving into code or working on something the user mentions."
- "Continually reinforce to user that init MUST be finished before building."

**For User:**
- Understand the process - init first, always
- Don't tempt CC with "oh while we're here can you just..."
- Hold CC accountable if it tries to skip ahead

**Two-way accountability:** CC has rules, user has rules. We hold each other to them.

### Notes
- No new scripts needed - just clearer language
- With /spec folder (IDEA-003) and proper flow, init should be clean
- If we actually init correctly from the start, gates become a safety net not a constant battle

---

## IDEA-007: Switch BUILD Back to INITIALIZE
**Status:** promoted
**Added:** 2025-12-10
**Implemented:** 2025-12-10 - Added "Handling Re-initialization Requests" section to CLAUDE.start.md

Ability to explicitly re-enter INITIALIZER mode from BUILD - but thoughtfully.

### Details
What if you get to BUILD but realize setup didn't work correctly? User says "we need to run through init again."

**What CC should NOT do:**
- Delete everything and start over (preserve src/, feature_list.json, work done)
- Just run analyze.sh, see it pass, say "great we're done let's build!"

**What CC SHOULD do:**
- Ask: "What specifically isn't working? What do we need to redo?"
- Understand the problem before taking action
- Surgically fix what's wrong, preserve what's right
- Walk through relevant init steps together

### Notes
- User knowing it's possible is enough - no formal mechanism needed
- Just needs guidance in CLAUDE.md about handling re-init requests thoughtfully
- It's a conversation, not a reset button

---

## IDEA-008: Clarify CLAUDE.project.md Usage
**Status:** parked
**Added:** 2025-12-10

We have this file but aren't sure how CC will actually use it.

### Details
CLAUDE.project.md exists for "project-specific knowledge" but it's vague:
- What goes here vs project-config.json vs project-brief.json?
- Should CC proactively write to it?
- When would CC (or user) add things?

### Current State
Documented as: "API locations, client preferences, deployment notes, etc."
But that's passive - "create as needed", "if it exists."

### Notes
- Park for now - let real usage illuminate the purpose
- As we work through projects, we'll see what actually needs a home
- May become clearer once other ideas (003, 006, 007) are implemented

---

## IDEA-010: CC Auto-Fixed Pre-existing Code Without Asking
**Status:** promoted
**Added:** 2025-12-10
**Implemented:** 2025-12-10 - Added Critical Behavioral Rule #6: "Never Modify Imported Code During Initialization"

When importing existing code, CC ran analyze.sh, saw errors, and immediately started "fixing" them.

### Details
User imported existing plugin via /spec. On first analyze.sh run:
- PHPCS complained about function prefix (bwg_ too short, needs 5+ chars)
- CC immediately started renaming functions without asking
- This could break things - pre-existing code is OUT OF SCOPE

Guidance exists ("Errors OUT OF SCOPE: STOP, report to user") but CC ignored it.

### The Real Question
Maybe init step shouldn't run the full test suite on imported code. Instead:
- Verify tooling is INSTALLED and OPERATIONAL
- Report what would fail (informational)
- Let user decide what to do about pre-existing issues

### Possible Fixes
1. Add Critical Behavioral Rule #6: "Never Auto-Fix Pre-existing Code"
2. Change init to verify tools work, not that code passes
3. For existing code imports, first analyze.sh is "discovery mode" not "gate mode"
4. Require explicit user approval before touching imported code

### Notes
- Relates to IDEA-004 (new vs existing)
- Relates to IDEA-003 (/spec folder - code came from there)
- The "analyze.sh must pass" gate makes sense for NEW code, not imported code

---

## IDEA-009: Starter Kit Files Ship to Derived Projects
**Status:** promoted
**Added:** 2025-12-10
**Promoted:** 2025-12-11 - Implemented as FEAT-054 (startup/ folder)

Template clone includes starter-kit-specific files that confuse derived projects.

### Details
When `gh repo create --template` runs, derived projects get:
- `feature_list.json` with 53 starter kit features (CC just overwrites without asking)
- `ideas.md` with our shower thoughts
- `claude-progress.txt` with our session notes

### Solution Implemented
Created `startup/` folder with:
- `startup.sh` - Human runs ONCE after clone, copies templates to root, then deletes itself
- `CLAUDE.md.template` - Clean instructions for derived projects
- `feature_list.json.template` - Empty feature list with sample task
- `ideas.md.template` - Clean ideas file
- `claude-progress.txt.template` - Fresh progress file

Also added Critical Rule #7: "Never Wholesale Overwrite Protected Files"

### Notes
- Human-only action ensures Claude never wholesale overwrites these files
- startup/ folder deletes itself after running to prevent accidental re-runs

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

## IDEA-013: Auto-Track User Requests in feature_list.json
**Status:** promoted
**Added:** 2025-12-10
**Implemented:** 2025-12-10 - Added "On Tracking Work" section to both CLAUDE.md and CLAUDE.start.md

When user asks for something to be done, CC should add it (or ask if user wants to add it) to feature_list.json so it's in the record.

### Details
Currently work can get done without being tracked. This would ensure all completed work is recorded.

### Notes
- Implemented as mutual accountability guidance, not a strict rule
- Both parties can suggest tracking - shared responsibility

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

## IDEA-018: Persistent Access to Non-Destructive Tools
**Status:** promoted
**Added:** 2025-12-11
**Promoted:** 2025-12-11 - Added as feature `persistent-tool-access`

Give Claude persistent (no-approval-needed) access to non-destructive tools to prevent work stopping for trivial read operations.

### Details
Current friction: User says "go look in ~/projects/foo" and Claude still needs approval to `ls` that folder.

Tools to consider for persistent access:
- `ls` - list directory contents
- `cat` / Read tool - read file contents
- `grep` / Grep tool - search file contents
- `glob` / Glob tool - find files by pattern
- `gh` read commands - `gh repo view`, `gh pr list`, `gh issue list`
- `git status`, `git log`, `git diff` (read-only git operations)
- `tree` - directory structure visualization

### Notes
- These are all read-only, non-destructive operations
- Dramatically reduces approval fatigue
- User already trusts Claude to work in their codebase
- Could be configured per-project in settings or CLAUDE.md

---

## IDEA-017: Feature List Dependencies and References
**Status:** promoted
**Added:** 2025-12-11
**Promoted:** 2025-12-11 - Implemented as FEAT-053

Add dependency and reference fields to feature_list.json - "we can't do this feature until we do this feature" and "this feature references this idea."

### Details
Current feature_list.json has: id, name, description, passes, source (optional).

Implemented additions:
- `id`: Sequential FEAT-XXX IDs (like IDEA-XXX)
- `status`: `pending`, `in_progress`, `complete`, `blocked` (replaces boolean `passes`)
- `depends_on`: array of FEAT-XXX IDs that must be `complete` first (enforced by analyze.sh)
- `references`: array of IDEA-XXX or FEAT-XXX this relates to (informational)

### Notes
- analyze.sh checks dependencies and triggers STOP AND ASK if unmet
- Migrated all 53 existing features to new schema
- Documentation added to CLAUDE.md and CLAUDE.start.md

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

## IDEA-001: Template
**Status:** new
**Added:** YYYY-MM-DD

One-liner description.

### Details
More context if needed.

### Notes
- Discussion points go here

---

