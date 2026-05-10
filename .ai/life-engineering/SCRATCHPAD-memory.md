# SCRATCHPAD — Life Systems Engineering Memory Layer

## Problem Statement

The current Life Systems Engineering commands operate as **stateless diagnostic tools** — each session boots up, collects data, generates analysis, and then loses all state. There is no persistent storage, no historical data, no trend analysis, no baseline computation, and no cross-command data sharing.

This means:
- **Cannot detect anomalies** — no baselines to compare against
- **Cannot compute trends** — weekly review has no historical query capability
- **Cannot calibrate decisions** — decision follow-ups can't be triggered automatically
- **Cannot identify patterns** — pattern recognition requires data across days/weeks
- **Cannot show progress** — no way to visualize improvement over time
- **Each session is ground zero** — no learning accumulates

## Current Data Collection Audit

### What each command collects (but loses)

| Command | Data Collected (Per Session) | Type | Persistence |
|---------|------------------------------|------|-------------|
| `daily-system-boot` | sleep quality (1-10), initial energy (1-10), initial mood (1-10), top 3 priorities, attention budget, intention | State snapshot | None — logged to transient markdown |
| `daily-system-shutdown` | energy curve (3 periods), focus quality (1-10), emotional range (min/max/current), priority completion status, decisions list, accomplishments, anomalies | Metrics + Events | None — logged to transient markdown |
| `daily-focus-session` | cognitive load (1-10), task selected, timebox, interruptions, focus quality output, post-session cognitive state | Session record | None |
| `daily-emotional-observability` | emotion(s), intensity (1-10), body sensations, trigger event, current narrative, urge, deviation type, regulation strategy, effectiveness | Event record | None |
| `daily-cognitive-scan` | recurring thoughts, decisions reviewed, reactions, self-evaluations, future predictions, social comparisons, distortion types, reframes, accuracy score | Scan record | None |
| `daily-energy-audit` | hourly energy levels, peak/trough times, recovery periods, drain list, source list, sleep hours | Time-series + Events | None |
| `life-incident-response` | SEV level, timeline, root cause, contributing factors, resolution, action items, learnings | Incident record | None |
| `life-decision-log` | decision context, options, analysis, chosen option, predicted outcome, probability, confidence, follow-up date | Decision record | None |
| `weekly-life-architecture-review` | energy avg, focus avg, emotional stability, priority completion %, debt assessment, next week goals | Aggregate | None — needs to READ 7 days of data |

### Data Flow Gaps

```
CURRENT (broken):
  Boot ──► SCRATCHPAD.md ──► PLAN.md ──► (lost)
  Shutdown ──► SCRATCHPAD.md ──► PLAN.md ──► (lost)
  Weekly Review ──► "aggregate 7 days" ──► ✗ NO DATA TO AGGREGATE

REQUIRED:
  Boot ──► life-journal/daily/2026-05-10.md + life-journal/metrics/energy.csv
  Shutdown ──► life-journal/daily/2026-05-10.md + life-journal/metrics/*.csv
  Weekly Review ──► READ life-journal/daily/2026-05-*.md ──► aggregate ──► life-journal/weekly/2026-W20.md
  Decision ──► life-journal/decisions/DEC-001.md ──► calendar reminder for follow-up
```

## Required Capabilities

The memory layer must support:

### 1. Structured Storage
- **Daily journal files**: One file per day, structured markdown with front-matter for machine parsing
- **Time-series data**: CSV files for numerical metrics (energy, focus, mood) — queryable across days
- **Event logs**: Appending log for emotional events, incident records, cognitive scans
- **Decision records**: Individual files with decision metadata (follow-up dates, status)
- **Weekly summaries**: Aggregated weekly files

### 2. Read Paths
- Weekly review reads last 7 daily files → aggregates metrics
- Emotional observability reads baselines from recent history → anomaly detection
- Decision log reads upcoming follow-up dates → reminders
- Energy audit reads recent energy patterns → trend identification

### 3. Baseline Computation
- Rolling averages for energy, focus, mood, emotional intensity
- Standard deviation for anomaly thresholds
- Typical emotional range (mode emotions, typical intensity spread)
- Energy peak/trough patterns

### 4. Query/Report Capability
- "What was my average energy this week?"
- "How does my focus today compare to last week?"
- "What are my most common emotional triggers?"
- "Which decisions had accurate predictions?"
- "What cognitive distortions recur most frequently?"

### 5. Follow-up Scheduling
- Decision follow-up dates tracked
- Weekly review auto-trigger (or user-remindable)
- Incident action item completion tracking

## Constraints

- **No external databases** — must be file-based (markdown + CSV), no SQLite, no cloud
- **No new dependencies** — works within existing OpenCode toolset (Read, Write, Bash, Grep)
- **Must be parseable** — both by humans and by the AI agent
- **Must be appendable** — time-series data grows by appending, not rewriting
- **Must survive agent resets** — data lives on disk, not in agent memory

## Proposed Directory Structure

```
C:\Users\thach\.config\opencode\
└── life-journal/
    ├── journal.yaml              # Config: baselines, thresholds, paths
    ├── daily/
    │   ├── 2026-05-10.md         # Full daily entry (boot + shutdown combined)
    │   └── 2026-05-11.md
    ├── time-series/
    │   ├── energy.csv             # date,period,level,activity
    │   ├── focus.csv              # date,session_id,score,duration_min,distractions
    │   ├── mood.csv               # date,timestamp,emotion,intensity,category
    │   └── sleep.csv              # date,hours,quality,notes
    ├── events/
    │   ├── triggers.csv           # date,timestamp,trigger,emotion,intensity,regulation,effectiveness
    │   └── distortions.csv        # date,distortion_type,thought,severity,reframe
    ├── incidents/
    │   └── INC-*.md               # Individual incident postmortems
    ├── decisions/
    │   └── DEC-*.md               # Individual decision records
    ├── weekly/
    │   └── 2026-W20.md            # Weekly architecture reviews
    └── meta/
        └── baselines.json         # Computed rolling averages and thresholds
```

## Existing Command Modification Requirements

Each command needs to be updated to:

1. **Write** structured data to the appropriate journal files at end of Phase 4 (Logging)
2. **Read** historical data where applicable (Phase 2 analysis)
3. **Reference** journal files instead of transient SCRATCHPAD.md for persisted data

### Specific modifications:

| Command | Write to | Read from |
|---------|----------|-----------|
| `daily-system-boot` | `daily/YYYY-MM-DD.md`, `time-series/sleep.csv`, `time-series/mood.csv` | — |
| `daily-system-shutdown` | `daily/YYYY-MM-DD.md`, `time-series/energy.csv`, `time-series/focus.csv`, `time-series/mood.csv` | — |
| `daily-focus-session` | `time-series/focus.csv` | — |
| `daily-emotional-observability` | `events/triggers.csv`, `time-series/mood.csv` | `meta/baselines.json` (for anomaly detection) |
| `daily-cognitive-scan` | `events/distortions.csv` | — |
| `daily-energy-audit` | `daily/YYYY-MM-DD.md` (energy section) | `time-series/energy.csv` (for pattern identification) |
| `life-incident-response` | `incidents/INC-*.md`, `daily/YYYY-MM-DD.md` (reference) | — |
| `life-decision-log` | `decisions/DEC-*.md` | `decisions/` (for follow-ups) |
| `weekly-life-architecture-review` | `weekly/YYYY-Www.md` | `daily/*.md` (read last 7), `time-series/*.csv` (aggregate), `events/*.csv` (pattern analysis) |

## New Commands Required

| Command | Purpose |
|---------|---------|
| `life-journal-init` | Initialize journal directory structure, create baseline config |
| `life-metrics-query` | Query accumulated metrics: "avg energy this week", "most common triggers", etc. |
| `life-baseline-update` | Recompute baselines from historical data |

## Risks

| Risk | Mitigation |
|------|-----------|
| Journal files grow unbounded | Include rotation notes: archive quarterly, summarize annually |
| CSV parsing errors from malformed writes | Enforce strict format, validate on write |
| Too many writes slow down commands | Keep write operations minimal — append-only CSV, daily file write once |
| User might delete/modify journal files manually | Design for append-only; agent reads only, never rewrites history |
| Follow-up dates missed for decisions | Agent checks `decisions/` for pending follow-ups on boot | 
