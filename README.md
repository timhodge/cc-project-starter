# CC Project Starter

A universal project starter kit for Claude Code. Supports multiple project types with guided onboarding, quality gates, and deployment templates.

**Version:** 2.2.0

## Supported Project Types

| Type | Description |
|------|-------------|
| **WordPress Plugin** | WordPress plugin development |
| **Laravel App** | Laravel PHP applications |
| **Brochure Website** | Static-ish PHP sites for small businesses |
| **Complex Website** | Multi-stack sites (React/Vue + PHP/Node) |
| **Bespoke Project** | Games, CLI tools, experiments |

---

## Quick Start

### 1. Create Your Project

```bash
# Create a new repo from this template
gh repo create my-project --template timhodge/cc-project-starter --private --clone
cd my-project

# Run the startup script (creates CLAUDE.md, feature_list.json, ideas.md, etc.)
./startup/startup.sh
```

### 2. (Optional) Add Your Materials to /spec

If you have existing specs, proposals, or code to import:

```bash
mkdir spec

# Drop in whatever you have:
# - Proposals or requirements docs
# - Existing code to migrate
# - Design assets
# - Reference materials
```

Claude will analyze `/spec` at the start of initialization and use it to pre-fill questions.

### 3. Start Claude Code

Open the project in Claude Code and say:

```
read CLAUDE.md and let's go
```

Claude will:
1. Check `/spec` for any materials you've provided
2. Ask confirming/remaining questions about your project
3. Set up the workshop structure and quality gates
4. Generate a feature list to build

### 4. Build Your Project

Once setup is complete, Claude enters **BUILDER mode** and will:
- Work through features one at a time
- Run quality checks before each commit
- Track progress in `feature_list.json`
- Hand off cleanly between sessions

---

## Project Structure

### Workshop vs Product

This kit separates **workshop** (development tooling) from **product** (shipping code):

```
my-project/
├── CLAUDE.md                    # Claude's instructions
├── project-config.json          # Project settings (generated)
├── feature_list.json            # Features to build (generated)
├── analyze.sh                   # Quality gates
├── vendor/                      # Dev dependencies (not shipped)
│
├── spec/                        # YOUR INPUT (read-only for Claude)
│   └── ...                      # Specs, proposals, existing code
│
├── src/                         # YOUR CODE (the product)
│   └── ...                      # This is what ships
│
└── dist/                        # RELEASES
    └── my-project-v1.0.0.zip    # Packaged from src/
```

**Key insight:** `analyze.sh` only scans `src/`. Workshop files are never checked.

### Folder Ownership

| Folder | You | Claude |
|--------|-----|--------|
| `/spec` | read/write | read only |
| `/src` | read | read/write |
| `/dist` | read | write |

---

## Updating Derived Projects

When the starter kit improves, update your project:

```bash
# From cc-project-starter directory:
./update-project.sh ~/projects/my-project
```

This pushes the latest CLAUDE.md, skills, and project-types without touching your code.

---

## Lessons Learned

As you build, capture improvements for the starter kit in `lessons-learned.json`:

```json
{
  "id": "lesson-001",
  "category": "quality-gates",
  "title": "Add rule for X",
  "description": "What you discovered",
  "suggested_change": "What to fix in the starter kit",
  "addressed": false
}
```

Then run "fetch lessons from ~/projects/my-project" in the starter kit to import them.

---

## Requirements

- [Claude Code](https://claude.ai/claude-code) CLI
- Git
- `jq` (for delegator scripts)
- For PHP projects: PHP 8.1+, Composer
- For JS projects: Node.js 18+, npm

---

## Deployment Options

During onboarding, choose from:

- **RunCloud VPS** - SSH deployment to RunCloud-managed servers
- **Laravel Forge** - Zero-downtime Laravel deployments
- **Vercel** - Static/JAMstack deployments
- **WordPress.org** - Plugin directory releases
- **GitHub Releases** - Downloadable ZIP files
- **Manual SSH** - Custom deployment

GitHub Actions templates in `templates/github-actions/`.

---

## Documentation

- [startup/CLAUDE.md.template](startup/CLAUDE.md.template) - Full instructions for Claude (copied to CLAUDE.md by startup.sh)
- [docs/quality-gates-palette.md](docs/quality-gates-palette.md) - Available quality tools by project type
- [docs/security-patterns.md](docs/security-patterns.md) - Security best practices

---

## License

MIT
