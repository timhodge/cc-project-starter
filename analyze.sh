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
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Universal Project Starter - Quality Gates                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# =============================================================================
# Feature Dependency Check
# =============================================================================
# Checks if any in_progress features have unmet dependencies.
# This is a STOP AND ASK condition - work should not proceed until resolved.
# =============================================================================

check_feature_dependencies() {
    if [ ! -f "feature_list.json" ]; then
        return 0  # No feature list, skip check
    fi

    if ! command -v jq &> /dev/null; then
        return 0  # No jq, skip check (will error later anyway)
    fi

    local has_unmet=false
    local unmet_report=""

    # Find all in_progress features
    local in_progress_features=$(jq -r '.features[] | select(.status == "in_progress") | .id' feature_list.json 2>/dev/null)

    for feat_id in $in_progress_features; do
        # Get the feature's depends_on array
        local depends_on=$(jq -r --arg id "$feat_id" '.features[] | select(.id == $id) | .depends_on[]?' feature_list.json 2>/dev/null)

        for dep_id in $depends_on; do
            # Check if the dependency is complete
            local dep_status=$(jq -r --arg id "$dep_id" '.features[] | select(.id == $id) | .status' feature_list.json 2>/dev/null)

            if [ "$dep_status" != "complete" ]; then
                has_unmet=true
                local feat_name=$(jq -r --arg id "$feat_id" '.features[] | select(.id == $id) | .name' feature_list.json 2>/dev/null)
                local dep_name=$(jq -r --arg id "$dep_id" '.features[] | select(.id == $id) | .name' feature_list.json 2>/dev/null)
                unmet_report="${unmet_report}\n  ${feat_id} (${feat_name})\n    └── requires ${dep_id} (${dep_name}) [status: ${dep_status:-not found}]"
            fi
        done
    done

    if [ "$has_unmet" = true ]; then
        echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${MAGENTA}║  ⚠  STOP AND ASK: Unmet Feature Dependencies                  ║${NC}"
        echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}The following in_progress features have dependencies that are not passing:${NC}"
        echo -e "$unmet_report"
        echo ""
        echo -e "${YELLOW}Options:${NC}"
        echo "  1. Complete the dependency first"
        echo "  2. Remove/change the dependency if it's incorrect"
        echo "  3. Ask user if you should proceed anyway"
        echo ""
        return 1
    fi

    return 0
}

# Run dependency check first
if ! check_feature_dependencies; then
    echo -e "${YELLOW}Dependency check failed. Resolve before proceeding.${NC}"
    exit 1
fi

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
