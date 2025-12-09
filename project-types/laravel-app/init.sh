#!/bin/bash
# init.sh - Laravel Application Development Setup
# Installs dependencies and starts the development server

set -e

echo "=== Laravel App - Development Setup ==="
echo ""

# Check for PHP
if ! command -v php &> /dev/null; then
    echo "ERROR: PHP is not installed or not in PATH"
    echo "Please install PHP 8.2 or higher"
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

# Check for Node.js (for Vite)
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo "Node.js version: $NODE_VERSION"
else
    echo "NOTE: Node.js not installed (needed for Vite frontend)"
fi

echo ""

# Check if this is a new project or existing
if [ ! -f "artisan" ]; then
    echo "ERROR: This doesn't appear to be a Laravel project (artisan not found)"
    echo ""
    echo "To create a new Laravel project:"
    echo "  composer create-project laravel/laravel ."
    echo "  # or"
    echo "  laravel new project-name"
    exit 1
fi

# Install Composer dependencies if needed
if [ ! -d "vendor" ]; then
    echo "=== Installing Composer dependencies ==="
    composer install
    echo ""
fi

# Install npm dependencies if needed
if [ -f "package.json" ] && [ ! -d "node_modules" ]; then
    echo "=== Installing npm dependencies ==="
    npm install
    echo ""
fi

# Check if .env exists, create from example if not
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        echo "Creating .env from .env.example"
        cp .env.example .env
        echo ""
    fi
fi

# Generate app key if not set
if grep -q "APP_KEY=$" .env 2>/dev/null || grep -q "APP_KEY=base64:" .env 2>/dev/null; then
    : # Key exists
else
    echo "Generating application key..."
    php artisan key:generate
    echo ""
fi

# Check database configuration
DB_CONNECTION=$(grep "^DB_CONNECTION=" .env 2>/dev/null | cut -d '=' -f2)
echo "Database: ${DB_CONNECTION:-sqlite}"

if [ "$DB_CONNECTION" = "sqlite" ] || [ -z "$DB_CONNECTION" ]; then
    # Create SQLite database if needed
    if [ ! -f "database/database.sqlite" ]; then
        echo "Creating SQLite database..."
        touch database/database.sqlite
    fi
fi

# Run migrations if database exists
echo ""
echo "=== Database Status ==="
set +e
php artisan migrate:status 2>/dev/null
MIGRATE_STATUS=$?
set -e

if [ $MIGRATE_STATUS -ne 0 ]; then
    echo "Run 'php artisan migrate' to create database tables"
fi

echo ""
echo "=== Starting Development Server ==="
echo "Laravel: http://localhost:8000"
echo "Vite: http://localhost:5173 (run 'npm run dev' in another terminal)"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start Laravel development server
php artisan serve
