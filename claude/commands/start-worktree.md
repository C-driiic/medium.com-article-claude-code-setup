---
allowed-tools: Bash, EnterWorktree
description: Start a new worktree
---

If $ARGUMENTS is empty or contains spaces, stop here and ask the user to provide a worktree name in dash-case format.
If $ARGUMENTS is provided, verify it is in dash-case format, then:

1. Start a new worktree named $ARGUMENTS using the EnterWorktree tool
2. After the worktree is created, symlink the following from the main repo into the worktree:
   - `.env.local`: `ln -sf [/path-to/].env.local [/path-to/].claude/worktrees/$ARGUMENTS/.env.local`
   - `node_modules`: `ln -sf [/path-to/]node_modules [/path-to/].claude/worktrees/$ARGUMENTS/node_modules`
   - `generated/prisma`: `mkdir -p [/path-to/].claude/worktrees/$ARGUMENTS/generated && ln -sf [/path-to/]generated/prisma [/path-to/].claude/worktrees/$ARGUMENTS/generated/prisma`

   **Note:** Skip the `generated/prisma` symlink if the worktree involves Prisma schema changes — it will need its own generated client via `npm run db:generate`.

## Output

Confirm the worktree name you are currently in and that all three symlinks were created.
