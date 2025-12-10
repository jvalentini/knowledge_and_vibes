# Beads Issue Tracker

## Overview

**Beads** is a lightweight memory system for coding agents, using a graph-based issue tracker. It gives AI coding agents unprecedented long-term planning capability by solving their amnesia when dealing with complex nested plans. Four kinds of dependencies chain issues together like beads, making them easy for agents to follow for long distances and reliably perform complex task streams in the right order.

**Current Version:** v0.29.0 (December 2025)

**Repository:** https://github.com/steveyegge/beads

---

## What It Does

Beads provides AI coding agents with:

1. **Persistent Memory** - Issues survive across sessions and context compactions
2. **Dependency Tracking** - Graph-based relationships between issues (blocks, related, parent-child, discovered-from)
3. **Ready Work Detection** - Automatically surfaces issues with no open blockers
4. **Git-Native Storage** - No servers needed; syncs through normal git workflows
5. **Multi-Agent Coordination** - Multiple agents can work on the same project without conflicts
6. **Distributed Database** - Acts like a centralized database but is distributed via git

### The Problem It Solves

When AI agents work on complex, long-horizon tasks:
- Context windows get compacted, losing important details
- Agents "forget" what they were working on
- Dependencies between tasks aren't tracked
- No structured way to resume work across sessions
- Agents silently pass over problems due to lack of context space

Beads gives agents a structured "external memory" that persists regardless of context window limitations. Agents will automatically file issues for newly-discovered work as they go—no more lost work, ever.

---

## Key Features

### Dependency Management
Four dependency types for modeling complex relationships:

| Type | Description | Example |
|------|-------------|---------|
| `blocks` | Issue A blocks issue B (hard blocker) | Auth system blocks user dashboard |
| `related` | Issues are connected but independent | Login and logout features |
| `parent-child` | Hierarchical relationship | Epic → Tasks → Subtasks |
| `discovered-from` | Issue found while working on another | Bug found during feature work |

Only `blocks` dependencies affect ready work detection.

### Hash-Based IDs (v0.20.1+)
Collision-resistant hash IDs that scale and enable multi-worker workflows:
- 4 chars (0-500 issues): `bd-a1b2`
- 5 chars (500-1,500): `bd-f14c3`
- 6 chars (1,500+): `bd-3e7a5b`

Supports hierarchical children: `bd-a3f8e9.1`, `bd-a3f8e9.3.1`

### Time Estimates (v0.29.0+)
Add time estimates to issues for planning:
```bash
bd create "My task" --estimate 120  # 2 hours in minutes
bd update bd-xyz --estimate 60      # 1 hour
```

### Distributed Architecture
- **JSONL Storage** - Human-readable, git-friendly format
- **SQLite Cache** - Local cache for fast queries (<100ms)
- **No Server** - Everything syncs through git
- **Auto-Sync** - Changes flush to git automatically (5-second debounce)

---

## Installation

### Quick Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
```

### npm (Node.js)
```bash
npm install -g @beads/bd
```

### Homebrew (macOS)
```bash
brew tap steveyegge/beads && brew install bd
```

### Go Install (Fallback for Claude Code Web)
```bash
go install github.com/steveyegge/beads/cmd/bd@latest
export PATH="$PATH:$HOME/go/bin"
```

### Requirements
- Linux: glibc 2.32+ (Ubuntu 22.04+, Debian 11+, RHEL 9+)
- macOS: 10.15+
- Windows: PowerShell

---

## Setup

### Initialize a New Project
```bash
cd your-project
bd init

# For OSS contributors (fork workflow):
bd init --contributor

# For team members (branch workflow):
bd init --team

# For protected branches (GitHub/GitLab):
bd init --branch beads-metadata

# Silent mode for agents:
bd init --quiet

# Stealth mode (personal/isolated usage):
bd init --stealth
```

This creates:
```
.beads/
├── beads.jsonl      # Issue data (committed to git)
├── deletions.jsonl  # Deletion manifest
├── config.yaml      # Configuration
└── beads.db         # SQLite cache (gitignored)
```

### Bootstrap for AI Agents
Add this to your AGENTS.md:
```
BEFORE ANYTHING ELSE: run 'bd onboard' and follow the instructions
```

Your agent will then:
1. Run `bd onboard` and receive integration instructions
2. Add bd workflow documentation to AGENTS.md
3. Update CLAUDE.md with a note (if present)
4. Remove the bootstrap instruction

---

## How to Use

### Basic Commands

**Create Issues:**
```bash
bd create "Fix login bug" -t bug -p 0
bd create "Add dark mode" -t feature -p 1 --estimate 120
bd create "Refactor auth" -t task
bd create --from-template epic "Q4 Platform Improvements"
```

**View Issues:**
```bash
bd list                         # All issues
bd list --status open           # Open issues only
bd show bd-a1b2                 # Specific issue details
bd info                         # Database path and daemon status
```

**Update Issues:**
```bash
bd update bd-a1b2 --status in_progress
bd update bd-a1b2 --priority 0 --estimate 60
bd close bd-a1b2 --reason "Completed implementation"
bd close bd-a1b2 bd-f14c bd-3e7a  # Close multiple
```

### Dependency Commands

```bash
# Add dependency (bd-f14c depends on bd-a1b2)
bd dep add bd-f14c bd-a1b2 --type blocks

# Visualize dependencies
bd dep tree bd-f14c

# Detect cycles
bd dep cycles
```

### Finding Ready Work (Key Feature)

```bash
bd ready                    # Human-readable
bd ready --json             # For AI agents
bd ready --sort priority    # Strict priority order
bd ready --sort hybrid      # Recent by priority, old by age (default)
bd blocked                  # Show blocked issues
```

### Health Check & Doctor (v0.29.0+)

```bash
bd doctor                   # Full health check
bd doctor --output report.txt  # Export diagnostics
bd doctor --dry-run         # Preview fixes
bd doctor --fix             # Apply fixes with confirmation
```

Doctor now checks:
- SQLite integrity
- Configuration value validation
- Stale sync branch detection
- Database version and ID format

### Synchronization

```bash
bd sync                     # Manual sync with git
bd sync --squash            # Batch commits into one
```

Auto-sync happens automatically:
- After CRUD operations (5-second debounce)
- When JSONL is newer (e.g., after `git pull`)

### Compaction (Memory Decay)

Agent-driven compaction for graceful memory decay:

```bash
# Get candidates with full content
bd compact --analyze --json

# Apply summary (agent provides the summary)
bd compact --apply --id bd-42 --summary summary.txt

# Legacy AI-powered (requires ANTHROPIC_API_KEY)
bd compact --auto --all
```

---

## Agent Workflow

### Recommended Pattern for AI Agents

```bash
# 1. Start session - check what's ready
bd ready --json

# 2. Pick an issue and start work
bd update bd-a1b2 --status in_progress

# 3. Create new issues as discovered during work
bd create "Found bug in validation" -t bug
bd dep add bd-new bd-a1b2 --type discovered-from

# 4. Complete work
bd close bd-a1b2 --reason "Implemented feature X"

# 5. Sync before ending session
bd sync && git push
```

### JSON Output for Programmatic Access

All commands support `--json` flag:
```bash
bd list --json
bd ready --json
bd show bd-a1b2 --json
bd create "Fix bug" --json
```

### Read-Only Mode (v0.29.0+)

For worker sandboxes that should only read:
```bash
bd --readonly list
bd --readonly ready --json
```

---

## Configuration

### config.yaml Options
```yaml
# .beads/config.yaml
sync:
  auto_export: true      # Auto-flush to JSONL
  debounce_ms: 5000      # Debounce delay
  remote: upstream       # For contributor workflows

cache:
  max_age_hours: 24      # SQLite cache TTL

ids:
  min_length: 4          # Minimum hash length

import:
  orphan_handling: resurrect  # How to handle orphaned children
```

### Custom Status States (v0.27.0+)

Define project-specific statuses:
```yaml
statuses:
  - open
  - in_progress
  - testing
  - blocked
  - review
  - closed
```

---

## Advanced Features

### Protected Branch Support
For GitHub/GitLab protected branches:
```bash
bd init --branch beads-metadata
```
Commits issue updates to a separate branch.

### Git Worktree Support (v0.27.0+)
Full support for git worktrees:
```bash
bd hooks install  # Works correctly in worktrees
```

### Multi-Repo Hydration
Aggregate tasks from multiple repositories:
```yaml
# .beads/config.yaml
repos:
  primary: "."
  additional:
    - ~/projects/backend
    - ~/projects/shared-libs
```

### Daemon Management
```bash
bd daemons list           # List all running daemons
bd daemons health         # Check health
bd daemons logs <path>    # View logs
bd daemons killall        # Stop all daemons
```

---

## Best Practices

### 1. Use `bd ready` at Session Start
Always check ready work first—shows issues with no blockers.

### 2. Create Issues During Work
When you discover bugs or related tasks:
```bash
bd create "Found: missing null check" -t bug
bd dep add <new-id> <current-id> --type discovered-from
```

### 3. Update Status Promptly
Keep issue status current:
```bash
bd update bd-a1b2 --status in_progress  # When starting
bd close bd-a1b2 --reason "Done"        # When finished
```

### 4. Add Time Estimates
Help with planning:
```bash
bd create "Implement feature" -t feature --estimate 240  # 4 hours
```

### 5. Sync Before Session End
Always sync changes:
```bash
bd sync && git push
```

### 6. Use Doctor Regularly
Keep your database healthy:
```bash
bd doctor
```

---

## Integration with Agent Mail

Use Beads issue IDs as Agent Mail thread IDs:
```
Beads ID: bd-a1b2
├── Agent Mail thread_id: "bd-a1b2"
├── File reservation reason: "bd-a1b2"
├── Commit message: "[bd-a1b2] Implement feature"
└── PR title: "[bd-a1b2] Feature implementation"
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `bd: command not found` | Ensure install script completed; check `~/.local/bin` in PATH |
| SQLite errors | Run `bd doctor` then `bd migrate` |
| Sync conflicts | Pull latest, then `bd sync` |
| Fresh clone issues | Run `bd init` to import from JSONL |
| Daemon version mismatch | Run `bd daemons killall` after upgrading |

---

## What's New in v0.29.0

- **Time estimates**: `--estimate` flag for `bd create` and `bd update`
- **Enhanced doctor**: SQLite integrity check, config validation, stale sync branch detection
- **Doctor output**: `--output` flag to export diagnostics, `--dry-run` for previews
- **Read-only mode**: `--readonly` flag for worker sandboxes
- **Sync safety**: Auto-push after merge, deterministic conflict resolution
- **3-char hash fix**: Support for edge case hashes like "bd-abc"

---

## Related Tools

- **beads_viewer** - TUI for visualizing Beads issues with graphs and Kanban boards
- **mcp_agent_mail** - Multi-agent coordination layer (optional integration)

---

## Links

- **Repository**: https://github.com/steveyegge/beads
- **Documentation**: https://github.com/steveyegge/beads/tree/main/docs
- **Author**: Steve Yegge
- **License**: MIT

---

*Last updated: December 2025*
