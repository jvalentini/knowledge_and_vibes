# knowledge_and_vibes

```
┌────────────────────────────────────────────────────────────────────────────┐
│                                                                            │
│   ██╗  ██╗███╗   ██╗ ██████╗ ██╗    ██╗██╗     ███████╗██████╗  ██████╗   │
│   ██║ ██╔╝████╗  ██║██╔═══██╗██║    ██║██║     ██╔════╝██╔══██╗██╔════╝   │
│   █████╔╝ ██╔██╗ ██║██║   ██║██║ █╗ ██║██║     █████╗  ██║  ██║██║  ███╗  │
│   ██╔═██╗ ██║╚██╗██║██║   ██║██║███╗██║██║     ██╔══╝  ██║  ██║██║   ██║  │
│   ██║  ██╗██║ ╚████║╚██████╔╝╚███╔███╔╝███████╗███████╗██████╔╝╚██████╔╝  │
│   ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝╚══════╝╚═════╝  ╚═════╝   │
│                                                                            │
│                    & VIBES — AI Coding Agent Toolkit                       │
│                                                                            │
│   Persistent memory • Multi-agent coordination • Session search • QA       │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## For AI Agents: Quick Setup

If you're an AI agent and a user gave you this repo link, here's what to do:

### 1. Install the toolkit (run these commands)

```bash
# Core stack (Beads + Viewer + Agent Mail)
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh?$(date +%s)" | bash -s -- --yes

# CASS (session search)
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_session_search/main/install.sh?$(date +%s)" | bash -s -- --easy-mode --verify

# UBS (bug scanner)
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/install.sh?$(date +%s)" | bash -s -- --easy-mode
```

### 2. Initialize the user's project

```bash
cd /path/to/user/project
bd init
```

### 3. Create AGENTS.md in their project

Copy the [AGENTS_TEMPLATE.md](./AGENTS_TEMPLATE.md) to the user's project root as `AGENTS.md`, then customize the Project section.

### 4. Explain to the user

Tell them:
- **`bd ready`** shows available tasks
- **`bv --robot-priority`** tells you what to work on (use `--robot-*` flags always)
- **`ubs --staged`** scans for bugs before commits
- **`cass search "query" --robot`** finds past solutions
- **`bd sync && git push`** saves everything at session end

The TUTORIAL.md has the full explanation for humans. The AGENTS_TEMPLATE.md has the distilled commands for agents.

---

## For Humans: The `kv` CLI

**Prefer a terminal UI?** Install the `kv` command for an interactive setup experience:

```bash
# Clone and install
git clone https://github.com/YOUR-USERNAME/knowledge-and-vibes.git
cd knowledge-and-vibes
./install-kv.sh

# Run interactive TUI
kv

# Or use direct commands
kv install      # Install full stack
kv tutorial     # Show workflow tutorial
kv status       # Check what's installed
kv init         # Initialize Beads in current dir
kv agents       # Create AGENTS.md in current dir
kv docs         # Browse tool documentation
kv help         # Show all commands
```

**Or just read on** — everything below covers the same content.

---

## Main Menu

| # | Option | Description |
|---|--------|-------------|
| 1 | [**Install**](#1-install) | Get the full stack running in 5 minutes |
| 2 | [**What's Included**](#2-whats-included) | Overview of all tools |
| 3 | [**Quick Tutorial**](#3-quick-tutorial) | Learn the daily workflow |
| 4 | [**AGENTS.md Setup**](#4-agentsmd-setup) | Configure AI agent behavior |
| 5 | [**Multi-Agent Mode**](#5-multi-agent-mode) | Run multiple agents together |
| 6 | [**Tool Deep Dives**](#6-tool-deep-dives) | Detailed docs for each tool |
| 7 | [**Troubleshooting**](#7-troubleshooting) | Common issues & fixes |

---

## 1. Install

```
┌─────────────────────────────────────────────────────────────────┐
│  INSTALL                                           [5 minutes]  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Run these commands in order. Each one installs part of the     │
│  toolkit. Copy-paste friendly.                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Step 1: Core Stack (Beads + Beads Viewer + Agent Mail)

```bash
curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh | bash -s -- --yes
```

**Installs:** `bd` (tasks) • `bv` (graph analysis) • Agent Mail server • `am` alias

### Step 2: Session Search (CASS)

```bash
curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_session_search/main/install.sh | bash -s -- --easy-mode --verify
```

**Installs:** `cass` (search past AI sessions)

### Step 3: Bug Scanner (UBS)

```bash
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/install.sh?$(date +%s)" | bash -s -- --easy-mode
```

**Installs:** `ubs` (static analysis for 1000+ bug patterns)

### Step 4: Warp-Grep (Optional)

Get free API key → https://morphllm.com/dashboard/api-keys

```bash
claude mcp add morph-fast-tools -s user \
  -e MORPH_API_KEY=your-key-here \
  -e ALL_TOOLS=true \
  -- npx -y @morphllm/morphmcp
```

**Installs:** 8× parallel codebase search

### Step 5: Initialize Your Project

```bash
cd your-project
bd init
```

**✓ Done!** [Back to Menu](#main-menu)

---

## 2. What's Included

```
┌─────────────────────────────────────────────────────────────────┐
│  WHAT'S INCLUDED                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Six tools that work together to supercharge AI coding agents.  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### The Stack

```
┌────────────────────────────────────────────────────────────────────────┐
│                                                                        │
│  ┌──────────┐   ┌──────────┐   ┌────────────────────────────────────┐ │
│  │  BEADS   │──▶│ BEADS    │   │         MCP AGENT MAIL             │ │
│  │   bd     │   │ VIEWER   │   │  Multi-agent messaging & locks     │ │
│  │  Tasks   │   │   bv     │   │                                    │ │
│  └──────────┘   └──────────┘   └────────────────────────────────────┘ │
│                                                                        │
│  ┌──────────┐   ┌──────────┐   ┌────────────────────────────────────┐ │
│  │   CASS   │   │   UBS    │   │           WARP-GREP                │ │
│  │ Session  │   │   Bug    │   │     8× parallel search             │ │
│  │ Search   │   │ Scanner  │   │                                    │ │
│  └──────────┘   └──────────┘   └────────────────────────────────────┘ │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### Tool Summary

| Tool | Problem It Solves | Command |
|------|-------------------|---------|
| **Beads** | Agents forget tasks mid-session | `bd` |
| **Beads Viewer** | Can't see task dependencies/impact | `bv` |
| **Agent Mail** | Multiple agents overwrite each other | MCP server |
| **CASS** | Lost knowledge from past sessions | `cass` |
| **UBS** | AI-generated code has bugs | `ubs` |
| **Warp-Grep** | Serial search is slow, pollutes context | MCP server |

**→** [Back to Menu](#main-menu)

---

## 3. Quick Tutorial

```
┌─────────────────────────────────────────────────────────────────┐
│  QUICK TUTORIAL                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Learn the daily workflow in 5 steps.                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Daily Workflow

```
  START SESSION                    DURING WORK                    END SESSION
       │                                │                              │
       ▼                                ▼                              ▼
┌─────────────┐                 ┌─────────────┐                ┌─────────────┐
│ bd ready    │ ───────────────▶│ cass search │ ──────────────▶│ ubs --staged│
│             │                 │             │                │             │
│ What's      │                 │ Search past │                │ Scan for    │
│ available?  │                 │ solutions   │                │ bugs        │
└─────────────┘                 └─────────────┘                └─────────────┘
       │                                                               │
       ▼                                                               ▼
┌─────────────┐                                                ┌─────────────┐
│ bd update   │                                                │ bd close    │
│ --status    │                                                │ --reason    │
│ in_progress │                                                │ "Done"      │
└─────────────┘                                                └─────────────┘
```

### Step-by-Step

**1. Start Session — See What's Ready**
```bash
bd ready --json
```

**2. Get Priority Recommendations**
```bash
bv --robot-priority
```

**3. Claim a Task**
```bash
bd update bd-a1b2 --status in_progress
```

**4. Search Past Sessions (if needed)**
```bash
cass search "similar problem" --robot --limit 5
```

**5. Before Committing — Scan for Bugs**
```bash
ubs --staged
```

**6. Complete the Task**
```bash
bd close bd-a1b2 --reason "Implemented feature X"
bd sync && git push
```

**→** [Back to Menu](#main-menu)

---

## 4. AGENTS.md Setup

```
┌─────────────────────────────────────────────────────────────────┐
│  AGENTS.md SETUP                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  The AGENTS.md file tells AI agents how to behave in your       │
│  project. Create one in your project root.                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Create the File

```bash
touch AGENTS.md
```

### Paste This Template

```markdown
# AGENTS.md

## Project Overview
<!-- Brief description of your project -->

## Critical Rules
- Never delete files without explicit user approval
- Never run destructive git commands (force push, hard reset)
- Always run `ubs --staged` before committing
- Reserve files via Agent Mail before editing (multi-agent)

## Beads (Task Tracking)

Start every session:
\`\`\`bash
bd ready --json
\`\`\`

Claim a task:
\`\`\`bash
bd update <id> --status in_progress
\`\`\`

Complete a task:
\`\`\`bash
bd close <id> --reason "Completed: <summary>"
bd sync
\`\`\`

## Beads Viewer (Graph Analysis)

**IMPORTANT**: Always use robot flags. Interactive TUI will hang your session.

\`\`\`bash
bv --robot-priority    # Priority recommendations
bv --robot-plan        # Parallel execution tracks
bv --robot-insights    # Graph metrics
\`\`\`

## CASS (Session Search)

Search past sessions:
\`\`\`bash
cass search "query" --robot --fields minimal --limit 10
\`\`\`

## UBS (Bug Scanner)

Scan before committing:
\`\`\`bash
ubs --staged
\`\`\`

Suppress false positives: `// ubs:ignore`

## Warp-Grep

Works automatically — Claude runs 8 parallel searches.
```

**→** [Full AGENTS.md Template](./AGENTS_TEMPLATE.md)

**→** [Back to Menu](#main-menu)

---

## 5. Multi-Agent Mode

```
┌─────────────────────────────────────────────────────────────────┐
│  MULTI-AGENT MODE                                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Run multiple AI agents on the same project without conflicts.  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Architecture

```
┌─────────────────┐         ┌─────────────────┐
│   Agent #1      │         │   Agent #2      │
│   "GreenCastle" │         │   "BlueLake"    │
└────────┬────────┘         └────────┬────────┘
         │                           │
         └───────────┬───────────────┘
                     │
                     ▼
         ┌───────────────────────┐
         │   MCP AGENT MAIL      │
         │   Port 8765           │
         │                       │
         │  • Messaging          │
         │  • File Reservations  │
         │  • Audit Trail        │
         └───────────────────────┘
```

### Setup Steps

**1. Start the Server**
```bash
am
```
Web UI: http://127.0.0.1:8765/mail

**2. Each Agent Registers**
```python
ensure_project(project_key="/path/to/project")
register_agent(project_key, program="claude-code", model="opus-4.5", name="GreenCastle")
```

**3. Reserve Files Before Editing**
```python
file_reservation_paths(
    project_key="/path/to/project",
    agent_name="GreenCastle",
    paths=["src/auth/**"],
    ttl_seconds=3600,
    exclusive=True,
    reason="bd-123"
)
```

**4. Send Messages**
```python
send_message(
    project_key="/path/to/project",
    sender_name="GreenCastle",
    to=["BlueLake"],
    subject="[bd-123] Starting auth refactor",
    body_md="Working on login module...",
    thread_id="bd-123"
)
```

**5. Release When Done**
```python
release_file_reservations(project_key, agent_name="GreenCastle")
```

### Cross-Repo Setup

For frontend + backend in separate repos:

```yaml
# .beads/config.yaml (in primary repo)
repos:
  primary: "."
  additional:
    - ~/projects/backend
    - ~/projects/shared-libs
```

Now `bd ready` shows tasks from all repos.

**→** [Agent Mail Deep Dive](./mcp_agent_mail/README.md)

**→** [Back to Menu](#main-menu)

---

## 6. Tool Deep Dives

```
┌─────────────────────────────────────────────────────────────────┐
│  TOOL DEEP DIVES                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Detailed documentation for each tool.                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

| Tool | Documentation | Source Repo |
|------|---------------|-------------|
| **Beads** | [beads/README.md](./beads/README.md) | [github.com/steveyegge/beads](https://github.com/steveyegge/beads) |
| **Beads Viewer** | [beads_viewer/README.md](./beads_viewer/README.md) | [github.com/Dicklesworthstone/beads_viewer](https://github.com/Dicklesworthstone/beads_viewer) |
| **Agent Mail** | [mcp_agent_mail/README.md](./mcp_agent_mail/README.md) | [github.com/Dicklesworthstone/mcp_agent_mail](https://github.com/Dicklesworthstone/mcp_agent_mail) |
| **CASS** | [coding_agent_session_search/README.md](./coding_agent_session_search/README.md) | [github.com/Dicklesworthstone/coding_agent_session_search](https://github.com/Dicklesworthstone/coding_agent_session_search) |
| **UBS** | [ultimate_bug_scanner/README.md](./ultimate_bug_scanner/README.md) | [github.com/Dicklesworthstone/ultimate_bug_scanner](https://github.com/Dicklesworthstone/ultimate_bug_scanner) |
| **Warp-Grep** | [warp_grep/README.md](./warp_grep/README.md) | [morphllm.com](https://morphllm.com) |

**→** [Back to Menu](#main-menu)

---

## 7. Troubleshooting

```
┌─────────────────────────────────────────────────────────────────┐
│  TROUBLESHOOTING                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Common issues and how to fix them.                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Quick Fixes

| Issue | Fix |
|-------|-----|
| `bd: command not found` | Re-run installer, add `~/.local/bin` to PATH |
| `bv: command not found` | Re-run installer, check PATH |
| Agent Mail won't start | Check port 8765 is free, run `am` |
| CASS finds nothing | Run `cass index --full` |
| UBS module errors | Run `ubs doctor --fix` |
| Warp-Grep not working | Restart Claude Code, run `/mcp` |

### Health Checks

```bash
# Beads health
bd doctor

# UBS health
ubs doctor

# Agent Mail status
curl http://127.0.0.1:8765/health

# CASS index status
cass index --full
```

**→** [Back to Menu](#main-menu)

---

## Repository Structure

```
knowledge_and_vibes/
├── README.md                    ← You are here
├── kv                           ← Interactive CLI (./kv or kv after install)
├── install-kv.sh                ← Installer for kv CLI
├── TUTORIAL.md                  ← Complete workflow tutorial
├── AGENTS_TEMPLATE.md           ← Full AGENTS.md template
│
├── beads/
│   ├── beads/                   ← Cloned repo
│   └── README.md                ← Beads documentation
│
├── beads_viewer/
│   ├── beads_viewer/            ← Cloned repo
│   └── README.md                ← Beads Viewer documentation
│
├── mcp_agent_mail/
│   ├── mcp_agent_mail/          ← Cloned repo
│   └── README.md                ← Agent Mail documentation
│
├── coding_agent_session_search/
│   ├── coding_agent_session_search/  ← Cloned repo
│   └── README.md                ← CASS documentation
│
├── ultimate_bug_scanner/
│   ├── ultimate_bug_scanner/    ← Cloned repo
│   └── README.md                ← UBS documentation
│
└── warp_grep/
    └── README.md                ← Warp-Grep documentation
```

---

```
┌────────────────────────────────────────────────────────────────────────────┐
│                                                                            │
│                         knowledge_and_vibes                                  │
│                                                                            │
│                    Last updated: December 2025                             │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```
