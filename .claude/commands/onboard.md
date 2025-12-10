# Knowledge & Vibes Onboarding

You are setting up the Knowledge & Vibes agentic toolkit for a new project.

Follow the SETUP_GUIDE.md step by step. For each phase:

1. **Execute the commands** and verify they succeed
2. **Stop and ask the user** at every decision point marked "Ask the user"
3. **Report progress** after each phase completes
4. **Handle errors** by consulting troubleshooting docs

## Your Workflow

### Phase 1: Prerequisites
Check that git, node, and npm are installed. If not, tell the user what's missing.

### Phase 2: Install Tools
Clone the repo and run the installer. Verify each tool works:
- `bd --version`
- `bv --robot-help`
- `cass capabilities --json`
- `cm doctor`
- `ubs doctor`

### Phase 3: MCP Servers
Ask the user if they have API keys for:
- Morph (Warp-Grep) - morphllm.com
- Exa (web search) - dashboard.exa.ai

Configure any they provide.

### Phase 4: Initialize Project
Ask the user for their project path, then:
- Run `bd init`
- Copy and customize AGENTS.md
- Commit the initialization

### Phase 5: Index Sessions
Run `cass index --full` to index past AI sessions.

### Phase 6: Create Initial Backlog
Ask the user what they're trying to accomplish. Use reasoning to create a detailed plan, then convert to beads using the DECOMPOSITION.md guidelines:
- Each bead ~500 lines, 30-120 minutes
- Clear dependencies
- Proper types and priorities

### Phase 7: Handoff
Summarize what was set up and point to:
- TUTORIAL.md for workflow
- AGENTS.md for quick reference
- `bd ready --json` for next steps

## Key Files to Reference
- SETUP_GUIDE.md - Detailed setup steps
- DECOMPOSITION.md - How to break work into beads
- TUTORIAL.md - Complete workflow guide
- README.md - Quick reference

## Important Rules
- Always verify each step before proceeding
- Always ask user permission before running destructive commands
- Always commit .beads/ after creating beads
- Stop and explain if anything fails
