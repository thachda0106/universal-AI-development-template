#!/bin/bash
# OpenCode Adapter — Install Script
# Reads .ai/ canonical structure and generates .opencode/ directory + config for OpenCode
#
# Usage: bash adapters/opencode/install.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AI_DIR="$PROJECT_ROOT/.ai"

# Load shared library
source "$PROJECT_ROOT/.ai/scripts/_lib.sh"
parse_flags "$@"

echo -e "${BLUE}=== OpenCode Adapter Install ===${NC}"
echo ""

# Verify .ai/ exists
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
        echo -e "${YELLOW}  Adapter will proceed, but life-engineering workflows require journal_path.${NC}"
        echo ""
    else
        echo -e "${GREEN}✓${NC} life-engineering config: journal_path = $JOURNAL_PATH"
    fi
else
    echo -e "${YELLOW}⚠ WARNING: life-engineering config not found at $LIFE_CONFIG${NC}"
    echo -e "${YELLOW}  Life Systems Engineering is available but not configured.${NC}"
    echo -e "${YELLOW}  Run 'bash .ai/scripts/setup-life-engineering.sh' to set up your journal.${NC}"
    echo ""
fi

echo -e "${BLUE}Creating .opencode/ directory structure...${NC}"
mkdir -p "$PROJECT_ROOT/.opencode/agents"
mkdir -p "$PROJECT_ROOT/.opencode/commands"
mkdir -p "$PROJECT_ROOT/.opencode/skills"
# Create other directories only if they will have content
# (modes, plugins, tools, themes remain empty for now)

# 1. Merge context files into AGENTS.md (using shared lib)
echo -e "${GREEN}✓${NC} Generating AGENTS.md from context files"
merge_context_files "$AI_DIR" "$PROJECT_ROOT/AGENTS.md" "# OpenCode Agent Instructions" "OpenCode"

# 2. Add OpenCode-specific instructions
echo -e "${GREEN}✓${NC} Adding OpenCode-specific instructions"
cat >> "$PROJECT_ROOT/AGENTS.md" << 'EOF'

## For OpenCode Sessions

1. **Read `.ai/` first**: Understand the canonical structure before making changes
2. **Run validation**: Use `bash .ai/scripts/validate-template.sh` to check integrity
3. **Update manifest**: When adding agents/workflows/skills, update `AI_MANIFEST.yaml`
4. **Test adapters**: After changes, install adapters to verify translation works
5. **Respect boundaries**: Follow safety rules in `BOUNDARIES.md`, especially approval gates
EOF

# 3. Copy AGENTS.md to .opencode/ directory as well
cp "$PROJECT_ROOT/AGENTS.md" "$PROJECT_ROOT/.opencode/AGENTS.md"

# 4. Create opencode.json configuration in project root
echo -e "${GREEN}✓${NC} Creating opencode.json configuration with MCP servers"
cat > "$PROJECT_ROOT/opencode.json" << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["AGENTS.md"],
  "tools": {
    "bash": true,
    "read": true,
    "glob": true,
    "grep": true,
    "edit": true,
    "write": true,
    "task": true,
    "webfetch": true,
    "todowrite": true,
    "question": true
  },
  "mcp": {
    "prisma-mcp-server": {
      "type": "local",
      "command": ["npx", "-y", "prisma", "mcp"],
      "enabled": false
    },
    "sequential-thinking": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-sequential-thinking"],
      "enabled": false
    },
    "context7": {
      "type": "local",
      "command": ["npx", "-y", "@upstash/context7-mcp@2.0.2"],
      "enabled": false
    },
    "serena": {
      "type": "local",
      "command": [
        "uvx",
        "--from",
        "git+https://github.com/oraios/serena",
        "serena",
        "start-mcp-server",
        "--context",
        "claude-code"
      ],
      "enabled": false
    },
    "postgres-mcp": {
      "type": "local",
      "command": ["uvx", "postgres-mcp", "--access-mode=unrestricted"],
      "enabled": false,
      "environment": {
        "DATABASE_URI": "postgresql://postgres:123456@localhost:5432/postgres"
      }
    },
    "pdf-reader-mcp": {
      "type": "local",
      "command": ["npx", "-y", "-q", "@sylphx/pdf-reader-mcp"],
      "enabled": false
    }
  }
}
EOF

# 5. Also create opencode.json in .opencode/ directory
cp "$PROJECT_ROOT/opencode.json" "$PROJECT_ROOT/.opencode/opencode.json"

# 6. Copy agents from .ai/agents/ to .opencode/agents/
echo -e "${GREEN}✓${NC} Copying agents to .opencode/agents/"
for f in "$AI_DIR"/agents/*.agent.md; do
    [ -f "$f" ] || continue
    BASENAME=$(basename "$f" .agent.md)
    cp "$f" "$PROJECT_ROOT/.opencode/agents/$BASENAME.md"
done

# 7. Copy workflows from .ai/workflows/ to .opencode/commands/
echo -e "${GREEN}✓${NC} Copying workflows to .opencode/commands/"
for f in "$AI_DIR"/workflows/*.md; do
    [ -f "$f" ] || continue
    cp "$f" "$PROJECT_ROOT/.opencode/commands/$(basename "$f")"
done

# 8. Copy skills from .ai/skills/ to .opencode/skills/
echo -e "${GREEN}✓${NC} Copying skills to .opencode/skills/"
for d in "$AI_DIR"/skills/*/; do
    [ -d "$d" ] || continue
    DIRNAME=$(basename "$d")
    mkdir -p "$PROJECT_ROOT/.opencode/skills/$DIRNAME"
    if [ -f "$d/SKILL.md" ]; then
        cp "$d/SKILL.md" "$PROJECT_ROOT/.opencode/skills/$DIRNAME/SKILL.md"
    fi
    # Copy any other files in the skill directory
    for f in "$d"*; do
        [ -f "$f" ] || continue
        if [ "$(basename "$f")" != "SKILL.md" ]; then
            cp "$f" "$PROJECT_ROOT/.opencode/skills/$DIRNAME/$(basename "$f")"
        fi
    done
done

echo ""
echo -e "${GREEN}=== OpenCode adapter installed successfully ===${NC}"
echo ""
echo "Generated files:"
echo "  .opencode/                    (OpenCode directory structure)"
echo "    ├── agents/                 ($(ls -1 "$PROJECT_ROOT/.opencode/agents/" 2>/dev/null | wc -l) agent files)"
echo "    ├── commands/               ($(ls -1 "$PROJECT_ROOT/.opencode/commands/" 2>/dev/null | wc -l) command files)"
echo "    ├── skills/                 ($(ls -1d "$PROJECT_ROOT/.opencode/skills"/*/ 2>/dev/null | wc -l) skill modules)"
echo "    └── opencode.json           (OpenCode configuration with MCP servers)"
echo "  AGENTS.md                    (merged context + OpenCode instructions)"
echo "  opencode.json                (project-level OpenCode configuration with MCP servers)"
echo ""
echo "Note: OpenCode loads configuration from multiple sources with .opencode/ directory"
echo "having highest priority for agents, commands, and skills."
echo "MCP servers are configured in opencode.json (disabled by default)."