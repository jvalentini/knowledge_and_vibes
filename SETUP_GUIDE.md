# Agent Setup Guide

**For AI agents setting up Knowledge & Vibes in a new project.**

This guide is designed to be followed by an AI agent. Each section has clear steps, verification commands, and decision points where you should consult the user.

---

## Prerequisites Check

Before starting, verify these are available:

```bash
# Check for required tools
which git && echo "✓ git"
which node && echo "✓ node"
which npm && echo "✓ npm"
```

**If any are missing**: Stop and tell the user what needs to be installed.

---

## Phase 1: Install the Toolkit

### Step 1.1: Clone the repository

```bash
git clone https://github.com/Mburdo/knowledge_and_vibes.git ~/.knowledge_and_vibes
```

### Step 1.2: Run the installer

```bash
cd ~/.knowledge_and_vibes
./install-kv.sh
```

Or use the interactive installer:

```bash
~/.knowledge_and_vibes/kv install
```

### Step 1.3: Verify PATH

```bash
# Add to shell config if not already present
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc  # or ~/.bashrc
source ~/.zshrc
```

### Step 1.4: Verify each tool

Run these and confirm each returns output (not "command not found"):

```bash
bd --version        # Beads
bv --robot-help     # Beads Viewer
cass capabilities --json  # CASS
cm doctor           # cass-memory
ubs doctor          # UBS
```

**Decision point**: If any tool fails, consult the Troubleshooting section in README.md.

---

## Phase 2: Configure MCP Servers

### Step 2.1: Agent Mail (multi-agent coordination)

Agent Mail is already configured as an MCP server. Verify:

```bash
# Start the server
am &

# Check health
curl -s http://127.0.0.1:8765/health
```

### Step 2.2: Warp-Grep (parallel search)

**Ask the user**: "Do you have a Morph API key from morphllm.com? Warp-Grep provides 8× faster code search."

If yes:
```bash
claude mcp add morph-fast-tools -s user \
  -e MORPH_API_KEY=<user-provided-key> \
  -e ALL_TOOLS=true \
  -- npx -y @morphllm/morphmcp
```

If no: Skip this step. The agent can use regular grep/search tools.

### Step 2.3: Exa (web search)

**Ask the user**: "Do you have an Exa API key from dashboard.exa.ai? Exa provides real-time web search for current documentation."

If yes:
```bash
claude mcp add exa -s user \
  -e EXA_API_KEY=<user-provided-key> \
  -- npx -y @anthropic-labs/exa-mcp-server
```

If no: Skip this step. The agent will use training knowledge for documentation.

### Step 2.4: Verify MCP servers

```bash
# In Claude Code, run:
/mcp
```

Should show installed MCP servers.

---

## Phase 3: Initialize the Target Project

### Step 3.1: Navigate to user's project

**Ask the user**: "What is the path to your project?"

```bash
cd <user-provided-path>
```

### Step 3.2: Initialize Beads

```bash
bd init
```

This creates `.beads/` directory for task tracking.

### Step 3.3: Copy AGENTS.md template

```bash
cp ~/.knowledge_and_vibes/AGENTS_TEMPLATE.md ./AGENTS.md
```

### Step 3.4: Customize AGENTS.md

**Ask the user**:
- "What is the project name?"
- "What is the primary language (TypeScript/Python/Go/etc.)?"
- "What are the key paths (src/, tests/, etc.)?"

Edit AGENTS.md with their answers:

```markdown
## Project Overview

- **Name**: <user-provided-name>
- **Language**: <user-provided-language>
- **Key Paths**: <user-provided-paths>
```

### Step 3.5: Add to .gitignore (if not already)

```bash
# Ensure .beads is NOT in .gitignore (it should be tracked)
# But add any local-only files:
echo ".beads/*.db" >> .gitignore  # SQLite cache
```

### Step 3.6: Initial commit

```bash
git add .beads/ AGENTS.md
git commit -m "Initialize Knowledge & Vibes toolkit

- Add Beads task tracking (.beads/)
- Add AGENTS.md for agent instructions"
```

---

## Phase 4: Index Past Sessions (CASS)

### Step 4.1: Build the index

```bash
cass index --full
```

This indexes all past AI coding sessions from Claude Code, Cursor, Codex, etc.

### Step 4.2: Verify

```bash
cass timeline --today --json
```

Should show indexed sessions.

---

## Phase 5: Create Initial Task Backlog

### Step 5.1: Ask user about their goals

**Ask the user**: "What are you trying to accomplish with this project? Please describe:
1. The main goal or feature you're building
2. Any known subtasks or components
3. Current blockers or unknowns"

### Step 5.2: Use reasoning to create a plan

Before creating beads, think through the decomposition:

1. **Break into phases**: What must be done first? What depends on what?
2. **Identify atomic units**: Each bead should be ~500 lines of code or less
3. **Mark dependencies**: Which tasks block others?
4. **Assign types**: bug, feature, task, epic, chore
5. **Set priorities**: 0 (critical) to 4 (backlog)

### Step 5.3: Create beads from the plan

For each identified task:

```bash
bd create "Task title" -t <type> -p <priority> --estimate <minutes>
```

For dependencies:

```bash
bd dep add <child-id> <blocker-id> --type blocks
```

For epics with subtasks:

```bash
bd create "Epic: Main Feature" -t epic -p 1
bd create "Subtask 1" -t task -p 1
bd create "Subtask 2" -t task -p 1
bd dep add <subtask1> <epic> --type parent-child
bd dep add <subtask2> <epic> --type parent-child
```

### Step 5.4: Verify the task graph

```bash
bv --robot-insights
```

Check for:
- No cycles (`bd dep cycles` should return empty)
- Clear critical path
- Reasonable dependency structure

### Step 5.5: Commit the backlog

```bash
git add .beads/
git commit -m "Add initial task backlog

Created <N> beads across <M> phases"
```

---

## Phase 6: Handoff to User

### Step 6.1: Summary message

Tell the user:

```
Setup complete! Here's what was configured:

**Tools Installed:**
- bd (Beads) - Task tracking
- bv (Beads Viewer) - Graph analysis
- cass - Session search
- cm (cass-memory) - Cross-agent learning
- ubs - Bug scanner
- [Warp-Grep - if configured]
- [Exa - if configured]

**Project Initialized:**
- .beads/ - Task tracking directory
- AGENTS.md - Agent instructions

**Initial Backlog:**
- <N> tasks created
- <M> ready to start (no blockers)

**Next Steps:**
1. Review the backlog: `bd list`
2. See what's ready: `bd ready --json`
3. Start your first task: `bd update <id> --status in_progress`
4. Read TUTORIAL.md for detailed workflow guidance

**Key Files:**
- AGENTS.md - Instructions for AI agents working on this project
- .beads/ - Task state (always commit with code changes)

**Daily Workflow:**
1. `bd ready --json` - Find work
2. `cm context "task" --json` - Get context
3. Do the work
4. `ubs --staged` - Scan for bugs
5. `bd close <id>` - Complete task
6. `git add -A && git commit && git push`
```

### Step 6.2: Point to documentation

```
**Where to Learn More:**
- TUTORIAL.md - Complete workflow guide
- AGENTS_TEMPLATE.md - Full tool reference
- README.md - Quick reference
- cass_memory_system/AGENTS.md - Excellent AGENTS.md example
```

---

## Troubleshooting During Setup

| Issue | Solution |
|-------|----------|
| `bd: command not found` | Add `~/.local/bin` to PATH, restart shell |
| `am` fails to start | Check port 8765: `lsof -i :8765` |
| `cass index` finds nothing | Check Claude Code sessions exist in `~/.claude/` |
| MCP server not listed | Restart Claude Code after adding |
| Permission denied | Check file permissions, may need `chmod +x` |

---

## Decomposition Guidelines

When creating beads from a plan:

### Size Target
- **~500 lines of code** per bead
- If larger, decompose into sub-beads: `bd-abc.1`, `bd-abc.2`
- If much smaller, consider combining with related work

### Atomic Principle
Each bead should be:
- **Independently testable** - Can verify completion without other beads
- **Single responsibility** - Does one thing well
- **Clear boundaries** - Obvious where it starts and ends

### Dependency Types
- `blocks` - Must complete A before starting B
- `related` - Work is connected but not blocking
- `parent-child` - B is a subtask of A
- `discovered-from` - Found B while working on A

### Priority Guidelines
- **P0** - Blocking everything, do immediately
- **P1** - Core functionality, this sprint
- **P2** - Important but not urgent
- **P3** - Nice to have
- **P4** - Backlog, someday

### Estimation
- Use minutes for estimates
- 30-120 minutes is typical for a well-scoped bead
- If estimate > 240 minutes, consider decomposing

---

## Example: Decomposing "Add User Authentication"

**Bad** (too large):
```bash
bd create "Add user authentication" -t feature -p 1 --estimate 1440
```

**Good** (atomic):
```bash
# Create epic
bd create "Epic: User Authentication" -t epic -p 1

# Phase 1: Foundation
bd create "Set up auth database schema" -t task -p 0 --estimate 60
bd create "Create User model and migrations" -t task -p 0 --estimate 45
bd create "Add password hashing utilities" -t task -p 0 --estimate 30

# Phase 2: Core auth
bd create "Implement registration endpoint" -t feature -p 1 --estimate 90
bd create "Implement login endpoint" -t feature -p 1 --estimate 90
bd create "Add JWT token generation" -t task -p 1 --estimate 60
bd create "Create auth middleware" -t task -p 1 --estimate 45

# Phase 3: Session management
bd create "Add refresh token support" -t feature -p 2 --estimate 90
bd create "Implement logout endpoint" -t task -p 2 --estimate 30
bd create "Add session invalidation" -t task -p 2 --estimate 45

# Set up dependencies
bd dep add <registration> <user-model> --type blocks
bd dep add <login> <password-hashing> --type blocks
bd dep add <jwt> <login> --type blocks
bd dep add <middleware> <jwt> --type blocks
# ... etc
```

Each bead is testable, atomic, and ~30-90 minutes of focused work.
