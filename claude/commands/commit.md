---
description: Spawn the git-specialist agent to fulfill the request
allowed-tools: Bash, BashOutput, Read, Glob, Grep, LS, Task, TodoRead, AskUserQuestion, WebFetch, WebSearch, ExitWorktree
argument-hint: [patch|minor|major|close] [issue-numbers]
---

Arguments: $ARGUMENTS

Parse the arguments as follows:

- The **first word** is the release type: either "patch", "minor", "major", or "close"
- **Everything after the first word** is a list of GitHub issue numbers to close. They may be comma-separated, space-separated, or both (e.g. "188,189,190" or "188, 189, 190" or "188 189 190"). Strip any commas and extract all numbers.

**If the first word is "patch", "minor", or "major", create a release of that type (step 9 below).**
**If the first word is "close" or anything else, DO NOT create a release (skip step 9).**

You ARE the git specialist agent. Follow these instructions exactly:

@.claude/agents/git-specialist.md

And do the following:

1. If on `main`, create a new branch. Otherwise, use the current branch (e.g. when inside a worktree that already has its own branch).
2. Stage all changes (excluding changelog — added in step 3)
3. Spawn the docs-specialist agent via Task to write or update today's changelog at `docs/changelogs/changelog-YYYY-MM-DD.md`. Pass it the full `git diff --staged` output and the intended commit message. If a changelog for today already exists, the specialist must read it and produce a unified rewrite that integrates the new changes — not a stack of appended sections. Then stage the changelog file alongside the other changes before committing.
4. Commit all staged changes (source changes + changelog together)
5. Push
6. Create a PR with relevant notes from the latest changelogs (make sure it closes **each** parsed issue number)
7. Merge if possible
8. Pull latest main into the local main branch. **IMPORTANT:** Never use `git checkout main` — it fails when inside a worktree because main is already checked out in the primary repo. Instead use:
   ```bash
   git -C /<main-dir-name>/ pull origin main
   ```
9. **ONLY** if $1 is equal to "patch", "minor" or "major", then create a **$1** release, otherwise skip this step. **IMPORTANT:** Always run `gh release list --limit 1` to get the actual latest version before computing the next one. NEVER rely on memory or conversation context for version numbers.
10. If inside a worktree, clean it up in two sub-steps:

    **10a.** Call the `ExitWorktree` tool with `action: "remove"`. This removes the worktree directory AND resets the session CWD back to the main repo in one atomic operation. Do NOT attempt to remove the worktree via Bash — `git worktree remove` deletes the shell's CWD, making every subsequent Bash call fail.

    **10b.** After ExitWorktree returns, the session CWD is the main repo. Now delete branches and prune in a single Bash call:

    ```bash
    git branch -D <linked-branch> 2>/dev/null ; \
    git branch -D worktree-<name> 2>/dev/null ; \
    git branch -D feature/<name> 2>/dev/null ; \
    git branch -D bugfix/<name> 2>/dev/null ; \
    git branch -D hotfix/<name> 2>/dev/null ; \
    git push origin --delete <linked-branch> 2>/dev/null ; \
    git fetch --prune ; \
    git branch --merged origin/main | grep -v "^\*\|main" | xargs -r git branch -d 2>/dev/null ; \
    true
    ```

11. If NOT inside a worktree, delete all remaining fully merged local and remote branches (run from current directory — already on main).
