#!/bin/bash
# analyze.sh - Laravel Application Quality Gates
# Runs Pint, PHPStan, and Pest/PHPUnit. Exits non-zero on failure.
#
# Project structure:
#   repo-root/        <- Workshop (tooling, configs)
#   └── src/          <- Product (the Laravel app)
#       ├── artisan
#       ├── app/
#       ├── config/
#       └── ...

set -e

echo "=== Laravel App - Quality Gates ==="
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
    echo "The Laravel app should live in src/"
    echo "This separates your deliverable from workshop tooling."
    exit 1
fi

# Check if this is a Laravel project
if [ ! -f "src/artisan" ]; then
    echo -e "${RED}ERROR: src/artisan not found - is this a Laravel project?${NC}"
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "src/vendor" ]; then
    echo -e "${YELLOW}WARNING: Composer dependencies not installed. Run ./init.sh first.${NC}"
    echo ""
fi


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
done < <(find src/app src/config src/routes src/database -name "*.php" -print0 2>/dev/null)
set -e
print_status $SYNTAX_ERRORS


# ===== LARAVEL PINT (Code Style) =====
echo "=== Laravel Pint (Code Style) ==="
if [ -d "src/vendor" ] && [ -f "src/vendor/bin/pint" ]; then
    set +e
    (cd src && vendor/bin/pint --test) 2>&1
    RESULT=$?
    set -e
    print_status $RESULT

    if [ $RESULT -ne 0 ]; then
        echo "Run 'cd src && vendor/bin/pint' to auto-fix style issues"
        echo ""
    fi
else
    echo -e "${YELLOW}SKIPPED: Laravel Pint not installed${NC}"
    echo "Run: cd src && composer require --dev laravel/pint"
    echo ""
fi


# ===== PHPStan (Static Analysis) =====
echo "=== PHPStan (Static Analysis) ==="
if [ -d "src/vendor" ] && [ -f "src/vendor/bin/phpstan" ]; then
    set +e
    (cd src && vendor/bin/phpstan analyse --memory-limit=512M) 2>&1
    RESULT=$?
    set -e
    print_status $RESULT
else
    echo -e "${YELLOW}SKIPPED: PHPStan not installed${NC}"
    echo "Run: cd src && composer require --dev larastan/larastan"
    echo ""
fi


# ===== PEST / PHPUnit (Tests) =====
echo "=== Tests ==="
if [ -d "src/vendor" ] && [ -f "src/vendor/bin/pest" ]; then
    echo "Running Pest..."
    set +e
    (cd src && vendor/bin/pest --parallel) 2>&1
    RESULT=$?
    set -e
    print_status $RESULT
elif [ -d "src/vendor" ] && [ -f "src/vendor/bin/phpunit" ]; then
    echo "Running PHPUnit..."
    set +e
    (cd src && vendor/bin/phpunit) 2>&1
    RESULT=$?
    set -e
    print_status $RESULT
else
    echo -e "${YELLOW}SKIPPED: No test runner installed${NC}"
    echo "Run: cd src && composer require --dev pestphp/pest"
    echo ""
fi


# ===== BLADE LINTING (if available) =====
if [ -d "src/vendor" ] && [ -f "src/vendor/bin/blade-formatter" ]; then
    echo "=== Blade Formatter ==="
    set +e
    (cd src && vendor/bin/blade-formatter --check resources/views/**/*.blade.php) 2>&1
    RESULT=$?
    set -e
    print_status $RESULT
fi


# ===== LARAVEL SPECIFIC CHECKS =====
echo "=== Laravel Checks ==="

# Check for debug mode in non-local environments
if grep -q "APP_DEBUG=true" src/.env 2>/dev/null; then
    APP_ENV=$(grep "^APP_ENV=" src/.env 2>/dev/null | cut -d '=' -f2)
    if [ "$APP_ENV" != "local" ] && [ "$APP_ENV" != "testing" ]; then
        echo -e "${YELLOW}WARNING: APP_DEBUG=true in $APP_ENV environment${NC}"
    else
        echo "APP_DEBUG=true (OK for $APP_ENV)"
    fi
fi

# Check for missing migrations
set +e
PENDING=$(cd src && php artisan migrate:status 2>/dev/null | grep -c "Pending")
set -e
if [ "$PENDING" -gt 0 ]; then
    echo -e "${YELLOW}WARNING: $PENDING pending migration(s)${NC}"
else
    echo "Migrations: Up to date"
fi

echo ""


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
