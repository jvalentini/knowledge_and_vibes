# coding_agent_session_search (cass)

## Overview

**CASS** (Coding Agent Session Search) is a unified, high-performance terminal UI for indexing and searching local coding agent history. It aggregates sessions from multiple AI coding agents into a single, searchable timeline with sub-60ms latency.

**Repository:** https://github.com/Dicklesworthstone/coding_agent_session_search

---

## What It Does

CASS treats your coding agent history as a **unified knowledge base**. It:

1. **Normalizes** disparate formats into a common schema
2. **Indexes** everything with a purpose-built full-text search engine
3. **Surfaces** relevant past conversations in milliseconds
4. **Respects** your privacy—everything stays local, nothing phones home

### Supported Agents

| Agent | Storage Location |
|-------|-----------------|
| **Codex** | `~/.codex/sessions` (Rollout JSONL) |
| **Claude Code** | `~/.claude/projects` (Session JSONL) |
| **Gemini CLI** | `~/.gemini/tmp` (Chat JSON) |
| **Cline** | VS Code global storage (Task directories) |
| **OpenCode** | `.opencode` directories (SQLite) |
| **Amp** | `~/.local/share/amp` & VS Code storage |
| **Cursor** | `~/Library/Application Support/Cursor/User/` (SQLite) |
| **ChatGPT** | `~/Library/Application Support/com.openai.chat` |
| **Aider** | `~/.aider.chat.history.md` (Markdown) |
| **Pi-Agent** | `~/.pi/agent/sessions` (Session JSONL) |

---

## Why It's Useful

### The Problem
AI coding agents are transforming how we write software, but the knowledge they generate is:
- **Fragmented** - Each agent stores data differently
- **Unsearchable** - No cross-agent visibility
- **Lost** - Brilliant debugging sessions disappear

### The Solution
CASS unifies all this collective intelligence:
- **Cross-Agent Search** - Find solutions discovered in any agent
- **Instant Results** - Sub-60ms latency
- **AI-Ready Output** - Structured JSON for automation

---

## Installation

### Linux/macOS
```bash
curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_session_search/main/install.sh \
  | bash -s -- --easy-mode --verify
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_session_search/main/install.ps1 | iex
install.ps1 -EasyMode -Verify
```

---

## Human Usage (Interactive TUI)

### Launch
```bash
cass
```

Opens a three-pane layout:
- **Filter bar (top)** - Type to search with real-time results
- **Results list (left)** - Matching sessions with color-coded agents
- **Detail view (right)** - Syntax-highlighted session content

### Keyboard Navigation

| Key | Action |
|-----|--------|
| Type | Instant search |
| `Up`/`Down` | Navigate results |
| `Enter` | Select result |
| `/` | Find in detail pane |
| `n`/`N` | Navigate matches |
| `Ctrl+Enter` | Queue for multi-open |
| `Ctrl+O` | Open queued results |
| `Ctrl+B` | Toggle border style |
| `F12` | Cycle ranking modes |
| `F1` or `?` | Help |
| `q` | Quit |

### Ranking Modes (F12)

| Mode | Description |
|------|-------------|
| `recent` | Newest first |
| `balanced` | Mix of recency and relevance |
| `relevance` | Best matches first |
| `quality` | Penalizes fuzzy/wildcard matches |

---

## Robot Mode (AI Agent Usage)

CASS is purpose-built for consumption by AI coding agents—not just as an afterthought, but as a first-class design goal.

### Self-Documenting API

```bash
# Quick capability check
cass capabilities --json

# Full API schema with argument types
cass introspect --json

# Topic-based help
cass robot-docs commands   # All commands and flags
cass robot-docs schemas    # Response JSON schemas
cass robot-docs examples   # Copy-paste invocations
cass robot-docs exit-codes # Error handling guide
cass robot-docs guide      # Quick-start walkthrough
```

### Search Commands

```bash
# Basic search with JSON output
cass search "authentication error" --robot

# With metadata
cass search "auth*" --robot --robot-meta --limit 20

# Streaming JSONL
cass search "error" --robot-format jsonl

# Compact single-line JSON
cass search "error" --robot-format compact
```

### Output Formats

| Flag | Description |
|------|-------------|
| `--robot` | Pretty-printed JSON (default robot mode) |
| `--robot-format jsonl` | Streaming: header + one hit per line |
| `--robot-format compact` | Minimal single-line JSON |
| `--robot-meta` | Include performance metadata |

### Token Budget Management

| Flag | Effect |
|------|--------|
| `--fields minimal` | Only `source_path`, `line_number`, `agent` |
| `--fields summary` | Adds `title`, `score` |
| `--fields score,title,snippet` | Custom field selection |
| `--max-content-length 500` | Truncate long fields (UTF-8 safe) |
| `--max-tokens 2000` | Soft budget (~4 chars/token) |
| `--limit 5` | Cap number of results |

### Error Handling

Errors are structured with recovery hints:

```json
{
  "error": {
    "code": 3,
    "kind": "index_missing",
    "message": "Search index not found",
    "hint": "Run 'cass index --full' to build the index",
    "retryable": false
  }
}
```

**Exit codes:**
| Code | Meaning | Action |
|------|---------|--------|
| 0 | Success | Parse stdout |
| 2 | Usage error | Fix syntax (hint provided) |
| 3 | Index missing | Run `cass index --full` |
| 4 | Not found | Try different query |
| 5 | Idempotency mismatch | Retry with new key |
| 9 | Unknown error | Check `retryable` flag |
| 10 | Timeout exceeded | Increase `--timeout` |

### Forgiving Syntax

CASS auto-corrects common agent mistakes:

| Input | Corrected To |
|-------|-------------|
| `cass serach "error"` | `cass search "error"` |
| `cass -robot -limit=5` | `cass --robot --limit=5` |
| `cass --Robot --LIMIT 5` | `cass --robot --limit 5` |
| `cass find "auth"` | `cass search "auth"` |
| `cass search --limt 5` | `cass search --limit 5` |

---

## Advanced Features

### Wildcard Patterns

```bash
cass search "foo*"      # Prefix match (foobar, foo123)
cass search "*foo"      # Suffix match (barfoo)
cass search "*foo*"     # Substring match (afoob)
```

Auto-fuzzy fallback: When exact searches return sparse results, automatically retries with `*term*` wildcards.

### Match Highlighting

```bash
cass search "authentication error" --robot --highlight
# In text: **authentication** and **error** are bold-wrapped
# In HTML export: <mark>authentication</mark>
```

### Pagination

```bash
# First page
cass search "TODO" --robot --robot-meta --limit 20
# Returns: { "hits": [...], "_meta": { "next_cursor": "eyJ..." } }

# Next page
cass search "TODO" --robot --limit 20 --cursor "eyJ..."
```

### Session Analysis

```bash
# Export to Markdown
cass export /path/to/session.jsonl --format markdown -o conversation.md

# Export to HTML
cass export /path/to/session.jsonl --format html -o conversation.html

# Expand context around a line
cass expand /path/to/session.jsonl -n 42 -C 5 --json
# Shows 5 messages before and after line 42

# Activity timeline
cass timeline --today --json --group-by hour
cass timeline --since 7d --agent claude --json
```

### Index Management

```bash
# Full re-index
cass index --full

# Incremental update (automatic)
# Index updates atomically; searches remain available
```

---

## Agent Workflow Integration

### Cross-Agent Search Example

Imagine you're Claude Code working on a React authentication bug. With CASS, you can search across:
- Your own previous sessions
- Codex sessions about OAuth flows
- Cursor conversations about token refresh
- Aider chats about security

```bash
# Search for relevant prior art
cass search "authentication JWT refresh" --robot --limit 10 --fields summary
```

### Integration with Beads

Use CASS to find prior solutions before starting work:

```bash
# 1. Pick ready work from Beads
bd ready --json

# 2. Search for similar past work
cass search "similar problem description" --robot --limit 5

# 3. Start work with prior context
bd update bd-a1b2 --status in_progress
```

---

## Configuration

### Environment

CASS reads history from standard locations automatically. For ChatGPT encrypted databases, see the Environment section in the repo documentation.

### Output Control Flags

| Flag | Description |
|------|-------------|
| `--fields <spec>` | Control payload size |
| `--max-content-length N` | Truncate fields |
| `--max-tokens N` | Soft LLM budget |
| `--robot-format <fmt>` | Output format |

### Search Refinement

| Flag | Description |
|------|-------------|
| `--limit N` | Cap results |
| `--cursor <token>` | Pagination |
| `--explain` | Query analysis |
| `--highlight` | Match highlighting |
| `--timeout N` | Max milliseconds |

### Correlation

| Flag | Description |
|------|-------------|
| `--request-id ID` | Track across logs |
| `--idempotency-key "value"` | Safe retries (24h cache) |

---

## Best Practices

### 1. Use Robot Mode for Automation
Never parse interactive TUI output:
```bash
# Good
cass search "error" --robot | jq '.'

# Bad - unstable output
cass search "error" 2>&1 | grep ...
```

### 2. Manage Token Budget
For LLM consumption:
```bash
cass search "error" --robot --fields minimal --max-tokens 2000
```

### 3. Use Pagination for Large Results
```bash
cass search "TODO" --robot --limit 20 --cursor "$CURSOR"
```

### 4. Keep Index Fresh
```bash
cass index --full  # Run periodically
```

### 5. Leverage Wildcards
- `foo*` is faster than `*foo*`
- Auto-fuzzy fallback handles sparse results

---

## AGENTS.md/CLAUDE.md Snippet

Add this to your agent documentation:

```markdown
## CASS: Cross-Agent Session Search

CASS provides unified search across all your coding agent histories (Claude Code, Codex, Cursor, Aider, etc.).

Usage:
- `cass search "query" --robot` — JSON search results
- `cass search "query" --robot --fields minimal` — Minimal output for LLMs
- `cass robot-docs guide` — Self-documenting help

Useful for:
- Finding prior solutions to similar problems
- Learning from past debugging sessions
- Cross-pollinating knowledge across tools

Commands are typo-tolerant and output structured errors with recovery hints.
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Index missing" | Run `cass index --full` |
| Slow searches | Check `--timeout`, reduce `--limit` |
| No results for known content | Verify agent storage path; re-index |
| Truncated output | Increase `--max-content-length` |

---

## Technical Details

- **Language**: Rust (nightly)
- **Indexing**: Edge N-gram for O(1) prefix matching
- **Formats**: Normalizes JSONL, SQLite, Markdown
- **Performance**: Sub-60ms latency typical
- **Storage**: Completely local; no external transmission

---

## Links

- **Repository**: https://github.com/Dicklesworthstone/coding_agent_session_search
- **Author**: Jeffrey Emanuel (Dicklesworthstone)
- **License**: MIT

---

*Last updated: December 2025*
