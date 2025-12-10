# Decomposition Guide

**How to break large tasks into atomic beads using frontier reasoning models.**

---

## The Problem

You have a big goal: "Build a payment system" or "Add real-time collaboration" or "Migrate to new architecture."

Dumping this into one bead creates:
- Unclear progress tracking
- No parallelization opportunities
- Overwhelming scope
- Merge conflicts when multiple agents work

---

## The Solution: Reasoning-First Decomposition

Use a frontier reasoning model (Claude, GPT-4, etc.) to think through the decomposition BEFORE creating beads. This ensures:
- Logical dependency ordering
- Appropriate granularity
- No missing pieces
- Parallelizable tracks

---

## Step 1: Describe the Goal

Give the reasoning model complete context:

```
I need to implement [GOAL].

Context:
- Project: [name, language, framework]
- Existing code: [relevant files/patterns]
- Constraints: [time, dependencies, compatibility]
- Users: [who will use this, how]

Please create a detailed implementation plan with:
1. All required components
2. Dependencies between them
3. Estimated complexity for each
4. Suggested implementation order
```

---

## Step 2: Get the Detailed Plan

The model should return something like:

```
## Implementation Plan: User Authentication

### Phase 0: Foundation (must complete first)
1. Database schema for users table
   - Complexity: Low (~30 min)
   - Dependencies: None

2. Password hashing utility
   - Complexity: Low (~30 min)
   - Dependencies: None

### Phase 1: Core Authentication
3. User registration endpoint
   - Complexity: Medium (~90 min)
   - Dependencies: [1, 2]

4. User login endpoint
   - Complexity: Medium (~90 min)
   - Dependencies: [1, 2]

5. JWT token generation
   - Complexity: Medium (~60 min)
   - Dependencies: [4]

### Phase 2: Middleware & Protection
6. Auth middleware
   - Complexity: Medium (~60 min)
   - Dependencies: [5]

7. Protected route examples
   - Complexity: Low (~30 min)
   - Dependencies: [6]

### Phase 3: Session Management
8. Refresh token support
   - Complexity: High (~120 min)
   - Dependencies: [5]

9. Logout & session invalidation
   - Complexity: Medium (~60 min)
   - Dependencies: [8]

### Phase 4: Security Hardening
10. Rate limiting
    - Complexity: Medium (~60 min)
    - Dependencies: [6]

11. Brute force protection
    - Complexity: Medium (~60 min)
    - Dependencies: [10]

### Parallel Execution Opportunities:
- [1] and [2] can run in parallel
- [3] and [4] can run in parallel after [1,2]
- [10] and [11] can run after [6], parallel to [8,9]
```

---

## Step 3: Validate the Plan

Before creating beads, check:

### Size Check
- Is each item ~500 lines or less?
- Can it be completed in 30-120 minutes?
- If not, decompose further

### Atomicity Check
- Can each item be tested independently?
- Does it have a clear "done" state?
- Is the scope unambiguous?

### Dependency Check
- Are all blockers identified?
- Is the critical path clear?
- Are there parallelization opportunities?

### Completeness Check
- Are there any gaps?
- What about error handling?
- What about tests?
- What about documentation?

---

## Step 4: Create Beads from Plan

### Create the Epic

```bash
bd create "Epic: User Authentication" -t epic -p 1
```

### Create Phase 0 Tasks

```bash
bd create "Set up users table schema" -t task -p 0 --estimate 30
bd create "Add bcrypt password hashing utility" -t task -p 0 --estimate 30
```

### Create Phase 1 Tasks with Dependencies

```bash
bd create "Implement POST /auth/register endpoint" -t feature -p 1 --estimate 90
bd create "Implement POST /auth/login endpoint" -t feature -p 1 --estimate 90
bd create "Add JWT token generation service" -t task -p 1 --estimate 60

# Set up dependencies
bd dep add <register-id> <schema-id> --type blocks
bd dep add <register-id> <hashing-id> --type blocks
bd dep add <login-id> <schema-id> --type blocks
bd dep add <login-id> <hashing-id> --type blocks
bd dep add <jwt-id> <login-id> --type blocks
```

### Continue for All Phases

```bash
# Phase 2
bd create "Create auth middleware" -t task -p 1 --estimate 60
bd create "Add protected route examples" -t task -p 2 --estimate 30
bd dep add <middleware-id> <jwt-id> --type blocks
bd dep add <protected-id> <middleware-id> --type blocks

# Phase 3
bd create "Implement refresh token rotation" -t feature -p 2 --estimate 120
bd create "Add logout and session invalidation" -t task -p 2 --estimate 60
bd dep add <refresh-id> <jwt-id> --type blocks
bd dep add <logout-id> <refresh-id> --type blocks

# Phase 4
bd create "Add rate limiting to auth endpoints" -t task -p 2 --estimate 60
bd create "Implement brute force protection" -t task -p 2 --estimate 60
bd dep add <rate-id> <middleware-id> --type blocks
bd dep add <brute-id> <rate-id> --type blocks
```

### Link to Epic

```bash
bd dep add <schema-id> <epic-id> --type parent-child
bd dep add <hashing-id> <epic-id> --type parent-child
# ... for all tasks
```

---

## Step 5: Verify the Graph

```bash
# Check for cycles
bd dep cycles

# View the structure
bv --robot-insights

# See what's ready to start
bd ready --json

# View critical path
bv --robot-plan
```

---

## Step 6: Commit and Start

```bash
git add .beads/
git commit -m "Add authentication implementation plan

Epic with 11 atomic tasks across 4 phases:
- Phase 0: Foundation (2 tasks, parallelizable)
- Phase 1: Core auth (3 tasks)
- Phase 2: Middleware (2 tasks)
- Phase 3: Sessions (2 tasks)
- Phase 4: Security (2 tasks, parallelizable)"

# See what's ready
bd ready --json
```

---

## Decomposition Patterns

### Pattern 1: Vertical Slice

Break by user-facing feature:

```
Epic: Shopping Cart
├── Add item to cart (API + UI + tests)
├── Remove item from cart (API + UI + tests)
├── Update quantity (API + UI + tests)
└── Clear cart (API + UI + tests)
```

Each slice is independently shippable.

### Pattern 2: Horizontal Layer

Break by technical layer:

```
Epic: Shopping Cart
├── Phase 1: Database
│   ├── Cart schema
│   └── Cart item schema
├── Phase 2: API
│   ├── Cart endpoints
│   └── Cart validation
├── Phase 3: UI
│   ├── Cart component
│   └── Cart integration
└── Phase 4: Tests
    ├── API tests
    └── E2E tests
```

Good for shared foundations.

### Pattern 3: Risk-First

Break by uncertainty:

```
Epic: Third-Party Integration
├── Phase 0: Spikes (high uncertainty)
│   ├── Spike: Test API connectivity
│   └── Spike: Evaluate rate limits
├── Phase 1: Core (medium uncertainty)
│   ├── Implement auth flow
│   └── Basic data sync
└── Phase 2: Polish (low uncertainty)
    ├── Error handling
    └── Retry logic
```

Reduces risk early.

### Pattern 4: Frontend + Backend Split

For full-stack features:

```
Epic: User Profile
├── Backend
│   ├── Profile API endpoints
│   ├── Avatar upload handling
│   └── Profile validation
├── Frontend
│   ├── Profile page component
│   ├── Avatar upload UI
│   └── Form validation
└── Integration
    ├── Connect frontend to API
    └── E2E tests
```

Enables parallel agent work.

---

## Granularity Guidelines

### Too Large (decompose further)

```
bd create "Implement entire payment system" -t feature --estimate 2880
```

Signs it's too large:
- Estimate > 240 minutes
- Multiple unrelated concerns
- Would touch > 20 files
- Can't describe "done" simply

### Too Small (consider combining)

```
bd create "Add semicolon to line 42" -t chore --estimate 1
```

Signs it's too small:
- Estimate < 15 minutes
- Not independently meaningful
- Would never be worked alone
- Trivial scope

### Just Right

```
bd create "Implement password reset email sending" -t feature -p 1 --estimate 90
```

Signs it's right-sized:
- 30-120 minute estimate
- Single clear responsibility
- Testable in isolation
- ~500 lines of code

---

## Multi-Agent Decomposition

When multiple agents will work in parallel:

### Identify Parallel Tracks

```bash
bv --robot-plan
```

Returns execution tracks that can run simultaneously.

### Assign by Track

```
Agent 1 (GreenCastle): Backend track
- bd-abc: Database schema
- bd-def: API endpoints
- bd-ghi: Validation

Agent 2 (BlueLake): Frontend track
- bd-jkl: Components
- bd-mno: State management
- bd-pqr: Styling
```

### Reserve Files by Track

```python
# Agent 1
file_reservation_paths(paths=["src/api/**", "src/db/**"], reason="backend-track")

# Agent 2
file_reservation_paths(paths=["src/components/**", "src/pages/**"], reason="frontend-track")
```

### Coordinate at Boundaries

When tracks need to merge:

```python
send_message(
    to=["BlueLake"],
    subject="[bd-ghi] API contract ready",
    body_md="Endpoints are done. Schema: POST /api/items { name, price }",
    thread_id="bd-ghi"
)
```

---

## Common Mistakes

### 1. Skipping the Planning Phase

**Bad**: Jump straight to `bd create` without thinking through dependencies.

**Good**: Use reasoning model first, validate plan, then create beads.

### 2. Vague Titles

**Bad**: `bd create "Fix stuff" -t bug`

**Good**: `bd create "Fix null pointer in UserService.getProfile when user not found" -t bug`

### 3. Missing Dependencies

**Bad**: Create all beads without `bd dep add`.

**Good**: Every bead that requires another should have an explicit dependency.

### 4. Monolithic Estimates

**Bad**: `--estimate 480` (8 hours)

**Good**: Decompose into 4-8 smaller beads of 60-90 minutes each.

### 5. No Verification

**Bad**: Create beads and start working.

**Good**: Run `bd dep cycles` and `bv --robot-insights` before starting.

---

## Template: Decomposition Prompt

Copy this to use with any reasoning model:

```
I need to implement: [GOAL]

Project context:
- Language/Framework: [X]
- Existing patterns: [Y]
- Constraints: [Z]

Please create a detailed implementation plan with:

1. **Phases**: Group related work into sequential phases
2. **Tasks**: Break each phase into atomic tasks (~500 lines, 30-120 min each)
3. **Dependencies**: Which tasks block which others?
4. **Parallel opportunities**: Which tasks can run simultaneously?
5. **Estimates**: Complexity rating for each task
6. **Risks**: What could go wrong? Any spikes needed?

For each task, specify:
- Clear title (verb + noun + context)
- Type: bug, feature, task, epic, or chore
- Priority: 0 (critical) to 4 (backlog)
- Estimated minutes
- What it depends on
- What it unblocks

Format the output so I can easily create beads with `bd create` and `bd dep add`.
```

---

## Verification Checklist

Before starting work on decomposed beads:

- [ ] `bd dep cycles` returns empty (no circular dependencies)
- [ ] `bd ready --json` shows at least one task to start
- [ ] `bv --robot-insights` shows reasonable graph metrics
- [ ] Every bead has estimate <= 120 minutes
- [ ] Every bead has clear, actionable title
- [ ] Dependencies match logical implementation order
- [ ] Parallel tracks are identified for multi-agent work
- [ ] `.beads/` is committed to git
