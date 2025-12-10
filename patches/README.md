# Patches Directory

This directory contains patches for upstream bugs that break the kv toolkit.

## Current Patches

### `fix-cass-memory.sh`

**Status**: ACTIVE - Still needed as of 2025-12-09

**What it fixes**:
1. cass-memory search parsing (code expects `[...]`, CASS returns `{hits:[...]}`)
2. Nullable `created_at` field (some CASS hits have `null`, Zod only allowed `undefined`)

**Tracking Issues**:
- https://github.com/Dicklesworthstone/cass_memory_system/issues/2 (our report)
- https://github.com/Dicklesworthstone/coding_agent_session_search/issues/7 (CASS bug)

**When to remove**: Delete this script when issue #2 above is CLOSED.

**How to check if still needed**:
```bash
# Fresh clone without patches:
git clone https://github.com/Dicklesworthstone/cass_memory_system.git /tmp/cm-test
cd /tmp/cm-test && bun install && bun run build
/tmp/cm-test/dist/cass-memory context "test" --json | jq '.historySnippets | length'

# If result > 0, upstream is fixed. If 0 or error, still need patches.
```

---

## Known Unfixable Issues

### CASS Timeline SQL Bug

**Status**: CANNOT PATCH - requires upstream Rust fix

**Symptom**: `cass timeline` returns SQL error `no such column: c.agent`

**Impact**: `cm reflect` is broken (depends on timeline)

**Tracking**: https://github.com/Dicklesworthstone/coding_agent_session_search/issues/7

**Workaround**: None. Use `cm context` instead of `cm reflect` until fixed.

---

## Patch Lifecycle

1. Bug found → Create fix script with clear header docs
2. Report upstream → Link GitHub issue in script header
3. Check periodically → When issue closed, test fresh install
4. If works → Delete patch script, update this README
5. Update kv → The installer auto-skips missing patch scripts
