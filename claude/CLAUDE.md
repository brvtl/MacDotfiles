# Global Claude Code Guidelines

These guidelines apply to all projects unless overridden by project-specific CLAUDE.md files.

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

## Workflow Orchestration

### Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately – don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### Self-Improvement Loop
- At session start: read `.claude/lessons.md` if it exists
- After ANY correction from the user: update `.claude/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops

### Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes – don't over-engineer
- Challenge your own work before presenting it

### Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests – then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task Management

1. **Plan First**: Use plan mode or create tasks with built-in task tools
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark tasks complete as you go (TaskUpdate)
4. **Explain Changes**: High-level summary at each step
5. **Capture Lessons**: Update `.claude/lessons.md` after corrections

## Development Philosophy

### TDD Workflow (Mandatory)

Every implementation follows Red-Green-Refactor:

```
1. WRITE FAILING TEST FIRST (Red)
   - Define expected behavior before implementation
   - Run test, verify it fails for the right reason

2. IMPLEMENT MINIMAL CODE (Green)
   - Just enough to make the test pass
   - No extra features or "while I'm here" additions

3. REFACTOR (Keep Green)
   - Improve code quality
   - Run tests after each change

4. QUALITY GATE BEFORE COMMIT
   - Lint must pass
   - Tests must pass
   - Then commit with conventional message
```

**TDD Violations (never acceptable):**
- Writing implementation before tests
- Committing without running tests
- Skipping lint checks
- "I'll add tests later"

### Function Design

**Every function should do ONE thing well.** Readable, maintainable code over arbitrary line counts.

**Acceptable patterns:**
- Guard clause functions - Multiple early returns for validation are fine even if 25+ lines
- Orchestration functions - High-level coordination of well-factored helpers is fine
- Table-driven tests - Long test tables are acceptable

**Refactor when you see:**
- Mixed responsibilities in one function
- Deep nesting (3+ levels)
- Functions doing validation + transformation + persistence together

**Extract into helpers:**
- `extractX()` - Extract data from context/request
- `buildX()` - Construct objects
- `validateX()` - Validation logic
- `handleXError()` - Error handling

## Planning & Coordination

### DAG-Based Parallelization

When planning multi-task work, build a dependency graph. **Tasks start as soon as their dependencies complete - not waiting for unrelated tasks.**

```
Dependency Analysis:
1. No dependencies → Start immediately
2. Import/type dependency → Wait only for that specific task
3. File conflict → Serialize only those specific tasks

Example: Independent feature tracks run in PARALLEL
─────────────────────────────────────────────────────────────
Time:   t0   t1   t2   t3   t4   t5   t6   t7

TRACK A: User Feature
  model      ████░░░░░░░░░░░░░░░░░░░░░░░░░░
  repository ░░░░████░░░░░░░░░░░░░░░░░░░░░░  ← after model
  service    ░░░░░░░░████░░░░░░░░░░░░░░░░░░  ← after repo

TRACK B: Product Feature (INDEPENDENT - parallel with Track A!)
  model      ████░░░░░░░░░░░░░░░░░░░░░░░░░░
  service    ░░░░████░░░░░░░░░░░░░░░░░░░░░░  ← waits only for B's model

JOINS:
  handler    ░░░░░░░░░░░░████░░░░░░░░░░░░░░  ← after both services
─────────────────────────────────────────────────────────────
```

### Specialist Agents by Domain

Route tasks to appropriate specialists. Check available agents in:
- Global: `$CLAUDE_CONFIG_DIR/agents/` (usually `~/.config/claude/agents/`)
- Project: `.claude/agents/`

Each subagent should:
- Focus on one domain (models, services, API, database, tests, etc.)
- Follow project-specific patterns defined in project CLAUDE.md
- Complete work with TDD discipline before handing off

Use the most specific agent available (project over global). If no specialized agent exists, use general-purpose subagents.

### Quality Gates (Before PR)

Run these in parallel after all implementation tasks complete:

1. **Code Review** - Architecture, patterns, best practices
2. **Security Review** - Vulnerability scans, injection risks
3. **Test Review** - Coverage gaps, edge cases, test quality

If issues found → delegate fixes to appropriate specialist → re-run gates

### PR Creation & Iteration

When implementation and quality gates pass, create and iterate on the PR:

**1. Create PR**
```bash
# Push branch if needed
git push -u origin $(git branch --show-current)

# Create PR with structured description
gh pr create --title "[type](scope): description" --body "$(cat <<'EOF'
## Summary
- [What this PR does]
- [Why it's needed]

## Changes
- [List of changes]

## Testing
- [ ] Tests added/updated
- [ ] Manual testing done

## Checklist
- [ ] Follows project patterns
- [ ] No secrets committed
EOF
)"
```

**2. Monitor CI Checks**
```bash
# Watch checks (blocking)
gh pr checks --watch

# Or poll status
gh pr checks --json name,state,conclusion
```

**3. Handle Failures**

| Failure Type | Action |
|--------------|--------|
| Lint error | Route to specialist by file path |
| Test failure | Route to test specialist or domain owner |
| Build error | Analyze and route appropriately |
| Security scan | Route to security specialist |

**4. Handle PR Comments**

| Comment Type | Action |
|--------------|--------|
| Valid issue | Delegate fix to appropriate specialist |
| Question | Respond with clarification |
| Suggestion | Evaluate, delegate if valuable |
| Nitpick | Note, fix if trivial |

**5. Iterate Until Ready**
- All CI checks pass (green)
- All valid comments addressed
- No unresolved conversations
- Push fixes, repeat from step 2

**Parallel Fix Delegation:** When multiple independent issues exist, delegate to specialists in parallel (different files = no conflict).

## Commit Conventions

Use conventional commits:

```
type(scope): description

Types:
- feat: New feature
- fix: Bug fix
- test: Adding/updating tests
- refactor: Code change that neither fixes nor adds
- docs: Documentation only
- chore: Maintenance tasks
```

Co-author when Claude helps:
```
Co-Authored-By: Claude <noreply@anthropic.com>
```

## Code Quality Principles

### Error Handling
- Wrap errors with context (the "why" not just the "what")
- Distinguish error types: validation, not-found, internal
- Log errors with structured fields before returning

### Logging
- Use structured logging (key-value pairs, not string interpolation)
- Include relevant context: IDs, operation name, duration
- Appropriate levels: debug for flow, info for operations, error for failures

### Context Propagation
- Pass context through all layers for cancellation/timeouts
- Don't store request-scoped data in long-lived objects

## Anti-Patterns to Avoid

- **Mixed responsibilities** - Functions doing multiple unrelated things
- **Deep nesting** - Use guard clauses and early returns
- **Business logic in handlers** - Keep handlers thin, delegate to services
- **Database access in services** - Use repository pattern
- **Ignoring errors** - Always handle or propagate
- **String concatenation in queries** - Use parameterized queries
- **Hardcoded credentials** - Use environment variables
- **Committing secrets** - Use .gitignore, secret scanning

## Pre-Commit Checklist

Before every commit:
- [ ] Tests written first (TDD)
- [ ] Lint passes
- [ ] Tests pass
- [ ] Functions are focused and readable
- [ ] Errors wrapped with context
- [ ] No secrets in code
- [ ] Verified it actually works (not just "looks right")

## Post-Correction Checklist

After any user correction:
- [ ] Update `.claude/lessons.md` with the pattern
- [ ] Write a rule to prevent recurrence
- [ ] Apply the lesson to current work
