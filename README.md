# CC Project Starter

A universal project starter kit for Claude Code. Supports multiple project types with guided onboarding, quality gates, and deployment templates.

## Supported Project Types

| Type | Description | Status |
|------|-------------|--------|
| **Brochure Website** | Static-ish PHP sites for small businesses | Ready |
| **WordPress Plugin** | WordPress plugin development | Onboarding ready |
| **Laravel App** | Laravel PHP applications | Onboarding ready |
| **Complex Website** | Multi-stack sites (React/Vue + PHP/Node) | Onboarding ready |
| **Bespoke Project** | Games, CLI tools, experiments | Onboarding ready |

## Getting Started

### 1. Create Your Project

```bash
# Clone this template for a new project
gh repo create my-project --template timhodge/cc-project-starter --private --clone
cd my-project
```

### 2. Start Claude Code

Open the project in Claude Code and say:

```
read CLAUDE.md and let's go
```

Claude will:
1. Ask what type of project you're building
2. Guide you through discovery questions
3. Set up the appropriate structure and quality gates
4. Generate a feature list to build

### 3. Build Your Project

Once setup is complete, Claude enters **BUILDER mode** and will:
- Work through features one at a time
- Run quality checks before each commit
- Track progress in `feature_list.json`
- Hand off cleanly between sessions

## How It Works

```
┌─────────────────────────────────────────────────────────┐
│  "read CLAUDE.md and let's go"                          │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│  INITIALIZER MODE                                       │
│  ─────────────────                                      │
│  1. What type of project? (WP plugin, Laravel, etc.)    │
│  2. Common questions (name, deployment target)          │
│  3. Type-specific questions                             │
│  4. Generate project-config.json + feature_list.json    │
│  5. Scaffold files, copy configs                        │
│  6. Commit: "Initial project setup"                     │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│  BUILDER MODE                                           │
│  ────────────                                           │
│  Loop:                                                  │
│    1. Pick next feature from feature_list.json          │
│    2. Implement it                                      │
│    3. Run ./analyze.sh (quality gates)                  │
│    4. Fix any issues                                    │
│    5. Mark feature complete, commit                     │
│    6. Repeat until done                                 │
└─────────────────────────────────────────────────────────┘
```

## Project Structure

After cloning, the template contains:

```
cc-project-starter/
├── CLAUDE.md                    # Instructions for Claude Code
├── onboarding/                  # Discovery questions by project type
│   ├── initial-onboarding.json  # Project type selection
│   ├── wordpress-plugin.json
│   ├── laravel-app.json
│   ├── brochure-website.json
│   ├── complex-website.json
│   └── bespoke-project.json
├── project-types/               # Type-specific configs and scaffolding
│   ├── brochure-website/
│   ├── wordpress-plugin/
│   ├── laravel-app/
│   ├── complex-website/
│   └── bespoke-project/
├── templates/
│   └── github-actions/          # CI/CD workflow templates
├── init.sh                      # Start dev environment
├── analyze.sh                   # Run quality gates
└── lessons-learned.json         # Capture improvements
```

After onboarding, Claude generates:

```
├── project-config.json          # Your project type and settings
├── project-brief.json           # Your answers from discovery
├── feature_list.json            # Features to build
└── src/ (or appropriate structure for your project type)
```

## Requirements

- [Claude Code](https://claude.ai/claude-code) CLI
- Git
- For PHP projects: PHP 8.1+, Composer
- For JS projects: Node.js 18+, npm
- `jq` (for the delegator scripts)

## Deployment Options

During onboarding, you can choose from:

- **RunCloud VPS** - SSH deployment to RunCloud-managed servers
- **Laravel Forge** - Zero-downtime Laravel deployments
- **Vercel** - Static/JAMstack deployments
- **WordPress.org** - Plugin directory releases
- **GitHub Releases** - Downloadable ZIP files
- **Manual SSH** - Custom deployment

GitHub Actions templates are provided in `templates/github-actions/`.

## Lessons Learned

As you build projects, capture improvements in `lessons-learned.json`:

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

This creates a feedback loop to improve the starter kit over time.

## Documentation

- [CLAUDE.md](CLAUDE.md) - Full instructions for Claude Code
- [PROJECT_PLAN.md](PROJECT_PLAN.md) - Original project plan
- Project type details in `project-types/*/README.md`

## License

MIT
