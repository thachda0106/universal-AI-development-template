# TASKS — Life Systems Engineering Memory Layer

## Configuration Constants

These are used across all tasks:

- **JOURNAL_ROOT**: `C:\personal_sources\find-jobs\life-journal\`
- **GIT_AUTO**: `true` — commands auto run `git add`, `git commit`, `git push`

## Implementation Order

### Task 1: Create life-journal-init command

**File**: `C:\Users\thach\.config\opencode\commands\life-journal-init.md`

**Dependencies**: None

**Purpose**: One-time initialization of the journal directory structure and entry-point for git setup.

**Behavior**:
- Checks if `JOURNAL_ROOT` exists
- If not, creates full directory tree: `daily/`, `time-series/`, `events/`, `incidents/`, `decisions/`, `weekly/`, `meta/`
- Creates `journal.yaml` with config: repo_path, git_mode, user_id
- Creates initial `meta/baselines.json` with empty defaults
- Creates `README.md` explaining the journal structure
- Optionally runs `git init` and instructions for connecting to GitHub remote

**Command structure**:
- Phase 1 — Check: does journal already exist? What's missing?
- Phase 2 — Initialize: create directories, config files, baselines
- Phase 3 — Verify: confirm structure is correct

---

### Task 2: Create empty baseline files in journal

**Files to create** (within `JOURNAL_ROOT`):
- `meta/baselines.json` — empty baseline template
- `journal.yaml` — configuration

**Dependencies**: Task 1 (directory structure must exist)

**Purpose**: Pre-create structured files that commands will read/write.

---

### Task 3: Initialize git repo for journal

**Command**: run `git init` in `JOURNAL_ROOT`

**Dependencies**: Task 1

**Note**: User needs to create the GitHub repo and add remote. Provide instructions. Do NOT auto-push without remote.

---

### Task 4: Update daily-system-boot — add journal writes

**File to modify**: `C:\Users\thach\.config\opencode\commands\daily-system-boot.md`

**Changes**:
- Phase 4 (Logging): Replace generic "log to journal" with:
  1. Read existing `JOURNAL_ROOT/daily/YYYY-MM-DD.md` (if exists from previous session)
  2. Write/overwrite morning front-matter: sleep_hours, sleep_quality, mood_morning, energy_morning, top_priorities, intention, attention_budget
  3. Append to `JOURNAL_ROOT/time-series/sleep.csv` (create with headers if first time)
  4. Append to `JOURNAL_ROOT/time-series/mood.csv`: morning baseline mood
  5. If GIT_AUTO: `git add -A && git commit -m "boot: YYYY-MM-DD"`

---

### Task 5: Update daily-system-shutdown — add journal writes

**File to modify**: `C:\Users\thach\.config\opencode\commands\daily-system-shutdown.md`

**Changes**:
- Phase 1: Read existing `JOURNAL_ROOT/daily/YYYY-MM-DD.md` to pre-fill morning data
- Phase 4 (Journal Logging): Replace markdown template with:
  1. Read existing `JOURNAL_ROOT/daily/YYYY-MM-DD.md`
  2. Append evening sections: energy_curve, focus_quality, mood_min/max/evening, priority_completion, decisions, accomplishments, anomalies, patterns, debt, next_priority
  3. Append to `JOURNAL_ROOT/time-series/energy.csv`: date, period, level, activity
  4. Append to `JOURNAL_ROOT/time-series/focus.csv`: date, session_id, score, duration_min, distractions
  5. Append to `JOURNAL_ROOT/time-series/mood.csv`: mood_min, mood_max if events
  6. If GIT_AUTO: `git add -A && git commit -m "shutdown: YYYY-MM-DD"`
  7. If GIT_AUTO: `git push` (fail silently if no remote)

---

### Task 6: Update daily-focus-session — add journal writes

**File to modify**: `C:\Users\thach\.config\opencode\commands\daily-focus-session.md`

**Changes**:
- Phase 4 (Session Review): Replace generic log with:
  1. Append to `JOURNAL_ROOT/time-series/focus.csv`: date, session_id, score, duration_min, distractions
  2. If GIT_AUTO: `git add -A && git commit -m "focus: YYYY-MM-DD session-N"`

---

### Task 7: Update daily-emotional-observability — add baseline reads + journal writes

**File to modify**: `C:\Users\thach\.config\opencode\commands\daily-emotional-observability.md`

**Changes**:
- Phase 2 (Anomaly Detection): Before analyzing, read `JOURNAL_ROOT/meta/baselines.json`:
  - Compare current emotion intensity to `emotional_intensity_avg` + `anomaly_threshold_stddevs`
  - Flag if anomalous: "This intensity is X standard deviations above your average"
- Phase 4 (Event Logging): Replace generic log with:
  1. Append to `JOURNAL_ROOT/time-series/mood.csv`: full emotion event
  2. Append to `JOURNAL_ROOT/events/triggers.csv`: full trigger record (create headers if first time)
  3. If GIT_AUTO: `git add -A && git commit -m "emotion: YYYY-MM-DD HH:MM"`

---

### Task 8: Update daily-cognitive-scan — add journal writes

**File to modify**: `C:\Users\thach\.config\opencode\commands\daily-cognitive-scan.md`

**Changes**:
- Phase 4 (Logging): Replace generic log with:
  1. Append to `JOURNAL_ROOT/events/distortions.csv`: date, distortion_type, original_thought, severity, reframe (create headers if first time)
  2. If GIT_AUTO: `git add -A && git commit -m "cognitive-scan: YYYY-MM-DD"`

---

### Task 9: Update daily-energy-audit — add journal reads

**File to modify**: `C:\Users\thach\.config\opencode\commands\daily-energy-audit.md`

**Changes**:
- Phase 2 (Drain Analysis): Add historical read:
  1. Read `JOURNAL_ROOT/time-series/energy.csv` for past 7 days
  2. Read `JOURNAL_ROOT/time-series/sleep.csv` for past 7 days
  3. Identify recurring drain patterns: "You consistently have energy drops after [activity]"
- Phase 4: Energy data is already captured by shutdown. No additional write needed.

---

### Task 10: Update life-decision-log — add journal writes + follow-up reads

**File to modify**: `C:\Users\thach\.config\opencode\commands\life-decision-log.md`

**Changes**:
- Phase 1 (Decision Context): Add check for pending follow-ups:
  1. Scan `JOURNAL_ROOT/decisions/` for decisions with `status: active` and `follow_up_date <= today`
  2. Notify user: "You have N decisions due for follow-up review"
- Phase 4 (Decision Record): Replace generic log with:
  1. Generate decision ID: read `JOURNAL_ROOT/decisions/`, find highest number, increment
  2. Write `JOURNAL_ROOT/decisions/DEC-{NNN}.md` with full record
  3. If GIT_AUTO: `git add -A && git commit -m "decision: DEC-NNN - [brief title]"`

---

### Task 11: Update life-incident-response — add journal writes

**File to modify**: `C:\Users\thach\.config\opencode\commands\life-incident-response.md`

**Changes**:
- Phase 4 (Post-Incident Review): Replace generic log with:
  1. Generate incident ID: read `JOURNAL_ROOT/incidents/`, find highest number, increment
  2. Write `JOURNAL_ROOT/incidents/INC-{NNN}.md` with full postmortem
  3. If GIT_AUTO: `git add -A && git commit -m "incident: INC-NNN"`

---

### Task 12: Update weekly-life-architecture-review — add journal reads + writes

**File to modify**: `C:\Users\thach\.config\opencode\commands\weekly-life-architecture-review.md`

**Changes**:
- Phase 1 (Metrics Aggregation): Replace "collect manually" with:
  1. Read `JOURNAL_ROOT/time-series/energy.csv` for past 7 days → compute energy_avg
  2. Read `JOURNAL_ROOT/time-series/focus.csv` for past 7 days → compute focus_avg
  3. Read `JOURNAL_ROOT/time-series/mood.csv` for past 7 days → compute emotional range + volatility
  4. Read `JOURNAL_ROOT/events/triggers.csv` for past 7 days → count + patterns
  5. Read `JOURNAL_ROOT/events/distortions.csv` for past 7 days → count + pattern analysis
  6. Read `JOURNAL_ROOT/incidents/` for past 7 days → count
  7. Read `JOURNAL_ROOT/decisions/` for past 7 days → count + pending follow-ups
  8. Read `JOURNAL_ROOT/daily/*.md` for past 7 days → extract priority completion rates
  9. Pre-fill the trend table with real data
- Phase 4 (System Update): Add writes:
  1. Write `JOURNAL_ROOT/weekly/YYYY-Www.md` with full review
  2. Update `JOURNAL_ROOT/meta/baselines.json`: recompute all averages from full history
  3. If GIT_AUTO: `git add -A && git commit -m "weekly: YYYY-Www"`

---

### Task 13: Create life-metrics-query command

**File to create**: `C:\Users\thach\.config\opencode\commands\life-metrics-query.md`

**Dependencies**: Task 1 (journal must exist)

**Purpose**: Query accumulated data for trends, aggregates, and patterns.

**Supported queries**:
- Average energy for a date range
- Average focus for a date range
- Most common emotional triggers (with frequency)
- Most common cognitive distortions (with frequency)
- Decision follow-ups pending/completed
- Sleep quality trend
- Weekly comparison (this week vs last week)

**Phase structure**:
- Phase 1 — **Query Parsing**: Determine what metric, date range, aggregation
- Phase 2 — **Data Reading**: Read relevant journal files
- Phase 3 — **Computation**: Compute aggregate, detect trends, identify patterns
- Phase 4 — **Report**: Return structured result

---

### Task 14: Create life-baseline-update command

**File to create**: `C:\Users\thach\.config\opencode\commands\life-baseline-update.md`

**Dependencies**: Task 1

**Purpose**: Recompute baselines from all accumulated historical data.

**Behavior**:
- Read ALL data from time-series/ CSVs
- Compute: mean, standard deviation, min, max for energy, focus, mood intensity, sleep quality
- Compute: most frequent emotions, triggers, distortions
- Compute: emotional volatility (standard deviation of mood over time)
- Write to `JOURNAL_ROOT/meta/baselines.json`
- If GIT_AUTO: `git add -A && git commit -m "baselines: recomputed from N data points"`

**Phase structure**:
- Phase 1 — **Data Scan**: Read all time-series and event files
- Phase 2 — **Computation**: Calculate all baseline metrics
- Phase 3 — **Write**: Update baselines.json
- Phase 4 — **Verify**: Confirm baselines are valid

---

### Task 15: Add git journal reference to life-engineering-daily-practices skill

**File to modify**: `C:\Users\thach\.config\opencode\skills\life-engineering-daily-practices\SKILL.md`

**Changes**:
- Add `## Journal System` section explaining:
  - Location of life-journal
  - Git workflow (auto-commits)
  - How to review history
  - How to query data
- Add journal references to daily practice procedures

---

## Dependency Graph

```
Task 1 (life-journal-init command)
  │
  ├──► Task 2 (baselines/config files)
  │     │
  │     └──► Task 3 (git init)
  │
  ├──► Task 4 (update boot) ──► Task 5 (update shutdown)
  │
  ├──► Task 6 (update focus)
  ├──► Task 7 (update emotional) ── reads baselines
  ├──► Task 8 (update cognitive)
  ├──► Task 9 (update energy) ── reads time-series
  ├──► Task 10 (update decisions)
  ├──► Task 11 (update incidents)
  │
  ├──► Task 12 (update weekly) ── reads ALL + writes baselines
  │
  ├──► Task 13 (create metrics-query)
  ├──► Task 14 (create baseline-update)
  │
  └──► Task 15 (update skill docs)
```

Tasks 4-11 are mostly independent and can be parallelized.

---

## File Summary

| # | Action | File Path | Type | Est. Lines |
|---|--------|-----------|------|-----------|
| 1 | Create | `commands/life-journal-init.md` | New | ~100 |
| 2 | Create | `life-journal/meta/baselines.json` | New | ~30 |
| 2 | Create | `life-journal/journal.yaml` | New | ~10 |
| 3 | Run | `git init` in `JOURNAL_ROOT` | Exec | — |
| 4 | Modify | `commands/daily-system-boot.md` | Edit | ~+20 |
| 5 | Modify | `commands/daily-system-shutdown.md` | Edit | ~+30 |
| 6 | Modify | `commands/daily-focus-session.md` | Edit | ~+10 |
| 7 | Modify | `commands/daily-emotional-observability.md` | Edit | ~+30 |
| 8 | Modify | `commands/daily-cognitive-scan.md` | Edit | ~+10 |
| 9 | Modify | `commands/daily-energy-audit.md` | Edit | ~+20 |
| 10 | Modify | `commands/life-decision-log.md` | Edit | ~+30 |
| 11 | Modify | `commands/life-incident-response.md` | Edit | ~+15 |
| 12 | Modify | `commands/weekly-life-architecture-review.md` | Edit | ~+50 |
| 13 | Create | `commands/life-metrics-query.md` | New | ~120 |
| 14 | Create | `commands/life-baseline-update.md` | New | ~80 |
| 15 | Modify | `skills/life-engineering-daily-practices/SKILL.md` | Edit | ~+30 |
