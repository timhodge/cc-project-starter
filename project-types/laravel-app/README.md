# Laravel App Project Type

This directory will contain the setup for Laravel application projects.

## Status: Stub

This project type is not yet fully functional. It needs:

- [ ] `init.sh` - Development environment setup (Sail, Herd, or artisan serve)
- [ ] `analyze.sh` - Quality gates (Pint, PHPStan, Pest)
- [ ] `config/` - Linter configurations
- [ ] `scaffolding/` - Not needed (uses `laravel new` or `composer create-project`)

## Planned Quality Gates

| Tool | Purpose |
|------|---------|
| php -l | PHP syntax check |
| Laravel Pint | Code style (PSR-12 + Laravel conventions) |
| PHPStan (L8) | Static analysis with Larastan |
| Pest/PHPUnit | Test runner |
| ESLint | JS linting (if using Inertia/Vue/React) |

## Notes

Laravel projects are typically created via:
- `laravel new project-name`
- `composer create-project laravel/laravel project-name`

The init.sh for this type should detect if Laravel is already installed and start the appropriate dev server.
