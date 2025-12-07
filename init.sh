#!/bin/bash
# init.sh - Development server startup script
# Installs dependencies if needed and starts PHP built-in server

set -e

echo "=== Brochure Starter - Development Server ==="
echo ""

# Check for PHP
if ! command -v php &> /dev/null; then
    echo "ERROR: PHP is not installed or not in PATH"
    echo "Please install PHP 8.1 or higher"
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

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js is not installed or not in PATH"
    echo "Please install Node.js 18 or higher"
    exit 1
fi

NODE_VERSION=$(node -v)
echo "Node.js version: $NODE_VERSION"

# Check for npm
if ! command -v npm &> /dev/null; then
    echo "ERROR: npm is not installed or not in PATH"
    exit 1
fi

NPM_VERSION=$(npm -v)
echo "npm version: $NPM_VERSION"
echo ""

# Install Composer dependencies if needed
if [ ! -d "vendor" ]; then
    echo "=== Installing Composer dependencies ==="
    composer install
    echo ""
fi

# Install npm dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "=== Installing npm dependencies ==="
    npm install
    echo ""
fi

# Check if .env exists, create from example if not
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        echo "Creating .env from .env.example"
        cp .env.example .env
        echo "Please update .env with your configuration values"
        echo ""
    fi
fi

# Check if src directory exists
if [ ! -d "src" ]; then
    echo "ERROR: src/ directory not found"
    echo "Run the INITIALIZER mode first to scaffold the project"
    exit 1
fi

# Check if port 8000 is already in use
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "WARNING: Port 8000 is already in use"
    echo "The server may already be running, or another process is using the port"
    echo ""
fi

echo "=== Starting PHP Development Server ==="
echo "Server: http://localhost:8000"
echo "Document root: $(pwd)/src"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start PHP built-in server
php -S localhost:8000 -t src/
