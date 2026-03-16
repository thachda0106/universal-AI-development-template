---
description: Execute an approved set of tasks, converting them into code and atomic commits.
---

# Workflow: Implement Task (`implement-task.md`)

## Purpose
The purpose of this workflow is to follow the specific instructions laid out in an approved `TASKS.md` artifact exactly as written. It ensures that execution matches the design intent and avoids scope creep. It also commits the changes in a structured, atomic way.

## When to Use
Use this workflow immediately after a Task Breakdown is approved. This is where actual code is written.

## Inputs
- Approved `{N}-TASKS.md` containing XML-formatted tasks grouped into waves.

## Steps
1. **Load Current Wave:** Identify the next unfinished task or wave in the `TASKS.md`.
2. **Execute Step-by-Step:** Follow the `<action>` instructions meticulously. 
3. **Verify Locally:** Run the verification steps (from `<verify>`) to ensure the task is functional.
4. **Log Progress:** Update `{N}-IMPLEMENTATION-LOG.md` with the task status and notes.
5. **Commit (Optional/Recommended):** Create an atomic git commit referencing the task (e.g., `feat(phase-2): add user model per task 2.1`).
6. **Report:** If the wave is complete, notify the user. Wait for the user to instruct you to move to the next wave. Do not auto-advance through dependent waves.

## Output Artifact
Code changes + updated `artifacts/phases/{N}-IMPLEMENTATION-LOG.md`

## Review Requirements
The user isn't strictly required to approve every single file change mid-wave, but they must review the overall implementation check at the end of the wave or phase before advancing.

## Example Usage
```
User: Approved the 2-TASKS.md. Start execution.
AI: Starts Implement Task workflow -> Executes Wave 1 Task 1.1 -> Logs completion -> Executes Wave 1 Task 1.2 -> Logs completion -> Commits wave -> Waits for user to advance to Wave 2.
```
