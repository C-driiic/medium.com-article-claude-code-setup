# [Project Name]

[Short project description. 1-2 sentences maximum]

## Global rule

**Always search for best practices from latest online research. Don't invent or assume, and don't be a pleaser. Be honest and factual.**

## Agents

Located in `.claude/agents/`:

| Agent                 | Purpose                                        |
| --------------------- | ---------------------------------------------- |
| `orchestrator`        | Decomposes tasks, delegates to specialists     |
| `backend-specialist`  | API endpoints, database, business logic        |
| `frontend-specialist` | React components, UI implementation            |
| `ui-designer`         | Design tokens, component specs                 |
| `cloud-architect`     | Infrastructure, Terraform, GCP                 |
| `code-reviewer`       | Runs lint/tests, reviews code, security checks |
| `test-specialist`     | Writes unit and integration tests              |
| `docs-specialist`     | CLAUDE.md, changelogs, READMEs                 |
| `git-specialist`      | Commits, branches, history management          |

## Project Structure

```
├── .claude/
│   ├── agents/            # Specialist agent definitions
│   ├── commands/          # Custom slash commands
│   └── hooks/             # Pre/post tool execution scripts
├── .github/
│   └── workflows/         # GitHub Actions CI/CD pipelines
│       └── deploy.yml     # Production deployment workflow (Docker build, push, Cloud Run deploy)
├── dist/                  # Production build output
│   └── assets/            # Compiled JS, CSS, images
├── public/                # Static web assets (favicon, PWA icons, manifest)
├── Dockerfile             # Multi-stage Docker build (frontend compile + Node.js runtime)
├── .dockerignore          # Files excluded from Docker build context
├── src/                   # Frontend application
│   ├── assets/            # Static assets (SVG logos, images, fonts, icons)
│   ├── components/        # Reusable UI components
│   │   ├── common/        # Shared components (Button, Input, Modal, ProtectedRoute, Autocomplete, Badge, ConfirmDialog, Tooltip, Card, Spinner, Accordion, etc.)
│   │   ├── landing/       # Landing page components
│   │   └── layout/        # Layout components (Header, Footer, Sidebar)
│   ├── constants/         # Frontend constants
│   ├── features/          # Feature modules (each with components/, hooks/, utils/)
│   │   ├── ...            # ...
│   │   └── ...            # ...
│   ├── hooks/             # Global custom React hooks
│   ├── stores/            # Zustand stores
│   ├── services/          # API client and calls
│   ├── styles/            # Global styles and SCSS
│   │   └── tokens/        # Design tokens (colors, spacing, typography)
│   ├── test/              # Test setup and utilities
│   └── types/             # Shared TypeScript types
├── server/                # Backend application
│   ├── config/            # Configuration constants
│   ├── constants/         # Backend constants
│   ├── controllers/       # Request handlers
│   ├── middleware/        # Express middleware
│   ├── repositories/      # Database access layer (Prisma queries)
│   ├── routes/            # API route definitions
│   ├── schemas/           # Zod validation schemas
│   ├── services/          # Business logic (organized by domain)
│   │   ├── ...            # ...
│   ├── types/             # Backend TypeScript types
│   └── utils/             # Helper functions
├── infrastructure/        # Terraform configurations
│   ├── environments/      # Environment-specific configs
│   │   ├── dev/           # Development environment
│   │   ├── prod/          # Production environment
│   │   └── staging/       # Staging environment
│   └── modules/           # Reusable Terraform modules
├── prisma/                # Database schema and migrations
│   └── migrations/        # Database migration files
├── scripts/               # Utility scripts for development/debugging
│   ├── ...                # ...
│   └── ...                # ...
├── docs/                  # Documentation
│   ├── api/               # API endpoint documentation
│   ├── changelogs/        # Version changelogs
│   ├── architecture.md    # System architecture overview
│   ├── development.md     # Development setup guide
│   └── database.md        # Database schema documentation
```

## Tech Stack

**Frontend:** [React 19, TypeScript, Vite, SCSS, Zustand, React Query, react-markdown, vite-plugin-svgr]
**Backend:** [Node.js 22, Express, PostgreSQL, Prisma, Zod]
**Infrastructure:** [GCP (Cloud Run, Artifact Registry, Secret Manager, Workload Identity Federation), Terraform]
**CI/CD:** [GitHub Actions, Docker (multi-stage build)]
**Testing:** [Vitest, React Testing Library, MSW]
**AI:** [Claude API]
**PWA:** [Web App Manifest, Adaptive Icons]

## Core Features

### 1. Feature A

- [Description or list of features]

### 2. Feature B

- [Description or list of features]

### 3. Feature C

- [Description or list of features]

**[Important notes]**

- **[Free Tier]**: [Access to ...]
- **[Paid Tier]**: [Full access to ...]

## Documentation

- **Getting Started**: `/docs/development.md`
- **API Reference**: `/docs/api/README.md`
- **Architecture**: `/docs/architecture.md`
- **Database**: `/docs/database.md`
- **Changelogs**: `/docs/changelogs/`

## Worktrees

When a task is assigned to a worktree, **ALL file edits MUST target the worktree path**:

```
.claude/worktrees/<worktree-name>/
```

**NEVER edit files in the root working directory when a worktree is active for that task.**

This applies to every agent — backend-specialist, frontend-specialist, docs-specialist, test-specialist, etc. If a specialist receives a task with a worktree path, every Read, Edit, Write, and Bash file operation must use that path as the base.

The docs-specialist must also write changelogs and documentation updates inside the worktree, not on main.

## Database Inspection

When Claude needs to inspect database data:

**DO NOT** try to create temporary files or use inline tsx eval.

**DO** use one of the existing scripts from the scripts/ folder or create a new one following the below pattern:

**Pattern for new scripts:**

- Place in `scripts/` folder
- Import from `"../server/utils/prisma"`
- Import from `"dotenv/config"`
- Use async function with proper error handling
- Run with `tsx --env-file-if-exists=.env.local scripts/filename.ts <optional_args>`

Note: All npm scripts (`npm run db:*`, `npm run seed:*`) already include the `--env-file-if-exists=.env.local` flag automatically.

## Database Migrations

**NEVER** use `prisma db push`. It bypasses migration tracking, creates broken `applied_steps_count = 0` records in `_prisma_migrations`, breaks the shadow DB replay chain, and makes the DB state unreproducible on a fresh instance.

**Schema changes:** Always create a migration file:

```sh
npm run db:migrate -- --name <description>
```

**CI/CD and fresh environments:** Use `prisma migrate deploy` (not `db push`):

```sh
npm run db:deploy
```

**If `migrate dev` fails** due to shadow DB issues, investigate and fix the migration history. Do NOT use `db push` as a workaround.
