#!/bin/bash
# update-project.sh - Push starter kit updates to a derived project
#
# This script lives in cc-project-starter and pushes starter-kit-owned
# files to derived projects. The script is always current with what
# files need updating.
#
# Usage:
#   ./update-project.sh ~/projects/my-project
#   ./update-project.sh ../my-project
#   ./update-project.sh  # will prompt

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         cc-project-starter → Update Derived Project           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get target path
if [ -n "$1" ]; then
    TARGET="$1"
else
    echo -e "${YELLOW}No target specified.${NC}"
    echo ""
    read -p "Enter path to derived project: " TARGET
fi

# Expand tilde and resolve path
TARGET="${TARGET/#\~/$HOME}"
TARGET=$(cd "$TARGET" 2>/dev/null && pwd) || {
    echo -e "${RED}ERROR: Cannot find directory: $TARGET${NC}"
    exit 1
}

echo "Source: $SCRIPT_DIR"
echo "Target: $TARGET"
echo ""

# Verify target looks like a derived project
if [ ! -f "$TARGET/project-config.json" ]; then
    echo -e "${RED}ERROR: Target doesn't look like a derived project${NC}"
    echo "       (no project-config.json found)"
    exit 1
fi

# Get current version
STARTER_VERSION=$(grep -o '"template_version": "[^"]*"' "$SCRIPT_DIR/feature_list.json" | cut -d'"' -f4)
echo -e "Starter version: ${GREEN}$STARTER_VERSION${NC}"
echo ""

# Files to update (starter-kit-owned)
echo -e "${BLUE}Updating starter-kit-owned files...${NC}"
echo ""

# startup/CLAUDE.md.template → CLAUDE.md
echo -n "  CLAUDE.md ... "
cp "$SCRIPT_DIR/startup/CLAUDE.md.template" "$TARGET/CLAUDE.md"
echo -e "${GREEN}done${NC}"

# .claude/skills/
echo -n "  .claude/skills/ ... "
mkdir -p "$TARGET/.claude"
rm -rf "$TARGET/.claude/skills"
cp -r "$SCRIPT_DIR/.claude/skills" "$TARGET/.claude/"
echo -e "${GREEN}done${NC}"

# .claude/commands/
echo -n "  .claude/commands/ ... "
mkdir -p "$TARGET/.claude"
rm -rf "$TARGET/.claude/commands"
cp -r "$SCRIPT_DIR/.claude/commands" "$TARGET/.claude/"
echo -e "${GREEN}done${NC}"

# .claude/settings.json (not settings.local.json)
echo -n "  .claude/settings.json ... "
cp "$SCRIPT_DIR/.claude/settings.json" "$TARGET/.claude/settings.json"
echo -e "${GREEN}done${NC}"

# Root delegator scripts
echo -n "  init.sh ... "
cp "$SCRIPT_DIR/init.sh" "$TARGET/init.sh"
echo -e "${GREEN}done${NC}"

echo -n "  analyze.sh ... "
cp "$SCRIPT_DIR/analyze.sh" "$TARGET/analyze.sh"
echo -e "${GREEN}done${NC}"

# project-types/
echo -n "  project-types/ ... "
rm -rf "$TARGET/project-types"
cp -r "$SCRIPT_DIR/project-types" "$TARGET/"
echo -e "${GREEN}done${NC}"

# docs/
echo -n "  docs/ ... "
rm -rf "$TARGET/docs"
cp -r "$SCRIPT_DIR/docs" "$TARGET/"
echo -e "${GREEN}done${NC}"

# templates/ (GitHub Actions, etc.)
echo -n "  templates/ ... "
rm -rf "$TARGET/templates"
cp -r "$SCRIPT_DIR/templates" "$TARGET/"
echo -e "${GREEN}done${NC}"

# onboarding/ (might be useful for reference)
echo -n "  onboarding/ ... "
rm -rf "$TARGET/onboarding"
cp -r "$SCRIPT_DIR/onboarding" "$TARGET/"
echo -e "${GREEN}done${NC}"

# Update starter_version in project-config.json
echo ""
echo -n "  Updating starter_version in project-config.json ... "
if command -v jq &> /dev/null; then
    jq --arg v "$STARTER_VERSION" '.starter_version = $v' "$TARGET/project-config.json" > "$TARGET/project-config.json.tmp"
    mv "$TARGET/project-config.json.tmp" "$TARGET/project-config.json"
    echo -e "${GREEN}done${NC}"
else
    echo -e "${YELLOW}skipped (jq not installed)${NC}"
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Update complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. cd $TARGET"
echo "  2. Run ./analyze.sh to verify everything works"
echo "  3. Review changes: git diff"
echo "  4. Commit: git add -A && git commit -m 'Update tooling from cc-project-starter $STARTER_VERSION'"
echo ""
