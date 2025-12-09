# Bespoke Project Type

Flexible setup for custom, experimental, or one-off projects.

## Status: Functional

This project type is ready for use.

## Philosophy

Bespoke projects vary widely:
- Games and simulations
- CLI tools and scripts
- Automation and scrapers
- Proof of concepts
- Learning projects
- API clients
- Data processing

The scripts auto-detect the project type and run appropriate tools.

## Quick Start

1. Run onboarding (minimal questions)
2. Create your project files
3. `./init.sh` auto-detects and sets up the environment
4. `./analyze.sh` runs appropriate quality gates

## Auto-Detection

Both `init.sh` and `analyze.sh` detect the project type based on config files:

| File | Detected As |
|------|-------------|
| `composer.json` | PHP |
| `package.json` | Node.js |
| `requirements.txt` / `pyproject.toml` | Python |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `Gemfile` | Ruby |

## Quality Gates by Language

### PHP
| Tool | Purpose |
|------|---------|
| php -l | Syntax check |
| PHPStan | Static analysis (if installed) |
| PHPCS | Code style (if installed) |
| PHPUnit | Tests (if installed) |

### Node.js
| Tool | Purpose |
|------|---------|
| tsc | TypeScript check (if tsconfig.json) |
| ESLint | Linting (if installed) |
| Jest/Vitest | Tests (if installed) |

### Python
| Tool | Purpose |
|------|---------|
| py_compile | Syntax check |
| Ruff/Flake8 | Linting (if installed) |
| MyPy | Type checking (if configured) |
| Pytest | Tests (if installed) |

### Rust
| Tool | Purpose |
|------|---------|
| cargo check | Compilation check |
| cargo clippy | Linting |
| cargo test | Tests |

### Go
| Tool | Purpose |
|------|---------|
| go vet | Code analysis |
| golangci-lint | Linting (if installed) |
| go test | Tests |

### Ruby
| Tool | Purpose |
|------|---------|
| RuboCop | Linting (if installed) |
| RSpec | Tests (if spec/ exists) |

## Structure Levels

### Minimal (Throwaway)
For quick experiments:
```
my-project/
├── main.py           # or index.js, main.php, etc.
└── README.md
```

No linting, no tests - just run it.

### Standard
For projects that might stick around:
```
my-project/
├── src/
│   └── ...
├── tests/
│   └── ...
├── package.json      # or composer.json, etc.
└── README.md
```

### Full (Long-term)
For serious projects:
```
my-project/
├── src/
├── tests/
├── docs/
├── .github/
│   └── workflows/
├── package.json
├── eslint.config.js
├── tsconfig.json
└── README.md
```

## Quick Setup Examples

### Node.js CLI Tool
```bash
mkdir my-tool && cd my-tool
npm init -y
npm install typescript @types/node
npx tsc --init
```

### Python Script
```bash
mkdir my-script && cd my-script
python3 -m venv venv
source venv/bin/activate
pip install ruff pytest
```

### Rust Project
```bash
cargo new my-project
cd my-project
```

### Go Project
```bash
mkdir my-project && cd my-project
go mod init github.com/user/my-project
```

## Adding Quality Gates

If you want to add linting/testing to a minimal project:

### Node.js
```bash
npm install --save-dev eslint typescript
npx eslint --init
```

### PHP
```bash
composer require --dev phpstan/phpstan squizlabs/php_codesniffer
```

### Python
```bash
pip install ruff pytest mypy
```

## Notes

- Scripts gracefully skip tools that aren't installed
- No scaffolding is copied - you create what you need
- The onboarding is minimal to avoid over-engineering
- Perfect for "just try something" projects
