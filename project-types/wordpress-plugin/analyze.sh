#!/bin/bash
# analyze.sh - WordPress Plugin Quality Gates
# Runs WPCS and PHPStan. Exits non-zero on failure.
#
# Project structure:
#   repo-root/        <- Workshop (tooling, configs)
#   └── src/          <- Product (the actual plugin)
#       ├── plugin-name.php
#       ├── includes/
#       └── ...
#
# Always scans src/. Exclusions read from project-config.json analyze_exclude array.
# Default exclusions: vendor, node_modules, .phpstan-cache

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

# Always scan src/
SOURCE_DIR="src"

# Check for source directory (the product)
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}ERROR: $SOURCE_DIR directory not found${NC}"
    echo ""
    echo "The plugin code should live in $SOURCE_DIR"
    echo "This separates your deliverable from workshop tooling."
    exit 1
fi

# Build exclusion list from project-config.json or use defaults
# Default exclusions: vendor, node_modules, .phpstan-cache
EXCLUDE_DIRS="vendor node_modules .phpstan-cache"
if [ -f "project-config.json" ] && command -v jq &> /dev/null; then
    CONFIGURED_EXCLUDES=$(jq -r '.analyze_exclude // empty | if type == "array" then .[] else empty end' project-config.json 2>/dev/null)
    if [ -n "$CONFIGURED_EXCLUDES" ]; then
        EXCLUDE_DIRS="$CONFIGURED_EXCLUDES"
    fi
fi

# Build find exclusion arguments
FIND_EXCLUDES=""
for dir in $EXCLUDE_DIRS; do
    FIND_EXCLUDES="$FIND_EXCLUDES -not -path \"*/${dir}/*\""
done

# Build PHPCS ignore pattern
PHPCS_IGNORE=""
for dir in $EXCLUDE_DIRS; do
    if [ -n "$PHPCS_IGNORE" ]; then
        PHPCS_IGNORE="${PHPCS_IGNORE},*/${dir}/*"
    else
        PHPCS_IGNORE="*/${dir}/*"
    fi
done

echo "Source directory: $SOURCE_DIR"
echo "Excluding: $EXCLUDE_DIRS"

# Check if dependencies are installed (at workshop root)
if [ ! -d "vendor" ]; then
    echo -e "${YELLOW}WARNING: Composer dependencies not installed. Run ./init.sh first.${NC}"
    echo ""
fi

# Count PHP files (using eval to expand exclusions)
PHP_FILES=$(eval "find \"$SOURCE_DIR\" -name \"*.php\" $FIND_EXCLUDES" 2>/dev/null | wc -l)
if [ "$PHP_FILES" -eq 0 ]; then
    echo -e "${RED}ERROR: No PHP files found in $SOURCE_DIR${NC}"
    exit 1
fi

echo "Found $PHP_FILES PHP file(s) to analyze"
echo ""


# ===== PHP SYNTAX CHECK =====
echo "=== PHP Syntax Check ==="
set +e
SYNTAX_ERRORS=0
while IFS= read -r file; do
    php -l "$file" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        php -l "$file"
        SYNTAX_ERRORS=1
    fi
done < <(eval "find \"$SOURCE_DIR\" -name \"*.php\" $FIND_EXCLUDES")
set -e
print_status $SYNTAX_ERRORS


# ===== PHPCS (WordPress Coding Standards) =====
echo "=== PHPCS (WordPress Coding Standards) ==="
if [ -d "vendor" ] && [ -f "vendor/bin/phpcs" ]; then
    set +e
    vendor/bin/phpcs "$SOURCE_DIR" --ignore="$PHPCS_IGNORE" 2>&1
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
    # PHPStan uses its own excludePaths in phpstan.neon, but we pass the source dir
    vendor/bin/phpstan analyse "$SOURCE_DIR" --memory-limit=512M 2>&1
    RESULT=$?
    set -e
    print_status $RESULT
else
    echo -e "${YELLOW}SKIPPED: PHPStan not installed${NC}"
    echo "Run: composer require --dev phpstan/phpstan szepeviktor/phpstan-wordpress"
    echo ""
fi


# ===== PHPUnit (if tests exist) =====
# Look for tests directory anywhere in src/
TESTS_DIR=$(find "$SOURCE_DIR" -type d -name "tests" | head -1)
if [ -n "$TESTS_DIR" ] && [ -f "vendor/bin/phpunit" ]; then
    echo "=== PHPUnit ==="
    set +e
    vendor/bin/phpunit 2>&1
    RESULT=$?
    set -e
    print_status $RESULT
elif [ -n "$TESTS_DIR" ]; then
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
