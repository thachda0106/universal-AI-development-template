#!/bin/bash
# Aider Adapter — Install Script
# Reads .ai/ canonical structure and generates .aider.conf.yml + CONVENTIONS.md for Aider
#
# Usage: bash adapters/aider/install.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AI_DIR="$PROJECT_ROOT/.ai"

# Load shared library
source "$PROJECT_ROOT/.ai/scripts/_lib.sh"
parse_flags "$@"

echo -e "${BLUE}=== Aider Adapter Install ===${NC}"
echo ""

if [ ! -d "$AI_DIR" ]; then
    echo -e "${RED}ERROR: .ai/ directory not found at $AI_DIR${NC}"
    exit 1
fi

# Verify life-engineering config exists before installing
LIFE_CONFIG="$AI_DIR/../life-config.yaml"
if [ -f "$LIFE_CONFIG" ]; then
    JOURNAL_PATH=$(grep "^journal_path:" "$LIFE_CONFIG" | sed 's/^journal_path: *"\(.*\)"/\1/' | sed 's/^journal_path: *\(.*\)/\1/')
    if [ -z "$JOURNAL_PATH" ] || [ "$JOURNAL_PATH" = "null" ] || [[ "$JOURNAL_PATH" == *"CHANGE THIS"* ]]; then
        echo -e "${YELLOW}⚠ WARNING: life-engineering config found but journal_path is not set.${NC}"
        echo -e "${YELLOW}  Run 'bash .ai/scripts/setup-life-engineering.sh' first.${NC}"
        echo ""
    else
        echo -e "${GREEN}✓${NC} life-engineering config: journal_path = $JOURNAL_PATH"
    fi
else
    echo -e "${YELLOW}⚠ WARNING: life-engineering config not found at $LIFE_CONFIG${NC}"
    echo -e "${YELLOW}  Run 'bash .ai/scripts/setup-life-engineering.sh' to configure.${NC}"
    echo ""
fi

# 1. Generate CONVENTIONS.md (using shared lib)
echo -e "${GREEN}✓${NC} Generating CONVENTIONS.md"
merge_context_files "$AI_DIR" "$PROJECT_ROOT/CONVENTIONS.md" "# AI Coding Conventions" "Aider"

# 2. Generate .aider.conf.yml
echo -e "${GREEN}✓${NC} Generating .aider.conf.yml"
cat > "$PROJECT_ROOT/.aider.conf.yml" <<EOF
# Aider Configuration
# Auto-generated from .ai/ by Aider adapter
# Do not edit directly. Edit .ai/context/ files and re-run adapter.

# Read convention files automatically
read:
  - CONVENTIONS.md

# Auto-commit settings
auto-commits: true

# MCP Servers configuration
mcp-servers:
  prisma-mcp-server:
    command: npx
    args:
      - -y
      - prisma
      - mcp
    disabled: true
  sequential-thinking:
    command: npx
    args:
      - -y
      - "@modelcontextprotocol/server-sequential-thinking"
    disabled: true
  context7:
    command: npx
    args:
      - -y
      - "@upstash/context7-mcp@2.0.2"
    disabled: true
  serena:
    command: uvx
    args:
      - "--from"
      - "git+https://github.com/oraios/serena"
      - serena
      - "start-mcp-server"
      - "--context"
      - "claude-code"
    disabled: true
  postgres-mcp:
    command: uvx
    args:
      - postgres-mcp
      - "--access-mode=unrestricted"
    env:
      DATABASE_URI: "postgresql://postgres:123456@localhost:5432/postgres"
    disabled: true
  pdf-reader-mcp:
    command: npx
    args:
      - -y
      - -q
      - "@sylphx/pdf-reader-mcp"
    disabled: true
EOF

echo ""
echo -e "${GREEN}=== Aider adapter installed successfully ===${NC}"
echo ""
echo "Generated files:"
echo "  .aider.conf.yml    (Aider configuration)"
echo "  CONVENTIONS.md     (merged context + system prompt for Aider to read)"
echo ""
echo "Usage: aider will automatically read CONVENTIONS.md on startup."
