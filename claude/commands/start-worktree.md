---
allowed-tools: Bash, EnterWorktree
description: Start a new worktree
---

If $ARGUMENTS is empty or not a number, stop here and ask the user to provide a GitHub issue number (e.g. `/start-worktree 169`).

1. Fetch the issue: `gh issue view $ARGUMENTS --json title,body,labels`
2. Derive a dash-case directory name from the issue title:
   - Lowercase, replace spaces/special characters with hyphens, collapse consecutive hyphens, trim leading/trailing hyphens
   - Example: "External feedback #1" → `external-feedback-1`
3. Determine the branch prefix from the issue title, body, and labels:
   - If any contain words like "bug", "fix", "crash", "broken", "error" → `bugfix/`
   - If any contain "hotfix", "urgent", "critical" → `hotfix/`
   - Otherwise → `feature/`
4. Start the worktree using the EnterWorktree tool with the directory name from step 2
5. Rename the branch created by EnterWorktree to follow the naming convention:
   ```bash
   git branch -m worktree-<dir-name> <prefix>/<dir-name>
   ```
6. Create symlinks from the main repo into the worktree:
   - `.env.local`: `ln -sf /<main-dir-name>/.env.local /<main-dir-name>/.claude/worktrees/<dir-name>/.env.local`
   - `node_modules`: `ln -sf /<main-dir-name>/node_modules /<main-dir-name>/.claude/worktrees/<dir-name>/node_modules`
   - `generated/prisma`: `mkdir -p /<main-dir-name>/.claude/worktrees/<dir-name>/generated && ln -sf /<main-dir-name>/generated/prisma /<main-dir-name>/.claude/worktrees/<dir-name>/generated/prisma`

   **Note:** Skip the `generated/prisma` symlink if the worktree involves Prisma schema changes — it will need its own generated client via `npm run db:generate`.

## Output

Confirm: the worktree directory name, the branch name (with prefix), and that all three symlinks were created.
