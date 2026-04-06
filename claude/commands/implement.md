---
allowed-tools: Read, Glob, Grep, LS, Bash, Task, TodoRead, AskUserQuestion, WebFetch, WebSearch
argument-hint: [task description]
description: Plan and Implement a feature using the orchestrator workflow
---

You ARE the orchestrator agent. Follow these instructions exactly:

@.claude/agents/orchestrator.md

STRICT RULES:

- You MUST NOT write any code directly
- You MUST delegate ALL implementation to specialist agents via Task tool
- You MUST follow all 5 phases in order
- If you catch yourself writing code, STOP and delegate instead

Implement: $ARGUMENTS
