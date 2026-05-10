---
description: Evening system shutdown sequence — metrics collection, log analysis, recovery preparation, journal write
agent: life-engineer
---

# Daily System Shutdown

Wind down the daily runtime. Collect metrics, review the day's events, prepare the system for recovery and tomorrow's startup.

> **When**: Every evening, after work completes, before sleep.
> **Duration**: 10-15 minutes.
> **Analog**: System shutdown — flush buffers, write logs, persist state, prepare for next boot.

> [!CAUTION]
> This workflow requires human approval between every phase.
> Do NOT skip phases. Do NOT combine phases into a single response.

---

## PHASE 1 — METRICS COLLECTION

**No analysis. Raw data collection only.**

Collect today's operational metrics:

1. **Energy curve**: Estimate energy level for each major period (morning/afternoon/evening). What was peak? What was trough?
2. **Focus quality** (1-10): How well did you maintain single-threaded attention? How many context switches?
3. **Emotional range**: Min emotional state (1-10), Max emotional state (1-10), Current state (1-10). Any notable emotional events?
4. **Priorities completion**: For each of today's top 3 priorities, status: Complete / Partial / Not started
5. **Decisions**: What significant decisions did you make today?
6. **Accomplishments**: What did you complete or make progress on?
7. **Anomalies**: Anything unusual? Unexpected events? Strong reactions?

**Reference**: `develop-life/part-1-foundations.md` Ch5 (Energy); `develop-life/part-4-performance.md` Ch6 (Sleep), Ch7 (Recovery); `develop-life/special-topics.md` Topic 2 (Observability)

**Output**: `SCRATCHPAD.md` with raw metrics data

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Metrics Collection) complete. Please review SCRATCHPAD.md.
Reply APPROVE to continue to log analysis, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — LOG ANALYSIS

**Scratchpad must be APPROVED. No actions yet.**

Analyze today's data for patterns and signals:

1. **Pattern scan**: Any recurring patterns across metrics? (e.g., energy drops after specific activities, emotional triggers from specific contexts)
2. **Deviation analysis**: Compare today's metrics to recent baseline. What's better? What's worse? What's anomalous?
3. **Debt accrual**: What unresolved issues accumulated today? What got pushed to tomorrow?
4. **Systemic insight**: What does today tell you about how your system operates? Any hypotheses to test?

**Output**: `PLAN.md` with analysis findings

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Log Analysis) complete. Please review PLAN.md.
Reply APPROVE to execute shutdown and recovery preparation, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — RECOVERY PREPARATION

**Plan must be APPROVED.**

1. **Brain dump**: Write down anything on your mind that needs processing — unresolved thoughts, tomorrow's concerns, creative ideas. This clears the mental cache.
2. **Tomorrow prep**: Identify tomorrow's top priority. Pre-configure environment if possible (lay out materials, set up workspace).
3. **Sleep environment**: Set up optimal sleep conditions — dim lights, cool temperature, no screens 30 min before bed.
4. **Recovery protocol**: Plan evening activities for nervous system down-regulation (reading, stretching, breathing, non-stimulating activity).

---

## PHASE 4 — JOURNAL LOGGING

Persist today's shutdown data to the life-journal:

### 4.1 Read Existing Daily File

Read `{journal_path}\daily\YYYY-MM-DD.md` (created by morning boot). If it doesn't exist (ran shutdown before boot), create it with the morning fields set to the same as evening values.

### 4.2 Append Evening Data to Daily File

Extend the daily file with evening sections:

```yaml
---
# ... (morning front-matter preserved)
sleep_hours: [hours]
sleep_quality: [score/10]
mood_evening: [score/10]
energy_curve_morning: [score]
energy_curve_afternoon: [score]
energy_curve_evening: [score]
focus_quality: [score/10]
focus_notes: "[interruption notes]"
mood_min: [score]
mood_max: [score]
priority_completion:
  - "[priority 1]: [complete/partial/not started]"
  - "[priority 2]: [complete/partial/not started]"
  - "[priority 3]: [complete/partial/not started]"
decisions:
  - "[decision 1]"
  - "[decision 2]"
accomplishments:
  - "[accomplishment 1]"
anomalies: "[unusual events]"
patterns: "[observed patterns]"
debt_accrued: "[what carried forward]"
next_priority: "[tomorrow's top priority]"
next_intention: "[tomorrow's intention]"
---
```

### 4.3 Append Time-Series Data

Append to `{journal_path}\time-series\energy.csv`:
```csv
YYYY-MM-DD,morning,[morning energy],[primary activity],
YYYY-MM-DD,afternoon,[afternoon energy],[primary activity],
YYYY-MM-DD,evening,[evening energy],[primary activity],
```

Append to `{journal_path}\time-series\focus.csv`:
```csv
YYYY-MM-DD,, [focus_quality], [total deep work minutes], [distraction count], [notes]
```

If mood_min/mood_max represent distinct emotional events, append to `{journal_path}\time-series\mood.csv`:
```csv
YYYY-MM-DD,[time of min], [emotion at min], [mood_min], [category], [trigger if known],,
YYYY-MM-DD,[time of max], [emotion at max], [mood_max], [category], [trigger if known],,
```

### 4.4 Git Commit

```bash
cd {journal_path}
git add -A
git commit -m "shutdown: YYYY-MM-DD"
git push 2>/dev/null || echo "No remote configured — push skipped"
```

**Output**: Daily journal extended + time-series appended + committed

---

// turbo
