# WordPress Plugin Project Type

This directory will contain the setup for WordPress plugin projects.

## Status: Stub

This project type is not yet fully functional. It needs:

- [ ] `init.sh` - Development environment setup (wp-env or local WP)
- [ ] `analyze.sh` - Quality gates (PHPCS with WordPress standard, PHPStan)
- [ ] `config/` - Linter configurations
- [ ] `scaffolding/` - Plugin file templates

## Planned Quality Gates

| Tool | Purpose |
|------|---------|
| php -l | PHP syntax check |
| PHPCS (WordPress) | WordPress Coding Standards |
| PHPStan (L6-8) | Static analysis |
| ESLint | JS linting (if using blocks) |

## Scaffolding Files Needed

- `plugin-name.php` - Main plugin file with headers
- `uninstall.php` - Clean uninstall script
- `includes/class-plugin-name.php` - Main plugin class
- `admin/` - Admin functionality
- `public/` - Public-facing functionality
- `languages/` - Translation files
