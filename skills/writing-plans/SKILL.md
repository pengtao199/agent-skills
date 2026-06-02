---
name: writing-plans
description: Write concise, repo-grounded implementation plans before coding. Use when the user asks for a plan, implementation plan, execution plan, staged roadmap, task breakdown, or Chinese requests such as 写计划, 计划文档, 梳理成计划, 规划下, 执行计划, 先分析再计划. Use especially when a plan should guide an agent or engineer without becoming a long audit, code tutorial, or generic best-practices essay.
---

# Writing Plans

## Purpose

Create compact implementation plans that make the next action obvious. A good plan names the goal, locks the scope, points to the relevant code or docs, breaks work into verifiable slices, and avoids unnecessary code explanation.

## Workflow

1. Read before planning.
   - Inspect the relevant repo files, rules, existing plan index, logs, or docs before writing.
   - If the user only asks for analysis, stop at analysis unless they also ask for a saved plan.
   - If the worktree is dirty, preserve unrelated changes and mention any affected files.

2. Choose the plan depth.
   - Use a short plan for narrow changes, bug fixes, UI adjustments, doc cleanup, and follow-up work.
   - Use a staged plan for multi-area work, migrations, large refactors, infrastructure changes, or risky production workflows.
   - Split separate subsystems into separate plans when one document would hide real dependencies or sequencing.

3. Anchor the plan in current facts.
   - Prefer exact file paths, symbols, commands, API names, and existing conventions.
   - Keep facts brief. Link or point to source instead of explaining large code blocks.
   - Mark assumptions explicitly when they have not been verified.

4. Write the plan.
   - Keep the default target length around 80-180 lines.
   - Use no code blocks unless an interface contract, SQL statement, command, or tiny example is necessary.
   - Make each work slice independently reviewable and verifiable.
   - Include non-goals so the plan does not invite scope creep.

5. Self-review before handing off.
   - Remove background that does not change execution.
   - Replace vague actions like "improve error handling" with observable work.
   - Ensure every task has a verification signal.
   - Check that the plan does not duplicate durable project rules or become an audit report.

## Default Plan Shape

Use this shape unless the repo already has a better local format:

```md
# <Feature or Task> Plan

Updated: <date and timezone>
Status: Draft | Ready | In Progress | Done | Archived

## Goal
One or two sentences describing the outcome.

## Current Facts
- Relevant verified facts from code, docs, logs, or product context.
- Include exact paths when useful.

## Non-Goals
- Things this plan will not do.

## Approach
The chosen direction and the tradeoff behind it.

## Work Slices

### Slice 1: <name>
- Intent: What this slice changes.
- Files: Exact files or directories likely to change.
- Steps: 2-5 concise actions.
- Verify: Commands, tests, screenshots, manual checks, or data checks.
- Checkpoint: Commit, review, or user confirmation point when useful.

### Slice 2: <name>
...

## Risks
- Known uncertainty, migration risk, dependency, or rollback concern.

## Done Criteria
- Concrete conditions that prove the plan is complete.
```

For very small tasks, collapse the plan to: Goal, Scope, Steps, Verify.

## Quality Bar

Plans should be:

- Concise: short enough to stay readable during implementation.
- Grounded: based on the current repo or live source of truth, not memory alone.
- Sequenced: earlier slices unblock later slices.
- Verifiable: each slice has a test, command, review point, or observable check.
- Scoped: non-goals and skipped work are visible.
- Practical: enough detail to start, not enough prose to bury the start.

Avoid:

- Long first-principles essays unless the user asks for research.
- Full code listings, broad code explanations, or tutorial text.
- Mixing plan, audit, rules, ADR, and execution log into one document.
- Repeating durable repo rules instead of linking or referencing them.
- "TBD", "TODO", "similar to above", or "add appropriate handling".
- Making implementation promises that were not verified against the repo.

## Saving Plans

When the user asks to save a plan:

1. Use the repo's existing plan directory and naming convention.
2. Update the plan index only when the repo maintains one.
3. Do not silently mark stale plans active. Archive or label old entries when the task requires it.
4. Keep saved plans as execution artifacts; put long background research in docs, reports, or references instead.

## Handoff

When the plan is complete, state:

- Where the plan was saved, if saved.
- The first recommended slice to execute.
- What was not verified or intentionally left out.
