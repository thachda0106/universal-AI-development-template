#!/bin/bash
# Cursor Adapter — Install Script
# Reads .ai/ canonical structure and generates .cursorrules for Cursor IDE
#
# Usage: bash adapters/cursor/install.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AI_DIR="$PROJECT_ROOT/.ai"
OUTPUT_DIR="$PROJECT_ROOT/output/cursor"

# Load shared library
source "$PROJECT_ROOT/.ai/scripts/_lib.sh"
parse_flags "$@"

echo -e "${BLUE}=== Cursor Adapter Install ===${NC}"
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

# Cursor uses a single .cursorrules file at the project root.
# We merge all context files + system prompt + agent summaries into it.
echo -e "${GREEN}✓${NC} Generating .cursorrules from context files"
{
    echo "# Cursor AI Rules"
    echo "# Auto-generated from .ai/context/ by Cursor adapter"
    echo "# Do not edit directly. Edit .ai/context/ files and re-run adapter."
    echo ""

    if [ -f "$AI_DIR/context/PROJECT.md" ]; then
        cat "$AI_DIR/context/PROJECT.md"
        echo ""
    fi

    if [ -f "$AI_DIR/context/CONVENTIONS.md" ]; then
        cat "$AI_DIR/context/CONVENTIONS.md"
        echo ""
    fi

    if [ -f "$AI_DIR/context/BOUNDARIES.md" ]; then
        cat "$AI_DIR/context/BOUNDARIES.md"
        echo ""
    fi

    if [ -f "$AI_DIR/prompts/system.md" ]; then
        cat "$AI_DIR/prompts/system.md"
    fi

    # Append agent summaries as context for Cursor
    echo ""
    echo "---"
    echo ""
    echo "# Agent Personas"
    echo ""
    echo "When working on different task types, adopt the following personas:"
    echo ""
    for f in "$AI_DIR"/agents/*.agent.md; do
        [ -f "$f" ] || continue
        AGENT_NAME=$(basename "$f" .agent.md)
        DESCRIPTION=$(grep '^description:' "$f" | head -1 | sed 's/^description: *//')
        echo "- **$AGENT_NAME**: $DESCRIPTION"
    done
} > "$OUTPUT_DIR/.cursorrules"

# 1b. Copy context files as standalone reference files
echo -e "${GREEN}✓${NC} Copying context files to .cursor/context/"
copy_context_files "$AI_DIR" "$OUTPUT_DIR/.cursor"

# Create MCP configuration for Cursor (in .cursor/config.json)
echo -e "${GREEN}✓${NC} Creating Cursor configuration with security permissions and 11 MCP servers"
mkdir -p "$OUTPUT_DIR/.cursor"
cat > "$OUTPUT_DIR/.cursor/config.json" << 'EOF'
{
  "permissions": {
    "allow": [
      "Shell(ls)",
      "Shell(git status)",
      "Shell(git diff)",
      "Shell(git log)",
      "Shell(grep)",
      "Shell(find)",
      "Shell(npm)",
      "Shell(yarn)",
      "Shell(pnpm)"
    ],
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(**/terraform.tfvars)",
      "Read(**/terraform.tfvars.*)",
      "Read(**/terraform.tfstate)",
      "Read(**/terraform.tfstate.*)",
      "Read(**/secrets/**)",
      "Read(**/config/credentials.json)",
      "Shell(rm -rf)",
      "Shell(git push)",
      "Shell(git reset --hard)",
      "Write(dist/**)",
      "Write(node_modules/**)"
    ]
  },
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

echo ""
echo -e "${GREEN}=== Cursor adapter installed successfully ===${NC}"
echo ""
echo "Generated files:"
echo "  output/cursor/              (Cursor adapter output)"
echo "    ├── .cursorrules           (merged context + system prompt + agent summaries)"
echo "    └── .cursor/config.json    (security permissions + MCP server configuration)"
echo ""
echo "Note: Cursor doesn't support workflows or skills natively."
echo "These are embedded in .cursorrules as context."
