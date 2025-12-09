#!/bin/bash
# init.sh - WordPress Plugin Development Setup
# Installs dependencies and provides dev environment options

set -e

echo "=== WordPress Plugin - Development Setup ==="
echo ""

# Check for PHP
if ! command -v php &> /dev/null; then
    echo "ERROR: PHP is not installed or not in PATH"
    echo "Please install PHP 8.0 or higher"
    exit 1
fi

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
echo "PHP version: $PHP_VERSION"

# Check for Composer
if ! command -v composer &> /dev/null; then
    echo "ERROR: Composer is not installed or not in PATH"
    echo "Please install Composer: https://getcomposer.org"
    exit 1
fi

COMPOSER_VERSION=$(composer --version | head -n 1)
echo "Composer: $COMPOSER_VERSION"
echo ""

# Install Composer dependencies if needed
if [ ! -d "vendor" ]; then
    echo "=== Installing Composer dependencies ==="
    composer install
    echo ""
fi

# Check if WP-CLI is available (optional but useful)
if command -v wp &> /dev/null; then
    WP_CLI_VERSION=$(wp --version)
    echo "WP-CLI: $WP_CLI_VERSION"
else
    echo "NOTE: WP-CLI not installed (optional, useful for testing)"
fi

# Check if wp-env is available (optional)
if command -v npx &> /dev/null && npx wp-env --version &> /dev/null 2>&1; then
    echo "wp-env: Available (run 'npx wp-env start' to launch)"
fi

echo ""
echo "=== Development Options ==="
echo ""
echo "1. Local WordPress Installation:"
echo "   - Symlink or copy this plugin to your wp-content/plugins/ directory"
echo "   - Example: ln -s \$(pwd) /path/to/wordpress/wp-content/plugins/\$(basename \$(pwd))"
echo ""
echo "2. wp-env (Docker-based):"
echo "   - Run: npx wp-env start"
echo "   - Access: http://localhost:8888 (admin: admin/password)"
echo "   - Stop: npx wp-env stop"
echo ""
echo "3. Local by Flywheel / MAMP / XAMPP:"
echo "   - Copy plugin to the wp-content/plugins/ directory of your local site"
echo ""
echo "=== Quality Gates ==="
echo "Run ./analyze.sh to check code quality before committing"
echo ""
