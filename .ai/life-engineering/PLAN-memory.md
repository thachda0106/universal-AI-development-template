# PLAN — Life Systems Engineering Memory Layer

## Architecture Overview

Add a persistent file-based journal to the Life Systems Engineering system. All commands become stateful: they write structured data to disk and read historical data for analysis.

```
CURRENT (stateless):               TARGET (stateful):
                                 
Command ─► output (ephemeral)     Command ─► output + ──► life-journal/ (persistent)
                                              │             ├── daily/
                                              │             ├── time-series/
                                              │             ├── events/
                                              │             ├── incidents/
                                              │             ├── decisions/
                                              │             ├── weekly/
                                              │             └── meta/
                                              │
                                              └─── reads ──► historical data for analysis
```

---

## 1. Data Models & File Formats

### 1.1 Daily Journal File: `life-journal/daily/YYYY-MM-DD.md`

Single daily file, updated by both boot and shutdown. Front-matter for machine parsing, body for human reading.

```yaml
---
date: 2026-05-10
sleep_hours: 7.5
sleep_quality: 8
mood_morning: 7
energy_morning: 6
top_priorities:
  - Complete PR review
  - Write API documentation
  - Exercise
intention: "Ship the PR review and clear the blocking issue"
attention_budget: "0900-1100: deep work PR, 1100-1200: shallow, 1400-1600: docs"
---
## Morning Boot
...

## Evening Shutdown
energy_curve: "morning:6, afternoon:5, evening:4"
focus_quality: 7
focus_notes: "One Slack interruption mid-session"
mood_min: 5
mood_max: 8
mood_evening: 6
priority_completion:
  - PR review: complete
  - API docs: partial
  - Exercise: not started
decisions:
  - "Accepted the sprint extension request"
accomplishments:
  - "Reviewed and merged 3 PRs"
  - "Unblocked the auth module issue"
anomalies: "Unexpected frustration during standup — triggered by teammate's comment"
patterns: "Energy drops after lunch consistently"
debt_accrued: "Exercise skipped again — 3 day streak broken"
next_priority: "Finish API docs"
next_intention: "Complete docs before 2pm"
```

### 1.2 Time-Series CSVs

**`energy.csv`**
```csv
date,period,level,activity,notes
2026-05-10,morning,6,standup+code review,
2026-05-10,afternoon,5,meeting+docs,
2026-05-10,evening,4,relaxation,
```

**`focus.csv`**
```csv
date,session_id,score,duration_min,distractions,notes
2026-05-10,1,7,60,1,Slack interrupt
2026-05-10,2,8,45,0,Deep flow
```

**`mood.csv`**
```csv
date,timestamp,emotion,intensity,category,trigger,regulation,effectiveness
2026-05-10,0900,calm,7,positive,,,
2026-05-10,1030,frustration,6,negative,standup comment,reappraisal,7
2026-05-10,1700,satisfaction,8,positive,PR merged,,
```

**`sleep.csv`**
```csv
date,hours,quality,bedtime,waketime,notes
2026-05-10,7.5,8,2230,0630,Good sleep
```

### 1.3 Event Logs

**`triggers.csv`** — Emotional trigger events
```csv
date,timestamp,emotion,intensity,trigger,context,narrative,urge,deviation_type,regulation,effectiveness
2026-05-10,1030,frustration,6,"Teammate questioned my approach","During standup","They think I don't know what I'm doing","Defend self verbally",pattern,reappraisal,7
```

**`distortions.csv`** — Cognitive distortion detections
```csv
date,distortion_type,original_thought,severity,reframe
2026-05-10,catastrophizing,"This bug means the whole release is doomed",4,"One bug in one module — fixable, not catastrophic"
2026-05-10,mind_reading,"My manager thinks I'm slacking",3,"No evidence they think that — I'm projecting my own insecurity"
```

### 1.4 Decision Records: `life-journal/decisions/DEC-001.md`

```yaml
---
id: DEC-001
date: 2026-05-10
status: active # active | completed | failed | superseded
type: career
decision: "Accept the sprint extension request"
rationale: "Team is under capacity and the deadline was aggressive"
options:
  - accept: "Extend sprint by 3 days — maintain quality"
  - reject: "Ship on time with reduced scope — risk bugs"
chosen: accept
expected_outcome: "Quality maintained, team morale preserved"
probability: 80
follow_up_date: 2026-05-17
---
## Context
The sprint deadline is this Friday. The team is stretched thin.
One engineer is out sick. The PM requested a 3-day extension.

## Analysis
Accept: $EV = 0.8 \times 10 + 0.2 \times (-2) = 7.6$
Reject: $EV = 0.4 \times 5 + 0.6 \times (-5) = -1.0$

## Follow-up
Date: 2026-05-17
Outcome: 
Calibration:
Update:
```

### 1.5 Incident Records: `life-journal/incidents/INC-001.md`

```yaml
---
id: INC-001
date: 2026-05-10
severity: SEV2
type: emotional
duration_min: 45
resolved: true
---
## Incident Summary
Intense frustration during standup triggered by teammate's comment.

## Timeline
- 1015: Standup starts
- 1022: Teammate says "why didn't you handle this differently?"
- 1023: Emotional spike — frustration 8/10, racing heart
- 1025: Started to respond defensively, caught myself
- 1030: Used reappraisal — "they're asking a question, not attacking"
- 1045: Returned to baseline
- 1100: Had private chat with teammate — resolved

## Root Cause
Trigger + pre-existing fatigue + interpretation bias

## Action Items
- [ ] Practice non-defensive response protocols (due: 2026-05-17)
- [ ] Check fatigue levels before standup (ongoing)
```

### 1.6 Weekly Summary: `life-journal/weekly/2026-W20.md`

```yaml
---
week: "2026-W20"
date_range: "2026-05-10 to 2026-05-16"
energy_avg: 5.8
focus_avg: 7.2
mood_avg: 6.4
priority_completion_pct: 67
system_health: 7
decisions_count: 3
incidents_count: 2
---
...
```

### 1.7 Baselines: `life-journal/meta/baselines.json`

```json
{
  "energy": { "avg": 5.8, "stddev": 1.2, "last_computed": "2026-05-16" },
  "focus": { "avg": 6.9, "stddev": 1.5, "last_computed": "2026-05-16" },
  "mood": { "avg": 6.5, "stddev": 1.8, "last_computed": "2026-05-16" },
  "sleep_quality": { "avg": 7.2, "stddev": 1.0, "last_computed": "2026-05-16" },
  "emotional_intensity_avg": 5.5,
  "common_emotions": ["calm", "frustration", "anxiety", "satisfaction"],
  "common_triggers": ["meetings", "deadlines", "social evaluation"],
  "common_distortions": ["catastrophizing", "mind_reading"],
  "anomaly_threshold_stddevs": 2.0
}
```

---

## 2. File Modification Plan

### 2.1 Modify: All 9 existing command files

Every command file needs its Phase 4 (Logging) updated to write to `life-journal/` instead of just producing transient output. Some commands also need their Phase 2 (Analysis) updated to read from life-journal/ for historical comparison.

### 2.2 Create: 3 new command files

| Command | Purpose | File |
|---------|---------|------|
| `life-journal-init` | Initialize the journal directory tree, create baselines | `commands/life-journal-init.md` |
| `life-metrics-query` | Query accumulated data: trends, aggregates, patterns | `commands/life-metrics-query.md` |
| `life-baseline-update` | Recompute baselines from all historical data | `commands/life-baseline-update.md` |

### 2.3 Create: Journal directory structure

```
C:\Users\thach\.config\opencode\life-journal\
├── daily\
├── time-series\
├── events\
├── incidents\
├── decisions\
├── weekly\
└── meta\
```

Automatically created by `life-journal-init` command.

### 2.4 Update: `life-engineering-daily-practices` skill

Add reference to the journal system and update procedures to include persistence.

---

## 3. Detailed Command Modifications

### 3.1 `daily-system-boot` — Changes

**Phase 4 (Logging)** — Currently says "Log today's metrics to journal" but doesn't specify format or location. Replace with explicit write instructions:

```markdown
## PHASE 4 — LOGGING

1. Write/update `life-journal/daily/YYYY-MM-DD.md` with morning data:
   - Front-matter: date, sleep_hours, sleep_quality, mood_morning, energy_morning, top_priorities, intention, attention_budget
2. Append to `life-journal/time-series/sleep.csv`: date, hours, quality
3. Append to `life-journal/time-series/mood.csv`: date, timestamp, "calm"/"neutral" etc., mood_morning as intensity, "morning baseline"
4. Set follow-up reminder for evening shutdown
```

### 3.2 `daily-system-shutdown` — Changes

**Phase 4 (Journal Logging)** — Currently outputs a markdown template. Replace with:

1. Read existing `life-journal/daily/YYYY-MM-DD.md` (created by boot)
2. Append evening data to the same file (energy_curve, focus_quality, mood_min/max/evening, priority_completion, decisions, accomplishments, anomalies, patterns, debt, next_priority, next_intention)
3. Append to `life-journal/time-series/energy.csv`: date, period, level, activity
4. Append to `life-journal/time-series/focus.csv`: date, session_id, score, duration_min, distractions
5. Append to `life-journal/time-series/mood.csv`: mood_min, mood_max events
6. Update `life-journal/meta/baselines.json` if this is the end of day

### 3.3 `daily-focus-session` — Changes

**Phase 4 (Session Review)** — Add append to `life-journal/time-series/focus.csv`.

### 3.4 `daily-emotional-observability` — Changes

**Phase 2 (Anomaly Detection)** — Add read from `life-journal/meta/baselines.json` for baseline comparison:
- Compare current intensity to `emotional_intensity_avg`
- Flag if > `anomaly_threshold_stddevs` standard deviations from mean

**Phase 4 (Event Logging)** — Append to:
- `life-journal/time-series/mood.csv`: emotion event
- `life-journal/events/triggers.csv`: full trigger record

### 3.5 `daily-cognitive-scan` — Changes

**Phase 4 (Logging)** — Append to:
- `life-journal/events/distortions.csv`: distortion record
- Also add to `life-journal/daily/YYYY-MM-DD.md` as notes

### 3.6 `daily-energy-audit` — Changes

**Phase 2 (Drain Analysis)** — Read from `life-journal/time-series/energy.csv` and `life-journal/time-series/sleep.csv` for pattern identification across multiple days.

**Phase 4 (Logging)** — Ensure energy data is already captured (by shutdown), add additional notes if needed.

### 3.7 `life-incident-response` — Changes

**Phase 4 (Post-Incident Review)** — Write to `life-journal/incidents/INC-{ID}.md` and reference in `life-journal/daily/YYYY-MM-DD.md`.

### 3.8 `life-decision-log` — Changes

**Phase 4 (Decision Record)** — Write to `life-journal/decisions/DEC-{ID}.md`.

**Phase 4 (Follow-up)** — Read `life-journal/decisions/` to check for pending follow-ups.

### 3.9 `weekly-life-architecture-review` — Changes

**Phase 1 (Metrics Aggregation)** — Instead of relying on user memory, READ from:
- `life-journal/daily/*.md` for the past 7 days → extract metrics
- `life-journal/time-series/energy.csv` for energy averages
- `life-journal/time-series/focus.csv` for focus averages
- `life-journal/time-series/mood.csv` for emotional range
- `life-journal/events/triggers.csv` for trigger pattern analysis
- `life-journal/events/distortions.csv` for cognitive pattern analysis
- `life-journal/incidents/` for incident count
- `life-journal/decisions/` for decision count and pending follow-ups

**Phase 4 (System Update)** — Write to `life-journal/weekly/YYYY-Www.md` and update `life-journal/meta/baselines.json`.

---

## 4. New Commands Design

### 4.1 `life-journal-init` Command

Single operation: initialize the journal directory structure.

No approval gates needed — it's a one-time setup.

**Phases**: 1 (Check), 2 (Create), 3 (Verify)

### 4.2 `life-metrics-query` Command

Query interface for accumulated data. User asks questions in natural language, agent reads relevant journal files, computes aggregate, returns result.

**Phase 1**: Parse query — what metric? What date range? What aggregation?
**Phase 2**: Read relevant life-journal files
**Phase 3**: Compute and return result

Example queries:
- "What was my average energy this week?"
- "What are my most common emotional triggers?"
- "How many focus sessions did I complete this month?"
- "Are there any decisions due for follow-up?"

### 4.3 `life-baseline-update` Command

Scan all historical data, recompute baselines, write to `life-journal/meta/baselines.json`.

Run manually or as part of weekly review.

---

## 5. Edge Cases

| Edge Case | Handling |
|-----------|----------|
| `life-journal/daily/YYYY-MM-DD.md` doesn't exist yet (ran shutdown before boot) | Create it fresh with morning defaults |
| CSV file doesn't exist yet | Create with headers on first append |
| Multiple emotional checks in one day | Append multiple rows to mood.csv and triggers.csv |
| Journal grows large over years | Archive: move year-old data to `life-journal/archive/YYYY/` |
| User deletes a journal file | Agent detects missing file, warns user, recreates with "reconstructed from remaining data" header |
| Follow-up date missed (decision) | Check pending follow-ups on every `life-decision-log` call |
| Baseline from thin data (first 3 days) | Include "data points: N" in baseline to indicate confidence |

---

## 6. Implementation Order

```
Phase 1: Create life-journal-init command + directory structure
Phase 2: Create baselines.json + journal.yaml config files
Phase 3: Update daily-system-boot (write daily/YYYY-MM-DD.md, append sleep.csv, mood.csv)
Phase 4: Update daily-system-shutdown (extend daily/YYYY-MM-DD.md, append energy.csv, focus.csv, mood.csv)
Phase 5: Update daily-focus-session (append focus.csv)
Phase 6: Update daily-emotional-observability (read baselines, append mood.csv, triggers.csv)
Phase 7: Update daily-cognitive-scan (append distortions.csv)
Phase 8: Update daily-energy-audit (read energy.csv + sleep.csv)
Phase 9: Update life-decision-log (write decisions/DEC-*.md, read for follow-ups)
Phase 10: Update life-incident-response (write incidents/INC-*.md)
Phase 11: Update weekly-life-architecture-review (read all + write weekly/ + update baselines.json)
Phase 12: Create life-metrics-query command
Phase 13: Create life-baseline-update command
Phase 14: Update life-engineering-daily-practices skill (add journal references)
```
