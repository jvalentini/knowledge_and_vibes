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

## Phase 5: Setup Complete

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
- Past sessions indexed in CASS
```

---

## Next Step: Create Your Plan

Now that setup is complete, you need an implementation plan before starting work.

**Tell your agent:**

```
Read PHILOSOPHY.md and DECOMPOSITION.md, then create an extremely detailed
implementation plan for: [describe what you want to build]

The plan should follow the 4-phase framework and break work into atomic
beads (~500 lines each). Present the plan for my approval before creating
any beads.
```

**What the agent will do:**
1. Read your planning guides (PHILOSOPHY.md, DECOMPOSITION.md)
2. Gather context from your codebase
3. Create a detailed phased plan with dependencies
4. Present it for your review
5. After approval, convert the plan to beads with `bd create` and `bd dep add`
6. Commit the backlog

**After the plan is created:**
```bash
bd ready --json           # See what's ready to start
bd update <id> --status in_progress  # Claim your first task
```

---

## Key Files

| File | Purpose |
|------|---------|
| AGENTS.md | Instructions for AI agents on your project |
| .beads/ | Task state (always commit with code changes) |
| PHILOSOPHY.md | The 4-phase development framework |
| DECOMPOSITION.md | How to break work into atomic beads |
| TUTORIAL.md | Complete workflow walkthrough |

---

## Daily Workflow (After Planning)

```bash
bd ready --json              # 1. Find work
cm context "task" --json     # 2. Get context
# Do the work                # 3. Implement
ubs --staged                 # 4. Scan for bugs
bd close <id> --reason "..." # 5. Complete task
git add -A && git commit     # 6. Save everything
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `bd: command not found` | Add `~/.local/bin` to PATH, restart shell |
| `am` fails to start | Check port 8765: `lsof -i :8765` |
| `cass index` finds nothing | Check Claude Code sessions exist in `~/.claude/` |
| MCP server not listed | Restart Claude Code after adding |
| Permission denied | Check file permissions, may need `chmod +x` |
