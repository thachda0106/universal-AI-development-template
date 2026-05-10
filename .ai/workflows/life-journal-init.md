---
description: Initialize the Life Systems Engineering journal — create directory structure, baseline files, and git repo
agent: life-engineer
---

# Life Journal Init

Initialize the persistent journal for the Life Systems Engineering system. Run this once after setting up the life-engineer agent and commands. Creates the directory structure, baseline files, and optionally initializes a git repository for multi-device sync.

> **When**: Once, immediately after setting up the Life Engineering system
> **Duration**: 5 minutes
> **Config**: Read `journal_path` from `.ai/life-config.yaml`

---

## PHASE 1 — CHECK

Verify current state:

1. **Check if journal already exists**: Does the `{journal_path}` exist with the full structure? (Read path from `.ai/life-config.yaml`)
2. **Check git status**: Is there already a git repo? Is a remote configured?
3. **Check existing data**: Are there any existing journal files from previous runs?

**Output**: `SCRATCHPAD.md` with current state

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Check) complete. Please review SCRATCHPAD.md.
Reply APPROVE to initialize the journal, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — INITIALIZE

**Scratchpad must be APPROVED.**

1. **Create directory structure** (if not already present):
   ```
   daily/       time-series/   events/   incidents/
   decisions/   weekly/        meta/
   ```

2. **Create config** `journal.yaml` (read `journal_path` from `.ai/life-config.yaml`):
   ```yaml
   repo_path: "{journal_path}"
   git_auto: true
   git_auto_push: true
   created_at: "YYYY-MM-DD"
   version: 1
   ```

3. **Create baselines** `meta/baselines.json` — empty baseline template

4. **Create CSV headers** in `time-series/`:
   - `energy.csv`: `date,period,level,activity,notes`
   - `focus.csv`: `date,session_id,score,duration_min,distractions,notes`
   - `mood.csv`: `date,timestamp,emotion,intensity,category,trigger,regulation,effectiveness`
   - `sleep.csv`: `date,hours,quality,bedtime,waketime,notes`

5. **Create event CSV headers** in `events/`:
   - `triggers.csv`: `date,timestamp,emotion,intensity,trigger,context,narrative,urge,deviation_type,regulation,effectiveness`
   - `distortions.csv`: `date,distortion_type,original_thought,severity,reframe`

6. **Git init** (if not already):
   - `git init`
   - Create `.gitignore` for OS files
   - Create initial commit: `git add -A && git commit -m "init: journal structure"`

7. **Instructions for GitHub remote**:
   ```
   1. Create a private repo on GitHub: github.com/new (name: life-journal)
   2. Run:
      git remote add origin https://github.com/YOUR_USERNAME/life-journal.git
      git push -u origin main
   ```

**Output**: `PLAN.md` with initialization results

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Initialization) complete. Please review PLAN.md.
Reply APPROVE to verify, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — VERIFY

**Plan must be APPROVED.**

1. Verify directory structure:
   ```
   life-journal/
   ├── daily/           (empty)
   ├── time-series/     (4 CSV files with headers)
   ├── events/          (2 CSV files with headers)
   ├── incidents/       (empty)
   ├── decisions/       (empty)
   ├── weekly/          (empty)
   └── meta/            (baselines.json)
   ```

2. Verify git status: `git log --oneline` shows initial commit

3. Run `/life-baseline-update` if there's existing data to compute baselines

**Output**: Confirmation that journal is ready

---

// turbo
