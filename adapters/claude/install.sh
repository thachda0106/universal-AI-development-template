#!/bin/bash
# Claude Code Adapter — Install Script
# Reads .ai/ canonical structure and generates .claude/ + CLAUDE.md for Claude Code
#
# Usage: bash adapters/claude/install.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AI_DIR="$PROJECT_ROOT/.ai"

# Load shared library
source "$PROJECT_ROOT/.ai/scripts/_lib.sh"
parse_flags "$@"

echo -e "${BLUE}=== Claude Code Adapter Install ===${NC}"
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

# Create target directories
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p "$PROJECT_ROOT/.claude/agents"
mkdir -p "$PROJECT_ROOT/.claude/commands"
mkdir -p "$PROJECT_ROOT/.claude/skills"
mkdir -p "$PROJECT_ROOT/.claude/scripts"
mkdir -p "$PROJECT_ROOT/.claude/prompts"
mkdir -p "$PROJECT_ROOT/.claude/docs"

# 1. Merge context files into CLAUDE.md (using shared lib)
echo -e "${GREEN}✓${NC} Generating CLAUDE.md from context files"
merge_context_files "$AI_DIR" "$PROJECT_ROOT/CLAUDE.md" "# CLAUDE.md" "Claude Code"

# 2. Convert agents
echo -e "${GREEN}✓${NC} Converting agents"
for f in "$AI_DIR"/agents/*.agent.md; do
    [ -f "$f" ] || continue
    BASENAME=$(basename "$f" .agent.md)
    cp "$f" "$PROJECT_ROOT/.claude/agents/$BASENAME.md"
done

# 3. Convert workflows → commands
echo -e "${GREEN}✓${NC} Converting workflows to commands"
for f in "$AI_DIR"/workflows/*.md; do
    [ -f "$f" ] || continue
    cp "$f" "$PROJECT_ROOT/.claude/commands/$(basename "$f")"
done

# 4. Copy skills (using shared lib)
echo -e "${GREEN}✓${NC} Copying skills"
copy_skills "$AI_DIR/skills" "$PROJECT_ROOT/.claude/skills"

# 5. Copy scripts (exclude template-level scripts)
echo -e "${GREEN}✓${NC} Copying scripts"
for f in "$AI_DIR"/scripts/*; do
    [ -f "$f" ] || continue
    BASENAME=$(basename "$f")
    case "$BASENAME" in
        install-ai-template.sh|migrate-from-claude.sh|validate-template.sh|_lib.sh) continue ;;
    esac
    cp "$f" "$PROJECT_ROOT/.claude/scripts/$BASENAME"
done

# 6. Copy prompts
echo -e "${GREEN}✓${NC} Copying prompt templates"
for f in "$AI_DIR"/prompts/templates/*; do
    [ -f "$f" ] || continue
    cp "$f" "$PROJECT_ROOT/.claude/prompts/$(basename "$f")"
done

# 7. Copy docs
echo -e "${GREEN}✓${NC} Copying docs"
for f in "$AI_DIR"/docs/*; do
    [ -f "$f" ] || continue
    cp "$f" "$PROJECT_ROOT/.claude/docs/$(basename "$f")"
done

# 8. Create MCP configuration for Claude Code
echo -e "${GREEN}✓${NC} Creating MCP configuration for Claude Code"
cat > "$PROJECT_ROOT/.claude/config.json" << 'EOF'
{
  "mcpServers": {
    "prisma-mcp-server": {
      "command": "npx",
      "args": [
        "-y",
        "prisma",
        "mcp"
      ],
      "disabled": true
    },
    "sequential-thinking": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sequential-thinking"
      ],
      "disabled": true
    },
    "context7": {
      "command": "npx",
      "args": [
        "-y",
        "@upstash/context7-mcp@2.0.2"
      ],
      "disabled": true
    },
    "serena": {
      "command": "uvx",
      "args": [
        "--from",
        "git+https://github.com/oraios/serena",
        "serena",
        "start-mcp-server",
        "--context",
        "claude-code"
      ],
      "disabled": true
    },
    "postgres-mcp": {
      "command": "uvx",
      "args": [
        "postgres-mcp",
        "--access-mode=unrestricted"
      ],
      "env": {
        "DATABASE_URI": "postgresql://postgres:123456@localhost:5432/postgres"
      },
      "disabled": true
    },
    "pdf-reader-mcp": {
      "command": "npx",
      "args": [
        "-y",
        "-q",
        "@sylphx/pdf-reader-mcp"
      ],
      "disabled": true
    }
  }
}
EOF

echo ""
echo -e "${GREEN}=== Claude Code adapter installed successfully ===${NC}"
echo ""
echo "Generated files:"
echo "  CLAUDE.md                  (merged context + system prompt)"
echo "  .claude/agents/            ($(ls -1 "$PROJECT_ROOT/.claude/agents/" 2>/dev/null | wc -l) agent files)"
echo "  .claude/commands/          ($(ls -1 "$PROJECT_ROOT/.claude/commands/" 2>/dev/null | wc -l) command files)"
echo "  .claude/skills/            ($(ls -1d "$PROJECT_ROOT/.claude/skills"/*/ 2>/dev/null | wc -l) skill modules)"
echo "  .claude/scripts/           ($(ls -1 "$PROJECT_ROOT/.claude/scripts/" 2>/dev/null | wc -l) scripts)"
echo "  .claude/config.json        (MCP server configuration)"
