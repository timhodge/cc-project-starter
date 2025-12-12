#!/bin/bash
# =============================================================================
# Project Startup Script
# =============================================================================
# Run this ONCE after cloning the template to set up your project files.
# This script will:
#   1. Copy template files to the project root
#   2. Delete itself and the startup/ folder
#
# After running, you're ready to start Claude Code.
# =============================================================================

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Project Startup Script                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Safety check: don't run if this looks like the starter kit itself
if [ -f "$PROJECT_ROOT/feature_list.json" ]; then
    FEAT_COUNT=$(grep -c '"id": "FEAT-' "$PROJECT_ROOT/feature_list.json" 2>/dev/null || echo "0")
    if [ "$FEAT_COUNT" -gt 10 ]; then
        echo -e "${RED}ERROR: This appears to be the starter kit itself (found $FEAT_COUNT features).${NC}"
        echo -e "${RED}This script is meant for derived projects only.${NC}"
        echo ""
        exit 1
    fi
fi

# Check for existing files that would be overwritten
EXISTING_FILES=""
for file in CLAUDE.md CLAUDE.project.md feature_list.json feature_list_archive.json ideas.md ideas_archive.md claude-progress.txt lessons-learned.json; do
    if [ -f "$PROJECT_ROOT/$file" ]; then
        EXISTING_FILES="$EXISTING_FILES $file"
    fi
done

if [ -n "$EXISTING_FILES" ]; then
    echo -e "${YELLOW}Warning: The following files already exist and will be overwritten:${NC}"
    echo "$EXISTING_FILES"
    echo ""
    read -p "Continue? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Copy templates to project root
echo "Setting up project files..."

cp "$SCRIPT_DIR/CLAUDE.md.template" "$PROJECT_ROOT/CLAUDE.md"
echo "  Created CLAUDE.md"

cp "$SCRIPT_DIR/CLAUDE.project.md.template" "$PROJECT_ROOT/CLAUDE.project.md"
echo "  Created CLAUDE.project.md"

cp "$SCRIPT_DIR/feature_list.json.template" "$PROJECT_ROOT/feature_list.json"
echo "  Created feature_list.json"

cp "$SCRIPT_DIR/feature_list_archive.json.template" "$PROJECT_ROOT/feature_list_archive.json"
echo "  Created feature_list_archive.json"

cp "$SCRIPT_DIR/ideas.md.template" "$PROJECT_ROOT/ideas.md"
echo "  Created ideas.md"

cp "$SCRIPT_DIR/ideas_archive.md.template" "$PROJECT_ROOT/ideas_archive.md"
echo "  Created ideas_archive.md"

cp "$SCRIPT_DIR/claude-progress.txt.template" "$PROJECT_ROOT/claude-progress.txt"
echo "  Created claude-progress.txt"

cp "$SCRIPT_DIR/lessons-learned.json.template" "$PROJECT_ROOT/lessons-learned.json"
echo "  Created lessons-learned.json"

echo ""

# Delete the startup folder (including this script)
echo "Cleaning up startup folder..."
rm -rf "$SCRIPT_DIR"
echo "  Deleted startup/"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Ready for Claude Code!                                        ║${NC}"
echo -e "${GREEN}║                                                                ║${NC}"
echo -e "${GREEN}║  Next steps:                                                   ║${NC}"
echo -e "${GREEN}║    1. Review CLAUDE.md to understand the workflow              ║${NC}"
echo -e "${GREEN}║    2. Run: claude                                              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
