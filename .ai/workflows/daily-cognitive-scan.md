---
description: Scan recent thinking for cognitive distortions and biases — catalog match, reframe, calibrate probability estimates
agent: life-engineer
---

# Daily Cognitive Scan

Run a structured scan of your recent thinking patterns to detect cognitive distortions and biases. Apply reframing and probability calibration to bring thinking back to engineering-grade accuracy.

> **When**: Once daily (mid-day or evening, when you have thinking distance from events).
> **Duration**: 5-10 minutes.
> **Analog**: Static code analysis + linter — scan for known anti-patterns, detect logical fallacies, suggest fixes.

> [!CAUTION]
> This workflow requires human approval between every phase.
> Do NOT skip phases. Do NOT combine phases into a single response.

---

## PHASE 1 — THOUGHT COLLECTION

**No analysis. Raw collection only.**

Gather recent significant thoughts for scanning:

1. **Recurring thoughts**: What thoughts have been looping or repeating today?
2. **Decisions**: What decisions did you make? What reasoning drove them?
3. **Reactions**: When you had a strong emotional reaction, what thoughts preceded it?
4. **Self-evaluations**: How have you evaluated yourself today? Your performance? Your worth?
5. **Future predictions**: What are you predicting about future outcomes? (Especially negative ones)
6. **Social comparisons**: Have you compared yourself to others today? In what context?

**Reference**: `develop-life/part-2-debugging.md` Ch5 (Cognitive Distortions); `develop-life/part-3-mental-models.md` Ch4 (Probabilistic Thinking), Ch5 (Bayesian Reasoning)

**Output**: `SCRATCHPAD.md` with collected thoughts

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Thought Collection) complete. Please review SCRATCHPAD.md.
Reply APPROVE to continue to distortion detection, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — DISTORTION CATALOG MATCHING

**Scratchpad must be APPROVED. No reframing yet.**

Run each collected thought against the distortion catalog:

### Distortion Check Table

| Distortion | Definition | Detection Question | Scan Result |
|-----------|-----------|-------------------|-------------|
| **All-or-nothing thinking** | Seeing situations in binary categories without gray area | "Am I treating this as completely good/bad with no middle ground?" | Yes/No + example |
| **Catastrophizing** | Assuming the worst possible outcome will happen | "Am I predicting the worst-case scenario as the most likely?" | Yes/No + example |
| **Overgeneralization** | Drawing broad conclusions from a single event | "Am I using 'always'/'never'/'everyone'/'no one' based on one incident?" | Yes/No + example |
| **Mind reading** | Assuming you know what others think without evidence | "Am I certain I know what someone else is thinking?" | Yes/No + example |
| **Fortune telling** | Predicting negative outcomes with certainty | "Am I treating a prediction as a foregone conclusion?" | Yes/No + example |
| **Emotional reasoning** | Assuming feelings are facts | "Am I treating my emotional state as evidence of reality?" | Yes/No + example |
| **Should statements** | Rigid rules about how things/people should be | "Am I using 'should'/'must'/'ought to'?" | Yes/No + example |
| **Labeling** | Reducing complex situations/people to a single negative label | "Am I using a global label instead of describing specific behavior?" | Yes/No + example |
| **Personalization** | Taking responsibility for events outside your control | "Am I blaming myself for something I didn't cause or control?" | Yes/No + example |
| **Discounting positives** | Dismissing positive experiences or achievements | "Am I minimizing or explaining away positive events?" | Yes/No + example |
| **Magnification/Minimization** | Exaggerating negatives while shrinking positives | "Am I making a mountain out of a molehill (or vice versa)?" | Yes/No + example |
| **Comparison trap** | Evaluating self-worth based on relative position to others | "Am I measuring myself against someone else's metrics?" | Yes/No + example |

**Output**: `PLAN.md` with detected distortions and their frequency/severity

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Distortion Detection) complete. Please review PLAN.md.
Reply APPROVE to continue to reframing, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — REFRAMING & CALIBRATION

**Plan must be APPROVED.**

For each detected distortion, apply reframing:

1. **State the distorted thought**: "I thought [distortion]"
2. **Identify the distortion type**: "This is [distortion type]"
3. **Generate balanced alternative**: "A more accurate way to think about this is [alternative]"
4. **Calibrate probability**: If the distortion involves probability estimates (catastrophizing, fortune telling):
   - What is the actual probability of the feared outcome? (0-100%)
   - What is the best-case scenario? Most likely scenario?
   - What is your track record with similar predictions? (Are you calibrated?)
5. **Evidence check**: What evidence supports the distorted thought? What evidence contradicts it? What evidence is missing?

**Example**:
- Distortion: "I'll never get promoted. I messed up that presentation."
- Type: Overgeneralization + Fortune telling
- Reframe: "I gave one presentation that didn't meet my standards. That's a data point, not a verdict. I can identify what went wrong and improve for next time."
- Calibration: Actual probability of never getting promoted = close to 0%. Track record with "never" predictions = consistently wrong.

---

## PHASE 4 — LOGGING & PERSISTENCE

Log detected distortions and reframes:

```markdown
## Cognitive Scan Log: [Date]

### Distortions Detected
| # | Distortion Type | Original Thought | Severity (1-5) |
|---|----------------|-----------------|-----------------|
| 1 | [type] | [thought] | [1-5] |
| 2 | [type] | [thought] | [1-5] |

### Reframes Applied
- [thought 1 reframe]
- [thought 2 reframe]

### Calibration Notes
- [probability corrections made]

### Pattern Observations
- [recurring distortion patterns to watch]
- [contexts/triggers associated with distortions]

### Accuracy Score
- Estimated thinking accuracy today (1-10): [score]
```

### 4.1 Persist to Journal

For each detected distortion, append to `{journal_path}\events\distortions.csv`:
```csv
YYYY-MM-DD,[distortion_type],[original_thought (escaped)],[severity],[reframe (escaped)]
```

### 4.2 Git Commit

```bash
cd {journal_path}
git add -A
git commit -m "cognitive-scan: YYYY-MM-DD"
git push 2>/dev/null || echo "No remote configured — push skipped"
```

**Output**: Saved cognitive scan log entry + distortions appended + committed

---

// turbo
