---
description: Query accumulated life-journal data — trends, aggregates, patterns, and follow-ups
agent: life-engineer
---

# Life Metrics Query

Query the life-journal for aggregated metrics, trends, patterns, and pending items. Use this to introspect your accumulated data without running a full weekly review.

> **When**: On-demand — whenever you want to check a specific metric, trend, or pattern.
> **Duration**: 2-10 minutes depending on query complexity.
> **Analog**: `SELECT AVG(energy) FROM journal WHERE date > NOW() - INTERVAL '7 days'` — query interface for your life observability data.

---

## PHASE 1 — QUERY PARSING

**No data reading. Understand the query first.**

Determine what the user wants to know:

### Supported Query Types

| Category | Examples |
|----------|----------|
| **Average metric** | "What's my average energy this week?" "What's my average focus score?" |
| **Trend** | "How does this week compare to last week?" "Is my sleep improving?" |
| **Top-N** | "What are my most common emotional triggers?" "What distortions recur most?" |
| **Count** | "How many focus sessions this month?" "How many incidents this week?" |
| **Follow-ups** | "Any decisions due for follow-up?" "What decisions are pending review?" |
| **Correlation** | "Does sleep quality correlate with next-day energy?" |
| **Anomaly** | "What were my most extreme emotional events this month?" |

### Parse Into Structure

```
query_type: [avg / trend / topn / count / followups / correlation / anomaly]
metric: [energy / focus / mood / sleep / emotion / distortion / all]
date_range: [today / this_week / last_week / this_month / all]
aggregation: [avg / sum / min / max / count / distribution]
```

**Output**: `SCRATCHPAD.md` with parsed query

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Query Parsing) complete. I'll query: [metric] for [date_range] with [aggregation].
Reply APPROVE to read the journal data, or refine the query."
WAIT for explicit approval.
```

---

## PHASE 2 — DATA READING

**Scratchpad must be APPROVED.**

Read the relevant journal files based on the parsed query:

### For energy queries
Read `{journal_path}\time-series\energy.csv` for the requested date range.
Extract: levels per period, daily averages, trends.

### For focus queries
Read `{journal_path}\time-series\focus.csv` for the requested date range.
Extract: scores, session counts, distraction averages.

### For mood/emotion queries
Read `{journal_path}\time-series\mood.csv` + `{journal_path}\events\triggers.csv` for the date range.
Extract: averages, distributions, trigger frequencies.

### For sleep queries
Read `{journal_path}\time-series\sleep.csv` for the date range.
Extract: average hours, quality, trends.

### For decision follow-ups
Scan `{journal_path}\decisions\` for files where `status: active` and `follow_up_date <= today` or within requested range.

### For distortion queries
Read `{journal_path}\events\distortions.csv` for the date range.
Extract: type frequencies, severity averages.

### For correlation queries
Read multiple time-series files and compute correlations (e.g., sleep vs. energy, focus vs. mood).

**Output**: `PLAN.md` with raw data read from journal

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Data Reading) complete. Raw data loaded.
Reply APPROVE to compute results, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — COMPUTATION

**Plan must be APPROVED.**

Compute the requested aggregation:

### Average
```
[metric] average for [date_range]: [value]/10
Based on [N] data points
```

### Trend
```
[metric] trend: [↑ improving / ↓ declining / → stable]
Week over week change: [+/- value]
```

### Top-N
```
Most common [items] (top 5):
1. [item] — [count] occurrences ([%] of total)
2. [item] — [count] occurrences
...
```

### Follow-ups
```
Pending decision follow-ups:
- DEC-NNN: [decision summary] — due [date] (overdue by X days)
- DEC-MMM: [decision summary] — due [date]
```

### Correlation
```
[metric A] vs [metric B]: [positive/negative/no] correlation (r = [value])
Interpretation: [what this suggests]
```

### Anomaly
```
Anomalous [metric] events:
- [date]: [value] — [Z] standard deviations from mean
- [context/note from event]
```

---

## PHASE 4 — REPORT

Present the results in a structured format:

```markdown
## Metrics Query Result

### Query
[What was asked]

### Result
[Computed answer]

### Data Quality
- Date range: [start] to [end]
- Data points: [count]
- Confidence: [high/medium/low — based on data volume]

### Recommendations (if applicable)
[Any actionable insights from the data]
```

**Output**: Structured query result

---

// turbo
