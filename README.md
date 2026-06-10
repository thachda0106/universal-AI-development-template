# Universal AI Development Template

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A **tool-agnostic AI development template** that works across OpenCode, Claude Code, Antigravity, Cursor, Aider, Codex, and future AI IDEs.

Define your AI agents, workflows, skills, and conventions **once** in a canonical `.ai/` directory. Adapters translate them into tool-native formats automatically.

## Architecture

```
.ai/                     ← Canonical source of truth (tool-agnostic)
├── AI_MANIFEST.yaml     ← Template metadata and module registry
├── context/             ← Project-level AI instructions
│   ├── PROJECT.md       ← What: tech stack, commands, architecture
│   ├── CONVENTIONS.md   ← How: coding standards, naming rules
│   └── BOUNDARIES.md    ← Don't: forbidden actions, safety constraints
├── agents/              ← AI persona definitions (24 canonical agents)
├── workflows/           ← Step-by-step task automation (30 workflows)
│   ├── build-large-system.md          ← 🏗️ 30-phase system development lifecycle
│   ├── build-large-system-phases-*.md ← Detailed phase descriptions
│   ├── build-minimum-system.md        ← 🚀 9-phase compressed lifecycle
│   ├── create-feature.md              ← Feature development workflow
│   ├── fix-bug.md                     ← Bug fixing workflow
│   ├── daily-system-boot.md           ← 🧬 Morning boot sequence
│   ├── daily-system-shutdown.md       ← 🌙 Evening shutdown & metrics
│   ├── daily-focus-session.md         ← ⚡ Deep work execution
│   ├── daily-emotional-observability.md ← ❤️ Emotional state check
│   ├── daily-cognitive-scan.md        ← 🧠 Cognitive distortion detection
│   ├── daily-energy-audit.md          ← 🔋 Energy drain analysis
│   ├── weekly-life-architecture-review.md ← 📊 Weekly retro & planning
│   ├── life-incident-response.md      ← 🚨 Emotional crisis protocol
│   ├── life-decision-log.md           ← 📝 Decision record with EV calc
│   ├── life-journal-init.md           ← 🏁 Initialize journal repository
│   ├── life-metrics-query.md          ← 🔍 Query accumulated life data
│   └── life-baseline-update.md        ← 📈 Recompute anomaly thresholds
├── skills/              ← Atomic, reusable procedures (8 skills)
├── prompts/             ← Reusable prompt fragments and templates
├── scripts/             ← Automation (install, validate, migrate, setup)
└── docs/                ← Documentation

adapters/                ← Tool-specific translation layers
├── opencode/             ← OpenCode → AGENTS.md + opencode.json + .opencode/
├── claude/              ← Claude Code → CLAUDE.md + .claude/
├── antigravity/         ← Antigravity → .gemini/ + .agent/
├── cursor/              ← Cursor → .cursorrules + .cursor/
├── aider/               ← Aider → CONVENTIONS.md + .aider.conf.yml
└── codex/               ← Codex → AGENTS.md + config.toml

output/                  ← Generated adapter output (gitignored)
├── opencode/            ← AGENTS.md, opencode.json, .opencode/
├── claude/              ← CLAUDE.md, .claude/
├── cursor/              ← .cursorrules, .cursor/
├── antigravity/         ← .gemini/, .agent/
├── aider/               ← CONVENTIONS.md, .aider.conf.yml
└── codex/               ← AGENTS.md, config.toml
```

## Quick Start

### 1. Copy the template

Copy `.ai/` and `adapters/` into your project root.

### 2. Fill in context files

Edit these files with your project's details:

| File | Purpose |
|------|---------|
| `.ai/context/PROJECT.md` | Project name, tech stack, commands, architecture |
| `.ai/context/CONVENTIONS.md` | Coding standards, naming conventions |
| `.ai/context/BOUNDARIES.md` | What the AI should never do |

### 3. Install for your AI tool

```bash
# Auto-detect installed tools
bash .ai/scripts/install-ai-template.sh

# Or install a specific adapter
bash adapters/opencode/install.sh
bash adapters/claude/install.sh
bash adapters/antigravity/install.sh
bash adapters/cursor/install.sh
bash adapters/aider/install.sh
bash adapters/codex/install.sh
```

### 4. Validate

```bash
bash .ai/scripts/validate-template.sh
```

## 🏗️ Build Large System Workflow

The flagship workflow: a **30-phase BigTech-level system development lifecycle** across **8 stages**, reflecting how Amazon, Google, Netflix, Uber, and Stripe build distributed systems.

```
Stage A: Discovery & Requirements  → Phases 01–03
Stage B: Domain & Architecture     → Phases 04–11
Stage C: Platform & Infrastructure → Phases 12–16
Stage D: Service Development       → Phases 17–19
Stage E: Hardening                 → Phases 20–25
Stage F: Launch                    → Phases 26–27
Stage G: Operations                → Phases 28–29
Stage H: Evolution                 → Phase 30
```

**Get started**: Read the [Build Large System Usage Guide](.ai/docs/BUILD_LARGE_SYSTEM_GUIDE.md) for step-by-step instructions.

**Workflow files**:
- [Master overview](.ai/workflows/build-large-system.md) — Phase table, dependency graph, folder structure
- [Phases 01–10](.ai/workflows/build-large-system-phases-01-10.md) — Discovery → Architecture
- [Phases 11–20](.ai/workflows/build-large-system-phases-11-20.md) — Platform → Service Dev
- [Phases 21–30](.ai/workflows/build-large-system-phases-21-30.md) — Hardening → Operations → Evolution

## 🚀 Build Minimum System Workflow

A **compressed 9-phase workflow** derived from the 30-phase lifecycle, designed for **solo developers or small teams**. Same architectural thinking, no enterprise overhead.

```
Phase 1: Business & Domain Discovery    ← Phases 01-03
Phase 2: Architecture & Domain Design   ← Phases 04-06
Phase 3: Data, API & Contract Design    ← Phases 07-09
Phase 4: System Flows & Tech Stack      ← Phases 10-12
Phase 5: Platform Skeleton & Dev Setup  ← Phases 13-15
Phase 6: CI/CD Pipeline (lean)          ← Phase 16
Phase 7: Build: Vertical Slice → Full   ← Phases 17-19
Phase 8: Observability & Hardening      ← Phases 20-25
Phase 9: Deploy, Stabilize & Evolve     ← Phases 26-30
```

**Timeline**: ~6-8 weeks solo, ~10-14 weeks small team.

**Workflow file**: [build-minimum-system.md](.ai/workflows/build-minimum-system.md)

---

## 🧬 Life Systems Engineering

A complete daily practice system that applies **software engineering principles to human life** — treating your mind, emotions, energy, and decisions as a production system requiring observability, debugging, and architecture.

```
AGENT:       life-engineer                    ← Applies engineering thinking to life
SKILL:       life-engineering-daily-practices ← 9 daily practice procedures
CONFIG:      .ai/life-config.yaml              ← Per-device journal path

DAILY ROUTINE (all times approximate)
═══════════════════════════════════════
🌅  Morning (10 min):   daily-system-boot     ← Initialize state, allocate attention
☀️  Mid-day (5 min):    daily-emotional-observability ← Check emotional metrics
⚡  Before focus:       daily-focus-session   ← Single-threaded execution
🌙  Evening (10 min):   daily-system-shutdown  ← Collect metrics, log, commit
📊  Weekly (30 min):    weekly-life-architecture-review ← Trend analysis, debt assessment

ON-DEMAND
🚨  life-incident-response    ← Emotional crisis: triage → RCA → postmortem
📝  life-decision-log         ← Decision ADR with expected value, follow-up
🔍  life-metrics-query        ← Query accumulated data: trends, patterns, follow-ups
```

All daily data is stored in a **version-controlled journal repository** (your own private git repo). Each command auto-commits to git, enabling multi-device sync via GitHub, full history with `git log`, and trend analysis across days/weeks/months.

### Setup on a New Device

```bash
# 1. Run setup FIRST — prompts for your journal path, creates directory structure
bash .ai/scripts/setup-life-engineering.sh

# 2. Connect to your private GitHub repo
cd /path/to/your/life-journal
git remote add origin https://github.com/YOUR_USERNAME/life-journal.git
git push -u origin master

# 3. Install adapter — verifies config exists before proceeding
bash adapters/opencode/install.sh   # or claude, cursor, aider, antigravity
```

### How It Works

| Component | Purpose | Reads | Writes |
|-----------|---------|-------|--------|
| `.ai/life-config.yaml` | Per-device journal path | — | Configured once |
| `.ai/agents/life-engineer.agent.md` | Life engineer persona | Config, workflows | — |
| `.ai/skills/life-engineering-daily-practices/SKILL.md` | Core procedures & analogy map | — | — |
| 12 workflow files | Daily/weekly/on-demand routines | Config, journal | Journal files |
| `life-journal/` (separate repo) | Persistent metric store | — | Daily data, decisions, incidents |

### Engineering Analogy

| Software Concept | Life Concept |
|-----------------|-------------|
| Observability stack | Self-awareness system |
| Logging | Journaling |
| Metrics / Monitoring | Habit tracking |
| Production incident | Emotional crisis |
| Incident response | Crisis management protocol |
| Technical debt | Neglected habits |
| Circuit breaker | Boundary enforcement |
| Eventual consistency | Delayed life outcomes |
| Anti-fragility | Post-traumatic growth |
| `git log` | Life history review |

## Design Principles

| Principle | Explanation |
|-----------|-------------|
| **Tool-agnostic core** | All agents, workflows, skills live in `.ai/` using generic language |
| **Adapter pattern** | Each AI tool gets a thin adapter translating `.ai/` into tool-native format |
| **Convention over configuration** | Standard filenames and YAML frontmatter |
| **Composable** | Each module (agent, skill, workflow) is independent and opt-in |
| **5-phase operating model** | Plan → Review → Execute → Verify → Reflect |

## Operating Model

Every non-trivial task follows 5 phases:

```
PLAN → REVIEW (hard stop) → EXECUTE → VERIFY → REFLECT
```

The AI creates a scratchpad, stops for human approval, implements the plan, verifies results, and reflects on what was learned.

In workflows, these phases expand into 6 detailed steps: **Scratchpad → Plan → Tasks → Execute → Verify → Reflect**, with approval gates between each phase.

## Adapters

| Feature | Claude Code | Antigravity | Cursor | Aider | OpenCode | Codex |
|---------|:-----------:|:-----------:|:------:|:-----:|:--------:|:-----:|
| Context files | ✅ CLAUDE.md | ✅ STYLE.md | ✅ .cursorrules | ✅ CONVENTIONS.md | ✅ AGENTS.md | ✅ AGENTS.md |
| Agent definitions | ✅ | ❌ (in docs) | ❌ (embedded) | ❌ | ✅ .opencode/agents/ | ❌ |
| Workflows | ✅ commands/ | ✅ workflows/ | ❌ | ❌ | ✅ .opencode/commands/ | ✅ docs/workflows/ |
| Skills | ✅ | ✅ | ❌ | ❌ | ✅ .opencode/skills/ | ✅ .codex/skills/ |
| Scripts | ✅ | ✅ | ❌ | ❌ | ✅ .opencode/ | ❌ |
| MCP servers (11) | ✅ config.json | ✅ config.json | ✅ config.json | ✅ conf.yml | ✅ opencode.json | ✅ config.toml |
| Security rules | ✅ settings.json | ✅ rules/ | ✅ config.json | ✅ CONVENTIONS.md | ✅ opencode.json | ✅ AGENTS.md |
| Life Engineering | ✅ | ✅ | ⚠️ (limited) | ⚠️ (limited) | ✅ full support | ⚠️ (limited) |
| Clean/uninstall | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Config format | JSON | JSON | JSON | YAML | JSON | TOML |

All adapter output goes into `output/<tool>/` (gitignored).

## MCP Servers

11 Model Context Protocol servers configured across all adapters, **all enabled by default**:

| # | Server | Purpose | Package |
|---|--------|---------|---------|
| 1 | **Prisma** | Database schema introspection | `npx prisma mcp` |
| 2 | **Sequential Thinking** | Structured reasoning | `@modelcontextprotocol/server-sequential-thinking` |
| 3 | **Context7** | Documentation lookup | `@upstash/context7-mcp` |
| 4 | **Serena** | Semantic code analysis (LSP) | `serena-agent` (uvx) |
| 5 | **Postgres** | PostgreSQL database operations | `postgres-mcp` (uvx) |
| 6 | **PDF Reader** | PDF content extraction | `@sylphx/pdf-reader-mcp` |
| 7 | **Playwright** | Headless browser automation | `@playwright/mcp` |
| 8 | **Chrome DevTools** | Live Chrome debugging & DevTools | `chrome-devtools-mcp` |
| 9 | **Docker** | Container management | `mcp-server-docker` (uvx) |
| 10 | **GitHub** | PRs, issues, repo management | `@github/github-mcp-server` |
| 11 | **Brave Search** | Web search for docs/solutions | `@anthropic-ai/brave-search-mcp` |

GitHub and Brave Search require environment variables (`GITHUB_TOKEN`, `BRAVE_API_KEY`).

## Security Rules

All adapters generate tool-native deny rules preventing AI agents from:

- Reading `.env`, `terraform.tfvars`, `terraform.tfstate`, `/secrets/`, `/config/credentials.json`
- Executing `rm -rf`, `git push`, `git reset --hard`
- Editing `/dist/`, `/node_modules/`
- Exposing secrets, credentials, or API keys

Rules are enforced in tool-native format: OpenCode `permission.deny`, Claude Code `settings.json`, Cursor `permissions.deny`, Antigravity `rules/security.md`, Aider `CONVENTIONS.md`, Codex `AGENTS.md`.

## Migrating from Claude Code

```bash
bash .ai/scripts/migrate-from-claude.sh
```

See [Migration Guide](.ai/docs/MIGRATION_GUIDE.md) for details.

## Adding a New Adapter

See [Adapter Guide](.ai/docs/ADAPTER_GUIDE.md) for the adapter contract specification.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding agents, workflows, skills, and adapters.

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
