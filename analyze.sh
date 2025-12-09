#!/bin/bash
# =============================================================================
# Universal Project Starter - Quality Gate Runner
# =============================================================================
# This script delegates to type-specific analyze scripts based on project-config.json
# Each project type has its own quality gates appropriate for that stack.
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Universal Project Starter - Quality Gates                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if project-config.json exists
if [ ! -f "project-config.json" ]; then
    echo -e "${YELLOW}⚠ No project-config.json found${NC}"
    echo ""
    echo "This project hasn't been initialized yet."
    echo "Run the onboarding process first via Claude Code."
    echo ""
    exit 0
fi

# Check for jq (required to parse JSON)
if ! command -v jq &> /dev/null; then
    echo -e "${RED}✗ jq is required but not installed${NC}"
    echo ""
    echo "Install jq:"
    echo "  macOS:  brew install jq"
    echo "  Ubuntu: sudo apt-get install jq"
    echo "  Other:  https://stedolan.github.io/jq/download/"
    exit 1
fi

# Read project configuration
PROJECT_TYPE=$(jq -r '.project_type' project-config.json)
PROJECT_NAME=$(jq -r '.project_name' project-config.json)
ANALYZE_SCRIPT=$(jq -r '.scripts.analyze // empty' project-config.json)

echo -e "Project: ${GREEN}${PROJECT_NAME}${NC}"
echo -e "Type:    ${GREEN}${PROJECT_TYPE}${NC}"
echo ""

# If no analyze script specified, try the default location
if [ -z "$ANALYZE_SCRIPT" ]; then
    ANALYZE_SCRIPT="project-types/${PROJECT_TYPE}/analyze.sh"
fi

# Check if the analyze script exists
if [ ! -f "$ANALYZE_SCRIPT" ]; then
    echo -e "${RED}✗ Analyze script not found: ${ANALYZE_SCRIPT}${NC}"
    echo ""
    echo "The project type '${PROJECT_TYPE}' may not be fully configured yet."
    echo "Check that project-types/${PROJECT_TYPE}/analyze.sh exists."
    exit 1
fi

# Make sure it's executable
chmod +x "$ANALYZE_SCRIPT"

# Run the type-specific analyze script
echo -e "${BLUE}Running ${PROJECT_TYPE} quality gates...${NC}"
echo ""
exec bash "$ANALYZE_SCRIPT"
