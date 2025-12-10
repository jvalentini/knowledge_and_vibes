#!/usr/bin/env bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                     CASS-MEMORY UPSTREAM BUG FIXES                           ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║                                                                              ║
# ║  This script patches TWO bugs in cass-memory that break real-world usage.   ║
# ║                                                                              ║
# ║  WHEN TO REMOVE THIS SCRIPT:                                                 ║
# ║  ---------------------------                                                 ║
# ║  Remove when BOTH of these GitHub issues are marked CLOSED:                  ║
# ║                                                                              ║
# ║  1. https://github.com/Dicklesworthstone/cass_memory_system/issues/2         ║
# ║     (Search parsing + nullable created_at)                                   ║
# ║                                                                              ║
# ║  2. https://github.com/Dicklesworthstone/coding_agent_session_search/issues/7║
# ║     (CASS timeline SQL bug - affects cm reflect)                             ║
# ║                                                                              ║
# ║  HOW TO CHECK IF STILL NEEDED:                                               ║
# ║  -----------------------------                                               ║
# ║  Run: cm context "test" --json | jq '.historySnippets | length'              ║
# ║  If you get > 0, the fix is working or was merged upstream.                  ║
# ║                                                                              ║
# ║  WHAT THIS FIXES:                                                            ║
# ║  -----------------                                                           ║
# ║  Bug 1: CASS returns {count, hits:[...]} but code expected raw array [...]   ║
# ║  Bug 2: Some CASS hits have created_at: null, but Zod schema only allowed    ║
# ║         undefined (needed .nullable())                                       ║
# ║                                                                              ║
# ║  DATE CREATED: 2025-12-09                                                    ║
# ║  CREATED BY: Claude Code session with @Mburdo                                ║
# ║                                                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

set -e
CM_DIR="${1:-.}"

echo "Applying cass-memory fixes..."

# Fix 1: CASS returns {hits:[...]} wrapper, not raw array
CASS_TS="$CM_DIR/src/cass.ts"
if [ -f "$CASS_TS" ] && grep -q "const rawHits = parseCassOutput(stdout);" "$CASS_TS"; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/const rawHits = parseCassOutput(stdout);/const parsed = parseCassOutput(stdout); const rawHits = parsed?.hits || (Array.isArray(parsed) ? parsed : []);/' "$CASS_TS"
        sed -i '' 's/return Array.isArray(rawHits)/return rawHits.length > 0/' "$CASS_TS"
        sed -i '' 's/: \[CassHitSchema.parse(rawHits)\];/: [];/' "$CASS_TS"
    else
        sed -i 's/const rawHits = parseCassOutput(stdout);/const parsed = parseCassOutput(stdout); const rawHits = parsed?.hits || (Array.isArray(parsed) ? parsed : []);/' "$CASS_TS"
        sed -i 's/return Array.isArray(rawHits)/return rawHits.length > 0/' "$CASS_TS"
        sed -i 's/: \[CassHitSchema.parse(rawHits)\];/: [];/' "$CASS_TS"
    fi
    echo "  ✓ Fixed search result parsing (issue #2)"
else
    echo "  - Search parsing: already fixed or merged upstream"
fi

# Fix 2: Some CASS hits have created_at: null
TYPES_TS="$CM_DIR/src/types.ts"
if [ -f "$TYPES_TS" ] && grep -q 'created_at: z.union(\[z.string(), z.number()\]).optional(),' "$TYPES_TS"; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/created_at: z.union(\[z.string(), z.number()\]).optional(),/created_at: z.union([z.string(), z.number()]).nullable().optional(),/' "$TYPES_TS"
    else
        sed -i 's/created_at: z.union(\[z.string(), z.number()\]).optional(),/created_at: z.union([z.string(), z.number()]).nullable().optional(),/' "$TYPES_TS"
    fi
    echo "  ✓ Fixed nullable created_at (issue #2)"
else
    echo "  - Nullable created_at: already fixed or merged upstream"
fi

echo ""
echo "Note: 'cm reflect' still broken due to CASS timeline bug (issue #7)"
echo "      This requires upstream CASS fix - nothing we can patch here."
echo ""
echo "Done. Rebuild with: bun run build"
