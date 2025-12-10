#!/bin/bash
# analyze.sh - Bespoke Project Quality Gates
# Runs appropriate checks based on detected project type
#
# Project structure:
#   repo-root/        <- Workshop (tooling, configs)
#   └── src/          <- Product (your code)

set -e

echo "=== Bespoke Project - Quality Gates ==="
echo ""

# Track if any checks fail
EXIT_CODE=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASSED${NC}"
    else
        echo -e "${RED}✗ FAILED${NC}"
        EXIT_CODE=1
    fi
    echo ""
}

# Check for src/ directory (the product)
if [ ! -d "src" ]; then
    echo -e "${RED}ERROR: src/ directory not found${NC}"
    echo ""
    echo "The project code should live in src/"
    echo "This separates your deliverable from workshop tooling."
    exit 1
fi

# Detect primary language/framework from src/
detect_project_type() {
    if [ -f "src/composer.json" ]; then
        echo "php"
    elif [ -f "src/package.json" ]; then
        echo "node"
    elif [ -f "src/requirements.txt" ] || [ -f "src/pyproject.toml" ] || [ -f "src/setup.py" ]; then
        echo "python"
    elif [ -f "src/Cargo.toml" ]; then
        echo "rust"
    elif [ -f "src/go.mod" ]; then
        echo "go"
    elif [ -f "src/Gemfile" ]; then
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
        # PHP Syntax Check
        echo "=== PHP Syntax Check ==="
        set +e
        SYNTAX_ERRORS=0
        while IFS= read -r -d '' file; do
            php -l "$file" > /dev/null 2>&1
            if [ $? -ne 0 ]; then
                php -l "$file"
                SYNTAX_ERRORS=1
            fi
        done < <(find src -name "*.php" -not -path "src/vendor/*" -print0 2>/dev/null)
        set -e
        print_status $SYNTAX_ERRORS

        # PHPStan
        if [ -f "src/vendor/bin/phpstan" ]; then
            echo "=== PHPStan ==="
            set +e
            (cd src && vendor/bin/phpstan analyse) 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi

        # PHPCS
        if [ -f "src/vendor/bin/phpcs" ]; then
            echo "=== PHPCS ==="
            set +e
            (cd src && vendor/bin/phpcs) 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi

        # PHPUnit
        if [ -f "src/vendor/bin/phpunit" ]; then
            echo "=== PHPUnit ==="
            set +e
            (cd src && vendor/bin/phpunit) 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi
        ;;

    node)
        # TypeScript
        if [ -f "src/tsconfig.json" ]; then
            echo "=== TypeScript ==="
            if [ -f "src/node_modules/.bin/tsc" ]; then
                set +e
                (cd src && npx tsc --noEmit) 2>&1
                RESULT=$?
                set -e
                print_status $RESULT
            else
                echo -e "${YELLOW}SKIPPED: TypeScript not installed${NC}"
                echo ""
            fi
        fi

        # ESLint
        if [ -f "src/node_modules/.bin/eslint" ]; then
            echo "=== ESLint ==="
            set +e
            (cd src && npx eslint . --ext .js,.jsx,.ts,.tsx) 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi

        # Tests
        if [ -f "src/node_modules/.bin/jest" ]; then
            echo "=== Jest ==="
            set +e
            (cd src && npx jest) 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        elif [ -f "src/node_modules/.bin/vitest" ]; then
            echo "=== Vitest ==="
            set +e
            (cd src && npx vitest run) 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi
        ;;

    python)
        # Python syntax check
        echo "=== Python Syntax Check ==="
        set +e
        SYNTAX_ERRORS=0
        while IFS= read -r -d '' file; do
            python3 -m py_compile "$file" 2>&1
            if [ $? -ne 0 ]; then
                SYNTAX_ERRORS=1
            fi
        done < <(find src -name "*.py" -not -path "src/venv/*" -not -path "src/.venv/*" -print0 2>/dev/null)
        set -e
        print_status $SYNTAX_ERRORS

        # Activate venv if exists
        if [ -f "src/venv/bin/activate" ]; then
            source src/venv/bin/activate
        elif [ -f "src/.venv/bin/activate" ]; then
            source src/.venv/bin/activate
        fi

        # Ruff (fast Python linter)
        if command -v ruff &> /dev/null; then
            echo "=== Ruff ==="
            set +e
            ruff check src/ 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        # Flake8
        elif command -v flake8 &> /dev/null; then
            echo "=== Flake8 ==="
            set +e
            flake8 src/ 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi

        # MyPy
        if command -v mypy &> /dev/null && [ -f "src/mypy.ini" ] || [ -f "src/pyproject.toml" ]; then
            echo "=== MyPy ==="
            set +e
            mypy src/ 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi

        # Pytest
        if command -v pytest &> /dev/null; then
            echo "=== Pytest ==="
            set +e
            (cd src && pytest) 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi
        ;;

    rust)
        echo "=== Cargo Check ==="
        set +e
        (cd src && cargo check) 2>&1
        RESULT=$?
        set -e
        print_status $RESULT

        echo "=== Cargo Clippy ==="
        set +e
        (cd src && cargo clippy -- -D warnings) 2>&1
        RESULT=$?
        set -e
        print_status $RESULT

        echo "=== Cargo Test ==="
        set +e
        (cd src && cargo test) 2>&1
        RESULT=$?
        set -e
        print_status $RESULT
        ;;

    go)
        echo "=== Go Vet ==="
        set +e
        (cd src && go vet ./...) 2>&1
        RESULT=$?
        set -e
        print_status $RESULT

        if command -v golangci-lint &> /dev/null; then
            echo "=== GolangCI-Lint ==="
            set +e
            (cd src && golangci-lint run) 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi

        echo "=== Go Test ==="
        set +e
        (cd src && go test ./...) 2>&1
        RESULT=$?
        set -e
        print_status $RESULT
        ;;

    ruby)
        if command -v rubocop &> /dev/null; then
            echo "=== RuboCop ==="
            set +e
            (cd src && rubocop) 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi

        if [ -d "src/spec" ] && command -v rspec &> /dev/null; then
            echo "=== RSpec ==="
            set +e
            (cd src && rspec) 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi
        ;;

    *)
        echo "Could not detect project type in src/."
        echo "No automated quality gates available."
        echo ""
        echo "Consider adding to src/:"
        echo "  - package.json (Node.js)"
        echo "  - composer.json (PHP)"
        echo "  - requirements.txt (Python)"
        echo "  - Cargo.toml (Rust)"
        echo "  - go.mod (Go)"
        ;;
esac

# ===== SUMMARY =====
echo "=========================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}=== All quality checks passed ===${NC}"
else
    echo -e "${RED}=== Some quality checks failed ===${NC}"
    echo "Fix the errors above and run ./analyze.sh again"
fi
echo "=========================================="

exit $EXIT_CODE
