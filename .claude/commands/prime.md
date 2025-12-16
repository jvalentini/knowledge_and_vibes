# Prime - New Agent Startup

Complete the startup checklist to initialize a new agent session.

## Usage

```
/prime [task_focus]
```

## Arguments

- `$ARGUMENTS` - Optional. Brief description of what you'll be working on (e.g., "api integration", "database refactor")

---

## Configuration

**Before using, set these variables for your project:**

```
PROJECT_PATH="/path/to/your/project"
PROJECT_NAME="Your Project Name"
PROJECT_SLUG="your-project-slug"  # Used for Agent Mail resource URIs
```

---

## Instructions

**Complete ALL steps in order. Do not skip any.**

---

### Step 1: Announce Your Identity

Set terminal tab title and print banner:

```bash
echo -ne "\033]0;[AgentName] | PROJECT_NAME\007"
```

(You'll update this after registration with your actual agent name)

---

### Step 2: Register with Agent Mail

First, ensure the project exists:

```
mcp__mcp-agent-mail__ensure_project(
  human_key="PROJECT_PATH"
)
```

Then register yourself (let it auto-generate your name):

```
mcp__mcp-agent-mail__register_agent(
  project_key="PROJECT_PATH",
  program="claude-code",
  model="opus-4.5",
  task_description="Agent - $ARGUMENTS"
)
```

**SAVE YOUR AGENT NAME** from the response (e.g., "BlueLake"). You need it for everything.

Then set your contact policy to open:

```
mcp__mcp-agent-mail__set_contact_policy(
  project_key="PROJECT_PATH",
  agent_name="YOUR_AGENT_NAME",
  policy="open"
)
```

Now update the terminal with your real name:

```bash
echo -ne "\033]0;[YOUR_AGENT_NAME] | PROJECT_NAME\007"
```

Print your banner:
```
╔═══════════════════════════════════════╗
║  [YOUR_AGENT_NAME] | PROJECT_NAME     ║
╚═══════════════════════════════════════╝
```

---

### Step 3: Read AGENTS.md

```
Read("AGENTS.md")
```

Note the key rules:
- File reservation requirements
- Safety rules (NEVER delete files)
- Project-specific documentation requirements
- Cross-repo boundaries (if applicable)

---

### Step 4: Check Recent Session History (CASS)

```bash
cass search "PROJECT_NAME" --workspace "PROJECT_PATH" --robot --days 7 --limit 5
```

Understand what's been worked on recently.

---

### Step 5: Check Your Inbox

```
mcp__mcp-agent-mail__fetch_inbox(
  project_key="PROJECT_PATH",
  agent_name="YOUR_AGENT_NAME",
  include_bodies=true,
  limit=20
)
```

Read any messages. Acknowledge those requiring it.

---

### Step 6: Discover and Greet Other Agents

Find who else is registered:

```
ReadMcpResourceTool(
  server="mcp-agent-mail",
  uri="resource://agents/PROJECT_SLUG"
)
```

Send a greeting to other active agents (excluding yourself):

```
mcp__mcp-agent-mail__send_message(
  project_key="PROJECT_PATH",
  sender_name="YOUR_AGENT_NAME",
  to=["OtherAgent1", "OtherAgent2"],
  subject="Agent Online",
  body_md="I'm online and ready to work. Focusing on: $ARGUMENTS. What needs attention?",
  importance="normal"
)
```

---

### Step 7: Check Git State

```bash
git status
git log --oneline -5
```

Understand current state of the repo.

---

### Step 8: Find Ready Tasks

```bash
bd ready --json
```

See what's unblocked and available.

---

### Step 9: Claim a Task

If a task matches your focus (`$ARGUMENTS`), claim it:

```bash
bd update <task-id> --status in_progress --assignee YOUR_AGENT_NAME
```

**Always set assignee** so other agents know who owns the task.

Reserve the files you'll be working on:

```
mcp__mcp-agent-mail__file_reservation_paths(
  project_key="PROJECT_PATH",
  agent_name="YOUR_AGENT_NAME",
  paths=["app/services/**"],
  ttl_seconds=3600,
  exclusive=true,
  reason="<task-id>: brief description"
)
```

---

### Step 10: Output Startup Summary

```
## Agent Initialized

**Name:** [YOUR_AGENT_NAME]
**Focus:** $ARGUMENTS
**Repo:** PROJECT_NAME

### Context
- Recent sessions: [summary from CASS]
- Inbox: [X messages, Y requiring response]
- Active agents: [list]

### Task Claimed
- **ID:** [task-id]
- **Title:** [task title]
- **Files reserved:** [list]

### Ready to Work
[State your plan for the task]
```

---

## After Priming

You're now fully initialized. Proceed with your task.

When done or switching tasks:
- Run `/reflect` to verify completion
- Run `/commit` to commit changes
- Release file reservations
- Close the bead
- Run `/next_bead` to find your next task

If context gets compacted mid-session:
- Run `/re-prime` to recover context
