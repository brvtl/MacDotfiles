# Catch Up Command

You need to understand the current state of this branch and what work has been done so far.

**Arguments**: `[issue_number]` (optional)

## Your Task

Analyze the current branch to provide yourself with full context about the work that's been done.

### Step 1: Gather Git Context

Run these commands in parallel to understand the branch state:
- `git branch --show-current` - Get current branch name
- `git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'` or check for main/master - Determine base branch
- `git status` - See current working tree state
- `git log --oneline $(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD origin/master 2>/dev/null || git merge-base HEAD main 2>/dev/null || git merge-base HEAD master)..HEAD` - Get commit history since divergence

### Step 2: Analyze the Changes

Get the full diff against the base branch to understand what's been modified:
```bash
git diff $(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD origin/master 2>/dev/null || git merge-base HEAD main 2>/dev/null || git merge-base HEAD master)...HEAD --stat
git diff $(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD origin/master 2>/dev/null || git merge-base HEAD main 2>/dev/null || git merge-base HEAD master)...HEAD
```

Read the key files that were modified to understand the implementation details.

### Step 3: GitHub Issue Context (if provided)

If an issue number was provided as an argument (e.g., `/catchup 123`), fetch the issue details:
```bash
gh issue view {issue_number}
```

This will help you understand the original requirements and discussion.

### Step 4: Provide Your Understanding

After gathering all context, provide a summary to the user that demonstrates your understanding:

1. **Branch Overview**: What branch we're on, how many commits ahead of base
2. **Purpose**: What this branch is trying to accomplish (based on commits and changes)
3. **Key Changes**: The main files modified and what changed in them
4. **Current State**: Is there uncommitted work? Are there failing tests? What's the status?
5. **Next Steps**: Based on the issue (if provided) and current state, what likely needs to happen next?

Be thorough in your analysis but concise in your summary. The goal is to demonstrate that you now fully understand the context and are ready to help with the next steps.
