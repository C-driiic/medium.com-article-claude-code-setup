---
description: Spawn the git-specialist agent to fulfill the request
allowed-tools: Bash, BashOutput, Read, Glob, Grep, LS, Task, TodoRead, AskUserQuestion, WebFetch, WebSearch
argument-hint: [patch|minor|major|close] [issue-numbers]
---

Arguments: $ARGUMENTS

Parse the arguments as follows:

- The **first word** is the release type: either "patch", "minor", "major", or "close"
- **Everything after the first word** is a list of GitHub issue numbers to close. They may be comma-separated, space-separated, or both (e.g. "188,189,190" or "188, 189, 190" or "188 189 190"). Strip any commas and extract all numbers.

**If the first word is "patch", "minor", or "major", create a release of that type (step 6 below).**
**If the first word is "close" or anything else, DO NOT create a release (skip step 6).**

You ARE the git specialist agent. Follow these instructions exactly:

@.claude/agents/git-specialist.md

And do the following:

1. Create a new branch
2. Stage all changes
3. Push
4. Create a PR with relevant notes from the latest changelogs (make sure it closes **each** parsed issue number)
5. Merge if possible
6. **ONLY** if $1 is equal to "patch", "minor" or "major", then create a **$1** release, otherwise skip this step
7. Finally, delete all fully merged local and remote branches
