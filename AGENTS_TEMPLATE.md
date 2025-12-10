# AGENTS.md

## Project
<!-- CUSTOMIZE -->
- Name: [Project Name]
- Language: [TypeScript/Python/Go/etc.]
- Key paths: `src/`, `tests/`, `docs/`

---

## Session Start

```bash
bd ready --json                           # Available work
bv --robot-priority                       # Highest impact task
cass search "query" --robot --limit 5     # Prior solutions
bd update <id> --status in_progress       # Claim task
```

---

## Multi-Agent Setup

```python
ensure_project(project_key="/abs/path/to/project")
register_agent(project_key, program="claude-code", model="opus-4.5")

file_reservation_paths(
    project_key, agent_name,
    paths=["src/**/*.ts"],
    exclusive=True,
    ttl_seconds=3600,
    reason="<task-id>"
)

send_message(
    project_key, sender_name,
    to=["OtherAgent"],
    subject="[<task-id>] Starting X",
    body_md="...",
    thread_id="<task-id>"
)
```

---

## During Work

```python
fetch_inbox(project_key, agent_name, limit=10)
acknowledge_message(project_key, agent_name, message_id)
```

```bash
bd create "Found: issue" -t bug
bd dep add <new> <parent> --type discovered-from
```

---

## Before Commit

```bash
ubs --staged                      # Scan
# Fix issues
ubs --staged --fail-on-warning    # Verify (must exit 0)
git commit -m "Message\n\nFixes <task-id>"
```

---

## Session End

```bash
bd close <id> --reason "Done: summary"
bd sync && git push
```

```python
release_file_reservations(project_key, agent_name)
```

---

## Critical Rules

| DO | DON'T |
|----|-------|
| `bd ready --json` at start | Run `bv` without `--robot-*` |
| `bv --robot-priority` for priority | Skip `ubs --staged` |
| `ubs --staged` before commit | Forget `bd sync && git push` |
| Reserve files before editing | Hold reservations too long |
| `bd sync && git push` at end | Start without checking ready |

---

## Beads Viewer (ALWAYS use --robot-*)

```bash
bv --robot-priority     # Ranked recommendations
bv --robot-insights     # Graph metrics
bv --robot-plan         # Parallel tracks
bv --robot-diff         # Recent changes
```

**WARNING**: Never run `bv` without flags - TUI hangs agent sessions.

---

## CASS Search

```bash
cass search "query" --robot --fields minimal --limit 5
cass search "query" --robot --max-tokens 2000
```

---

## UBS Scan

```bash
ubs --staged                    # Staged changes
ubs --staged --fail-on-warning  # CI mode
ubs .                           # Full scan
```

Suppress: `// ubs:ignore`

---

## Exa MCP (Web & Code Search)

```
# Available tools (MCP - no bash commands)
web_search_exa          # Real-time web search
get_code_context_exa    # GitHub, docs, StackOverflow code search
deep_search_exa         # Deep research with query expansion
crawling                # Extract content from specific URLs
```

Use when: current docs needed, code examples required, API usage patterns.

---

## Agent Mail

```python
# Identity
ensure_project(project_key)
register_agent(project_key, program, model)

# Files
file_reservation_paths(project_key, agent, paths, exclusive, ttl, reason)
release_file_reservations(project_key, agent)

# Messages
send_message(project_key, sender, to, subject, body_md, thread_id)
reply_message(project_key, message_id, sender, body_md)
fetch_inbox(project_key, agent, limit)
acknowledge_message(project_key, agent, message_id)
```

---

## ID Linking

```
Bead:        bd-a1b2
Thread:      bd-a1b2
Subject:     [bd-a1b2] ...
Reservation: reason="bd-a1b2"
Commit:      Fixes bd-a1b2
```

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `bd` not found | Check PATH |
| `bv` hangs | Add `--robot-*` flag |
| Mail errors | Run `am` first |
| CASS empty | `cass index --full` |
| UBS errors | `ubs doctor --fix` |
| "not registered" | `ensure_project` + `register_agent` |
