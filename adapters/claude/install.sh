#!/bin/bash
# Claude Code Adapter — Install Script
# Reads .ai/ canonical structure and generates .claude/ + CLAUDE.md for Claude Code
#
# Usage: bash adapters/claude/install.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AI_DIR="$PROJECT_ROOT/.ai"
OUTPUT_DIR="$PROJECT_ROOT/output/claude"

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
mkdir -p "$OUTPUT_DIR/.claude/agents"
mkdir -p "$OUTPUT_DIR/.claude/commands"
mkdir -p "$OUTPUT_DIR/.claude/skills"
mkdir -p "$OUTPUT_DIR/.claude/scripts"
mkdir -p "$OUTPUT_DIR/.claude/prompts"
mkdir -p "$OUTPUT_DIR/.claude/docs"

# 1. Merge context files into CLAUDE.md (using shared lib)
echo -e "${GREEN}✓${NC} Generating CLAUDE.md from context files"
merge_context_files "$AI_DIR" "$OUTPUT_DIR/CLAUDE.md" "# CLAUDE.md" "Claude Code"

# 1b. Copy context files as standalone reference files
echo -e "${GREEN}✓${NC} Copying context files to .claude/context/"
copy_context_files "$AI_DIR" "$OUTPUT_DIR/.claude"

# 1a. Append security rules to CLAUDE.md
echo -e "${GREEN}✓${NC} Adding security rules to CLAUDE.md"
cat >> "$OUTPUT_DIR/CLAUDE.md" << 'EOF'

## Security Rules

Never read: `.env`, `.env.*`, `**/terraform.tfvars`, `**/terraform.tfvars.*`, `**/terraform.tfstate`, `**/terraform.tfstate.*`, `/secrets/**`, `/config/credentials.json`
Never execute: `rm -rf`, `rm-rf`, `git push`, `git reset --hard`
Never edit: `/dist/**`, `/node_modules/**`
Never expose secrets, credentials, or API keys in code, logs, or documentation
EOF

# Helper: map skill name to human-readable capability phrase
skill_to_capability() {
    case "$1" in
        locate-code-patterns) echo "Locate code patterns in codebase" ;;
        analyze-project-structure) echo "Analyze project structure and dependencies" ;;
        trace-execution-flow) echo "Trace execution flow through system" ;;
        diagnose-bug-root-cause) echo "Diagnose bug root cause" ;;
        apply-targeted-fix) echo "Apply targeted code fixes" ;;
        verify-bug-regression) echo "Verify bug fixes and regression testing" ;;
        validate-architecture) echo "Validate code against architecture rules" ;;
        life-engineering-daily-practices) echo "Apply life engineering daily practices" ;;
        *) echo "$1" ;;
    esac
}

# 2. Convert agents to Claude format
echo -e "${GREEN}✓${NC} Converting agents to Claude format"
for f in "$AI_DIR"/agents/*.agent.md; do
    [ -f "$f" ] || continue
    BASENAME=$(basename "$f" .agent.md)
    DESC=$(grep '^description:' "$f" | head -1 | sed 's/^description: *//' || true)
    # Extract skill lines from YAML frontmatter (between --- markers)
    SKILLS=$(sed -n '/^skills:/,/^[a-z]/p' "$f" | grep '^  - ' | sed 's/^  - //' || true)
    # Extract body after frontmatter closing ---
    BODY=$(awk 'BEGIN{count=0} /^---$/{count++; if(count<=2) next} count>=2' "$f")
    {
        echo "---"
        echo "description: $DESC"
        if [ -n "$SKILLS" ]; then
            echo "capabilities:"
            echo "$SKILLS" | while IFS= read -r skill || [ -n "$skill" ]; do
                [ -z "$skill" ] && continue
                CAP=$(skill_to_capability "$skill")
                echo "  - $CAP"
            done
        fi
        echo "---"
        echo ""
        echo "$BODY"
    } > "$OUTPUT_DIR/.claude/agents/$BASENAME.md"
done

# 3. Convert workflows to Claude command format
echo -e "${GREEN}✓${NC} Converting workflows to Claude commands"
for f in "$AI_DIR"/workflows/*.md; do
    [ -f "$f" ] || continue
    BASENAME=$(basename "$f" .md)
    DESC=$(grep '^description:' "$f" | head -1 | sed 's/^description: *//' || true)
    # Extract body after frontmatter closing ---
    BODY=$(awk 'BEGIN{count=0} /^---$/{count++; if(count<=2) next} count>=2' "$f")
    {
        echo "---"
        echo "description: $DESC"
        echo "allowed-tools: Read, Bash, Edit, Write, Glob, Grep"
        echo "---"
        echo ""
        echo "$BODY"
    } > "$OUTPUT_DIR/.claude/commands/$BASENAME.md"
done

# 4. Copy skills (using shared lib)
echo -e "${GREEN}✓${NC} Copying skills"
copy_skills "$AI_DIR/skills" "$OUTPUT_DIR/.claude/skills"

# 5. Copy scripts (exclude template-level scripts)
echo -e "${GREEN}✓${NC} Copying scripts"
for f in "$AI_DIR"/scripts/*; do
    [ -f "$f" ] || continue
    BASENAME=$(basename "$f")
    case "$BASENAME" in
        install-ai-template.sh|migrate-from-claude.sh|validate-template.sh|_lib.sh) continue ;;
    esac
    cp "$f" "$OUTPUT_DIR/.claude/scripts/$BASENAME"
done

# 6. Copy prompts
echo -e "${GREEN}✓${NC} Copying prompt templates"
for f in "$AI_DIR"/prompts/templates/*; do
    [ -f "$f" ] || continue
    cp "$f" "$OUTPUT_DIR/.claude/prompts/$(basename "$f")"
done

# 7. Copy docs
echo -e "${GREEN}✓${NC} Copying docs"
for f in "$AI_DIR"/docs/*; do
    [ -f "$f" ] || continue
    cp "$f" "$OUTPUT_DIR/.claude/docs/$(basename "$f")"
done

# 8. Create MCP configuration for Claude Code
echo -e "${GREEN}✓${NC} Creating MCP configuration with 12 servers for Claude Code"
cat > "$OUTPUT_DIR/.claude/config.json" << 'EOF'
{
  "mcpServers": {
    "prisma-mcp-server": {
      "command": "npx",
      "args": [
        "-y",
        "prisma",
        "mcp"
      ]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sequential-thinking"
      ]
    },
    "context7": {
      "command": "npx",
      "args": [
        "-y",
        "@upstash/context7-mcp@2.0.2"
      ]
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
      ]
    },
    "postgres-mcp": {
      "command": "uvx",
      "args": [
        "postgres-mcp",
        "--access-mode=unrestricted"
      ],
      "env": {
        "DATABASE_URI": "postgresql://postgres:123456@localhost:5432/postgres"
      }
    },
    "pdf-reader-mcp": {
      "command": "npx",
      "args": [
        "-y",
        "-q",
        "@sylphx/pdf-reader-mcp"
      ]
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"]
    },
    "docker": {
      "command": "uvx",
      "args": ["mcp-server-docker"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@github/github-mcp-server"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "codegraph": {
      "command": "npx",
      "args": ["-y", "@colbymchenry/codegraph", "serve", "--mcp"]
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/brave-search-mcp"],
      "env": {
        "BRAVE_API_KEY": "${BRAVE_API_KEY}"
      }
    }
  }
}
EOF

# 9. Create security settings for Claude Code
echo -e "${GREEN}✓${NC} Creating security settings for Claude Code"
cat > "$OUTPUT_DIR/.claude/settings.json" << 'EOF'
{
  "permissions": {
    "disableBypassPermissionsMode": "disable",
    "deny": [
      "WebSearch",
      "WebFetch"
    ],
    "ask": [
      "Bash"
    ]
  }
}
EOF

echo ""
echo -e "${GREEN}=== Claude Code adapter installed successfully ===${NC}"
echo ""
echo "  output/claude/              (Claude Code adapter output)"
echo "    ├── CLAUDE.md              (merged context + system prompt + security rules)"
echo "    ├── .claude/agents/        ($(ls -1 "$OUTPUT_DIR/.claude/agents/" 2>/dev/null | wc -l) agent files)"
echo "    ├── .claude/commands/      ($(ls -1 "$OUTPUT_DIR/.claude/commands/" 2>/dev/null | wc -l) command files)"
echo "    ├── .claude/skills/        ($(ls -1d "$OUTPUT_DIR/.claude/skills"/*/ 2>/dev/null | wc -l) skill modules)"
echo "    ├── .claude/scripts/       ($(ls -1 "$OUTPUT_DIR/.claude/scripts/" 2>/dev/null | wc -l) scripts)"
echo "    ├── .claude/config.json    (MCP server configuration)"
echo "    └── .claude/settings.json  (security permissions)"
