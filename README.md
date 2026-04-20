# Claude Code Setup — Article Companion Files

This repository contains the configuration files referenced in the article **[How I Set Up Claude Code for a Complex Project](https://cedv.medium.com/how-i-set-up-claude-code-for-a-complex-project-ae1beb2e6a37)**, published on [Medium](https://medium.com/@cedric.vanier).

## What is in here

- `CLAUDE.md` file placed at the project root
- `claude/agents/` — specialist agent definitions (orchestrator, backend, frontend, UI designer, cloud architect, code reviewer, test specialist, docs specialist, git specialist, ...)
- `claude/commands/` — custom slash commands (`/starter`, `/implement`, `/commit`, `/restart-servers`, `/start-worktree`, ...)
- `claude/hooks/format-and-lint.sh` — a post-edit hook that runs Prettier and ESLint automatically
- `claude/settings.local.json` — local Claude Code settings with hook configuration

## Important

All values within square brackets `[...]` in these files are placeholders. They reflect the structure and conventions of a specific project and need to be adjusted to fit yours.

This is not a template to copy. It is one setup, built around one project and one set of preferences. Read the article for the reasoning behind each decision.

## Author

[Cedric Vanier on Medium](https://medium.com/@cedric.vanier)
