# Bespoke Project Type

This directory will contain the setup for custom/experimental projects.

## Status: Stub

This project type is designed to be flexible. It needs:

- [ ] `init.sh.template` - Customizable dev environment setup
- [ ] `analyze.sh.template` - Customizable quality gates
- [ ] Language-specific config templates

## Philosophy

Bespoke projects vary widely:
- Games
- CLI tools
- Automation scripts
- Proof of concepts
- Learning projects

The scaffolding should be minimal and adapt to:
1. **Structure level** (minimal / standard / full)
2. **Primary language** (PHP, JS, Python, etc.)
3. **Longevity** (throwaway vs long-term)

## Planned Approach

### Throwaway / Minimal
- Single file or flat directory
- No linting unless requested
- No tests unless requested

### Standard
- Basic directory structure
- Language-appropriate linting
- Optional test setup

### Full / Long-term
- Proper project structure
- Full linting setup
- Test infrastructure
- CI/CD ready

## Notes

The onboarding questions for this type are intentionally open-ended to capture the unique needs of each project.
