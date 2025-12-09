#!/bin/bash
# analyze.sh - WordPress Plugin Quality Gates
# Runs WPCS and PHPStan. Exits non-zero on failure.

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

# Check if dependencies are installed
if [ ! -d "vendor" ]; then
    echo -e "${YELLOW}WARNING: Composer dependencies not installed. Run ./init.sh first.${NC}"
    echo ""
fi

# Determine source directory (could be src/, includes/, or root)
if [ -d "src" ]; then
    SOURCE_DIR="src"
elif [ -d "includes" ]; then
    SOURCE_DIR="includes"
else
    SOURCE_DIR="."
fi

# Find main plugin file
MAIN_FILE=$(find . -maxdepth 1 -name "*.php" -type f | head -1)

# Count PHP files
PHP_FILES=$(find . -name "*.php" -not -path "./vendor/*" -not -path "./node_modules/*" 2>/dev/null | wc -l)
if [ "$PHP_FILES" -eq 0 ]; then
    echo -e "${RED}ERROR: No PHP files found${NC}"
    exit 1
fi

echo "Found $PHP_FILES PHP file(s) to analyze"
echo "Source directory: $SOURCE_DIR"
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
done < <(find . -name "*.php" -not -path "./vendor/*" -not -path "./node_modules/*" -print0)
set -e
print_status $SYNTAX_ERRORS


# ===== PHPCS (WordPress Coding Standards) =====
echo "=== PHPCS (WordPress Coding Standards) ==="
if [ -d "vendor" ] && [ -f "vendor/bin/phpcs" ]; then
    set +e
    vendor/bin/phpcs 2>&1
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
    vendor/bin/phpstan analyse --memory-limit=512M 2>&1
    RESULT=$?
    set -e
    print_status $RESULT
else
    echo -e "${YELLOW}SKIPPED: PHPStan not installed${NC}"
    echo "Run: composer require --dev phpstan/phpstan szepeviktor/phpstan-wordpress"
    echo ""
fi


# ===== PHPUnit (if tests exist) =====
if [ -d "tests" ] && [ -f "vendor/bin/phpunit" ]; then
    echo "=== PHPUnit ==="
    set +e
    vendor/bin/phpunit 2>&1
    RESULT=$?
    set -e
    print_status $RESULT
elif [ -d "tests" ]; then
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
