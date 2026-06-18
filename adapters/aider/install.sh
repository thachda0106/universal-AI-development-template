#!/bin/bash
# Aider Adapter — Install Script
# Reads .ai/ canonical structure and generates .aider.conf.yml + CONVENTIONS.md for Aider
#
# Usage: bash adapters/aider/install.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AI_DIR="$PROJECT_ROOT/.ai"
OUTPUT_DIR="$PROJECT_ROOT/output/aider"

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
merge_context_files "$AI_DIR" "$OUTPUT_DIR/CONVENTIONS.md" "# AI Coding Conventions" "Aider"

# 1b. Copy context files as standalone reference files
echo -e "${GREEN}✓${NC} Copying context files"
copy_context_files "$AI_DIR" "$OUTPUT_DIR"

# 1a. Append security rules to CONVENTIONS.md
echo -e "${GREEN}✓${NC} Adding security rules to CONVENTIONS.md"
cat >> "$OUTPUT_DIR/CONVENTIONS.md" << 'EOF'

---

# Security Boundaries

Aider approves changes interactively by default. The following are non-negotiable rules:

- Never read: `.env`, `.env.*`, `**/terraform.tfvars`, `**/terraform.tfvars.*`, `**/terraform.tfstate`, `**/terraform.tfstate.*`, `/secrets/**`, `/config/credentials.json`
- Never execute: `rm -rf`, `rm-rf`, `git push`, `git reset --hard`
- Never edit: `/dist/**`, `/node_modules/**`
- Never expose secrets, credentials, or API keys in code, logs, or documentation
EOF

# 2. Generate .aider.conf.yml
echo -e "${GREEN}✓${NC} Generating .aider.conf.yml"
cat > "$OUTPUT_DIR/.aider.conf.yml" <<EOF
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
  sequential-thinking:
    command: npx
    args:
      - -y
      - "@modelcontextprotocol/server-sequential-thinking"
  context7:
    command: npx
    args:
      - -y
      - "@upstash/context7-mcp@2.0.2"
  serena:
    command: uvx
    args:
      - "--from"
      - "git+https://github.com/oraios/serena"
      - serena
      - "start-mcp-server"
      - "--context"
      - "claude-code"
  postgres-mcp:
    command: uvx
    args:
      - postgres-mcp
      - "--access-mode=unrestricted"
    env:
      DATABASE_URI: "postgresql://postgres:123456@localhost:5432/postgres"
  pdf-reader-mcp:
    command: npx
    args:
      - -y
      - -q
      - "@sylphx/pdf-reader-mcp"
  playwright:
    command: npx
    args:
      - -y
      - "@playwright/mcp@latest"
  chrome-devtools:
    command: npx
    args:
      - -y
      - "chrome-devtools-mcp@latest"
  docker:
    command: uvx
    args:
      - "mcp-server-docker"
  github:
    command: npx
    args:
      - -y
      - "@github/github-mcp-server"
    env:
      GITHUB_TOKEN: "${GITHUB_TOKEN}"
  codegraph:
    command: npx
    args:
      - -y
      - "@colbymchenry/codegraph"
      - serve
      - "--mcp"
  brave-search:
    command: npx
    args:
      - -y
      - "@anthropic-ai/brave-search-mcp"
    env:
      BRAVE_API_KEY: "${BRAVE_API_KEY}"
EOF

echo ""
echo -e "${GREEN}=== Aider adapter installed successfully ===${NC}"
echo ""
echo "Generated files:"
echo "  output/aider/              (Aider adapter output)"
echo "    ├── CONVENTIONS.md         (merged context + system prompt + security rules)"
echo "    └── .aider.conf.yml        (Aider configuration)"
echo ""
echo "Usage: aider will automatically read CONVENTIONS.md on startup."
