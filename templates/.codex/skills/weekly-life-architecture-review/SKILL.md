---
name: weekly-life-architecture-review
description: Weekly retrospective — aggregate daily metrics, review architecture debt, design next week's system architecture
---


# Weekly Life Architecture Review

The weekly system architecture review. Aggregate daily metrics, analyze trends, identify accumulated debt, and design the next week's architecture. This is the most important practice for long-term system improvement.

> **When**: Once per week (Friday evening or Sunday, at the end of the week).
> **Duration**: 30-45 minutes.
> **Analog**: Architecture review + sprint retrospective — review system metrics, identify architecture debt, design next iteration.

> [!CAUTION]
> This workflow requires human approval between every phase.
> Do NOT skip phases. Do NOT combine phases into a single response.

---

## PHASE 1 — METRICS AGGREGATION

**No analysis. Raw data aggregation only.**

Automatically aggregate data from the life-journal for the past 7 days:

### 1.1 Read Time-Series Data

Read `{journal_path}\time-series\energy.csv` for last 7 days:
- Compute average energy per period (morning/afternoon/evening)
- Compute overall weekly energy average
- Detect day-of-week patterns

Read `{journal_path}\time-series\focus.csv` for last 7 days:
- Compute average focus quality
- Count total focus sessions and minutes
- Average distractions per session

Read `{journal_path}\time-series\mood.csv` for last 7 days:
- Compute average mood
- Compute emotional range (min/max)
- Identify most frequent emotions
- Compute emotional volatility (stddev of mood values)

Read `{journal_path}\time-series\sleep.csv` for last 7 days:
- Compute average sleep hours and quality
- Detect sleep debt (hours below optimal)

### 1.2 Read Event Data

Read `{journal_path}\events\triggers.csv` for last 7 days:
- Count emotional events
- Most common triggers
- Regulation effectiveness average

Read `{journal_path}\events\distortions.csv` for last 7 days:
- Count distortions by type
- Most common distortion patterns

### 1.3 Read Decision & Incident Metadata

Scan `{journal_path}\decisions\`:
- Count decisions made this week
- Check for pending follow-ups

Scan `{journal_path}\incidents\`:
- Count incidents this week

### 1.4 Compute Trend Indicators

Compare this week's metrics to:
- Previous week's data (read previous 7 days)
- Baselines from `{journal_path}\meta\baselines.json`

**Reference**: `develop-life/part-2-debugging.md` Ch1 (RCA); `develop-life/part-8-meaning.md` Ch3 (Planning); `develop-life/special-topics.md` Topic 3 (Architecture Debt), Topic 7 (Life Refactoring)

**Output**: `SCRATCHPAD.md` with automatically aggregated weekly data

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Metrics Aggregation) complete. Please review SCRATCHPAD.md.
Reply APPROVE to continue to architecture review, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — ARCHITECTURE REVIEW

**Scratchpad must be APPROVED. No strategy yet.**

Analyze the week's architecture:

### 1. Trend Analysis
| Metric | Mon | Tue | Wed | Thu | Fri | Sat | Sun | Trend |
|--------|-----|-----|-----|-----|-----|-----|-----|-------|
| Energy | | | | | | | | ↑↓→ |
| Focus | | | | | | | | ↑↓→ |
| Emotional Stability | | | | | | | | ↑↓→ |
| Priority Completion | | | | | | | | ↑↓→ |

### 2. Architecture Debt Assessment
Identify accumulated debt across these categories:
- **Physical debt**: Sleep deprivation, poor nutrition, missed exercise
- **Cognitive debt**: Unresolved decisions, overthinking loops, information overload
- **Emotional debt**: Unprocessed emotions, avoided conversations, suppressed reactions
- **Social debt**: Neglected relationships, unmet commitments, unresolved conflicts
- **Career debt**: Procrastinated tasks, missed opportunities, skill development gaps
- **Environmental debt**: Cluttered workspace, disorganized systems, unmaintained tools

For each identified debt:
- Severity (1-5): How impactful is this debt?
- Interest rate (1-5): How fast is the cost of this debt growing?
- Servicing effort (1-5): How hard is it to resolve?

### 3. Pattern Recognition
What recurring patterns emerged this week?
- **Positive patterns**: What consistently worked well?
- **Negative patterns**: What consistently went wrong?
- **Trigger-consequence chains**: What events consistently led to what outcomes?

### 4. System Health Score
Rate your overall system health this week (1-10):
- **Performance**: How productive/focused were you?
- **Stability**: How emotionally stable were you?
- **Maintenance**: How well did you maintain the system (sleep, recovery, habits)?
- **Evolution**: Did you make progress on long-term goals?

**Output**: `PLAN.md` with architecture review findings

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Architecture Review) complete. Please review PLAN.md.
Reply APPROVE to continue to strategy design, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — STRATEGY & NEXT WEEK ARCHITECTURE

**Plan must be APPROVED.**

Design next week's architecture:

### 1. Strategy Design
- **Start**: What new practices, habits, or approaches will you start next week?
- **Stop**: What ineffective patterns will you stop?
- **Continue**: What works and will continue?
- **Increase**: What deserves more time/energy?
- **Decrease**: What deserves less time/energy?

### 2. Next Week Goals
Define 2-3 weekly goals using this format:
```
Goal: [measurable outcome]
Rationale: [why this matters — which debt it services or which growth area it addresses]
Key result: [how you'll know it's done]
Risk: [what might prevent it — and how you'll mitigate]
```

### 3. Weekly Architecture
- What does the ideal week look like? (Schedule structure)
- What are the critical-path items?
- What buffers/flexibility do you need?
- What single change this week would have the highest impact?

### 4. One Big Question
What is the most important question to hold this week? (A question to reflect on, not necessarily answer immediately.)

---

## PHASE 4 — SYSTEM UPDATE & PERSISTENCE

1. **Update goals tracker**: Record this week's outcomes and next week's goals
2. **Journal entry**: Write comprehensive weekly reflection
3. **System adjustment**: Implement any process changes (new habit triggers, environment changes, schedule adjustments)
4. **Monday preview**: Brief look at Monday's commitments

### 4.1 Write Weekly Summary

Write `{journal_path}\weekly\YYYY-Www.md`:

```markdown
---
week: "YYYY-Www"
date_range: "[start] to [end]"
energy_avg: [score]
focus_avg: [score]
mood_avg: [score]
sleep_avg: [hours]
sleep_quality_avg: [score]
priority_completion_pct: [%]
emotional_events: [count]
incidents: [count]
decisions: [count]
system_health: [score]
---
## Weekly Architecture Review: [Week of Date]

### Metrics Summary
- Energy avg: [score]/10, Trend: [↑↓→]
- Focus avg: [score]/10, Trend: [↑↓→]
- Mood avg: [score]/10, Trend: [↑↓→]
- Sleep avg: [hours], Quality: [score]/10
- Emotional volatility: [stddev]
- Priority completion rate: [%]
- System health: [score]/10

### Debt Assessment
- Physical: [score]/5 severity, [score]/5 interest
- Cognitive: [score]/5 severity, [score]/5 interest
- Emotional: [score]/5 severity, [score]/5 interest
- Social: [score]/5 severity, [score]/5 interest
- Career: [score]/5 severity, [score]/5 interest
- Environmental: [score]/5 severity, [score]/5 interest

### Priority Debt to Service
1. [highest urgency debt + plan]

### Patterns
- Positive: [patterns to continue]
- Negative: [patterns to change]
- Recurring triggers: [most common emotional triggers]
- Recurring distortions: [most common cognitive distortions]

### Next Week Goals
1. Goal: [goal 1] | Key result: [measure]
2. Goal: [goal 2] | Key result: [measure]

### Weekly Intention
[One sentence focus for the week]

### One Big Question
[Question to hold this week]
```

### 4.2 Update Baselines

Update `{journal_path}\meta\baselines.json`:
- Recompute all averages, standard deviations from ALL historical time-series data
- Update `common_emotions` from mood.csv frequency analysis
- Update `common_triggers` from triggers.csv frequency analysis
- Update `common_distortions` from distortions.csv frequency analysis

### 4.3 Git Commit

```bash
cd {journal_path}
git add -A
git commit -m "weekly: YYYY-Www"
git push 2>/dev/null || echo "No remote configured — push skipped"
```

**Output**: Complete weekly review log + baselines updated + committed

---


