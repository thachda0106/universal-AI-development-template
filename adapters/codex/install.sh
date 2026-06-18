#!/bin/bash
# Codex Adapter — Install Script
# Reads .ai/ canonical structure and generates AGENTS.md + config.toml for OpenAI Codex CLI
#
# Usage: bash adapters/codex/install.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AI_DIR="$PROJECT_ROOT/.ai"
OUTPUT_DIR="$PROJECT_ROOT/output/codex"
CODEX_DIR="$OUTPUT_DIR/.codex"

# Load shared library
source "$PROJECT_ROOT/.ai/scripts/_lib.sh"
parse_flags "$@"

echo -e "${BLUE}=== Codex Adapter Install ===${NC}"
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
    echo -e "${YELLOW}  Run 'bash .ai/scripts/setup-life-engineering.sh' to configure.${NC}"
    echo ""
fi

# Create output directories (everything under .codex/ — Codex expects ~/.codex/*)
echo -e "${BLUE}Creating output directories...${NC}"
mkdir -p "$CODEX_DIR/skills"
mkdir -p "$CODEX_DIR/rules"
mkdir -p "$CODEX_DIR/agents"
mkdir -p "$CODEX_DIR/docs/agents"
mkdir -p "$CODEX_DIR/docs/workflows"

# 1. Merge context files into AGENTS.md (using shared lib)
echo -e "${GREEN}✓${NC} Generating AGENTS.md from context files"
merge_context_files "$AI_DIR" "$CODEX_DIR/AGENTS.md" "# Codex Agent Instructions" "Codex"

# 1b. Copy context files as standalone reference files
echo -e "${GREEN}✓${NC} Copying context files to .codex/context/"
copy_context_files "$AI_DIR" "$CODEX_DIR"

# 1a. Append security rules to AGENTS.md
echo -e "${GREEN}✓${NC} Adding security rules to AGENTS.md"
cat >> "$CODEX_DIR/AGENTS.md" << 'EOF'

## Security Rules

Never read: `.env`, `.env.*`, `**/terraform.tfvars`, `**/terraform.tfvars.*`, `**/terraform.tfstate`, `**/terraform.tfstate.*`, `/secrets/**`, `/config/credentials.json`
Never execute: `rm -rf`, `rm-rf`, `git push`, `git reset --hard`
Never edit: `/dist/**`, `/node_modules/**`
Never expose secrets, credentials, or API keys in code, logs, or documentation
EOF

# 2. Copy skills to .codex/skills/ (Codex native skill format — SKILL.md with YAML frontmatter)
echo -e "${GREEN}✓${NC} Copying skills to .codex/skills/"
for d in "$AI_DIR"/skills/*/; do
    [ -d "$d" ] || continue
    DIRNAME=$(basename "$d")
    mkdir -p "$CODEX_DIR/skills/$DIRNAME"
    if [ -f "$d/SKILL.md" ]; then
        cp "$d/SKILL.md" "$CODEX_DIR/skills/$DIRNAME/SKILL.md"
    fi
    # Copy bundled resources (scripts, references, assets)
    for sub in scripts references assets; do
        if [ -d "$d/$sub" ]; then
            cp -r "$d/$sub" "$CODEX_DIR/skills/$DIRNAME/"
        fi
    done
done
# Copy skills README if present
if [ -f "$AI_DIR/skills/README.md" ]; then
    cp "$AI_DIR/skills/README.md" "$CODEX_DIR/skills/README.md"
fi

# 3. Copy agents as reference docs
echo -e "${GREEN}✓${NC} Copying agents as reference docs"
for f in "$AI_DIR"/agents/*.agent.md; do
    [ -f "$f" ] || continue
    BASENAME=$(basename "$f" .agent.md)
    cp "$f" "$CODEX_DIR/docs/agents/$BASENAME.md"
done

# 3a. Generate Codex agent config files (.codex/agents/<name>.toml)
echo -e "${GREEN}✓${NC} Generating agent config files"
for f in "$AI_DIR"/agents/*.agent.md; do
    [ -f "$f" ] || continue
    BASENAME=$(basename "$f" .agent.md)
    DESCRIPTION=$(grep '^description:' "$f" | head -1 | sed 's/^description: *//')
    # Extract agent body (everything after frontmatter closing ---)
    BODY=$(awk 'BEGIN{count=0} /^---$/{count++; if(count<=2) next} count>=2' "$f")
    {
        echo "# Agent: $BASENAME"
        echo "# $DESCRIPTION"
        echo "#"
        echo "# Agent role configuration for Codex CLI."
        echo "# Referenced by config.toml [agents.$BASENAME].config_file"
        echo "#"
        echo "# Full agent instructions are in docs/agents/$BASENAME.md"
        echo "# and in AGENTS.md workflow index."
        echo ""
        echo "# --- Agent Instructions ---"
        while IFS= read -r line || [ -n "$line" ]; do
            echo "# $line"
        done <<< "$BODY"
    } > "$CODEX_DIR/agents/$BASENAME.toml"
done

# 4. Copy workflows as reference docs
echo -e "${GREEN}✓${NC} Copying workflows as reference docs"
for f in "$AI_DIR"/workflows/*.md; do
    [ -f "$f" ] || continue
    cp "$f" "$CODEX_DIR/docs/workflows/$(basename "$f")"
done

# 4a. Append workflow index to AGENTS.md so Codex knows which workflow to load
echo -e "${GREEN}✓${NC} Adding workflow index to AGENTS.md"
{
    echo ""
    echo "## Available Workflows"
    echo ""
    echo "When asked to perform a task below, load the workflow file from docs/workflows/ and follow it step by step:"
    echo ""
    for f in "$AI_DIR"/workflows/*.md; do
        [ -f "$f" ] || continue
        BASENAME=$(basename "$f" .md)
        DESCRIPTION=$(grep '^description:' "$f" | head -1 | sed 's/^description: *//' || true)
        AGENT=$(grep '^agent:' "$f" | head -1 | sed 's/^agent: *//' || true)
        echo "- **$BASENAME**: $DESCRIPTION (agent: $AGENT)"
    done
} >> "$CODEX_DIR/AGENTS.md"

# 4b. Convert workflows to Codex skills (slash commands)
echo -e "${GREEN}✓${NC} Converting workflows to Codex skills"
for f in "$AI_DIR"/workflows/*.md; do
    [ -f "$f" ] || continue
    WF_NAME=$(basename "$f" .md)
    # Skip sub-phase files and meta-workflows
    case "$WF_NAME" in
        build-large-system-phases-*) continue ;;
        ai-workflow) continue ;;
    esac
    WF_DESC=$(grep '^description:' "$f" | head -1 | sed 's/^description: *//')
    WF_BODY=$(awk 'BEGIN{count=0} /^---$/{count++; if(count<=2) next} count>=2' "$f")
    mkdir -p "$CODEX_DIR/skills/$WF_NAME"
    {
        echo "---"
        echo "name: $WF_NAME"
        echo "description: $WF_DESC"
        echo "---"
        echo ""
        echo "$WF_BODY"
    } > "$CODEX_DIR/skills/$WF_NAME/SKILL.md"
done

# 5. Copy prompt templates as reference
echo -e "${GREEN}✓${NC} Copying prompt templates"
for f in "$AI_DIR"/prompts/templates/*; do
    [ -f "$f" ] || continue
    cp "$f" "$CODEX_DIR/docs/$(basename "$f")"
done

# 5a. Populate rules directory with security boundaries
echo -e "${GREEN}✓${NC} Writing security rules to .codex/rules/"
cat > "$CODEX_DIR/rules/security.md" << 'RULESEOF'
# Security Rules

## Never Read
- `.env`, `.env.*`
- `**/terraform.tfvars`, `**/terraform.tfvars.*`
- `**/terraform.tfstate`, `**/terraform.tfstate.*`
- `/secrets/**`
- `/config/credentials.json`

## Never Execute
- `rm -rf`
- `rm -rf` (any variation)
- `git push`
- `git reset --hard`

## Never Edit
- `/dist/**`
- `/node_modules/**`

## Never Expose
- Secrets, credentials, or API keys in code, logs, or documentation
RULESEOF

# 6. Generate config.toml with MCP servers and permissions
echo -e "${GREEN}✓${NC} Creating config.toml with 12 MCP servers"
cat > "$CODEX_DIR/config.toml" << 'EOF'
# Codex Configuration
# Auto-generated from .ai/ by Codex adapter
# Do not edit directly. Edit .ai/context/ files and re-run adapter.
#
# Copy to ~/.codex/config.toml or use with --config flag

approval_policy = "on-request"
sandbox_mode = "workspace-write"

[sandbox_workspace_write]
network_access = true

# MCP Servers (11 servers, all enabled)
# Codex has no per-server disabled flag — remove a [mcp_servers.<name>] block to disable

[mcp_servers.prisma-mcp-server]
command = "npx"
args = ["-y", "prisma", "mcp"]

[mcp_servers.sequential-thinking]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-sequential-thinking"]

[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp@2.0.2"]

[mcp_servers.serena]
command = "uvx"
args = ["--from", "git+https://github.com/oraios/serena", "serena", "start-mcp-server", "--context", "claude-code"]

[mcp_servers.postgres-mcp]
command = "uvx"
args = ["postgres-mcp", "--access-mode=unrestricted"]
[mcp_servers.postgres-mcp.env]
DATABASE_URI = "postgresql://postgres:123456@localhost:5432/postgres"

[mcp_servers.pdf-reader-mcp]
command = "npx"
args = ["-y", "-q", "@sylphx/pdf-reader-mcp"]

[mcp_servers.playwright]
command = "npx"
args = ["-y", "@playwright/mcp@latest"]

[mcp_servers.chrome-devtools]
command = "npx"
args = ["-y", "chrome-devtools-mcp@latest"]

[mcp_servers.docker]
command = "uvx"
args = ["mcp-server-docker"]

[mcp_servers.github]
command = "npx"
args = ["-y", "@github/github-mcp-server"]
[mcp_servers.github.env]
GITHUB_TOKEN = "${GITHUB_TOKEN}"

[mcp_servers.codegraph]
command = "npx"
args = ["-y", "@colbymchenry/codegraph", "serve", "--mcp"]

[mcp_servers.brave-search]
command = "npx"
args = ["-y", "@anthropic-ai/brave-search-mcp"]
[mcp_servers.brave-search.env]
BRAVE_API_KEY = "${BRAVE_API_KEY}"
EOF

# 6a. Append agent definitions to config.toml
echo -e "${GREEN}✓${NC} Adding agent definitions to config.toml"
{
    echo ""
    echo "# Custom Agents ($(ls -1 "$AI_DIR/agents"/*.agent.md 2>/dev/null | wc -l) agents)"
    echo "# Each agent has a corresponding config file in .codex/agents/<name>.toml"
    echo ""
    echo "[agents]"
    echo "max_threads = 5"
    echo "max_depth = 2"
    echo ""
} >> "$CODEX_DIR/config.toml"

for f in "$AI_DIR"/agents/*.agent.md; do
    [ -f "$f" ] || continue
    BASENAME=$(basename "$f" .agent.md)
    DESCRIPTION=$(grep '^description:' "$f" | head -1 | sed 's/^description: *//')
    # Generate nicknames based on agent role
    case "$BASENAME" in
        bug-hunter) NICKS='["Sherlock", "Debugger", "Watson"]' ;;
        code-reviewer) NICKS='["Reviewer", "Inspector", "Auditor"]' ;;
        doc-keeper) NICKS='["Librarian", "Scribe", "Archivist"]' ;;
        feature-builder) NICKS='["Builder", "Architect", "Creator"]' ;;
        life-engineer) NICKS='["Coach", "Mentor", "Guide"]' ;;
        performance-optimizer) NICKS='["Racer", "Tuner", "Optimizer"]' ;;
        test-engineer) NICKS='["Tester", "Validator", "QA"]' ;;
        *) NICKS='["Agent"]' ;;
    esac
    {
        echo "[agents.$BASENAME]"
        echo "description = \"$DESCRIPTION\""
        echo "config_file = \"./agents/$BASENAME.toml\""
        echo "nickname_candidates = $NICKS"
        echo ""
    } >> "$CODEX_DIR/config.toml"
done

echo ""
echo -e "${GREEN}=== Codex adapter installed successfully ===${NC}"
echo ""
echo "Generated files:"
echo "  output/codex/.codex/        (Codex adapter output — copy to ~/.codex/)"
echo "    ├── AGENTS.md              (merged context + system prompt + security rules + workflow index)"
echo "    ├── config.toml            (12 MCP servers + 7 custom agents + permissions + sandbox config)"
echo "    ├── agents/                ($(ls -1 "$CODEX_DIR/agents"/*.toml 2>/dev/null | wc -l) agent config files)"
echo "    ├── skills/                ($(ls -1d "$CODEX_DIR/skills"/*/ 2>/dev/null | wc -l) skill + workflow modules)"
echo "    ├── rules/                 (security boundary rules)"
echo "    └── docs/                  (agent definitions + workflow docs + prompt templates)"
echo ""
echo "Usage: Copy the .codex/ directory to ~/.codex/:"
echo "  cp -r output/codex/.codex ~/.codex"
