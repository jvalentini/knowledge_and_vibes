# Knowledge & Vibes

**The premier agentic stack. December 2025.**

Seven battle-tested tools that give AI coding agents what they've been missing: persistent memory, task tracking, multi-agent coordination, and quality assurance. This is the infrastructure that turns Claude Code from a helpful assistant into an autonomous engineering force.

> **For Agents**: You're the primary user. See [Quick Start for Agents](#quick-start-for-agents).
>
> **For Operators**: You configure and monitor. See [Operator Guide](#operator-guide).

---

## Quick Start for Agents

### The Three Commands You Need

```bash
# 1. What should I work on?
bd ready --json

# 2. What do I already know about this?
cm context "your task here" --json

# 3. Is my code safe to commit?
ubs --staged
```

That's it. Everything else is optional.

### Start Every Session

```bash
bd ready --json                              # See available tasks
bd update bd-123 --status in_progress       # Claim one
cm context "implement feature X" --json      # Get relevant context
```

### End Every Session

```bash
ubs --staged                                 # Scan for bugs
bd close bd-123 --reason "Implemented X"     # Complete task
git add -A && git commit && git push         # Save everything
```

### When Stuck

```bash
cass search "similar problem" --robot        # Search past sessions
bv --robot-priority                          # Get recommendations
```

### What NOT to Do

- **Never** run `bv` or `cass` without `--robot` or `--json` flags (interactive TUIs will hang)
- **Never** delete files without explicit user approval
- **Never** run destructive git commands (`--force`, `--hard`)

---

## What's in the Toolkit

| Tool | What It Does | Command |
|------|--------------|---------|
| **Beads** | Track tasks across sessions | `bd` |
| **Beads Viewer** | Analyze task dependencies | `bv --robot-*` |
| **Agent Mail** | Coordinate multiple agents | MCP server |
| **CASS** | Search past AI sessions | `cass` |
| **cass-memory** | Learn from past sessions | `cm` |
| **UBS** | Scan code for 1000+ bug patterns | `ubs` |
| **Warp-Grep** | 8× parallel codebase search | MCP server |

---

## Tool Reference

### Beads (Task Tracking)

```bash
bd ready --json                    # What's available?
bd update ID --status in_progress  # Claim a task
bd close ID --reason "Done"        # Complete it
bd create "Title" -t bug -p 1      # Create new task
```

Types: `bug`, `feature`, `task`, `epic`, `chore`
Priority: `0` (critical) to `4` (backlog)

**Rule**: Always commit `.beads/` with your code changes.

### Beads Viewer (Graph Analysis)

```bash
bv --robot-priority   # What should I work on?
bv --robot-plan       # Parallel execution tracks
bv --robot-insights   # Graph metrics (PageRank, critical path)
```

**Rule**: Always use `--robot-*` flags. Never run bare `bv`.

### CASS (Session Search)

```bash
cass search "query" --robot --limit 5    # Find past solutions
cass view /path/to/session.jsonl --json  # View a session
cass expand /path -n 42 -C 3 --json      # Expand context
```

**Rule**: Always use `--robot` or `--json`. Never run bare `cass`.

### cass-memory (Cross-Agent Learning)

```bash
cm context "task description" --json    # Get playbook + history
cm doctor                               # Health check
```

The system learns automatically. You just query it.

### UBS (Bug Scanner)

```bash
ubs --staged           # Scan staged changes
ubs path/to/file.ts    # Scan specific file
ubs --fix              # Auto-fix what's possible
```

Suppress false positives with `// ubs:ignore` comments.

### Agent Mail (Multi-Agent)

When multiple agents work on the same project:

```python
# Register yourself
ensure_project(project_key="/path/to/project")
register_agent(project_key, program="claude-code", model="opus-4.5")

# Reserve files before editing
file_reservation_paths(project_key, agent_name, ["src/**"], exclusive=True)

# Communicate with other agents
send_message(project_key, sender_name, to=["OtherAgent"], subject="...", body_md="...")

# Check your inbox
fetch_inbox(project_key, agent_name)
```

Web UI: http://127.0.0.1:8765/mail

---

## Operator Guide

### Installation

```bash
# Option 1: Interactive installer
git clone https://github.com/Mburdo/knowledge_and_vibes.git
cd knowledge_and_vibes
./install-kv.sh
kv install

# Option 2: Direct install scripts
curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh | bash -s -- --yes
curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_session_search/main/install.sh | bash -s -- --easy-mode
curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/install.sh | bash -s -- --easy-mode
```

### Initialize a Project

```bash
cd your-project
bd init
cp /path/to/knowledge_and_vibes/AGENTS_TEMPLATE.md ./AGENTS.md
# Edit AGENTS.md for your project
```

### Health Checks

```bash
bd doctor                            # Beads health
ubs doctor                           # UBS health
cm doctor                            # cass-memory health
curl http://127.0.0.1:8765/health    # Agent Mail health
cass health                          # CASS health
```

### Warp-Grep Setup

Get API key: https://morphllm.com/dashboard/api-keys

```bash
claude mcp add morph-fast-tools -s user \
  -e MORPH_API_KEY=your-key \
  -e ALL_TOOLS=true \
  -- npx -y @morphllm/morphmcp
```

### Multi-Agent Setup

1. Start Agent Mail: `am`
2. Each agent registers via MCP tools
3. Agents reserve files before editing
4. Agents communicate via messages/threads

### Configuration

cass-memory config: `~/.cass-memory/config.json`
```json
{
  "provider": "anthropic",
  "cassPath": "cass",
  "validationEnabled": true
}
```

Set API key: `export ANTHROPIC_API_KEY="sk-ant-..."`

---

## Repository Structure

```
knowledge_and_vibes/
├── kv                       # Interactive CLI installer
├── install-kv.sh            # Curl-able installer
├── AGENTS_TEMPLATE.md       # Template for your projects
├── TUTORIAL.md              # Detailed workflow guide
├── patches/                 # Upstream bug fixes
│   └── fix-cass-memory.sh   # Until PRs merged
├── cass_memory_system/      # Patched cass-memory (included)
│   ├── AGENTS.md            # Excellent AGENTS.md example
│   └── src/                 # Source with patches applied
└── */README.md              # Per-tool documentation
```

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `bd: command not found` | Add `~/.local/bin` to PATH |
| CASS finds nothing | Run `cass index --full` |
| `cm context` returns empty | Check CASS is indexed |
| Agent Mail won't start | Check port 8765 is free |
| UBS module errors | Run `ubs doctor --fix` |

---

## Links

- [AGENTS_TEMPLATE.md](./AGENTS_TEMPLATE.md) - Copy to your projects
- [TUTORIAL.md](./TUTORIAL.md) - Full workflow walkthrough
- [patches/README.md](./patches/README.md) - Upstream bug tracking
- [cass_memory_system/AGENTS.md](./cass_memory_system/AGENTS.md) - Comprehensive example
