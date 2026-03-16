---
description: Improve internal code structure without changing external behavior.
---

# Workflow: Refactor Code (`refactor.md`)

## Purpose
The purpose of this workflow is to restructure existing code to improve readability, maintainability, performance, or modularity, while explicitly ensuring that external public interfaces and behavior remain identical. 

## When to Use
Use this workflow when technical debt is slowing down progress, when preparing a module for future extensibility (e.g., applying the Strategy pattern ahead of a feature), or during the Optimization stage of a phase.

## Inputs
- Problematic code location or target file(s).
- Refactoring goal (e.g., "Extract function," "Apply Clean Architecture," "Remove duplicates").
- Existing tests.

## Steps
1. **Baseline Assessment:** Identify the current behavior and the test coverage for the target code. Do not proceed if there is zero test coverage for a critical path.
2. **Define the Refactor:** Propose the new structure (e.g., splitting one massive file into three focused classes).
3. **Execute Incrementally:** Apply the refactoring in small, atomic steps. Run tests frequently.
4. **Verify Behavior:** Ensure all existing unit and integration tests still pass perfectly. No new features should be added during this workflow.
5. **Clean Up:** Remove dead code, update imports, and fix linting errors introduced by the changes.

## Output Artifact
Refactored code + passing tests.

## Review Requirements
The user must approve the structural changes, as refactoring often involves renaming files or changing directory locations that developers need to be aware of.

## Example Usage
```
User: The UserAuth class is 1000 lines long. Let's refactor it.
AI: Starts Refactor workflow -> Reviews test coverage -> Proposes splitting into AuthRepository, SessionManager, and TokenService -> Approvals from user -> Performs split incrementally -> Verifies tests -> Updates docs.
```
