# Codex Global Config

Copy to install as global Codex configuration:

## Linux / macOS
```bash
cp config.toml ~/.codex/config.toml
cp AGENTS.md ~/.codex/AGENTS.md
cp -r agents/ ~/.codex/agents/
cp -r skills/ ~/.agents/skills/
```

## Windows (PowerShell)
```powershell
Copy-Item config.toml "$env:USERPROFILE\.codex\config.toml"
Copy-Item AGENTS.md "$env:USERPROFILE\.codex\AGENTS.md"
Copy-Item -Recurse agents "$env:USERPROFILE\.codex\agents"
Copy-Item -Recurse skills "$env:USERPROFILE\.agents\skills"
```

## What's included

| Directory | Destination | Contents |
|-----------|-------------|----------|
| `config.toml` | `~/.codex/config.toml` | MCP servers (11), custom agents (7), sandbox/approval |
| `AGENTS.md` | `~/.codex/AGENTS.md` | Global instructions, coding conventions, workflow index |
| `agents/` | `~/.codex/agents/` | 7 subagent definitions (bug-hunter, code-reviewer, etc.) |
| `skills/` | `~/.agents/skills/` | 33 reusable agent skills |
