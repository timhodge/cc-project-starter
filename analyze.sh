#!/bin/bash
# analyze.sh - Quality gate script
# Runs all quality checks. Exits non-zero on failure.

set -e

echo "=== Brochure Starter - Quality Gates ==="
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

if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}WARNING: npm dependencies not installed. Run ./init.sh first.${NC}"
    echo ""
fi

# Check if src directory exists
if [ ! -d "src" ]; then
    echo -e "${RED}ERROR: src/ directory not found${NC}"
    exit 1
fi

# Count PHP files
PHP_FILES=$(find src -name "*.php" 2>/dev/null | wc -l)
if [ "$PHP_FILES" -eq 0 ]; then
    echo -e "${YELLOW}NOTE: No PHP files found in src/. Skipping PHP checks.${NC}"
    echo ""
fi

# Count CSS files
CSS_FILES=$(find src -name "*.css" 2>/dev/null | wc -l)

# Count JS files
JS_FILES=$(find src -name "*.js" 2>/dev/null | wc -l)


# ===== PHP CHECKS =====
if [ "$PHP_FILES" -gt 0 ]; then
    echo "=== PHP Syntax Check ==="
    set +e
    find src -name "*.php" -exec php -l {} \; 2>&1 | grep -v "No syntax errors"
    RESULT=${PIPESTATUS[0]}
    set -e
    print_status $RESULT

    echo "=== PHPStan (Level 9) ==="
    if [ -d "vendor" ] && [ -f "vendor/bin/phpstan" ]; then
        set +e
        vendor/bin/phpstan analyse --memory-limit=256M 2>&1
        RESULT=$?
        set -e
        print_status $RESULT
    else
        echo -e "${YELLOW}SKIPPED: PHPStan not installed${NC}"
        echo ""
    fi

    echo "=== PHPCS (PSR-12) ==="
    if [ -d "vendor" ] && [ -f "vendor/bin/phpcs" ]; then
        set +e
        vendor/bin/phpcs --standard=PSR12 src/ 2>&1
        RESULT=$?
        set -e
        print_status $RESULT
    else
        echo -e "${YELLOW}SKIPPED: PHPCS not installed${NC}"
        echo ""
    fi
fi


# ===== CSS CHECKS =====
if [ "$CSS_FILES" -gt 0 ]; then
    echo "=== Stylelint ==="
    if [ -d "node_modules" ] && [ -f "node_modules/.bin/stylelint" ]; then
        set +e
        npx stylelint "src/**/*.css" 2>&1
        RESULT=$?
        set -e
        print_status $RESULT
    else
        echo -e "${YELLOW}SKIPPED: Stylelint not installed${NC}"
        echo ""
    fi
else
    echo "=== Stylelint ==="
    echo "NOTE: No CSS files found in src/"
    echo ""
fi


# ===== JS CHECKS =====
if [ "$JS_FILES" -gt 0 ]; then
    echo "=== ESLint ==="
    if [ -d "node_modules" ] && [ -f "node_modules/.bin/eslint" ]; then
        set +e
        npx eslint "src/**/*.js" 2>&1
        RESULT=$?
        set -e
        print_status $RESULT
    else
        echo -e "${YELLOW}SKIPPED: ESLint not installed${NC}"
        echo ""
    fi
else
    echo "=== ESLint ==="
    echo "NOTE: No JS files found in src/"
    echo ""
fi


# ===== HTML VALIDATION =====
if [ "$PHP_FILES" -gt 0 ]; then
    echo "=== HTML Validate ==="
    if [ -d "node_modules" ] && [ -f "node_modules/.bin/html-validate" ]; then
        set +e
        npx html-validate "src/**/*.php" 2>&1
        RESULT=$?
        set -e
        print_status $RESULT
    else
        echo -e "${YELLOW}SKIPPED: html-validate not installed${NC}"
        echo ""
    fi
fi


# ===== ACCESSIBILITY CHECK =====
echo "=== Accessibility (pa11y) ==="
if [ -d "node_modules" ] && [ -f "node_modules/.bin/pa11y" ]; then
    # Check if server is running
    if curl -s http://localhost:8000 > /dev/null 2>&1; then
        set +e
        npx pa11y http://localhost:8000 --standard WCAG2AA 2>&1
        RESULT=$?
        set -e
        print_status $RESULT
    else
        echo -e "${YELLOW}SKIPPED: Dev server not running on localhost:8000${NC}"
        echo "Run ./init.sh in another terminal first"
        echo ""
    fi
else
    echo -e "${YELLOW}SKIPPED: pa11y not installed${NC}"
    echo ""
fi


# ===== LIGHTHOUSE (Advisory Only) =====
echo "=== Lighthouse (Advisory) ==="
if [ -d "node_modules" ] && [ -f "node_modules/.bin/lighthouse" ]; then
    # Check if server is running
    if curl -s http://localhost:8000 > /dev/null 2>&1; then
        set +e
        npx lighthouse http://localhost:8000 \
            --only-categories=accessibility,seo,best-practices \
            --output=json \
            --output-path=./lighthouse-report.json \
            --chrome-flags="--headless --no-sandbox" \
            --quiet 2>&1

        if [ -f "lighthouse-report.json" ]; then
            # Extract scores
            A11Y=$(cat lighthouse-report.json | grep -o '"accessibility":[0-9.]*' | head -1 | cut -d: -f2)
            SEO=$(cat lighthouse-report.json | grep -o '"seo":[0-9.]*' | head -1 | cut -d: -f2)
            BP=$(cat lighthouse-report.json | grep -o '"best-practices":[0-9.]*' | head -1 | cut -d: -f2)

            echo "Accessibility: ${A11Y:-N/A}"
            echo "SEO: ${SEO:-N/A}"
            echo "Best Practices: ${BP:-N/A}"
            echo ""
            echo "Full report saved to lighthouse-report.json"
        fi
        set -e
        echo -e "${GREEN}✓ COMPLETED (advisory only)${NC}"
        echo ""
    else
        echo -e "${YELLOW}SKIPPED: Dev server not running on localhost:8000${NC}"
        echo ""
    fi
else
    echo -e "${YELLOW}SKIPPED: Lighthouse not installed${NC}"
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
