---
allowed-tools: Bash
description: Remove a worktree (for abandoning work without committing)
---

If $ARGUMENTS is empty or contains spaces, stop here and ask the user to provide a worktree directory name in dash-case format.
If $ARGUMENTS is provided, verify it is in dash-case format, then:

1. Check if currently inside the worktree being removed (compare `pwd` with `.claude/worktrees/$ARGUMENTS`). If yes, **stop** and tell the user to switch to main first.
2. Identify the branch linked to the worktree via `git worktree list`
3. Remove the worktree: `git worktree remove .claude/worktrees/$ARGUMENTS --force`
4. Delete the linked branch: `git branch -D <branch-name>`
5. Check for and delete any orphan branches matching:
   - `worktree-$ARGUMENTS`
   - `feature/$ARGUMENTS`
   - `bugfix/$ARGUMENTS`
   - `hotfix/$ARGUMENTS`
6. For each deleted branch, also delete from origin if it exists: `git push origin --delete <branch>`

## Output

Confirm the worktree $ARGUMENTS has been removed, list all branches deleted (local and remote), and confirm which branch you are now on.
