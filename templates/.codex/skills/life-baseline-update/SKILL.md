---
name: life-baseline-update
description: Recompute baselines from all accumulated life-journal time-series and event data
---


# Life Baseline Update

Recompute all statistical baselines from the accumulated life-journal data. Run this after the weekly review or whenever you want refreshed anomaly detection thresholds.

> **When**: Weekly (after weekly-life-architecture-review) or anytime data has accumulated significantly.
> **Duration**: 2-5 minutes.
> **Analog**: Model retraining — recompute statistical parameters from new data to improve detection accuracy.

---

## PHASE 1 — DATA SCAN

**No computation. Scan all available data.**

Read ALL data from journal time-series files:

1. **Energy**: `{journal_path}\time-series\energy.csv`
   - Count total rows (excluding header)
2. **Focus**: `{journal_path}\time-series\focus.csv`
   - Count total rows (excluding header)
3. **Mood**: `{journal_path}\time-series\mood.csv`
   - Count total rows, separate positive vs negative
4. **Sleep**: `{journal_path}\time-series\sleep.csv`
   - Count total rows
5. **Triggers**: `{journal_path}\events\triggers.csv`
   - Count total events
6. **Distortions**: `{journal_path}\events\distortions.csv`
   - Count total scans

**Output**: `SCRATCHPAD.md` with data volume summary

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Data Scan) complete. Found N data points across 6 files.
Reply APPROVE to compute baselines, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — COMPUTATION

**Scratchpad must be APPROVED.**

Compute all baseline statistics:

### Energy Baseline
- Read ALL energy levels from `energy.csv`
- Compute: mean, standard deviation, min, max
- Also compute per-period baselines (morning avg, afternoon avg, evening avg)

### Focus Baseline
- Read ALL focus scores from `focus.csv`
- Compute: mean, standard deviation, min, max
- Compute average session duration, average distractions per session

### Mood Baseline
- Read ALL intensity values from `mood.csv`
- Compute: mean, standard deviation, min, max
- Separate positive vs negative event baselines
- Compute emotional volatility (overall standard deviation of mood)

### Sleep Baseline
- Read ALL hours and quality from `sleep.csv`
- Compute: avg hours, avg quality, stddev for both

### Emotional Pattern Baseline
- Scan ALL trigger events from `triggers.csv`
- Build frequency table of emotions → count occurrences
- Build frequency table of triggers → count occurrences
- Compute average regulation effectiveness

### Cognitive Pattern Baseline
- Scan ALL distortion records from `distortions.csv`
- Build frequency table of distortion types → count occurrences

---

## PHASE 3 — WRITE

**Computation must be complete.**

Write updated `{journal_path}\meta\baselines.json`:

```json
{
  "energy": {
    "avg": [computed mean],
    "stddev": [computed stddev],
    "min": [min],
    "max": [max],
    "morning_avg": [computed],
    "afternoon_avg": [computed],
    "evening_avg": [computed],
    "data_points": [count],
    "last_computed": "YYYY-MM-DD"
  },
  "focus": {
    "avg": [computed mean],
    "stddev": [computed stddev],
    "min": [min],
    "max": [max],
    "avg_session_duration": [minutes],
    "avg_distractions": [number],
    "data_points": [count],
    "last_computed": "YYYY-MM-DD"
  },
  "mood_intensity": {
    "avg": [computed mean],
    "stddev": [computed stddev],
    "min": [min],
    "max": [max],
    "positive_avg": [computed],
    "negative_avg": [computed],
    "emotional_volatility": [overall stddev],
    "data_points": [count],
    "last_computed": "YYYY-MM-DD"
  },
  "sleep_quality": {
    "avg": [computed mean],
    "stddev": [computed stddev],
    "min": [min],
    "max": [max],
    "data_points": [count],
    "last_computed": "YYYY-MM-DD"
  },
  "sleep_hours": {
    "avg": [computed mean],
    "stddev": [computed stddev],
    "min": [min],
    "max": [max],
    "data_points": [count],
    "last_computed": "YYYY-MM-DD"
  },
  "emotional": {
    "common_emotions": [
      {"emotion": "[name]", "count": [N], "pct": [%]},
      ...
    ],
    "common_triggers": [
      {"trigger": "[description]", "count": [N]},
      ...
    ],
    "avg_regulation_effectiveness": [score],
    "total_events": [count],
    "last_computed": "YYYY-MM-DD"
  },
  "cognitive": {
    "common_distortions": [
      {"type": "[name]", "count": [N], "pct": [%]},
      ...
    ],
    "total_scans": [count],
    "last_computed": "YYYY-MM-DD"
  },
  "anomaly_threshold_stddevs": 2.0,
  "data_points": [total across all files],
  "last_computed": "YYYY-MM-DD"
}
```

---

## PHASE 4 — VERIFY

1. Confirm `baselines.json` is valid JSON
2. Verify all computed values are within reasonable ranges
3. Note any interesting shifts from previous baselines

### Git Commit

```bash
cd {journal_path}
git add -A
git commit -m "baselines: recomputed from [N] data points"
git push 2>/dev/null || echo "No remote configured — push skipped"
```

**Output**: Updated baselines.json + committed

---


