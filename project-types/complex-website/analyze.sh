#!/bin/bash
# analyze.sh - Complex Website Quality Gates
# Runs quality gates for both frontend and backend stacks

set -e

echo "=== Complex Website - Quality Gates ==="
echo ""

# Track if any checks fail
EXIT_CODE=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
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

# ===== FRONTEND CHECKS =====
if [ -n "$FRONTEND_DIR" ]; then
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}=== FRONTEND ($FRONTEND_DIR) ===${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""

    cd "$FRONTEND_DIR"

    # TypeScript Check
    if [ -f "tsconfig.json" ]; then
        echo "=== TypeScript ==="
        if [ -f "node_modules/.bin/tsc" ]; then
            set +e
            npx tsc --noEmit 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        else
            echo -e "${YELLOW}SKIPPED: TypeScript not installed${NC}"
            echo ""
        fi
    fi

    # ESLint
    echo "=== ESLint ==="
    if [ -f "node_modules/.bin/eslint" ]; then
        set +e
        npx eslint . --ext .js,.jsx,.ts,.tsx,.vue 2>&1
        RESULT=$?
        set -e
        print_status $RESULT
    else
        echo -e "${YELLOW}SKIPPED: ESLint not installed${NC}"
        echo ""
    fi

    # Prettier Check
    if [ -f ".prettierrc" ] || [ -f ".prettierrc.js" ] || [ -f "prettier.config.js" ]; then
        echo "=== Prettier ==="
        if [ -f "node_modules/.bin/prettier" ]; then
            set +e
            npx prettier --check "**/*.{js,jsx,ts,tsx,vue,css,scss,json}" 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        else
            echo -e "${YELLOW}SKIPPED: Prettier not installed${NC}"
            echo ""
        fi
    fi

    # Frontend Tests
    echo "=== Frontend Tests ==="
    if [ -f "node_modules/.bin/vitest" ]; then
        set +e
        npx vitest run 2>&1
        RESULT=$?
        set -e
        print_status $RESULT
    elif [ -f "node_modules/.bin/jest" ]; then
        set +e
        npx jest 2>&1
        RESULT=$?
        set -e
        print_status $RESULT
    else
        echo -e "${YELLOW}SKIPPED: No test runner found (vitest/jest)${NC}"
        echo ""
    fi

    cd ..
    echo ""
fi

# ===== BACKEND CHECKS =====
if [ -n "$BACKEND_DIR" ]; then
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}=== BACKEND ($BACKEND_DIR) ===${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""

    cd "$BACKEND_DIR"

    # Detect backend type
    if [ -f "artisan" ]; then
        # Laravel backend
        echo "=== PHP Syntax Check ==="
        set +e
        find app config routes database -name "*.php" -exec php -l {} \; 2>&1 | grep -v "No syntax errors"
        RESULT=${PIPESTATUS[0]}
        set -e
        print_status $RESULT

        echo "=== Laravel Pint ==="
        if [ -f "vendor/bin/pint" ]; then
            set +e
            vendor/bin/pint --test 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        else
            echo -e "${YELLOW}SKIPPED: Pint not installed${NC}"
            echo ""
        fi

        echo "=== PHPStan ==="
        if [ -f "vendor/bin/phpstan" ]; then
            set +e
            vendor/bin/phpstan analyse --memory-limit=512M 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        else
            echo -e "${YELLOW}SKIPPED: PHPStan not installed${NC}"
            echo ""
        fi

        echo "=== Backend Tests ==="
        if [ -f "vendor/bin/pest" ]; then
            set +e
            vendor/bin/pest 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        elif [ -f "vendor/bin/phpunit" ]; then
            set +e
            vendor/bin/phpunit 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        else
            echo -e "${YELLOW}SKIPPED: No test runner found${NC}"
            echo ""
        fi

    elif [ -f "package.json" ]; then
        # Node.js backend
        if [ -f "tsconfig.json" ]; then
            echo "=== TypeScript ==="
            if [ -f "node_modules/.bin/tsc" ]; then
                set +e
                npx tsc --noEmit 2>&1
                RESULT=$?
                set -e
                print_status $RESULT
            else
                echo -e "${YELLOW}SKIPPED: TypeScript not installed${NC}"
                echo ""
            fi
        fi

        echo "=== ESLint ==="
        if [ -f "node_modules/.bin/eslint" ]; then
            set +e
            npx eslint . --ext .js,.ts 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        else
            echo -e "${YELLOW}SKIPPED: ESLint not installed${NC}"
            echo ""
        fi

        echo "=== Backend Tests ==="
        if [ -f "node_modules/.bin/jest" ]; then
            set +e
            npx jest 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        elif [ -f "node_modules/.bin/vitest" ]; then
            set +e
            npx vitest run 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        else
            echo -e "${YELLOW}SKIPPED: No test runner found${NC}"
            echo ""
        fi

    elif ls *.php 1> /dev/null 2>&1; then
        # Generic PHP backend
        echo "=== PHP Syntax Check ==="
        set +e
        find . -maxdepth 2 -name "*.php" -not -path "./vendor/*" -exec php -l {} \; 2>&1 | grep -v "No syntax errors"
        RESULT=${PIPESTATUS[0]}
        set -e
        print_status $RESULT

        if [ -f "vendor/bin/phpstan" ]; then
            echo "=== PHPStan ==="
            set +e
            vendor/bin/phpstan analyse 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi

        if [ -f "vendor/bin/phpcs" ]; then
            echo "=== PHPCS ==="
            set +e
            vendor/bin/phpcs 2>&1
            RESULT=$?
            set -e
            print_status $RESULT
        fi
    fi

    cd ..
    echo ""
fi

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
