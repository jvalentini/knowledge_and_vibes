# AGENTS.md

<!-- CUSTOMIZE: Replace bracketed items with your project specifics -->

## Project Overview

- **Name**: [Project Name]
- **Language**: [TypeScript/Python/Go/etc.]
- **Key Paths**: `src/`, `tests/`, `docs/`

---

## RULE 1 – ABSOLUTE (DO NOT EVER VIOLATE THIS)

You may NOT delete any file or directory unless the user explicitly gives the exact command **in this session**.

- This includes files you just created (tests, tmp files, scripts, etc.)
- You do not get to decide that something is "safe" to remove
- If you think something should be removed, stop and ask

Treat "never delete files without permission" as a hard invariant.

---

## Irreversible Git & Filesystem Actions

Absolutely forbidden unless the user gives **exact command and explicit approval** in the same message:

- `git reset --hard`
- `git clean -fd`
- `rm -rf`
- Any command that can delete or overwrite code/data

Rules:

1. If you are not 100% sure what a command will delete, do not run it. Ask first.
2. Prefer safe tools: `git status`, `git diff`, `git stash`, copying to backups.
3. After approval, restate the command verbatim, list what it will affect, wait for confirmation.

---

## Code Editing Discipline

- Do **not** run scripts that bulk-modify code (codemods, one-off scripts, giant sed/regex refactors)
- Large mechanical changes: break into smaller, explicit edits and review diffs
- Subtle/complex changes: edit by hand, file-by-file, with careful reasoning

---

## Issue Tracking with bd (Beads)

All issue tracking goes through **bd**. No other TODO systems.

Key invariants:

- `.beads/` is authoritative state and **must always be committed** with code changes
- Do not edit `.beads/*.jsonl` directly; only via `bd`

### Basics

```bash
bd ready --json                    # Check ready work
bd create "Title" -t bug -p 1      # Create issue
bd update bd-42 --status in_progress
bd close bd-42 --reason "Completed"
```

Types: `bug`, `feature`, `task`, `epic`, `chore`
Priority: `0` (critical) to `4` (backlog)

### Agent Workflow

1. `bd ready` to find unblocked work
2. Claim: `bd update <id> --status in_progress`
3. Implement + test
4. If you discover new work, create a new bead with `discovered-from:<parent-id>`
5. Close when done
6. Commit `.beads/` in the same commit as code changes

Never:
- Use markdown TODO lists
- Use other trackers
- Duplicate tracking

---

## Using bv as an AI Sidecar

`bv` is a terminal UI + analysis layer for `.beads/`. It precomputes graph metrics.

**Always use robot flags. Never run bare `bv`.**

```bash
bv --robot-help       # Overview
bv --robot-priority   # What should I work on?
bv --robot-plan       # Parallel execution tracks
bv --robot-insights   # Graph metrics (PageRank, critical path)
```

---

## CASS — Cross-Agent Search

`cass` indexes prior agent conversations so we can reuse solved problems.

**Always use `--robot` or `--json`. Never run bare `cass`.**

```bash
cass search "query" --robot --limit 5
cass view /path/to/session.jsonl --json
cass expand /path -n 42 -C 3 --json
```

Tips:
- Use `--fields minimal` for lean output
- Filter by agent with `--agent`
- Use `--days N` to limit to recent history

---

## cass-memory — Cross-Agent Learning

Before starting any non-trivial task:

```bash
cm context "your task description" --json
```

This returns:
- **Relevant rules** from the playbook
- **Historical context** from past sessions
- **Anti-patterns** to avoid
- **Suggested searches** for deeper investigation

You do NOT need to:
- Run `cm reflect` (automation handles this)
- Manually add rules to the playbook
- Worry about the learning pipeline

The system learns from your sessions automatically.

---

## UBS — Bug Scanner

Before committing:

```bash
ubs --staged
```

Suppress false positives: `// ubs:ignore`

For specific files:

```bash
ubs path/to/file.ts
```

---

## MCP Agent Mail — Multi-Agent Coordination

Agent Mail is available as an MCP server for coordinating multiple agents.

### Registration

```python
ensure_project(project_key="/abs/path/to/project")
register_agent(project_key, program="claude-code", model="opus-4.5")
```

### File Reservations

Reserve files before editing to avoid conflicts:

```python
file_reservation_paths(
    project_key, agent_name,
    paths=["src/**"],
    ttl_seconds=3600,
    exclusive=True,
    reason="bd-123"
)
```

### Communication

```python
send_message(
    project_key, sender_name,
    to=["OtherAgent"],
    subject="[bd-123] Starting auth refactor",
    body_md="Working on login module...",
    thread_id="bd-123"
)

fetch_inbox(project_key, agent_name)
acknowledge_message(project_key, agent_name, message_id)
```

### Release When Done

```python
release_file_reservations(project_key, agent_name)
```

Common pitfalls:
- "from_agent not registered" → call `register_agent` with correct `project_key`
- `FILE_RESERVATION_CONFLICT` → adjust patterns, wait for expiry, or use non-exclusive

---

## Warp-Grep — AI-Powered Code Search

Use `warp_grep` for "how does X work?" discovery across the codebase.

When to use:
- You don't know where something lives
- You want data flow across multiple files
- You want all touchpoints of a cross-cutting concern

When NOT to use:
- You already know the function/identifier name (use `rg`)
- You know the exact file (just open it)
- You only need a yes/no existence check

---

## Session End

```bash
ubs --staged                              # Scan for bugs
bd close <id> --reason "Completed: ..."   # Complete task
bd sync                                   # Sync .beads
git add -A && git commit && git push      # Save everything
```

---

## Contribution Policy

<!-- CUSTOMIZE as needed -->
Remove any mention of contributing/contributors from README if not applicable.
