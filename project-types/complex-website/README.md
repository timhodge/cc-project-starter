# Complex Website Project Type

This directory will contain the setup for multi-stack website projects.

## Status: Stub

This project type is not yet fully functional. It needs:

- [ ] `init.sh` - Start both frontend and backend dev servers
- [ ] `analyze.sh` - Run quality gates for both stacks
- [ ] `config/` - Configurations for various frontend/backend combos
- [ ] `scaffolding/` - Monorepo or multi-repo templates

## Planned Quality Gates

Quality gates are determined by the chosen stacks:

### Frontend (examples)
| Stack | Tools |
|-------|-------|
| Next.js/React | ESLint, TypeScript, Jest/Vitest |
| Nuxt/Vue | ESLint, TypeScript, Vitest |
| Astro | ESLint, TypeScript |

### Backend (examples)
| Stack | Tools |
|-------|-------|
| Laravel | Pint, PHPStan, Pest |
| Express/NestJS | ESLint, TypeScript, Jest |
| WordPress (Headless) | PHPCS, PHPStan |

## Architecture Options

1. **Monorepo** - Single repo with `/frontend` and `/backend` directories
2. **Separate repos** - This starter helps set up one, references the other

## Notes

Complex websites require more custom configuration based on the exact stack combination chosen during onboarding.
