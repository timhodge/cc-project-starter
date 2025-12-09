#!/bin/bash
# =============================================================================
# Universal Project Starter - Development Environment Initializer
# =============================================================================
# This script delegates to type-specific init scripts based on project-config.json
# If no project is configured yet, it provides guidance on getting started.
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Universal Project Starter - Init                         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if project-config.json exists
if [ ! -f "project-config.json" ]; then
    echo -e "${YELLOW}⚠ No project-config.json found${NC}"
    echo ""
    echo "This project hasn't been initialized yet."
    echo ""
    echo "To get started:"
    echo "  1. Open this project in Claude Code"
    echo "  2. Say: \"read CLAUDE.md and let's go\""
    echo "  3. Answer the onboarding questions"
    echo ""
    echo "Claude will guide you through project setup and create the necessary configuration."
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
INIT_SCRIPT=$(jq -r '.scripts.init // empty' project-config.json)

echo -e "Project: ${GREEN}${PROJECT_NAME}${NC}"
echo -e "Type:    ${GREEN}${PROJECT_TYPE}${NC}"
echo ""

# If no init script specified, try the default location
if [ -z "$INIT_SCRIPT" ]; then
    INIT_SCRIPT="project-types/${PROJECT_TYPE}/init.sh"
fi

# Check if the init script exists
if [ ! -f "$INIT_SCRIPT" ]; then
    echo -e "${RED}✗ Init script not found: ${INIT_SCRIPT}${NC}"
    echo ""
    echo "The project type '${PROJECT_TYPE}' may not be fully configured yet."
    echo "Check that project-types/${PROJECT_TYPE}/init.sh exists."
    exit 1
fi

# Make sure it's executable
chmod +x "$INIT_SCRIPT"

# Run the type-specific init script
echo -e "${BLUE}Running ${PROJECT_TYPE} initialization...${NC}"
echo ""
exec bash "$INIT_SCRIPT"
