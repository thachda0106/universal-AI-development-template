---
description: Identify and fix performance bottlenecks strictly with evidence-based analysis.
---

# Workflow: Optimize Performance (`optimize-performance.md`)

## Purpose
The purpose of this workflow is to improve the execution speed, memory footprint, or bundle size of the application. Crucially, it must be driven by data (profiling, metrics) rather than intuition, and behavior must remain identical.

## When to Use
Use this workflow during the Optimization stage of the lifecycle, or when a specific performance issue is reported (e.g., "The dashboard takes 5 seconds to load").

## Inputs
- Performance report, flamegraph, or specific metric to improve.
- Target metric goal (e.g., "Reduce TTFB to < 200ms").
- Existing tests.

## Steps
1. **Establish Baseline:** Measure the current performance. Do not proceed until you have a reproducible metric. Ensure all tests pass.
2. **Profile & Diagnose:** Analyze *why* the code is slow (e.g., N+1 query, synchronous blocking I/O, large uncompressed assets).
3. **Formulate Hypothesis:** State what changes will resolve the bottleneck and the expected improvement.
4. **Implement Optimization:** Apply the fix.
5. **Verify Behavior:** Run all tests to ensure the logic was not broken.
6. **Verify Metric:** Re-measure the performance. The metric MUST show improvement for the optimization to be considered successful.

## Output Artifact
Optimized code + proof of performance improvement.

## Review Requirements
The user must approve the optimization, especially if it trades readability for performance (e.g., complex caching logic) or introduces new dependencies (e.g., adding Redis).

## Example Usage
```
User: The 'Get All Users' API is timing out.
AI: Starts Optimize Performance workflow -> Measures response time at 4000ms -> Profiles and finds N+1 query issue loading roles -> Changes to SQL JOIN -> Tests pass -> Re-measures response time at 45ms -> Commits changes.
```
