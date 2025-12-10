# MCP Agent Mail

> "It's like gmail for your coding agents!"

## Overview

**MCP Agent Mail** is a coordination layer for multiple AI coding agents working on the same project. It provides a mail-like system that lets agents communicate asynchronously, reserve files to avoid conflicts, and maintain searchable audit trails of all decisions and conversations.

**Think of it as:** Email + directory service + file locking for AI agents, backed by Git (for human-auditable artifacts) and SQLite (for fast queries).

**Repository:** https://github.com/Dicklesworthstone/mcp_agent_mail

---

## What It Does

When running multiple coding agents simultaneously (backend, frontend, scripts, infra), problems arise:

| Problem | How Agent Mail Solves It |
|---------|--------------------------|
| Agents overwrite each other's edits | **File reservations** - agents declare "leases" on files/globs before editing |
| Agents miss context from parallel work | **Inbox/outbox messaging** - asynchronous communication between agents |
| Humans must relay messages between tools | **Unified message system** - agents communicate directly |
| No record of agent decisions | **Git-backed audit trail** - every message is version-controlled markdown |
| Hard to search past conversations | **SQLite FTS5** - full-text search across all threads |

---

## Key Concepts

### 1. Agent Identity
Each agent registers with a memorable adjective+noun name (e.g., "GreenCastle", "BlueLake") and metadata about its program/model. This creates a persistent identity for the session.

### 2. Messaging System
- **Inbox/Outbox**: Each agent has a mailbox for sending and receiving messages
- **Threading**: Messages grouped by thread ID (e.g., ticket numbers like "bd-123")
- **GitHub-Flavored Markdown**: Full markdown support with images
- **Acknowledgments**: Important messages can require explicit acknowledgment
- **Importance Levels**: low, normal, high, urgent

### 3. File Reservations (Leases)
- **Advisory locks** on files or glob patterns (e.g., `src/**/*.ts`)
- **Exclusive or shared** reservations
- **TTL-based expiry** (e.g., 1 hour lease)
- **Pre-commit guard** can block commits that conflict with others' reservations

### 4. Dual Persistence
- **Git repo**: Human-readable markdown files for every message (auditable)
- **SQLite + FTS5**: Fast search, queries, and file reservation tracking

---

## Installation

### One-Line Install (Recommended)
```bash
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh?$(date +%s)" | bash -s -- --yes
```

This will:
- Install `uv` package manager if missing
- Create Python 3.14 virtual environment
- Install all dependencies
- Auto-detect and configure installed coding agents (Claude Code, Codex, etc.)
- Start the MCP server on port 8765
- Create `am` shell alias for quick server startup
- Install Beads CLI (`bd`) for task planning integration
- Install Beads Viewer (`bv`) for task intelligence

### Starting the Server

After installation, start from anywhere:
```bash
am                    # Uses the shell alias
# Or manually:
scripts/run_server_with_token.sh
```

### Custom Port
```bash
# During install
curl -fsSL "..." | bash -s -- --port 9000 --yes

# After install
uv run python -m mcp_agent_mail.cli config set-port 9000
```

---

## How To Use

### Basic Workflow for Agents

**1. Register identity:**
```python
ensure_project(project_key="/abs/path/to/project")
register_agent(project_key, program="claude-code", model="opus-4.5", name="GreenCastle")
```

**2. Reserve files before editing:**
```python
file_reservation_paths(
    project_key,
    agent_name="GreenCastle",
    paths=["src/**"],
    ttl_seconds=3600,
    exclusive=True,
    reason="bd-123"
)
```

**3. Communicate via threads:**
```python
send_message(
    project_key,
    sender_name="GreenCastle",
    to=["BlueLake"],
    subject="[bd-123] Starting auth refactor",
    body_md="Working on login module...",
    thread_id="bd-123"
)
```

**4. Check inbox and acknowledge:**
```python
fetch_inbox(project_key, agent_name="GreenCastle")
acknowledge_message(project_key, agent_name="GreenCastle", message_id=123)
```

**5. Release reservations when done:**
```python
release_file_reservations(project_key, agent_name="GreenCastle")
```

### Macros vs Granular Tools

| Use Case | Approach |
|----------|----------|
| Speed / smaller models | **Macros**: `macro_start_session`, `macro_prepare_thread`, `macro_file_reservation_cycle`, `macro_contact_handshake` |
| Fine-grained control | **Granular tools**: `register_agent`, `file_reservation_paths`, `send_message`, `fetch_inbox`, `acknowledge_message` |

### Cross-Repository Coordination

**Option A - Single project bus:**
- Register both repos under the same `project_key`
- Use specific reservation patterns (`frontend/**` vs `backend/**`)

**Option B - Separate projects:**
- Each repo has own `project_key`
- Use `request_contact`/`respond_contact` to link agents
- Share thread IDs across repos for clean summaries

---

## MCP Tools Reference

### Identity Management
| Tool | Purpose |
|------|---------|
| `ensure_project` | Create/ensure project exists for a working directory |
| `register_agent` | Register/update agent identity |
| `create_agent_identity` | Create a brand new unique identity |
| `whois` | Get profile details for an agent |

### Messaging
| Tool | Purpose |
|------|---------|
| `send_message` | Send message to recipients |
| `reply_message` | Reply to existing message (preserves thread) |
| `fetch_inbox` | Get recent messages for an agent |
| `mark_message_read` | Mark message as read |
| `acknowledge_message` | Acknowledge message (for ack_required) |
| `search_messages` | Full-text search over messages |

### Threads & Summaries
| Tool | Purpose |
|------|---------|
| `summarize_thread` | Extract participants, key points, action items |
| `summarize_threads` | Digest across multiple threads |

### File Reservations
| Tool | Purpose |
|------|---------|
| `file_reservation_paths` | Request advisory file reservations |
| `release_file_reservations` | Release active reservations |
| `renew_file_reservations` | Extend expiry for active reservations |
| `force_release_file_reservation` | Force-release stale reservation |

### Build Slots
| Tool | Purpose |
|------|---------|
| `acquire_build_slot` | Acquire advisory build slot |
| `renew_build_slot` | Extend build slot lease |
| `release_build_slot` | Release build slot |

### Contact Management
| Tool | Purpose |
|------|---------|
| `request_contact` | Request contact approval from another agent |
| `respond_contact` | Approve or deny contact request |
| `list_contacts` | List contact links for an agent |
| `set_contact_policy` | Set policy: open, auto, contacts_only, block_all |

### Macros
| Tool | Purpose |
|------|---------|
| `macro_start_session` | Boot session: ensure project, register, fetch inbox |
| `macro_prepare_thread` | Align agent with existing thread |
| `macro_file_reservation_cycle` | Reserve paths with optional auto-release |
| `macro_contact_handshake` | Request contact with optional auto-approve |

---

## Web UI

Access at `http://127.0.0.1:8765/mail` after starting the server.

### Features
- **Unified inbox**: See recent messages across all projects
- **Project browser**: Navigate projects, agents, threads
- **Full-text search**: FTS5-powered with filters (`subject:foo`, `body:"multi word"`)
- **File reservations view**: See active/historical file locks
- **Human Overseer**: Send high-priority messages to agents
- **Related Projects Discovery**: AI-powered suggestions for likely sibling projects

### Human Overseer Messages
The Web UI lets humans send priority messages to agents that:
- Include automatic preamble identifying it as human guidance
- Are marked high importance
- Bypass normal contact policies
- Instruct agents to pause, handle request, then resume

---

## Integration with Beads

[Beads](https://github.com/steveyegge/beads) is a dependency-aware task planner that complements Agent Mail:

| Tool | Purpose |
|------|---------|
| **Beads** (`bd`) | Task status, priorities, dependencies |
| **Agent Mail** | Messaging, audit trails, file reservations |
| **Beads Viewer** (`bv`) | Graph analysis, impact assessment |

### Recommended Workflow

```bash
# 1. Pick ready work from Beads
bd ready --json

# 2. Reserve files in Agent Mail with reason
file_reservation_paths(..., reason="bd-123")

# 3. Announce start via message thread
send_message(..., thread_id="bd-123", subject="[bd-123] Starting work")

# 4. Work and post updates in thread
reply_message(...)

# 5. Close task in Beads
bd close bd-123 --reason "Completed"

# 6. Release file reservations
release_file_reservations(...)

# 7. Final message with summary
send_message(..., thread_id="bd-123", subject="[bd-123] Completed")
```

### Mapping Cheat-Sheet
```
Mail thread_id    ↔  bd-###
Mail subject      ↔  [bd-###] ...
File reservation  ↔  reason: "bd-###"
Commit message    ↔  include bd-###
```

---

## Architecture

```
┌─────────────┐     ┌─────────────────┐     ┌──────────────┐
│   Agents    │────▶│   MCP Server    │────▶│   Git Repo   │
│             │     │   (port 8765)   │     │  (markdown)  │
└─────────────┘     └────────┬────────┘     └──────────────┘
                             │
                             ▼
                    ┌──────────────┐
                    │ SQLite FTS5  │
                    │  (queries)   │
                    └──────────────┘
```

**Git tree structure:**
```
agents/profile.json
agents/mailboxes/...
messages/YYYY/MM/id.md
file_reservations/sha1.json
attachments/xx/sha1.webp
```

---

## Configuration

### Environment Variables

| Variable | Purpose |
|----------|---------|
| `HTTP_BEARER_TOKEN` | Bearer token for authentication |
| `HTTP_ALLOW_LOCALHOST_UNAUTHENTICATED` | Allow localhost without auth (dev) |
| `LLM_ENABLED` | Enable AI-powered project relationship discovery |
| `AGENT_NAME` | Set for pre-commit guard to check reservations |

### CLI Configuration

```bash
# Set port
uv run python -m mcp_agent_mail.cli config set-port 9000

# Insert documentation blurbs
uv run python -m mcp_agent_mail.cli docs insert-blurbs
```

---

## Best Practices

### For Multi-Agent Projects

1. **Always reserve files before editing** - Use exclusive reservations for critical changes
2. **Use consistent thread IDs** - Match ticket/issue numbers (e.g., `bd-123`, `JIRA-456`)
3. **Include reasons in reservations** - Makes audit trails useful
4. **Check inbox regularly** - Other agents may have important context
5. **Release reservations promptly** - Don't block others unnecessarily
6. **Use macros for efficiency** - `macro_start_session` bundles common startup steps

### For Humans Overseeing Agents

1. **Use Human Overseer feature** for urgent redirections
2. **Review the Web UI** to monitor agent activity
3. **Search threads** to understand decision history
4. **Export archives** for compliance/audit needs

### Commit Integration

Set `AGENT_NAME` in your environment so the pre-commit guard can:
- Block commits conflicting with others' exclusive reservations
- Warn about potential conflicts with shared reservations

---

## Advanced Features

### Static Mailbox Export
Export project mailboxes as portable, read-only HTML bundles:

```bash
# Interactive wizard
uv run python -m mcp_agent_mail.cli share wizard

# Manual export
uv run python -m mcp_agent_mail.cli share export --output ./my-bundle
```

### Disaster Recovery
Save and restore complete mailbox state:

```bash
# Save snapshot
uv run python -m mcp_agent_mail.cli archive save --label nightly

# List restore points
uv run python -m mcp_agent_mail.cli archive list --json

# Restore
uv run python -m mcp_agent_mail.cli archive restore <file>.zip --force
```

### Pre-Commit Guard
Install to block commits that conflict with file reservations:

```bash
# Install in your repo
install_precommit_guard(project_key, code_repo_path)

# Uninstall
uninstall_precommit_guard(code_repo_path)
```

---

## AGENTS.md/CLAUDE.md Snippet

Add this to your agent documentation:

```markdown
## MCP Agent Mail: coordination for multi-agent workflows

What it is:
- A mail-like layer that lets coding agents coordinate asynchronously via MCP tools.
- Provides identities, inbox/outbox, searchable threads, and advisory file reservations.

How to use:
1. Register identity: `ensure_project`, then `register_agent`
2. Reserve files before editing: `file_reservation_paths(..., exclusive=true)`
3. Communicate with threads: `send_message(..., thread_id="bd-123")`
4. Check inbox: `fetch_inbox`, acknowledge with `acknowledge_message`

Common pitfalls:
- "from_agent not registered": always `register_agent` first
- "FILE_RESERVATION_CONFLICT": wait for expiry or use non-exclusive
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "from_agent not registered" | Call `register_agent` first with correct `project_key` |
| "FILE_RESERVATION_CONFLICT" | Adjust patterns, wait for expiry, or use non-exclusive |
| Auth errors with JWT | Include bearer token with matching `kid` |
| Blank page on localhost | Set `HTTP_ALLOW_LOCALHOST_UNAUTHENTICATED=true` |
| Empty inbox | Verify recipient names match exactly (case-sensitive) |

---

## Compatible Agents

- Claude Code
- OpenAI Codex CLI
- Gemini CLI
- Cline
- Any FastMCP-compatible client

---

## Links

- **Repository**: https://github.com/Dicklesworthstone/mcp_agent_mail
- **Beads (task planning)**: https://github.com/steveyegge/beads
- **Beads Viewer**: https://github.com/Dicklesworthstone/beads_viewer
- **Video Walkthrough**: https://youtu.be/68VVcqMEDrs
- **Author**: Jeffrey Emanuel (Dicklesworthstone)
- **License**: MIT

---

*Last updated: December 2025*
