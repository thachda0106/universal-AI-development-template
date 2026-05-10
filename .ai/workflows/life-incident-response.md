---
description: Crisis handling protocol for emotional/relationship/failure incidents — triage, root cause, resolution, postmortem
agent: life-engineer
---

# Life Incident Response

Structured incident response protocol for emotional crises, relationship conflicts, or significant failures. Treat incidents as production SEVs — with organized triage, containment, root cause analysis, resolution, and blameless postmortem.

> **When**: On-demand — whenever you experience a significant emotional/relational/failure event.
> **Duration**: 15-60 minutes depending on severity.
> **Analog**: Production incident response — SEV classification, triage, containment, root cause, fix, postmortem.

> [!CAUTION]
> This workflow requires human approval between every phase.
> Do NOT skip phases. Do NOT combine phases into a single response.

---

## PHASE 1 — INCIDENT TRIAGE

**No analysis. Immediate stabilization only.**

### Step 1: Severity Assessment

| Severity | Definition | Examples | Response |
|----------|-----------|----------|----------|
| **SEV1** | Immediate danger to self or others | Suicidal ideation, panic attack, serious accident, violent conflict | Stop all workflows. Contact emergency services or trusted person immediately. This tool is not for SEV1. |
| **SEV2** | Significant distress, system is degraded | Intense emotional reaction, major conflict, significant failure, overwhelming anxiety | Full incident protocol. Prioritize containment and stabilization before analysis. |
| **SEV3** | Moderate disruption, system is impacted but functional | Moderate frustration, disappointment, disagreement, minor setback | Incident protocol with reduced urgency. Proceed through phases but allow flexible timing. |
| **SEV4** | Minor disturbance, system is functional | Mild annoyance, slight disappointment, minor discomfort | Skip incident protocol. Use emotional observability or cognitive scan instead. |

**If SEV1**: STOP using this tool. Contact professional help or trusted person.

### Step 2: Immediate Stabilization (SEV2-3 only)

Before any analysis, stabilize the system:

1. **Physical grounding**: If physiologically activated (racing heart, shallow breathing, tension):
   - 5-4-3-2-1 grounding technique (5 things you see, 4 you feel, 3 you hear, 2 you smell, 1 you taste)
   - Slow breathing: inhale 4s, hold 4s, exhale 6s — repeat 5 times
   - If possible, change physical environment (step outside, different room)
2. **Cognitive grounding**: If mentally spiraling (rumination, catastrophizing, racing thoughts):
   - State out loud: "I am having a [emotion] response to [trigger]. This is a signal, not a fact."
   - State out loud: "I am safe right now. My nervous system is responding to a perceived threat."
   - Count to 10 slowly
3. **Safety check**: Are you in a physically and socially safe environment? If not, move to safety first.

**Reference**: `develop-life/special-topics.md` Topic 1 (Incident Response), Topic 9 (Production Failures); `develop-life/part-5-emotional.md` Ch1 (Regulation), Ch6 (Resilience)

**Output**: `SCRATCHPAD.md` with SEV classification and stabilization state

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Incident Triage) complete. Please review SCRATCHPAD.md.
Reply APPROVE to continue to root cause analysis, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — ROOT CAUSE ANALYSIS

**Scratchpad must be APPROVED. System must be stabilized before proceeding.**

Analyze the incident systematically:

### 1. Incident Timeline
Map what happened in sequence:
```
[Timestamp 1] Initial trigger: [event]
[Timestamp 2] Immediate response: [thought/emotion/action]
[Timestamp 3] Escalation/development: [what happened next]
[Timestamp 4] Current state: [where things are now]
```

### 2. The 5 Whys Analysis
Keep asking "why" until you hit the root cause:
```
Problem: [immediate symptom]
Why? → [first-level cause]
Why? → [second-level cause]  
Why? → [third-level cause]
Why? → [fourth-level cause]
Why? → [ROOT CAUSE: fundamental mechanism]
```

### 3. Symptom vs. Cause Distinction
- **Symptom** (what appears to be wrong):
- **Proximate cause** (the immediate trigger):
- **Root cause** (the underlying system condition):
- **Contributing factors** (context that enabled the incident):

### 4. Pre-existing Conditions
What system conditions made this incident possible?
- Unresolved stress or fatigue? (low system resources)
- Unprocessed emotions from previous events? (state carryover)
- Missing boundaries or unclear expectations? (configuration issues)
- Unrealistic expectations of self or others? (incorrect system model)

**Output**: `PLAN.md` with root cause analysis

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Root Cause Analysis) complete. Please review PLAN.md.
Reply APPROVE to continue to resolution, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — RESOLUTION & RECOVERY

**Plan must be APPROVED.**

### 1. Immediate Fix
What action will resolve the immediate situation?
- **If emotional**: Apply regulation strategy (from Part 5 Ch1)
- **If relational**: Communication protocol (from Part 6 Ch1-4) — use specific framework
- **If failure**: Damage assessment, communication with affected parties, next-step plan

### 2. Containment
How do you prevent this from escalating or spreading to other areas?
- Boundary setting
- Communication with affected parties
- Temporary process changes
- Environment adjustment

### 3. Recovery Plan
How will you restore system stability?
- Rest/recovery period
- Self-care protocol
- Social support engagement
- Reduced cognitive load for rest of day

### 4. Compensation
If applicable, how will you address impact on others?
- Apology (not self-flagellation, but acknowledgment + repair)
- Commitment to system improvement
- Timeline for fix

---

## PHASE 4 — POST-INCIDENT REVIEW

After resolution and recovery, write the postmortem:

```markdown
## Incident Postmortem: [Date]

### Incident Summary
- SEV: [1-4]
- Type: [Emotional / Relational / Failure / Other]
- Duration: [time from trigger to resolution]
- System impact: [how were you affected? for how long?]

### Timeline
[Structured timeline from trigger to resolution]

### Root Cause
[Root cause statement: "The incident occurred because X (system condition) caused Y (mechanism) when Z (trigger) occurred."]

### Contributing Factors
- [Factor 1]
- [Factor 2]

### Resolution Applied
[What was done to resolve the incident]

### System Improvements (Action Items)
| # | Action | Owner | Timeline |
|---|--------|-------|----------|
| 1 | [system change to prevent recurrence] | [self] | [when] |
| 2 | [improvement to incident response] | [self] | [when] |

### Blameless Note
[Reminder: Incidents happen because of system conditions, not character flaws. This postmortem identifies what to improve in the system, not what's wrong with you.]

### Learnings
- What did this incident reveal about my system?
- What will I do differently next time?
```

### 4.1 Persist to Journal

Generate incident ID by scanning `{journal_path}\incidents\` for the highest existing number (e.g., INC-012). New ID = next number (INC-013).

Write `{journal_path}\incidents\INC-NNN.md`:

```markdown
---
id: INC-NNN
date: YYYY-MM-DD
severity: SEV[2/3/4]
type: [emotional/relational/failure/other]
duration_min: [minutes]
resolved: true
---
## Incident Summary
[brief description]

## Timeline
[structured timeline]

## Root Cause
[root cause statement]

## Action Items
- [ ] [item] (due: date)
- [ ] [item] (due: date)

## Learnings
[what the system revealed]
```

Also append a reference line to `{journal_path}\daily\YYYY-MM-DD.md`:
```yaml
incident_ref: "INC-NNN"
```

### 4.2 Git Commit

```bash
cd {journal_path}
git add -A
git commit -m "incident: INC-NNN - [brief summary]"
git push 2>/dev/null || echo "No remote configured — push skipped"
```

**Output**: Saved incident postmortem + committed

---

// turbo
