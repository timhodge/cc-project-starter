# WordPress Plugin Project Type

Setup and scaffolding for WordPress plugin development.

## Status: Functional

This project type is ready for use.

## Quick Start

1. Run onboarding to configure the plugin
2. Scaffolding is copied and placeholders replaced
3. Run `./init.sh` to install dependencies
4. Run `./analyze.sh` to check quality gates

## Quality Gates

| Tool | Purpose | Config File |
|------|---------|-------------|
| php -l | PHP syntax check | - |
| PHPCS | WordPress Coding Standards | phpcs.xml |
| PHPStan | Static analysis (Level 8) | phpstan.neon |
| PHPUnit | Unit tests | phpunit.xml |

## Directory Structure

After scaffolding:

```
your-plugin/
├── your-plugin.php      # Main plugin file
├── uninstall.php        # Clean uninstall script
├── readme.txt           # WordPress.org readme
├── composer.json        # Dependencies
├── phpcs.xml            # WPCS configuration
├── phpstan.neon         # Static analysis config
├── phpunit.xml          # Test configuration
├── src/
│   └── Admin/
│       └── Settings.php # Settings page example
├── assets/
│   ├── css/             # Stylesheets
│   └── js/              # JavaScript
├── languages/           # Translation files
└── tests/
    ├── bootstrap.php    # Test bootstrap
    └── SampleTest.php   # Example test
```

## Development Options

### Option 1: Local WordPress

Symlink your plugin to an existing WordPress installation:

```bash
ln -s $(pwd) /path/to/wordpress/wp-content/plugins/$(basename $(pwd))
```

### Option 2: wp-env (Docker)

If you have Docker installed:

```bash
npx wp-env start
# Access at http://localhost:8888 (admin: admin/password)
npx wp-env stop
```

### Option 3: Local by Flywheel / MAMP / XAMPP

Copy the plugin folder to your local WordPress site's `wp-content/plugins/` directory.

## Placeholder Variables

The scaffolding uses these placeholders that get replaced during onboarding:

| Placeholder | Example Value |
|-------------|---------------|
| `{{PLUGIN_NAME}}` | My Awesome Plugin |
| `{{PLUGIN_SLUG}}` | my-awesome-plugin |
| `{{PLUGIN_DESCRIPTION}}` | A plugin that does awesome things |
| `{{NAMESPACE}}` | MyAwesomePlugin |
| `{{CONSTANT_PREFIX}}` | MAP |
| `{{AUTHOR_NAME}}` | Your Name |
| `{{AUTHOR_URI}}` | https://example.com |
| `{{WP_MIN_VERSION}}` | 6.0 |
| `{{PHP_MIN_VERSION}}` | 8.0 |

## WordPress Coding Standards

This setup uses WordPress-Extra which includes:
- WordPress-Core
- WordPress-Docs
- WordPress-Extra rules

Key rules enforced:
- Proper escaping of output (`esc_html`, `esc_attr`, etc.)
- Proper sanitization of input (`sanitize_text_field`, etc.)
- Text domain validation for translations
- Prefixing of functions, hooks, and global variables
- Yoda conditions (`if ( true === $var )`)

## PHPStan Configuration

PHPStan is configured at level 8 with the WordPress extension:
- Understands WordPress hooks and filters
- Knows about WordPress global functions
- Handles dynamic WordPress patterns

## Testing

Run tests with:

```bash
composer test
# or
vendor/bin/phpunit
```

For WordPress integration tests, consider using the [WordPress test suite](https://make.wordpress.org/core/handbook/testing/automated-testing/phpunit/).
