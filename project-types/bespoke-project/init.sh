#!/bin/bash
# init.sh - Bespoke Project Development Setup
# Flexible setup that adapts to the project type

set -e

echo "=== Bespoke Project - Development Setup ==="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Detect primary language/framework
detect_project_type() {
    if [ -f "composer.json" ]; then
        echo "php"
    elif [ -f "package.json" ]; then
        echo "node"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
        echo "python"
    elif [ -f "Cargo.toml" ]; then
        echo "rust"
    elif [ -f "go.mod" ]; then
        echo "go"
    elif [ -f "Gemfile" ]; then
        echo "ruby"
    else
        echo "unknown"
    fi
}

PROJECT_TYPE=$(detect_project_type)
echo "Detected project type: $PROJECT_TYPE"
echo ""

case $PROJECT_TYPE in
    php)
        echo "=== PHP Project Setup ==="
        if ! command -v php &> /dev/null; then
            echo -e "${RED}ERROR: PHP is not installed${NC}"
            exit 1
        fi
        echo "PHP: $(php -r 'echo PHP_VERSION;')"

        if [ -f "composer.json" ] && [ ! -d "vendor" ]; then
            echo "Installing Composer dependencies..."
            composer install
        fi

        # Check for common entry points
        if [ -f "public/index.php" ]; then
            echo ""
            echo "Starting PHP server on public/..."
            php -S localhost:8000 -t public/
        elif [ -f "index.php" ]; then
            echo ""
            echo "Starting PHP server..."
            php -S localhost:8000
        else
            echo ""
            echo "No index.php found. Create one to start the server."
        fi
        ;;

    node)
        echo "=== Node.js Project Setup ==="
        if ! command -v node &> /dev/null; then
            echo -e "${RED}ERROR: Node.js is not installed${NC}"
            exit 1
        fi
        echo "Node.js: $(node -v)"

        if [ -f "package.json" ] && [ ! -d "node_modules" ]; then
            echo "Installing npm dependencies..."
            npm install
        fi

        # Try to find a dev script
        if grep -q '"dev"' package.json 2>/dev/null; then
            echo ""
            echo "Running 'npm run dev'..."
            npm run dev
        elif grep -q '"start"' package.json 2>/dev/null; then
            echo ""
            echo "Running 'npm start'..."
            npm start
        else
            echo ""
            echo "No dev/start script found in package.json"
            echo "Add one or run your entry point manually"
        fi
        ;;

    python)
        echo "=== Python Project Setup ==="
        if ! command -v python3 &> /dev/null; then
            echo -e "${RED}ERROR: Python 3 is not installed${NC}"
            exit 1
        fi
        echo "Python: $(python3 --version)"

        # Check for virtual environment
        if [ ! -d "venv" ] && [ ! -d ".venv" ]; then
            echo "Creating virtual environment..."
            python3 -m venv venv
            echo "Activate it with: source venv/bin/activate"
        fi

        if [ -f "requirements.txt" ]; then
            echo ""
            echo "To install dependencies:"
            echo "  source venv/bin/activate"
            echo "  pip install -r requirements.txt"
        elif [ -f "pyproject.toml" ]; then
            echo ""
            echo "To install dependencies:"
            echo "  source venv/bin/activate"
            echo "  pip install -e ."
        fi
        ;;

    rust)
        echo "=== Rust Project Setup ==="
        if ! command -v cargo &> /dev/null; then
            echo -e "${RED}ERROR: Cargo is not installed${NC}"
            exit 1
        fi
        echo "Cargo: $(cargo --version)"
        echo ""
        echo "Building project..."
        cargo build
        echo ""
        echo "Run with: cargo run"
        ;;

    go)
        echo "=== Go Project Setup ==="
        if ! command -v go &> /dev/null; then
            echo -e "${RED}ERROR: Go is not installed${NC}"
            exit 1
        fi
        echo "Go: $(go version)"
        echo ""
        echo "Downloading dependencies..."
        go mod download
        echo ""
        echo "Run with: go run ."
        ;;

    ruby)
        echo "=== Ruby Project Setup ==="
        if ! command -v ruby &> /dev/null; then
            echo -e "${RED}ERROR: Ruby is not installed${NC}"
            exit 1
        fi
        echo "Ruby: $(ruby --version)"

        if [ -f "Gemfile" ] && ! command -v bundle &> /dev/null; then
            echo -e "${YELLOW}WARNING: Bundler not installed. Run: gem install bundler${NC}"
        elif [ -f "Gemfile" ]; then
            echo "Installing gems..."
            bundle install
        fi
        ;;

    *)
        echo "=== Generic Project ==="
        echo ""
        echo "Could not detect project type automatically."
        echo ""
        echo "Please specify your setup requirements, or create:"
        echo "  - package.json (Node.js)"
        echo "  - composer.json (PHP)"
        echo "  - requirements.txt (Python)"
        echo "  - Cargo.toml (Rust)"
        echo "  - go.mod (Go)"
        echo "  - Gemfile (Ruby)"
        ;;
esac

echo ""
echo "=== Done ==="
