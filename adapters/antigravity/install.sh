#!/bin/bash
# Antigravity Adapter — Install Script
# Reads .ai/ canonical structure and generates .agent/ + .gemini/ for Antigravity IDE
#
# Usage: bash adapters/antigravity/install.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AI_DIR="$PROJECT_ROOT/.ai"
OUTPUT_DIR="$PROJECT_ROOT/output/antigravity"

# Load shared library
source "$PROJECT_ROOT/.ai/scripts/_lib.sh"
parse_flags "$@"

echo -e "${BLUE}=== Antigravity Adapter Install ===${NC}"
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
mkdir -p "$OUTPUT_DIR/.agent/workflows"
mkdir -p "$OUTPUT_DIR/.agent/skills"
mkdir -p "$OUTPUT_DIR/.agent/scripts"
mkdir -p "$OUTPUT_DIR/.agent/docs"
mkdir -p "$OUTPUT_DIR/.agent/rules"
mkdir -p "$OUTPUT_DIR/.gemini"

# 1. Merge context files into .gemini/STYLE.md (using shared lib)
echo -e "${GREEN}✓${NC} Generating .gemini/STYLE.md from context files"
merge_context_files "$AI_DIR" "$OUTPUT_DIR/.gemini/STYLE.md" "# Project AI Instructions" "Antigravity"

# 2. Copy workflows
echo -e "${GREEN}✓${NC} Copying workflows"
for f in "$AI_DIR"/workflows/*.md; do
    [ -f "$f" ] || continue
    cp "$f" "$OUTPUT_DIR/.agent/workflows/$(basename "$f")"
done

# 3. Copy skills (using shared lib)
echo -e "${GREEN}✓${NC} Copying skills"
copy_skills "$AI_DIR/skills" "$OUTPUT_DIR/.agent/skills"

# 4. Copy scripts (exclude template-level scripts)
echo -e "${GREEN}✓${NC} Copying scripts"
for f in "$AI_DIR"/scripts/*; do
    [ -f "$f" ] || continue
    BASENAME=$(basename "$f")
    case "$BASENAME" in
        install-ai-template.sh|migrate-from-claude.sh|validate-template.sh|_lib.sh) continue ;;
    esac
    cp "$f" "$OUTPUT_DIR/.agent/scripts/$BASENAME"
done

# 5. Copy docs
echo -e "${GREEN}✓${NC} Copying docs"
for f in "$AI_DIR"/docs/*; do
    [ -f "$f" ] || continue
    cp "$f" "$OUTPUT_DIR/.agent/docs/$(basename "$f")"
done
# Copy doc subdirectories
for d in "$AI_DIR"/docs/*/; do
    [ -d "$d" ] || continue
    DIRNAME=$(basename "$d")
    mkdir -p "$OUTPUT_DIR/.agent/docs/$DIRNAME"
    cp -r "$d"* "$OUTPUT_DIR/.agent/docs/$DIRNAME/" 2>/dev/null || true
done

# 6. Copy README
if [ -f "$AI_DIR/README.md" ]; then
    cp "$AI_DIR/README.md" "$OUTPUT_DIR/.agent/README.md"
fi

# 7. Create MCP configuration for Antigravity
echo -e "${GREEN}✓${NC} Creating MCP configuration with 11 servers for Antigravity"
cat > "$OUTPUT_DIR/.agent/config.json" << 'EOF'
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

# 8. Create security rules for Antigravity
echo -e "${GREEN}✓${NC} Creating security rules for Antigravity"
cat > "$OUTPUT_DIR/.agent/rules/security.md" << 'EOF'
---
description: Security boundaries — files and commands the agent must never touch
---

# Security Boundaries

## Forbidden File Reads
Never read these files or directories:
- `.env` and `.env.*`
- `**/terraform.tfvars` and `**/terraform.tfvars.*`
- `**/terraform.tfstate` and `**/terraform.tfstate.*`
- `/secrets/**`
- `/config/credentials.json`

## Forbidden Commands
Never execute:
- `rm -rf` and `rm-rf`
- `git push`
- `git reset --hard`

## Forbidden File Edits
Never modify files in:
- `/dist/**`
- `/node_modules/**`

## Data Safety
Never expose secrets, credentials, or API keys in code, logs, or documentation
EOF

echo ""
echo -e "${GREEN}=== Antigravity adapter installed successfully ===${NC}"
echo ""
echo "Generated files:"
echo "  output/antigravity/          (Antigravity adapter output)"
echo "    ├── .gemini/STYLE.md        (merged context + system prompt)"
echo "    ├── .agent/workflows/       ($(ls -1 "$OUTPUT_DIR/.agent/workflows/" 2>/dev/null | wc -l) workflow files)"
echo "    ├── .agent/skills/          ($(ls -1d "$OUTPUT_DIR/.agent/skills"/*/ 2>/dev/null | wc -l) skill modules)"
echo "    ├── .agent/scripts/         ($(ls -1 "$OUTPUT_DIR/.agent/scripts/" 2>/dev/null | wc -l) scripts)"
echo "    ├── .agent/docs/            ($(ls -1 "$OUTPUT_DIR/.agent/docs/" 2>/dev/null | wc -l) docs)"
echo "    ├── .agent/rules/security.md (security boundaries)"
echo "    └── .agent/config.json      (MCP server configuration)"
