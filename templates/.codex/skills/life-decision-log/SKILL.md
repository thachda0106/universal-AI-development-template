---
name: life-decision-log
description: Log significant decisions with rationale, expected value calculation, and follow-up schedule for outcome tracking
---


# Life Decision Log

Record significant decisions with full context, analysis, and expected outcomes. This creates a traceable decision history for calibration and learning — enabling Bayesian updating of your decision-making models.

> **When**: On-demand — whenever you make a significant decision (career, relationship, finance, health, major purchase, etc.).
> **Duration**: 5-15 minutes.
> **Analog**: Architecture Decision Record (ADR) — capture context, options considered, decision rationale, expected consequences, and review schedule.

> [!CAUTION]
> This workflow requires human approval between every phase.
> Do NOT skip phases. Do NOT combine phases into a single response.

---

## PHASE 1 — DECISION CONTEXT

**No analysis. Context collection only.**

Define the decision to be made:

0. **Check pending follow-ups**: Scan `{journal_path}\decisions\` for decisions with `status: active` and `follow_up_date <= today`. Alert user of any due follow-ups.
1. **Decision statement**: What decision needs to be made? State it clearly.
2. **Options**: What are the realistic options? (At least 2. If there seems to be only 1, question the assumption.)
3. **Timeframe**: By when does this decision need to be made?
4. **Stakes**: What's at risk? What's the cost of being wrong?
5. **Reversibility**: Is this a two-way door (reversible, low cost) or one-way door (irreversible, high cost)?
6. **Emotional state** (1-10): What emotional state are you in while making this decision? (High emotion = defer if possible)

**Reference**: `develop-life/part-2-debugging.md` Ch8 (Decision Trees); `develop-life/part-3-mental-models.md` Ch4 (Probabilistic Thinking), Ch5 (Bayesian Reasoning), Ch7 (Opportunity Cost)

**Output**: `SCRATCHPAD.md` with decision context

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Decision Context) complete. Please review SCRATCHPAD.md.
Reply APPROVE to continue to analysis, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — ANALYSIS

**Scratchpad must be APPROVED. No decision yet.**

Analyze the decision systematically:

### 1. Option Analysis Table

| Criteria | Option A | Option B | Option C |
|----------|----------|----------|----------|
| Description | [brief] | [brief] | [brief] |
| Upside | [best case] | [best case] | [best case] |
| Downside | [worst case] | [worst case] | [worst case] |
| Probability of success | [0-100%] | [0-100%] | [0-100%] |
| Expected value | [numeric estimate] | [numeric estimate] | [numeric estimate] |
| Time commitment | [time] | [time] | [time] |
| Energy cost | [1-10] | [1-10] | [1-10] |
| Opportunity cost | [what you forego] | [what you forego] | [what you forego] |
| Alignment with goals | [1-10] | [1-10] | [1-10] |

### 2. Expected Value Calculation
For each option, estimate:
```
EV = (Probability of Success × Value of Success) + (Probability of Failure × Value of Failure)
```

Where "value" includes not just immediate outcome but also:
- Learning value (what you gain regardless of outcome)
- Option value (what future opportunities this preserves/creates)
- Identity value (does this align with who you want to become?)

### 3. Bayesian Prior
What is your prior probability of success for similar decisions? (Based on your track record with similar choices.)
- Prior: [X%]
- How does this decision differ from previous similar ones?
- Bayesian update after this decision (to be filled in during review phase):

### 4. Opportunity Cost Check
- What are you saying NO to by saying YES to each option?
- What is the cost of NOT making a decision? (Indecision is itself a decision — usually the worst one.)

### 5. Pre-commitment Test
- If a friend came to you with this same decision, what would you advise?
- What would you choose if you had to tell someone else your decision within 5 minutes?
- What would you choose if there were no fear involved?

**Output**: `PLAN.md` with full analysis

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Analysis) complete. Please review PLAN.md.
Reply APPROVE to make the decision and log it, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — DECISION RECORD

**Plan must be APPROVED.**

Make the decision and record it:

### Decision Record

```markdown
## Decision Log: [Date]

### Decision
[Chosen option]

### Rationale
[Why this option over others — key factors that drove the decision]

### Expected Outcome
[What you predict will happen as a result]

### Predicted Success Probability
[0-100%] — How confident are you in this decision?

### Key Assumptions
1. [Assumption that must hold for this decision to be correct]
2. [Another assumption]

### Hedge / Mitigation
[What can you do to reduce downside risk? What's your fallback?]

### Follow-up Date
[Date to review this decision — typically 1 week to 3 months depending on stakes]

### Emotional Check
Emotional state during decision: [score]/10
Is this decision influenced by: [fear / excitement / social pressure / fatigue / other]?
```

---

## PHASE 4 — FOLLOW-UP CALIBRATION

After the follow-up date:

1. **Outcome**: What actually happened?
2. **Comparison**: Did the outcome match the prediction?
3. **Calibration**: Was your probability estimate accurate? (Overconfident? Underconfident?)
4. **Bayesian update**: Update your prior for similar future decisions
5. **System improvement**: What does this decision outcome reveal about your decision-making process?

```markdown
### Follow-up Review: [Date]

#### Actual Outcome
[What happened]

#### Prediction Accuracy
- Predicted outcome: [original prediction]
- Actual outcome: [what happened]
- Match? [Yes / No / Partial]

#### Calibration
- Predicted probability: [X%]
- Did it happen? [Yes/No]
- What does this tell you about your calibration?

#### Bayesian Update
- Prior for similar decisions: [X%]
- Posterior (updated) for next time: [Y%]
- What did you learn?

#### Process Improvement
- What would improve your next decision of this type?
```

### 3.1 Persist to Journal

Generate decision ID by scanning `{journal_path}\decisions\` for the highest existing number (e.g., DEC-005). New ID = next number (DEC-006).

Write `{journal_path}\decisions\DEC-NNN.md`:

```markdown
---
id: DEC-NNN
date: YYYY-MM-DD
status: active
type: [career/relationship/health/finance/other]
decision: "[chosen option]"
rationale: "[key reason]"
expected_outcome: "[predicted result]"
probability: [0-100]%
follow_up_date: YYYY-MM-DD
---
## Decision Record
[Full record from Phase 3 output]

## Follow-up
_To be filled on follow_up_date_
Outcome:
Prediction accuracy:
Calibration update:
```

### 3.2 Git Commit

```bash
cd {journal_path}
git add -A
git commit -m "decision: DEC-NNN - [brief title]"
git push 2>/dev/null || echo "No remote configured — push skipped"
```

**Output**: Saved decision record with follow-up scheduled + committed

---


