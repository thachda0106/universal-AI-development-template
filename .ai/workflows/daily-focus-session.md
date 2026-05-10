---
description: Deep work execution — isolate environment, single-thread execution, maximize cognitive throughput
agent: life-engineer
---

# Daily Focus Session

Execute a deep work block using single-threaded execution principles. Eliminate context switches, isolate cognitive resources, and maximize throughput on a single task.

> **When**: Once or twice daily, during peak energy windows.
> **Duration**: 25-90 minutes per session (adjust based on cognitive capacity).
> **Analog**: Single-threaded high-CPU process — pin to core, set affinity, eliminate interrupts, maximize compute.

> [!CAUTION]
> This workflow requires human approval between every phase.
> Do NOT skip phases. Do NOT combine phases into a single response.

---

## PHASE 1 — CONTEXT ASSESSMENT

**No execution. Data collection only.**

Assess current state for focus readiness:

1. **Current cognitive load** (1-10): How mentally fatigued are you right now?
2. **Task selected**: What is the ONE task to execute? (Must be a single atomic unit)
3. **Estimated difficulty** (1-10): How cognitively demanding is this task?
4. **Timebox**: What duration? (25 min minimum, 90 min maximum)
5. **Interrupt risk**: What could interrupt you? Known notifications? People? Urges?
6. **Environment state**: Is your workspace configured for focus?

**Reference**: `develop-life/part-4-performance.md` Ch1 (Deep Focus), Ch5 (Cognitive Load); `develop-life/part-1-foundations.md` Ch4 (Attention)

**Output**: `SCRATCHPAD.md` with focus readiness data

### 🛑 HARD STOP — APPROVAL GATE 1

```
Say: "Phase 1 (Context Assessment) complete. Please review SCRATCHPAD.md.
Reply APPROVE to design the focus protocol, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 2 — FOCUS PROTOCOL DESIGN

**Scratchpad must be APPROVED. No execution yet.**

Design the focus execution protocol:

1. **Task atomicity check**: Is the selected task truly a single unit of work? If not, break it down until it is.
2. **Environment hardening**: Close all irrelevant tabs/browsers. Silence phone. Close email/chat. Put on focus-mode tools.
3. **External communication**: Set status to "Focus / Do Not Disturb." If others might interrupt, brief them: "I'll be unreachable for X minutes."
4. **Recovery plan**: Decide what you'll do during the post-focus recovery period (5-15 min, no screens, physical movement).
5. **Success metric**: Define what "done" looks like for this session. NOT completion of the task — output within the timebox.

**Output**: `PLAN.md` with focus protocol

### 🛑 HARD STOP — APPROVAL GATE 2

```
Say: "Phase 2 (Focus Protocol) complete. Please review PLAN.md.
Reply APPROVE to execute the focus session, or provide feedback."
WAIT for explicit approval.
```

---

## PHASE 3 — EXECUTION

**Plan must be APPROVED.**

1. **Priming** (2 min): Review the task context. Where did you leave off? What's the next step?
2. **Environment lockdown**: Apply all planned environment configurations
3. **Start timer**: Begin the timebox
4. **Execute single-threaded**: Work on ONLY the selected task. If an interrupt/urge arises:
   - Note it on scratch paper (do NOT act on it)
   - Return immediately to the task
   - Handle noted items after the session
5. **End at timer**: Stop when timer goes off. Do NOT push past the timebox.
6. **Recovery**: Execute planned recovery activity. No screens. Physical movement.

---

## PHASE 4 — SESSION REVIEW & JOURNALING

After focus session and recovery:

1. **Log focus quality** (1-10): How deep was focus? How many interruptions?
2. **Output assessment**: What was produced? Compare to success metric.
3. **Distraction log**: Review noted interruptions. Any patterns? System improvements needed?
4. **Cognitive state after** (1-10): How depleted are you now?
5. **Decision**: Another session today? Or switch to shallow work?

### 4.1 Persist to Journal

Append to `{journal_path}\time-series\focus.csv`:
```csv
YYYY-MM-DD,[session_id],[score],[duration_min],[distractions],[notes]
```

Where `session_id` = sequential number for today's sessions (1, 2, 3...).

### 4.2 Git Commit

```bash
cd {journal_path}
git add -A
git commit -m "focus: YYYY-MM-DD session-[N]"
git push 2>/dev/null || echo "No remote configured — push skipped"
```

**Output**: Focus session log entry + time-series appended + committed

---

// turbo
