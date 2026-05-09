---
name: write-development-rules
description: Create, rewrite, review, or distill practical development rules and coding standards. Use when the user asks for development rules, team conventions, repo guidelines, engineering principles, AGENTS.md/CLAUDE.md/CURSOR rules, review checklists, hook rules, or Chinese prompts such as 写规则, 开发规范, 编码规范, 规则结构, 规则模板, 规则沉淀.
---

# Write Development Rules

## Purpose

Produce development rules that are actionable enough to guide real work, detailed enough to prevent misreadings, and concise enough to stay useful during implementation.

## Workflow

1. Identify the rule target.
   - Infer the audience, repo, framework, file type, and enforcement level from the user's request and local context.
   - Ask one concise question only when the target cannot be inferred safely.
   - If the user names existing files, read them before writing.

2. Choose the output shape.
   - For one rule, use: scope, goal, principles, concrete rules, examples, checklist, exceptions.
   - For a rule set, group by workflow stage or ownership area.
   - For agent instruction files, prioritize operating rules, repo conventions, verification expectations, and response style.
   - For review checklists, keep each item observable and testable.

3. Write for execution.
   - Prefer imperatives and clear defaults: "Use", "Prefer", "Avoid", "Require".
   - State when the rule applies and when it does not.
   - Include concrete positive and negative examples when ambiguity is likely.
   - Define exceptions so the rule does not become brittle.

4. Tighten the draft.
   - Remove background that does not change behavior.
   - Replace vague goals with observable actions.
   - Merge duplicate rules.
   - Keep rationale short and attached to the rule it explains.

## Rule Anatomy

Use this structure by default:

```md
# Rule Name

## Scope
Where this rule applies: code areas, file types, workflows, roles, or technologies.

## Goal
One sentence explaining the behavior the rule should produce.

## Principles
- 2-4 judgment rules for ambiguous cases.

## Rules
- Concrete requirements.
- Clear defaults.
- Explicit "avoid" cases when useful.

## Examples
Good and bad examples that match the user's stack or document type.

## Checklist
- Short self-review list.

## Exceptions
Allowed deviations and the condition for using them.
```

For compact outputs, collapse to:

```md
## Scope
## Rules
## Examples
## Checklist
```

## Quality Bar

Rules should be:

- Specific: name the file, layer, workflow, or behavior affected.
- Actionable: tell the developer what to do next.
- Bounded: avoid universal claims unless they are truly universal.
- Testable: make compliance visible in code review, tests, linting, or runtime behavior.
- Proportional: give more detail for risky or repeated mistakes, less detail for obvious conventions.
- Local: follow existing project patterns instead of importing generic best practices blindly.

Avoid:

- "Write clean code" without explaining the observable behavior.
- Long essays before the actual rule.
- Rules that only say "be consistent".
- Absolute bans with no exception path.
- Examples that use a different stack from the user's project.
- Checklists with items that cannot be verified.

## Patterns

### Development Rule

```md
## Scope
Applies to ...

## Goal
Ensure ...

## Rules
- Prefer ...
- Require ...
- Avoid ...

## Examples
Good:
...

Avoid:
...

## Checklist
- ...

## Exceptions
...
```

### Agent Rule

```md
## Context Gathering
- Read ...
- Search ...

## Implementation
- Follow ...
- Preserve ...

## Verification
- Run ...
- Report ...

## Communication
- Keep ...
```

### Review Checklist

```md
## Checklist
- Does the change ...
- Are errors handled by ...
- Is behavior covered by ...
- Did the implementation avoid ...
```

## Distilling Rules From A Codebase

When the user asks to create project-specific rules:

1. Inspect representative files before writing.
2. Identify repeated patterns, naming conventions, boundaries, and verification commands.
3. Separate "observed convention" from "recommended improvement".
4. Write rules in the project's vocabulary.
5. Avoid inventing policies that the codebase does not support unless clearly labeled as recommendations.

## Editing Existing Rules

When updating an existing rule file:

- Preserve useful project-specific constraints.
- Remove contradictions or duplicate guidance.
- Tighten broad claims into enforceable defaults.
- Keep unrelated sections intact.
- If making file edits, summarize what changed and why.
