---
description: Emotional state check — collect emotional metrics, detect anomalies, identify triggers, apply regulation if needed
agent: life-engineer
---

# Daily Emotional Observability

Run a structured emotional state check. Collect emotional metrics, detect anomalies against baseline, identify trigger events, and apply regulation strategies when needed.

> **When**: 2-3 times per day (morning, mid-day, evening) or whenever you notice emotional state shift.
> **Duration**: 5-10 minutes.
> **Analog**: Application Performance Monitoring (APM) for the emotional runtime — collect metrics, detect anomalies, log events, trigger alerts.

> [!CAUTION]
> This workflow requires human approval between every phase.
> Do NOT skip phases. Do NOT combine phases into a single response.

---

## PHASE 1 — EMOTIONAL METRICS COLLECTION

**No analysis. Raw data collection only.**

Take an emotional snapshot:

1. **Primary emotion**: What emotion(s) are you experiencing right now? Name them specifically (e.g., not just "bad" but "frustration + anxiety").
2. **Intensity** (1-10): How intense is the strongest emotion?
3. **Body sensations**: What physical sensations accompany this state? (Tension in shoulders? Knot in stomach? Racing heart? Fatigue?)
4. **Recent triggers**: What event(s) occurred since last check that may have influenced this state?
5. **Current narrative**: What story are you telling yourself about the current situation?
6. **Urge**: What do you feel compelled to DO in this state? (Withdraw? Lash out? Fix? Avoid?)

**Reference**: `develop-life/part-5-emotional.md` Ch1 (Regulation), Ch2 (Fear/Anxiety), Ch4 (Social Pressure); `develop-life/special-topics.md` Topic 2 (Observability), Topic 11 (Event-Driven Emotions)

**Output**: `SCRATCHPAD.md` with raw emotional metrics

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Metrics Collection) complete. Please review SCRATCHPAD.md.
Reply APPROVE to continue to anomaly detection, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — ANOMALY DETECTION & ANALYSIS

**Scratchpad must be APPROVED. No regulation actions yet.**

### 2.0 Baseline Read

Read `{journal_path}\meta\baselines.json` for historical comparisons:

```json
{
  "mood_intensity": { "avg": 5.5, "stddev": 1.5 },
  "anomaly_threshold_stddevs": 2.0
}
```

**Anomaly check**: If current intensity > (avg + 2 * stddev), flag as anomalous:
```
Current intensity [X] is [Z] standard deviations above your average of [Y]
```

Analyze emotional state against baseline:
2. **Deviation characterization**:
   - **Amplitude deviation**: Emotion is unusually intense for the trigger
   - **Duration deviation**: Emotion is persisting longer than expected
   - **Context deviation**: Emotion is mismatched to the situation
   - **Pattern deviation**: This is a known recurring pattern (trigger → emotion → behavior)
3. **Root cause hypothesis**: What is the actual cause? Is the stated trigger the real trigger, or is there an earlier event in the causal chain?
4. **System impact**: How is this emotional state affecting your cognitive function, behavior, and decisions right now?

**Output**: `PLAN.md` with analysis findings and regulation strategy (if needed)

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Anomaly Detection) complete. Please review PLAN.md.
Reply APPROVE to execute regulation or continue to logging, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — REGULATION (IF NEEDED)

**Plan must be APPROVED.**

If an anomaly was detected and regulation is needed, select and apply a strategy:

**Top-down regulation (cognitive)**:
- **Reappraisal**: Reframe the situation. "What's another interpretation of this event?"
- **Perspective-taking**: "How will I feel about this in 1 day / 1 week / 1 year?"
- **Labeling**: Simply name the emotion. "I am experiencing anxiety." (Reduces amygdala activation)

**Bottom-up regulation (physiological)**:
- **Breathing**: 4-7-8 breathing (inhale 4s, hold 7s, exhale 8s) — activates parasympathetic system
- **Grounding**: 5-4-3-2-1 (5 things you see, 4 you feel, 3 you hear, 2 you smell, 1 you taste)
- **Movement**: Brief physical activity to discharge stress hormones

**If regulation is NOT needed** (state is within normal range): Skip directly to logging.

---

## PHASE 4 — EVENT LOGGING & PERSISTENCE

Log the complete emotional event record:

```markdown
## Emotional Event Log: [Timestamp]

### State
- Primary emotion(s): [named emotions]
- Intensity: [score]/10
- Body sensations: [description]

### Context
- Trigger event: [what happened]
- Current narrative: [storytelling]
- Urge: [behavioral impulse]

### Analysis
- Deviation type: [none / amplitude / duration / context / pattern]
- Root cause hypothesis: [analysis]

### Regulation (if applied)
- Strategy used: [top-down: reappraisal / bottom-up: breathing/grounding/movement]
- Effectiveness (1-10): [score]

### System impact
- Cognitive: [how thinking is affected]
- Behavior: [how actions are affected]
```

### 4.1 Persist to Journal

Append to `{journal_path}\time-series\mood.csv`:
```csv
YYYY-MM-DD,[timestamp],[emotion],[intensity],[positive/negative],[trigger],[regulation],[effectiveness]
```

If a trigger was identified, append to `{journal_path}\events\triggers.csv`:
```csv
YYYY-MM-DD,[timestamp],[emotion],[intensity],[trigger],[context],[narrative],[urge],[deviation_type],[regulation],[effectiveness]
```

### 4.2 Git Commit

```bash
cd {journal_path}
git add -A
git commit -m "emotion: YYYY-MM-DD HH:MM"
git push 2>/dev/null || echo "No remote configured — push skipped"
```

**Output**: Saved emotional event log entry + journal persisted + committed

---

// turbo
