# Ultimate Bug Scanner (UBS) v5.0

## Overview

**Ultimate Bug Scanner** (UBS) is a comprehensive static analysis tool designed to detect **1000+ bug patterns** across multiple programming languages before code reaches production. It serves as an automated quality guardrail, particularly valuable for AI-assisted development workflows where code generation can introduce subtle bugs.

**Repository:** https://github.com/Dicklesworthstone/ultimate_bug_scanner

---

## What It Does

UBS scans codebases for common programming mistakes, security vulnerabilities, resource leaks, and anti-patterns. It's a **language-aware meta-runner** that auto-detects the languages in your repo and fans out to specialized per-language scanners, merging results into unified reports.

### Supported Languages
| Language | Common Issues Detected |
|----------|----------------------|
| **JavaScript/TypeScript** | Null crashes, XSS, missing await, NaN comparison, parseInt footguns |
| **Python** | Resource leaks, encoding issues, context manager misuse |
| **C/C++** | Buffer overflows, strcpy, memory leaks |
| **Rust** | `.unwrap()` panics, unsafe blocks |
| **Go** | Goroutine leaks, missing defer, context cancellation |
| **Java** | Unclosed resources, try-with-resources violations |
| **Ruby** | Common security and performance issues |

---

## Why It's Useful

### The Problem
AI coding agents generate code fast, but frequently introduce:
- Resource leaks (unclosed files, connections, timers)
- Security holes (XSS, injection, eval)
- Silent failures (missing await, unchecked errors)
- Type confusion (NaN comparisons, parseInt issues)

Each of these bugs can cost 3-6 hours to debug in production.

### The Solution
UBS catches these patterns automatically:
- **Pre-commit scanning** - Block commits with critical bugs
- **CI/CD integration** - SARIF output for GitHub Code Scanning
- **Regression tracking** - Compare against baselines
- **AI workflow hooks** - Auto-scan after Claude Code generates code

---

## Installation

### Quick Install (Recommended)
```bash
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/install.sh?$(date +%s)" | bash
```

### Easy Mode (Auto-accepts all prompts)
```bash
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/install.sh?$(date +%s)" | bash -s -- --easy-mode
```

This will:
- Install `ubs` command globally
- Optionally install `ast-grep` (advanced AST analysis)
- Optionally install `ripgrep` (10x faster scanning)
- Optionally install `jq` (JSON/SARIF merging)
- Optionally install `typos` (smart spellchecker)
- Optionally install Node.js + TypeScript (deep type narrowing)
- Auto-run `ubs doctor` and log session summary
- Set up git hooks (block commits with critical bugs)
- Set up Claude Code hooks (scan on file save)
- Add documentation to AGENTS.md

### Integrity-First Install
```bash
export UBS_MINISIGN_PUBKEY="RWQg+jMrKiloMT5L3URISMoRzCMc/pVcVRCTfuY+WIzttzIr4CUJYRUk"
curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/scripts/verify.sh | bash
```

### Docker
```bash
docker run --rm ghcr.io/dicklesworthstone/ubs-tools ubs --help
```

### Nix
```bash
nix run github:Dicklesworthstone/ultimate_bug_scanner
```

---

## How to Use

### Basic Scanning
```bash
# Scan current directory
ubs .

# Scan specific path
ubs /path/to/project

# Verbose output (show code examples)
ubs -v .

# Save report to file
ubs . bug-report.txt

# Quiet mode (summary only)
ubs -q .
```

### Git-Aware Scanning
```bash
# Scan only staged files (pre-commit)
ubs --staged

# Scan working tree changes vs HEAD
ubs --diff
```

### Strictness Profiles
```bash
# Strict: Fail on warnings, enforce high standards
ubs --profile=strict .

# Loose: Skip TODO/debug/code-quality nits (prototyping)
ubs --profile=loose .
```

### Output Formats
```bash
# Plain text (default)
ubs .

# JSON output (logs to stderr)
ubs . --format=json

# Line-delimited JSON (per-scanner summaries)
ubs . --format=jsonl

# SARIF (for GitHub Code Scanning)
ubs . --format=sarif

# Save JSONL for Beads integration
ubs . --format=jsonl --beads-jsonl out/findings.jsonl
```

---

## Advanced Features

### Category-Based Analysis

Focus scanners on specific concern areas:

```bash
# Focus on resource lifecycle issues
ubs --ci --only=python --category=resource-lifecycle .
```

**Resource Lifecycle Heuristics:**
- **Python**: Correlates `open()` calls against `with open(...)`, checks `encoding=` parameters, tracks context managers
- **Go**: Detects `context.With*` missing cancel, `time.NewTicker` without `Stop`, `os.Open` without `Close`, mutex symmetry
- **Java**: Surfaces `FileInputStream` outside try-with-resources, executor services never closed

### Comparison & Regression Detection

```bash
# 1. Capture a baseline
ubs --ci --report-json .ubs/baseline.json .

# 2. Re-run with comparison
ubs --ci --comparison .ubs/baseline.json \
    --report-json .ubs/latest.json \
    --html-report .ubs/latest.html .
```

The report includes:
- Delta block showing new vs resolved issues
- Git metadata (repo URL, commit, blob_base)
- GitHub permalinks when inside a git repo

### Shareable Reports

```bash
# JSON report with git metadata
ubs --ci --report-json report.json .

# HTML dashboard for PRs
ubs --ci --html-report report.html .
```

SARIF uploads include `versionControlProvenance` and `automationDetails` for CI grouping.

---

## Configuration

### Command-Line Flags

| Flag | Purpose |
|------|---------|
| `--fail-on-warning` | Exit 1 on any warnings (CI mode) |
| `--skip=N,N` | Skip specific check categories |
| `--include-ext=ext,ext` | Include custom file extensions |
| `--only=lang` | Restrict to specific language |
| `--category=name` | Focus on specific concern area |
| `--comparison=file` | Compare against baseline |
| `--report-json=file` | Write enriched JSON summary |
| `--html-report=file` | Generate HTML dashboard |

### Installer Flags

| Flag | Purpose |
|------|---------|
| `--easy-mode` | Auto-install all, accept all prompts |
| `--dry-run` | Preview without disk changes |
| `--self-test` | Run smoke tests after install |
| `--skip-type-narrowing` | Skip Node.js + TypeScript probes |
| `--skip-typos` | Skip Typos spellchecker |
| `--skip-doctor` | Skip automatic `ubs doctor` run |
| `--skip-hooks` | Skip git/Claude hooks setup |
| `--no-path-modify` | Don't modify shell RC files |
| `--uninstall` | Remove UBS and integrations |

### Suppressing False Positives

Add inline comments to suppress intentional findings:
```javascript
eval("print('safe')") // ubs:ignore
```

---

## Supply Chain Security

UBS takes security seriously:

1. **Pinned Checksums**: Every lazily-downloaded module has SHA-256 checksum baked into the meta-runner
2. **Verification on Fetch**: Files from GitHub are verified before execution
3. **Module Cache**: Stored under `${XDG_DATA_HOME:-$HOME/.local/share}/ubs/modules`
4. **Integrity Check**: Run `ubs doctor` to audit modules anytime
5. **Signed Releases**: Use `verify.sh` with minisign for integrity-first installs

---

## Health & Maintenance

### Doctor Command
```bash
# Full health check
ubs doctor

# Auto-fix missing/corrupted modules
ubs doctor --fix
```

Doctor checks:
- curl/wget availability
- Writable cache directories
- Per-language module integrity
- ripgrep/jq/typos/type-narrowing readiness

### Session History
```bash
# View most recent session log
ubs sessions --entries 1
```

### Uninstall
```bash
curl -fsSL "..." | bash -s -- --uninstall --non-interactive
```

Removes binary, shell RC snippets, config under `~/.config/ubs`, and optional hooks.

---

## CI/CD Integration

### GitHub Actions Example
```yaml
- name: Run UBS
  run: |
    ubs --ci --format=sarif > results.sarif

- name: Upload SARIF
  uses: github/codeql-action/upload-sarif@v2
  with:
    sarif_file: results.sarif
```

### Pre-commit Hook
```bash
# In .git/hooks/pre-commit
ubs --staged --fail-on-warning
```

### Claude Code Hook
The installer can automatically configure Claude Code to run UBS on file save.

---

## Agent Workflow Integration

### Combined with Beads

```bash
# 1. Pick ready work from Beads
bd ready --json

# 2. Make changes...

# 3. Scan before committing
ubs --staged --fail-on-warning

# 4. If clean, proceed with commit
bd close bd-a1b2 --reason "Completed, UBS clean"
```

### Beads JSONL Integration

```bash
# Save findings as Beads-compatible JSONL
ubs . --format=jsonl --beads-jsonl out/findings.jsonl
```

---

## Best Practices

### 1. Run in CI
```bash
ubs . --fail-on-warning --format=sarif
```
Add as a required check before merge.

### 2. Pre-Commit Hooks
```bash
ubs --staged
```
Block commits with critical bugs.

### 3. Baseline Comparisons
```bash
# Before major changes
ubs --report-json baseline.json .

# After changes
ubs --comparison baseline.json --html-report delta.html .
```
Track regressions over time.

### 4. Start Loose, Go Strict
Begin with `--profile=loose` on legacy codebases, gradually tighten to `--profile=strict`.

### 5. Regular Doctor Checks
```bash
ubs doctor
```
Ensure module integrity periodically.

### 6. Category Focus During Refactoring
```bash
ubs --category=resource-lifecycle .
```
Deep-dive specific concern areas.

---

## AGENTS.md/CLAUDE.md Snippet

Add this to your agent documentation:

```markdown
## Ultimate Bug Scanner (UBS)

UBS scans for 1000+ bug patterns across JavaScript, Python, Go, Rust, Java, C/C++, Ruby.

Usage:
- `ubs .` — Scan current directory
- `ubs --staged` — Scan staged files only (pre-commit)
- `ubs --format=json` — JSON output for automation
- `ubs doctor` — Check module integrity

Integration:
- Run `ubs --staged` before committing AI-generated code
- Use `--fail-on-warning` in CI pipelines
- Suppress intentional findings with `// ubs:ignore` comments
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `ubs: command not found` | Check PATH, re-run installer |
| Module checksum mismatch | Run `ubs doctor --fix` |
| Slow scanning | Install `ripgrep` for 10x speedup |
| Missing language support | Check if language module downloaded |
| False positives | Add `// ubs:ignore` comments |

---

## Links

- **Repository**: https://github.com/Dicklesworthstone/ultimate_bug_scanner
- **Release Process**: docs/release.md
- **Security Model**: docs/security.md
- **Author**: Jeffrey Emanuel (Dicklesworthstone)
- **License**: MIT

---

*Last updated: December 2025*
