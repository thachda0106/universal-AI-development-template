#!/bin/bash
# OpenCode Adapter — Install Script
# Reads .ai/ canonical structure and generates .opencode/ directory + config for OpenCode
#
# Usage: bash adapters/opencode/install.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AI_DIR="$PROJECT_ROOT/.ai"
OUTPUT_DIR="$PROJECT_ROOT/output/opencode"

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
mkdir -p "$OUTPUT_DIR/.opencode/agents"
mkdir -p "$OUTPUT_DIR/.opencode/commands"
mkdir -p "$OUTPUT_DIR/.opencode/skills"
# Create other directories only if they will have content
# (modes, plugins, tools, themes remain empty for now)

# 1. Merge context files into AGENTS.md (using shared lib)
echo -e "${GREEN}✓${NC} Generating AGENTS.md from context files"
merge_context_files "$AI_DIR" "$OUTPUT_DIR/AGENTS.md" "# OpenCode Agent Instructions" "OpenCode"

# 2. Add OpenCode-specific instructions
echo -e "${GREEN}✓${NC} Adding OpenCode-specific instructions"
cat >> "$OUTPUT_DIR/AGENTS.md" << 'EOF'

## For OpenCode Sessions

1. **Read `.ai/` first**: Understand the canonical structure before making changes
2. **Run validation**: Use `bash .ai/scripts/validate-template.sh` to check integrity
3. **Update manifest**: When adding agents/workflows/skills, update `AI_MANIFEST.yaml`
4. **Test adapters**: After changes, install adapters to verify translation works
5. **Respect boundaries**: Follow safety rules in `BOUNDARIES.md`, especially approval gates
EOF

# 3. Copy AGENTS.md to .opencode/ directory as well
cp "$OUTPUT_DIR/AGENTS.md" "$OUTPUT_DIR/.opencode/AGENTS.md"

# 4. Create opencode.json configuration in project root
echo -e "${GREEN}✓${NC} Creating opencode.json configuration with security permissions and 11 MCP servers"
cat > "$OUTPUT_DIR/opencode.json" << 'EOF'
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
  "permission": {
    "read": {
      "*": "allow",
      ".env": "deny",
      ".env.*": "deny",
      "**/terraform.tfvars": "deny",
      "**/terraform.tfvars.*": "deny",
      "**/terraform.tfstate": "deny",
      "**/terraform.tfstate.*": "deny",
      "**/secrets/**": "deny",
      "**/credentials.json": "deny"
    },
    "edit": {
      "*": "allow",
      "**/dist/**": "deny",
      "**/node_modules/**": "deny"
    },
    "bash": {
      "*": "allow",
      "rm * -rf *": "deny",
      "rm * -r *": "deny",
      "rm -rf *": "deny",
      "rm -r *": "deny",
      "git push *": "deny",
      "git push": "deny",
      "git reset --hard *": "deny",
      "git reset --hard": "deny"
    },
    "external_directory": {
      "*": "ask"
    }
  },
  "mcp": {
    "prisma-mcp-server": {
      "type": "local",
      "command": ["npx", "-y", "prisma", "mcp"]
    },
    "sequential-thinking": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-sequential-thinking"]
    },
    "context7": {
      "type": "local",
      "command": ["npx", "-y", "@upstash/context7-mcp@2.0.2"]
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
      ]
    },
    "postgres-mcp": {
      "type": "local",
      "command": ["uvx", "postgres-mcp", "--access-mode=unrestricted"],
      "environment": {
        "DATABASE_URI": "postgresql://postgres:123456@localhost:5432/postgres"
      }
    },
    "pdf-reader-mcp": {
      "type": "local",
      "command": ["npx", "-y", "-q", "@sylphx/pdf-reader-mcp"]
    },
    "playwright": {
      "type": "local",
      "command": ["npx", "-y", "@playwright/mcp@latest"]
    },
    "chrome-devtools": {
      "type": "local",
      "command": ["npx", "-y", "chrome-devtools-mcp@latest"]
    },
    "docker": {
      "type": "local",
      "command": ["uvx", "mcp-server-docker"]
    },
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@github/github-mcp-server"],
      "environment": {
        "GITHUB_TOKEN": "{env:GITHUB_TOKEN}"
      }
    },
    "brave-search": {
      "type": "local",
      "command": ["npx", "-y", "@anthropic-ai/brave-search-mcp"],
      "environment": {
        "BRAVE_API_KEY": "{env:BRAVE_API_KEY}"
      }
    }
  }
}
EOF

# 4a. Append agent definitions to opencode.json
echo -e "${GREEN}✓${NC} Adding agent definitions to opencode.json"
# Remove the root closing } (last line), then add comma to mcp closing brace
sed -i '$ { /^}$/d }' "$OUTPUT_DIR/opencode.json"
sed -i '$ s/$/,/' "$OUTPUT_DIR/opencode.json"
# Count agents to avoid trailing comma on last entry
AGENT_COUNT=$(ls -1 "$AI_DIR"/agents/*.agent.md 2>/dev/null | wc -l)
CURRENT=0
{
    echo '  "agent": {'
    for f in "$AI_DIR"/agents/*.agent.md; do
        [ -f "$f" ] || continue
        CURRENT=$((CURRENT + 1))
        BASENAME=$(basename "$f" .agent.md)
        DESC=$(grep '^description:' "$f" | head -1 | sed 's/^description: *//' || true)
        # Escape double quotes in description for JSON
        DESC=$(echo "$DESC" | sed 's/"/\\"/g')
        # Set permissions based on agent role
        case "$BASENAME" in
            code-reviewer) PERM='"edit": "deny"' ;;
            doc-keeper) PERM='"bash": "ask"' ;;
            *) PERM='"edit": "allow", "bash": "allow"' ;;
        esac
        echo "    \"$BASENAME\": {"
        echo "      \"description\": \"$DESC\","
        echo "      \"mode\": \"subagent\","
        echo "      \"prompt\": \"{file:./.opencode/agents/$BASENAME.md}\","
        if [ $CURRENT -lt $AGENT_COUNT ]; then
            echo "      \"permission\": { $PERM }"
            echo "    },"
        else
            echo "      \"permission\": { $PERM }"
            echo "    }"
        fi
    done
    echo '  },'
    echo '  "skills": {'
    echo '    "paths": [".opencode/skills"]'
    echo '  }'
    echo '}'
} >> "$OUTPUT_DIR/opencode.json"

# 5. Also create opencode.json in .opencode/ directory
cp "$OUTPUT_DIR/opencode.json" "$OUTPUT_DIR/.opencode/opencode.json"

# 6. Copy agents from .ai/agents/ to .opencode/agents/
echo -e "${GREEN}✓${NC} Copying agents to .opencode/agents/"
for f in "$AI_DIR"/agents/*.agent.md; do
    [ -f "$f" ] || continue
    BASENAME=$(basename "$f" .agent.md)
    cp "$f" "$OUTPUT_DIR/.opencode/agents/$BASENAME.md"
done

# 7. Copy workflows from .ai/workflows/ to .opencode/commands/
echo -e "${GREEN}✓${NC} Copying workflows to .opencode/commands/"
for f in "$AI_DIR"/workflows/*.md; do
    [ -f "$f" ] || continue
    cp "$f" "$OUTPUT_DIR/.opencode/commands/$(basename "$f")"
done

# 8. Copy skills from .ai/skills/ to .opencode/skills/
echo -e "${GREEN}✓${NC} Copying skills to .opencode/skills/"
for d in "$AI_DIR"/skills/*/; do
    [ -d "$d" ] || continue
    DIRNAME=$(basename "$d")
    mkdir -p "$OUTPUT_DIR/.opencode/skills/$DIRNAME"
    if [ -f "$d/SKILL.md" ]; then
        cp "$d/SKILL.md" "$OUTPUT_DIR/.opencode/skills/$DIRNAME/SKILL.md"
    fi
    # Copy any other files in the skill directory
    for f in "$d"*; do
        [ -f "$f" ] || continue
        if [ "$(basename "$f")" != "SKILL.md" ]; then
            cp "$f" "$OUTPUT_DIR/.opencode/skills/$DIRNAME/$(basename "$f")"
        fi
    done
done

echo ""
echo -e "${GREEN}=== OpenCode adapter installed successfully ===${NC}"
echo ""
echo "Generated files:"
echo "  output/opencode/              (OpenCode adapter output)"
echo "    ├── .opencode/agents/       ($(ls -1 "$OUTPUT_DIR/.opencode/agents/" 2>/dev/null | wc -l) agent files)"
echo "    ├── .opencode/commands/     ($(ls -1 "$OUTPUT_DIR/.opencode/commands/" 2>/dev/null | wc -l) command files)"
echo "    ├── .opencode/skills/       ($(ls -1d "$OUTPUT_DIR/.opencode/skills"/*/ 2>/dev/null | wc -l) skill modules)"
echo "    ├── AGENTS.md               (merged context + OpenCode instructions)"
echo "    └── opencode.json           (project-level OpenCode configuration with security + MCP)"
echo ""
echo "Note: OpenCode loads configuration from multiple sources with .opencode/ directory"
echo "having highest priority for agents, commands, and skills."
echo "MCP servers are configured in opencode.json (disabled by default)."