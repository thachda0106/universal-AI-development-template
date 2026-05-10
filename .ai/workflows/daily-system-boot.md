---
description: Morning system boot sequence — state initialization, day architecture design, intention setting, attention budget allocation
agent: life-engineer
---

# Daily System Boot

Initialize your daily operating state. This is the morning startup sequence for the human runtime — check system health, design day architecture, allocate attention budget, and set intention.

> **When**: Every morning, before starting work.
> **Duration**: 10-15 minutes.
> **Analog**: System boot — POST check, kernel initialization, service startup, user session init.

> [!CAUTION]
> This workflow requires human approval between every phase.
> Do NOT skip phases. Do NOT combine phases into a single response.

---

## PHASE 1 — BOOT DIAGNOSTICS

**No plans or actions. Data collection only.**

Collect current system state before any planning:

1. **Sleep quality** (1-10): How well did the system recover overnight?
2. **Energy level** (1-10): Current available compute capacity
3. **Current mood** (1-10): Current emotional state register
4. **Calendar scan**: What events/commitments are scheduled today?
5. **Top 3 priorities**: What are the critical-path tasks for today?
6. **Outstanding debt**: Any carry-over from yesterday? Unresolved issues?
7. **Intention**: What single outcome would make today successful?

**Reference**: `develop-life/part-1-foundations.md` Ch1 (Human OS), Ch4 (Attention), Ch5 (Energy); `develop-life/part-4-performance.md` Ch8 (Routines)

**Output**: `SCRATCHPAD.md` with raw boot diagnostics data

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Boot Diagnostics) complete. Please review SCRATCHPAD.md.
Reply APPROVE to continue to day architecture design, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — DAY ARCHITECTURE DESIGN

**Scratchpad must be APPROVED. No actions yet.**

Design today's architecture based on diagnostic data:

1. **Priority triage**: Rank top 3 priorities by impact. Which is the highest-leverage use of today's compute?
2. **Attention budget**: Allocate attention across the day. Assign deep work blocks to high-cognitive-demand tasks. Shallow work to low-energy windows.
3. **Energy-aware scheduling**: Align tasks with predicted energy curve. Hard tasks at peak energy. Routine tasks at troughs.
4. **Interrupt handling plan**: Identify known interrupt sources. Schedule buffers for the unexpected.
5. **Environment configuration**: What does the workspace need to look like? What tools/resources need to be ready?
6. **Intention setting**: Write a single sentence: "Today, I will [specific outcome] because [why it matters]."

**Output**: `PLAN.md` with day architecture

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Day Architecture) complete. Please review PLAN.md.
Reply APPROVE to execute the boot sequence, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — SYSTEM INITIALIZATION

**Plan must be APPROVED.**

Execute the boot sequence:

1. **Execute primer action**: Do the first 2-5 minutes of the top priority (momentum priming)
2. **Configure environment**: Set up workspace per plan (close irrelevant tabs, silence notifications, prepare tools)
3. **Set external context**: Block focus time on calendar, communicate availability to relevant parties
4. **Run initial state**: Begin first work block

**Output**: Brief execution confirmation

---

## PHASE 4 — JOURNAL LOGGING

After boot sequence completes, persist data to the life-journal:

### 4.1 Write Daily Journal File

Write/update `{journal_path}\daily\YYYY-MM-DD.md`:

```markdown
---
date: YYYY-MM-DD
sleep_hours: [hours from last night]
sleep_quality: [score/10]
mood_morning: [score/10]
energy_morning: [score/10]
top_priorities:
  - [priority 1]
  - [priority 2]
  - [priority 3]
intention: "[single outcome for today]"
attention_budget: "[time blocks allocation]"
---
## Morning Boot
[any additional context or notes]
```

### 4.2 Append Time-Series Data

Append to `{journal_path}\time-series\sleep.csv`:
```csv
YYYY-MM-DD,[sleep_hours],[sleep_quality],[bedtime optional],[waketime optional],[notes]
```

Append to `{journal_path}\time-series\mood.csv`:
```csv
YYYY-MM-DD,[HH:MM],[current emotion],[mood_morning],morning,,,
```

### 4.3 Git Commit

```bash
cd {journal_path}
git add -A
git commit -m "boot: YYYY-MM-DD"
git push 2>/dev/null || echo "No remote configured — push skipped"
```

**Output**: Daily journal entry written + time-series appended + committed

---

// turbo
