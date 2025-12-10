#!/bin/bash
# analyze.sh - WordPress Plugin Quality Gates
# Runs WPCS and PHPStan. Exits non-zero on failure.
#
# Project structure:
#   repo-root/        <- Workshop (tooling, configs)
#   └── src/          <- Product (the actual plugin)
#       ├── plugin-name.php
#       ├── src/
#       └── ...

set -e

echo "=== WordPress Plugin - Quality Gates ==="
echo ""

# Track if any checks fail
EXIT_CODE=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
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
    echo "The plugin code should live in src/"
    echo "This separates your deliverable from workshop tooling."
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "vendor" ]; then
    echo -e "${YELLOW}WARNING: Composer dependencies not installed. Run ./init.sh first.${NC}"
    echo ""
fi

# Count PHP files in src/
PHP_FILES=$(find src -name "*.php" 2>/dev/null | wc -l)
if [ "$PHP_FILES" -eq 0 ]; then
    echo -e "${RED}ERROR: No PHP files found in src/${NC}"
    exit 1
fi

echo "Found $PHP_FILES PHP file(s) to analyze in src/"
echo ""


# ===== PHP SYNTAX CHECK =====
echo "=== PHP Syntax Check ==="
set +e
SYNTAX_ERRORS=0
while IFS= read -r -d '' file; do
    php -l "$file" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        php -l "$file"
        SYNTAX_ERRORS=1
    fi
done < <(find src -name "*.php" -print0)
set -e
print_status $SYNTAX_ERRORS


# ===== PHPCS (WordPress Coding Standards) =====
echo "=== PHPCS (WordPress Coding Standards) ==="
if [ -d "vendor" ] && [ -f "vendor/bin/phpcs" ]; then
    set +e
    vendor/bin/phpcs src/ 2>&1
    RESULT=$?
    set -e
    print_status $RESULT
else
    echo -e "${YELLOW}SKIPPED: PHPCS not installed${NC}"
    echo "Run: composer require --dev wp-coding-standards/wpcs dealerdirect/phpcodesniffer-composer-installer"
    echo ""
fi


# ===== PHPStan =====
echo "=== PHPStan (Static Analysis) ==="
if [ -d "vendor" ] && [ -f "vendor/bin/phpstan" ]; then
    set +e
    vendor/bin/phpstan analyse src/ --memory-limit=512M 2>&1
    RESULT=$?
    set -e
    print_status $RESULT
else
    echo -e "${YELLOW}SKIPPED: PHPStan not installed${NC}"
    echo "Run: composer require --dev phpstan/phpstan szepeviktor/phpstan-wordpress"
    echo ""
fi


# ===== PHPUnit (if tests exist) =====
if [ -d "src/tests" ] && [ -f "vendor/bin/phpunit" ]; then
    echo "=== PHPUnit ==="
    set +e
    vendor/bin/phpunit 2>&1
    RESULT=$?
    set -e
    print_status $RESULT
elif [ -d "src/tests" ]; then
    echo "=== PHPUnit ==="
    echo -e "${YELLOW}SKIPPED: PHPUnit not installed${NC}"
    echo "Run: composer require --dev phpunit/phpunit"
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
