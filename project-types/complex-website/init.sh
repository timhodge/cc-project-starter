#!/bin/bash
# init.sh - Complex Website Development Setup
# Sets up and starts dev servers for multi-stack projects

set -e

echo "=== Complex Website - Development Setup ==="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Detect project structure
FRONTEND_DIR=""
BACKEND_DIR=""

if [ -d "frontend" ]; then
    FRONTEND_DIR="frontend"
elif [ -d "client" ]; then
    FRONTEND_DIR="client"
elif [ -d "web" ]; then
    FRONTEND_DIR="web"
fi

if [ -d "backend" ]; then
    BACKEND_DIR="backend"
elif [ -d "api" ]; then
    BACKEND_DIR="api"
elif [ -d "server" ]; then
    BACKEND_DIR="server"
fi

echo "Project structure detected:"
echo "  Frontend: ${FRONTEND_DIR:-'(not found)'}"
echo "  Backend:  ${BACKEND_DIR:-'(not found)'}"
echo ""

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}ERROR: Node.js is not installed${NC}"
    echo "Please install Node.js 18 or higher"
    exit 1
fi
echo "Node.js: $(node -v)"

# Check for PHP (if backend is PHP)
if [ -n "$BACKEND_DIR" ] && ([ -f "$BACKEND_DIR/artisan" ] || [ -f "$BACKEND_DIR/composer.json" ]); then
    if ! command -v php &> /dev/null; then
        echo -e "${YELLOW}WARNING: PHP not found (needed for backend)${NC}"
    else
        echo "PHP: $(php -r 'echo PHP_VERSION;')"
    fi
fi

echo ""

# Install frontend dependencies
if [ -n "$FRONTEND_DIR" ]; then
    echo "=== Frontend Setup ==="
    cd "$FRONTEND_DIR"

    if [ -f "package.json" ] && [ ! -d "node_modules" ]; then
        echo "Installing frontend dependencies..."
        npm install
    fi

    # Detect frontend framework
    if [ -f "next.config.js" ] || [ -f "next.config.mjs" ]; then
        echo "Detected: Next.js"
        FRONTEND_CMD="npm run dev"
        FRONTEND_PORT="3000"
    elif [ -f "nuxt.config.ts" ] || [ -f "nuxt.config.js" ]; then
        echo "Detected: Nuxt"
        FRONTEND_CMD="npm run dev"
        FRONTEND_PORT="3000"
    elif [ -f "astro.config.mjs" ]; then
        echo "Detected: Astro"
        FRONTEND_CMD="npm run dev"
        FRONTEND_PORT="4321"
    elif [ -f "vite.config.ts" ] || [ -f "vite.config.js" ]; then
        echo "Detected: Vite"
        FRONTEND_CMD="npm run dev"
        FRONTEND_PORT="5173"
    else
        echo "Detected: Generic Node.js"
        FRONTEND_CMD="npm run dev"
        FRONTEND_PORT="3000"
    fi

    cd ..
    echo ""
fi

# Install backend dependencies
if [ -n "$BACKEND_DIR" ]; then
    echo "=== Backend Setup ==="
    cd "$BACKEND_DIR"

    # Laravel/PHP backend
    if [ -f "artisan" ]; then
        echo "Detected: Laravel"
        if [ ! -d "vendor" ]; then
            echo "Installing Composer dependencies..."
            composer install
        fi
        if [ ! -f ".env" ] && [ -f ".env.example" ]; then
            cp .env.example .env
            php artisan key:generate
        fi
        BACKEND_CMD="php artisan serve --port=8000"
        BACKEND_PORT="8000"

    # Node.js backend
    elif [ -f "package.json" ]; then
        echo "Detected: Node.js backend"
        if [ ! -d "node_modules" ]; then
            echo "Installing backend dependencies..."
            npm install
        fi
        BACKEND_CMD="npm run dev"
        BACKEND_PORT="8000"

    # Generic PHP
    elif ls *.php 1> /dev/null 2>&1; then
        echo "Detected: PHP backend"
        if [ -f "composer.json" ] && [ ! -d "vendor" ]; then
            composer install
        fi
        BACKEND_CMD="php -S localhost:8000"
        BACKEND_PORT="8000"
    fi

    cd ..
    echo ""
fi

# Summary and instructions
echo "=========================================="
echo "=== Development Servers ==="
echo "=========================================="
echo ""

if [ -n "$FRONTEND_DIR" ]; then
    echo -e "${GREEN}Frontend:${NC} http://localhost:${FRONTEND_PORT:-3000}"
    echo "  Directory: $FRONTEND_DIR/"
    echo "  Command: $FRONTEND_CMD"
    echo ""
fi

if [ -n "$BACKEND_DIR" ]; then
    echo -e "${GREEN}Backend/API:${NC} http://localhost:${BACKEND_PORT:-8000}"
    echo "  Directory: $BACKEND_DIR/"
    echo "  Command: $BACKEND_CMD"
    echo ""
fi

echo "=========================================="
echo ""
echo "To start development, open TWO terminals:"
echo ""
if [ -n "$FRONTEND_DIR" ]; then
    echo "  Terminal 1 (Frontend):"
    echo "    cd $FRONTEND_DIR && $FRONTEND_CMD"
    echo ""
fi
if [ -n "$BACKEND_DIR" ]; then
    echo "  Terminal 2 (Backend):"
    echo "    cd $BACKEND_DIR && $BACKEND_CMD"
    echo ""
fi

echo "Or use a process manager like 'concurrently' or 'pm2'"
echo ""

# Optionally start one server
echo "Which server would you like to start now?"
echo "  1) Frontend only"
echo "  2) Backend only"
echo "  3) None (I'll start them manually)"
echo ""
read -p "Choice [3]: " CHOICE

case $CHOICE in
    1)
        if [ -n "$FRONTEND_DIR" ]; then
            echo ""
            echo "Starting frontend..."
            cd "$FRONTEND_DIR" && $FRONTEND_CMD
        fi
        ;;
    2)
        if [ -n "$BACKEND_DIR" ]; then
            echo ""
            echo "Starting backend..."
            cd "$BACKEND_DIR" && $BACKEND_CMD
        fi
        ;;
    *)
        echo ""
        echo "No server started. Run the commands above to start development."
        ;;
esac
