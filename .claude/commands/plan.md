# Create Implementation Plan

You are creating a detailed implementation plan and converting it to beads.

## Input Required

Ask the user: "What would you like to implement? Please describe:
1. The main goal or feature
2. Any known requirements or constraints
3. Current state of the codebase (if relevant)"

## Your Workflow

### Step 1: Gather Context

Before planning, understand:
- What already exists? (use Warp-Grep or read key files)
- What patterns does this codebase follow?
- Are there similar implementations to reference?

```bash
cm context "<user's goal>" --json
```

### Step 2: Create Detailed Plan

Think through the implementation completely:

1. **Phases**: What must happen in what order?
2. **Tasks**: Break into atomic units (~500 lines, 30-120 min each)
3. **Dependencies**: What blocks what?
4. **Parallel tracks**: What can run simultaneously?
5. **Risks**: What could go wrong?

Output a structured plan:

```
## Phase 0: Foundation
- Task 1: [title] (~X min) - Dependencies: none
- Task 2: [title] (~X min) - Dependencies: none

## Phase 1: Core Implementation
- Task 3: [title] (~X min) - Dependencies: [1, 2]
- Task 4: [title] (~X min) - Dependencies: [1]

## Phase 2: Integration
...

## Parallel Opportunities
- Tasks [1, 2] can run simultaneously
- Tasks [3, 4] can run after Phase 0 completes
```

### Step 3: Get User Approval

Present the plan and ask:
- "Does this plan look correct?"
- "Any tasks missing?"
- "Any priorities to adjust?"

### Step 4: Create Beads

Once approved, create the beads:

```bash
# Create epic (if applicable)
bd create "Epic: <main goal>" -t epic -p 1

# Create tasks with proper types
bd create "<task title>" -t <type> -p <priority> --estimate <minutes>

# Set up dependencies
bd dep add <child> <blocker> --type blocks
bd dep add <task> <epic> --type parent-child
```

### Step 5: Verify

```bash
bd dep cycles           # Must be empty
bv --robot-insights     # Check graph structure
bd ready --json         # See what's ready to start
```

### Step 6: Commit

```bash
git add .beads/
git commit -m "Add implementation plan: <goal>

<N> tasks across <M> phases
Critical path: <key milestones>"
```

### Step 7: Report

Tell the user:
- How many beads were created
- What's ready to start (`bd ready`)
- The critical path
- Parallel execution opportunities

## Guidelines

Follow DECOMPOSITION.md for:
- Sizing (~500 lines per bead)
- Atomicity (each bead independently testable)
- Dependencies (explicit blocking relationships)
- Types (bug, feature, task, epic, chore)
- Priorities (0=critical to 4=backlog)

## Output Format

After creating beads, provide:

```
## Plan Created: <goal>

**Structure:**
- Epic: <epic-id>
- Tasks: <count>
- Phases: <count>

**Ready to Start:**
<list of bd-ids with no blockers>

**Critical Path:**
<sequence of key tasks>

**Next Step:**
Run `bd update <first-task-id> --status in_progress` to begin.
```
