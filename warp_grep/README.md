# Warp-Grep (Morph MCP Server)

## Overview

**Warp-Grep** is a parallel search tool bundled with the Morph MCP server that dramatically accelerates codebase exploration. Instead of running grep searches one at a time, Warp-Grep executes 8 parallel tool calls per turn—multiple greps, file reads, and glob searches happening simultaneously.

This is the same technology that powers Cognition's Devin ("SWE-grep") and Windsurf's "Fast Context" feature. It prevents "context pollution"—the phenomenon where irrelevant code degrades answer quality—by finding relevant code 5-8× faster without bloating the context window.

---

## What It Does

The Morph MCP server provides two tools:

| Tool | Purpose |
|------|---------|
| **Warp-Grep** | Parallel codebase search (8 concurrent searches) |
| **FastApply** | Merges code edits in under a second |

### The Problem It Solves

Traditional AI coding workflows suffer from:
- **Serial searches** - One grep at a time, slow exploration
- **Context pollution** - Too much irrelevant code in context degrades quality
- **Lost time** - Agents spend 60%+ of time just finding relevant files

Warp-Grep solves this by:
- Running 8 searches in parallel per turn
- Returning only relevant results
- Keeping context clean and focused

---

## Installation

### For Claude Code CLI (Global/User Level)

```bash
# Install globally (available in all sessions)
claude mcp add morph-fast-tools -s user \
  -e MORPH_API_KEY=your-api-key-here \
  -e ALL_TOOLS=true \
  -- npx -y @morphllm/morphmcp
```

### For Claude Code CLI (Project Level)

```bash
# Install for current project only
claude mcp add morph-fast-tools \
  -e MORPH_API_KEY=your-api-key-here \
  -e ALL_TOOLS=true \
  -- npx -y @morphllm/morphmcp
```

### For Claude Desktop

Add to your config file:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "morph-fast-tools": {
      "command": "npx",
      "args": ["@morphllm/morphmcp"],
      "env": {
        "MORPH_API_KEY": "your-api-key-here",
        "ALL_TOOLS": "true"
      }
    }
  }
}
```

### Get Your API Key

1. Go to https://morphllm.com/dashboard/api-keys
2. Create a free account if needed
3. Generate an API key
4. Use in the installation commands above

---

## How to Use

Once installed, Warp-Grep is automatically available to Claude. The tools appear in Claude's available MCP tools.

### Verify Installation

In Claude Code CLI:
```bash
/mcp
```
You should see `morph-fast-tools` listed with its tools.

Or ask Claude:
> "What MCP tools are available?"

### Usage Patterns

**Parallel Search (Automatic)**
When Claude needs to search your codebase, Warp-Grep automatically parallelizes:
- Multiple file pattern searches
- Multiple content greps
- Multiple file reads
- All happening in a single turn

**Example Prompt:**
> "Find all authentication-related files and show me how login is implemented"

Claude will simultaneously:
1. Glob for `**/auth*.{ts,js,py}`
2. Grep for `login`, `authenticate`, `session`
3. Read discovered files
4. Return focused results

---

## Agent Workflow Integration

### At Session Start

Warp-Grep works automatically once the MCP server is running. No special initialization needed.

### During Work

The tool is most effective for:
- **Codebase exploration** - "Where is X implemented?"
- **Pattern finding** - "Show me all API endpoints"
- **Dependency tracing** - "What imports this module?"
- **Multi-file refactoring** - "Find all usages of this function"

### Best Practice: Combine with Other Tools

```bash
# 1. Use Warp-Grep to find relevant code fast
# 2. Use Beads to track the work
bd create "Refactor auth system" -t task

# 3. Use Agent Mail to coordinate with other agents
file_reservation_paths(..., ["src/auth/**"], ...)

# 4. Use UBS to scan changes before committing
ubs --staged
```

---

## Configuration

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `MORPH_API_KEY` | Yes | Your Morph API key |
| `ALL_TOOLS` | No | Set to `"true"` to enable both Warp-Grep and FastApply |

### Enabling/Disabling

**In Claude Code CLI:**
```bash
# Disable temporarily
/mcp disable morph-fast-tools

# Re-enable
/mcp enable morph-fast-tools

# Remove entirely
claude mcp remove morph-fast-tools -s user
```

---

## Why It's Useful

### For AI Agents

- **5-8× faster exploration** - Parallel searches complete in one turn
- **Cleaner context** - Less irrelevant code polluting responses
- **Better answers** - More relevant code = higher quality output
- **Reduced token usage** - Focused results instead of full file dumps

### For Developers

- **Faster iteration** - Claude finds code faster, you get answers faster
- **Less waiting** - No more watching serial grep after grep
- **Better code understanding** - Agent sees the full picture quickly

### For Projects

- **Scales to large codebases** - Parallel search handles big repos
- **Works across languages** - Any text-based code
- **No configuration** - Works out of the box once installed

---

## Comparison: Search Tool Selection

When to use which search tool:

| Tool | Best For | Speed | Precision |
|------|----------|-------|-----------|
| **Warp-Grep** | Fast exploration, broad searches, multi-pattern | Fastest (parallel) | Good |
| **ripgrep** (`rg`) | Single precise searches, regex | Fast | Excellent |
| **ast-grep** | Structural code patterns, refactoring | Medium | Excellent |
| **Grep tool** | Simple text search | Fast | Good |
| **Glob tool** | File pattern matching | Fast | Excellent |

**Recommendation:**
- Start with Warp-Grep for exploration
- Use ripgrep for precise single searches
- Use ast-grep for structural refactoring

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| MCP server not appearing | Restart Claude Code session after installation |
| "Invalid API key" error | Verify key at morphllm.com/dashboard/api-keys |
| Tools not working | Check `/mcp` output; ensure server status is "running" |
| Slow performance | Check network connection to Morph API |

### Debug Steps

1. Check MCP status:
   ```bash
   /mcp
   ```

2. Verify environment variables:
   ```bash
   cat ~/.claude.json | grep -A5 morph-fast-tools
   ```

3. Test API key manually:
   ```bash
   curl -H "Authorization: Bearer YOUR_KEY" https://api.morphllm.com/health
   ```

---

## Integration with AGENTS.md

Add this section to your project's AGENTS.md:

```markdown
## Warp-Grep (Parallel Search)

This project has Warp-Grep enabled for fast codebase exploration.

**Usage:**
- Warp-Grep runs automatically when searching the codebase
- It parallelizes searches (8 concurrent) for 5-8× speedup
- No special commands needed - just ask Claude to find code

**When to use alternatives:**
- Use `rg` (ripgrep) for precise regex searches
- Use `ast-grep` for structural code patterns
- Use Glob tool for file pattern matching only
```

---

## Links

- **Morph Dashboard**: https://morphllm.com/dashboard/api-keys
- **Morph Blog**: https://morphllm.com/blog/claude-code-mcp-servers
- **npm Package**: https://www.npmjs.com/package/@morphllm/morphmcp

---

## Related Tools

- **Beads** - Task tracking and persistent memory
- **CASS** - Search past coding sessions
- **UBS** - Bug scanning for AI-generated code
- **MCP Agent Mail** - Multi-agent coordination

---

*Last updated: December 2025*
