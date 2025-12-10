# Beads Viewer (bv)

## Overview

**Beads Viewer** (`bv`) is a high-performance Terminal User Interface (TUI) for browsing and managing tasks in projects that use the **Beads** issue tracking system. It treats your project as a **Directed Acyclic Graph (DAG)**, providing dependency-aware insights that traditional list-based trackers miss.

**Repository:** https://github.com/Dicklesworthstone/beads_viewer

---

## What It Does

Beads Viewer provides:

1. **Fast Terminal Browsing** - Browse thousands of issues instantly with zero network latency
2. **Graph Analysis** - Visualizes dependency graphs with PageRank, critical path, and cycle detection
3. **AI-Ready Output** - Structured JSON output via robot flags for AI agent consumption
4. **Multiple Views** - List view, Kanban board, insights panel, and graph visualization
5. **Live Reload** - Watches `.beads/beads.jsonl` and refreshes automatically

### The Problem It Solves

While `bd` (Beads CLI) handles task CRUD operations, `bv` provides **precomputed graph analytics** that help both humans and AI agents make intelligent prioritization decisions:

- **PageRank scores** - Identify high-impact tasks that unblock the most downstream work
- **Critical path analysis** - Find the longest dependency chain to completion
- **Cycle detection** - Spot circular dependencies before they cause deadlocks
- **Parallel track planning** - Determine which tasks can run concurrently

Instead of agents parsing `.beads/beads.jsonl` directly or attempting to compute graph metrics (risking hallucinated results), they can call `bv`'s deterministic robot flags and get JSON output they can trust.

---

## Installation

### Quick Install (Recommended)
```bash
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh?$(date +%s)" | bash
```

### Go Install
```bash
go install github.com/Dicklesworthstone/beads_viewer@latest
```

### From Source
```bash
git clone https://github.com/Dicklesworthstone/beads_viewer.git
cd beads_viewer
go build -o bv
```

---

## Human Usage (Interactive TUI)

### Launching
```bash
bv                    # Auto-detects .beads/beads.jsonl
bv /path/to/project   # Specify project directory
bv --recipe ready     # Start with pre-filtered view
```

### Keyboard Navigation

| Key | Action |
|-----|--------|
| `j`/`k` | Move down/up |
| `Enter` | Select/expand |
| `/` | Fuzzy search |
| `?` | Help |
| `q` | Quit |

### View Switching

| Key | View |
|-----|------|
| `l` | List view (default) |
| `b` | Kanban board |
| `g` | Graph view (dependency DAG) |
| `i` | Insights panel |

### Filtering

| Key | Filter |
|-----|--------|
| `o` | Open issues only |
| `c` | Closed issues only |
| `r` | Ready (unblocked) issues |
| `Esc` | Clear filters |

### Actions

| Key | Action |
|-----|--------|
| `E` | Export to Markdown file |
| `C` | Copy selected issue as Markdown |
| `O` | Open `.beads/beads.jsonl` in editor |
| `t` | Time-travel comparison to git revision |
| `T` | Quick comparison to HEAD~5 |

---

## Robot Flags (AI Agent Usage)

**CRITICAL FOR AGENTS**: You must ONLY use `bv` with the robot flags. The interactive TUI will hang your agent session!

### Discovery
```bash
bv --robot-help       # Shows all AI-facing commands
```

### Graph Metrics & Insights
```bash
bv --robot-insights
```
Returns JSON with:
- PageRank scores (foundational blockers)
- Betweenness centrality (bottlenecks)
- HITS scores (hubs vs authorities)
- Critical path (longest dependency chain)
- Cycle detection (structural errors)

Example output:
```json
{
  "pagerank": [
    {"id": "bd-a1b2", "score": 0.142, "title": "Auth System"},
    {"id": "bd-f14c", "score": 0.089, "title": "Database Schema"}
  ],
  "critical_path": {
    "length": 5,
    "path": ["bd-a1b2", "bd-c3d4", "bd-e5f6", "bd-g7h8", "bd-i9j0"]
  },
  "cycles": [],
  "density": 0.12
}
```

### Execution Planning
```bash
bv --robot-plan
```
Returns JSON with:
- Parallel tracks (what can run concurrently)
- Items per track
- Unblocks lists (what each completion frees up)

Example output:
```json
{
  "tracks": [
    {
      "track": 1,
      "items": ["bd-a1b2", "bd-c3d4"],
      "unblocks": {"bd-a1b2": ["bd-e5f6", "bd-g7h8"]}
    }
  ],
  "total_tracks": 3,
  "parallelism_ratio": 0.67
}
```

### Priority Recommendations
```bash
bv --robot-priority
```
Returns JSON with ranked tasks, reasoning, and confidence levels.

Example output:
```json
{
  "recommendations": [
    {
      "id": "bd-a1b2",
      "priority": 1,
      "reasoning": "High PageRank (0.142), on critical path, unblocks 3 tasks",
      "confidence": 0.92
    }
  ]
}
```

### Change Detection
```bash
bv --robot-diff --diff-since "1 hour ago"
bv --robot-diff --diff-since HEAD~5
bv --robot-diff --diff-since 2024-01-15
```
Returns JSON with:
- New items since reference
- Closed items since reference
- Cycles introduced/resolved

### Available Recipes
```bash
bv --robot-recipes
```
Lists filter presets: `default`, `actionable`, `blocked`, `high-priority`, etc.

Apply a recipe before other flags:
```bash
bv --recipe actionable --robot-insights
```

---

## Graph Metrics Explained

### 1. PageRank (Dependency Authority)
Measures recursive dependency importance. High PageRank tasks are the bedrock of your project—often schemas, core libraries, or architectural decisions.

**Use case**: Find foundational blockers that, if broken, break the entire graph.

### 2. Betweenness Centrality (Bottlenecks)
Measures fraction of shortest paths passing through a node. High betweenness indicates a task that bridges otherwise isolated clusters.

**Use case**: Identify gatekeepers and choke points that block multiple sub-teams.

### 3. HITS (Hubs & Authorities)
- **High Hub Score**: Epics or product features that aggregate many dependencies
- **High Authority Score**: Utilities that provide value to many consumers

**Use case**: Distinguish between feature-driven work and infrastructure work.

### 4. Critical Path
The longest dependency chain from any start node to any end node. Tasks on the critical path have zero slack—any delay propagates.

**Use case**: Find the keystones that determine project completion time.

### 5. Cycle Detection
Circular dependencies are structural errors that prevent valid execution order.

**Use case**: Catch dependency mistakes before they cause deadlocks.

### 6. Topological Sort
Valid execution order respecting all dependencies.

**Use case**: Foundation for the work queue and parallel track planning.

---

## Agent Workflow Integration

### Task Selection Workflow
```bash
# 1. Get priority recommendations
bv --robot-priority

# 2. Check what completing a task would unblock
bv --robot-plan

# 3. After work, check what changed
bv --robot-diff --diff-since "1 hour ago"
```

### Combined with Agent Mail
```bash
# 1. Agent A runs bv --robot-priority → identifies bd-42 as highest-impact
# 2. Agent A reserves files: file_reservation_paths(..., reason="bd-42")
# 3. Agent A announces via Agent Mail: send_message(..., thread_id="bd-42")
# 4. Other agents see reservation and pick different tasks
# 5. Agent A completes, runs bv --robot-diff to report downstream unblocks
```

### When to Use bv vs bd

| Tool | Best For |
|------|----------|
| `bd` | Creating, updating, closing tasks; `bd ready` for simple "what's next" |
| `bv` | Graph analysis, impact assessment, parallel planning, change tracking |

**Rule of thumb**: Use `bd` for task operations, use `bv` for task intelligence.

---

## Configuration

### Hooks (`.bv/hooks.yaml`)
Configure pre- and post-export hooks:

```yaml
hooks:
  pre_export:
    - command: "validate-issues.sh"
      on_error: fail    # fail fast
  post_export:
    - command: "notify-slack.sh"
      on_error: continue  # log and continue
      env:
        SLACK_CHANNEL: "#project-updates"
```

Hook environment includes:
- `BV_EXPORT_PATH`
- `BV_EXPORT_FORMAT`
- `BV_ISSUE_COUNT`
- `BV_TIMESTAMP`

---

## Best Practices

### 1. Use Robot Flags for Automation
Never use interactive TUI from scripts or agents:
```bash
# Good
bv --robot-priority | jq '.'

# Bad - will hang
bv  # Interactive mode
```

### 2. Combine with Recipes for Focus
```bash
bv --recipe blocked --robot-insights  # Only blocked issues
bv --recipe actionable --robot-plan   # Ready to work items
```

### 3. Track Progress with Diffs
```bash
# Start of day
bv --robot-diff --diff-since "8 hours ago"

# End of sprint
bv --robot-diff --diff-since "2 weeks ago"
```

### 4. Use Insights for Prioritization
Before picking work, check what has the highest impact:
```bash
bv --robot-priority  # Ranked recommendations with reasoning
```

---

## AGENTS.md/CLAUDE.md Snippet

Add this to your agent documentation:

```markdown
### Using bv as an AI sidecar

bv is a fast terminal UI for Beads projects. For agents, it's a graph sidecar: instead of parsing JSONL or risking hallucinated traversal, call the robot flags to get deterministic, dependency-aware outputs.

*IMPORTANT: As an agent, you must ONLY use bv with the robot flags!*

- bv --robot-help — shows all AI-facing commands
- bv --robot-insights — JSON graph metrics
- bv --robot-plan — JSON execution plan with parallel tracks
- bv --robot-priority — JSON priority recommendations
- bv --robot-recipes — list available filter presets
- bv --robot-diff --diff-since <ref> — JSON diff of changes

Use these commands instead of hand-rolling graph logic.
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `bv: command not found` | Run installer or add to PATH |
| No issues showing | Ensure `.beads/beads.jsonl` exists; run `bd init` |
| Agent stuck in TUI | Always use `--robot-*` flags for non-interactive use |
| Stale data | Press `r` to refresh or restart `bv` |

---

## Links

- **Repository**: https://github.com/Dicklesworthstone/beads_viewer
- **Beads (parent project)**: https://github.com/steveyegge/beads
- **Author**: Jeffrey Emanuel (Dicklesworthstone)
- **License**: MIT

---

*Last updated: December 2025*
