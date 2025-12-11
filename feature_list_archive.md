# Feature List Archive

Completed features moved here to keep `feature_list.json` lean. These are for reference only.

---

## FEAT-001: Directory structure
Created onboarding/, project-types/, templates/github-actions/, docs/ directories

## FEAT-002: Initial onboarding questions
Project type selection + common questions (name, slug, deployment)
- Depends on: FEAT-001

## FEAT-003: Brochure website type
Moved init.sh, analyze.sh, configs, and scaffolding to project-types/brochure-website/
- Depends on: FEAT-001

## FEAT-004: Stub onboarding files
Created wordpress-plugin.json, laravel-app.json, complex-website.json, bespoke-project.json
- Depends on: FEAT-002

## FEAT-005: Delegator scripts
Root init.sh and analyze.sh that delegate to type-specific scripts
- Depends on: FEAT-001

## FEAT-006: Lessons learned template
Template for capturing improvements to port back to starter kit

## FEAT-007: GitHub Actions templates
push-to-runcloud.yml, create-release-zip.yml, laravel-deploy.yml, wordpress-plugin-release.yml, run-tests.yml

## FEAT-008: CLAUDE.md refactor
Updated for multi-type support, new mode detection, lessons learned workflow

## FEAT-009: Quality gates documentation
docs/quality-gates-palette.md with tools reference by project type

## FEAT-010: Security patterns documentation
docs/security-patterns.md with CSRF, rate limiting, input validation patterns

## FEAT-011: Composer.json templates
composer.json.template for brochure, WordPress, and Laravel types with scripts

## FEAT-012: PHPStan configurations
Added strict-rules, WordPress extension, Larastan configs per type

## FEAT-013: WPCS configuration
phpcs.xml with WordPress-Extra, text domain, prefix configuration

## FEAT-014: PHPUnit scaffolding
phpunit.xml, bootstrap.php, SampleTest.php for WordPress plugin type

## FEAT-015: WordPress plugin type functional
Create init.sh, analyze.sh, and complete scaffolding for WordPress plugins
- Depends on: FEAT-004, FEAT-005, FEAT-013, FEAT-014

## FEAT-016: Laravel app type functional
Create init.sh, analyze.sh for Laravel apps (scaffolding via laravel new)
- Depends on: FEAT-004, FEAT-005

## FEAT-017: Complex website type functional
Create init.sh, analyze.sh, and dynamic config generation for multi-stack sites
- Depends on: FEAT-004, FEAT-005

## FEAT-018: Bespoke project type functional
Create flexible init.sh and analyze.sh that adapt to chosen language/structure
- Depends on: FEAT-004, FEAT-005

## FEAT-019: WordPress plugin skill
SKILL.md with WP coding standards, security practices, plugin architecture patterns
- Depends on: FEAT-015

## FEAT-020: Laravel skill
SKILL.md with Laravel conventions, service patterns, testing strategies
- Depends on: FEAT-016

## FEAT-021: E2E test: Brochure website
Test full flow: onboarding → scaffolding → build → quality gates
- Depends on: FEAT-003

## FEAT-022: E2E test: WordPress plugin
Test full flow for WordPress plugin creation
- Depends on: FEAT-015

## FEAT-024: Rule: Never lower test standards
CLAUDE.md instruction that Claude must fix code, not weaken quality gates to pass tests

## FEAT-025: Rule: Feature list immutability
CLAUDE.md instruction that only 'status' field can be changed without approval, never names/descriptions

## FEAT-026: Rule: Verify quality gates after scaffolding
CLAUDE.md instruction to run analyze.sh immediately after scaffolding, before building features

## FEAT-027: Rule: Ask user to install missing tools
CLAUDE.md instruction to ask user to install missing system tools rather than creating workarounds

## FEAT-028: Brochure: Schema.org by default
Add schema.php to scaffolding, add onboarding question for business type (Attorney, Restaurant, etc.)
- Depends on: FEAT-003

## FEAT-029: Brochure: Render PHP before HTML validation
analyze.sh renders PHP to temp HTML files before running html-validate to avoid false errors
- Depends on: FEAT-003

## FEAT-030: Brochure: Stylelint ch unit
Add 'ch' to unit-allowed-list in .stylelintrc.json
- Depends on: FEAT-003

## FEAT-031: Brochure: pa11y config with Chromium flags
Add .pa11yci.json with sandbox flags for WSL/Docker/CI environments
- Depends on: FEAT-003

## FEAT-032: Brochure: Accessible color guidance
Add comments in variables.css about WCAG AA contrast, update skill file
- Depends on: FEAT-003

## FEAT-033: Brochure: router.php for local dev
Add router.php for clean URLs with PHP built-in server, exclude from deployment
- Depends on: FEAT-003

## FEAT-034: Brochure: Web server type question
Add onboarding question for OpenLiteSpeed vs NGINX for URL rewrite config
- Depends on: FEAT-003

## FEAT-035: Brochure skill: PHP whitespace note
Add note about placing <?php at column 0 to avoid trailing whitespace in rendered HTML
- Depends on: FEAT-003

## FEAT-036: WordPress skill: PHP to WP function reference
Add reference of PHP functions and their WordPress equivalents (file_get_contents -> wp_remote_get, etc.)
- Depends on: FEAT-019

## FEAT-037: Lessons learned workflow
Document the process: pull lessons-learned.json from derived projects, add to feature_list, discuss with user, implement, mark addressed
- Depends on: FEAT-006

## FEAT-038: Standardize src/ as deliverable location
Establish clear separation: repo root is workshop (tooling), src/ is product (shipping code). All analyze.sh scripts scan src/ only.
- Source: bwg-post-grid

## FEAT-039: Fresh zip files for distribution
Always 'rm -f' old zip before creating new one. zip -r updates existing archives, causing corruption with removed files.
- Source: bwg-post-grid

## FEAT-040: update-project.sh script
Script that pushes starter-kit-owned files (CLAUDE.md, skills, project-types, docs) to a derived project.

## FEAT-041: /spec folder in init flow
Add /spec as user-managed input folder. CC checks for specs, proposals, existing code at init start.
- References: IDEA-002, IDEA-003

## FEAT-042: New vs existing discovery question
Onboarding question: Is this new or importing existing code? Shapes what TODOs get generated.
- References: IDEA-004

## FEAT-043: Organization branding question
Onboarding question: Who is putting their name on this project? (BWG or Off Walter). Populates headers, copyright.
- References: IDEA-005

## FEAT-044: /idea slash command
Quick capture command that adds ideas to ideas.md with auto-incrementing IDEA-XXX IDs.

## FEAT-045: Track work guidance
Added 'On Tracking Work' section to CLAUDE.md and CLAUDE.start.md - mutual accountability for recording work.
- References: IDEA-013

## FEAT-052: Persistent tool access
Allowlist for read-only tools in .claude/settings.json: ls, cat, git status/log/diff, gh read commands.
- References: IDEA-018

## FEAT-053: Feature dependencies and references
Add FEAT-XXX sequential IDs, depends_on, references fields to feature_list.json. Update analyze.sh to check dependencies.
- References: IDEA-017

## FEAT-054: startup/ folder for project initialization
Human-run startup.sh creates CLAUDE.md, feature_list.json, ideas.md, claude-progress.txt from templates. Deletes itself after. Replaces CLAUDE.start.md approach.
- References: IDEA-009

## FEAT-056: /todo slash command
Create /todo command to add items to feature_list.json (like /idea). Support switches like --list for listing todos.

## FEAT-057: Update bwg-post-grid-wp feature_list
Update bwg-post-grid-wp project with new feature_list.json architecture (FEAT-XXX IDs, status, depends_on, references).
- Depends on: FEAT-053

## FEAT-058: Update coponigrolaw-site feature_list
Update coponigrolaw-site project with new feature_list.json architecture (FEAT-XXX IDs, status, depends_on, references).
- Depends on: FEAT-053

## FEAT-059: Update dope-wars-cle feature_list
Update dope-wars-cle project with new feature_list.json architecture (FEAT-XXX IDs, status, depends_on, references). N/A - project not set up with cc-project-starter.
- Depends on: FEAT-053

## FEAT-060: Update letters-to-claus feature_list
Update letters-to-claus project with new feature_list.json architecture (FEAT-XXX IDs, status, depends_on, references).
- Depends on: FEAT-053

## FEAT-061: Test item for feature list
this is a test item to add to the feature list

## FEAT-062: Archive completed features and ideas
Move completed features to feature_list_archive.md and promoted/parked/rejected ideas to ideas_archive.md. Reduces token burn on /todo operations.
- References: IDEA-020

## FEAT-063: /todo handle archived dependencies
Update /todo command logic to treat archived dependencies as satisfied. Only active items in feature_list.json can block; missing = archived = satisfied.
- Depends on: FEAT-062
