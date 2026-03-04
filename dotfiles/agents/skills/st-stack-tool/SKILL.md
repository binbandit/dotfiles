---
name: st-stack-tool
description: Manage stacked git branches with parent-child relationships. Use for dependent branches, stacked PRs, and branch navigation with optional worktree support.
license: MIT
compatibility: opencode
metadata:
  version: "1.0"
  author: "brayden.moon"
---

## What I Do

I help you use the `st` command-line tool for managing stacked git branches:

- Check if current branch is part of a stack (`st status`)
- Visualize stack structure as a tree (`st ls`)
- Create child branches that depend on current branch (`st new`)
- Navigate between parent and child branches (`st up`, `st down`)
- Rebase current branch and children onto parent (`st restack`)
- Remove branches while auto-restacking children (`st remove`)
- Generate PR documentation showing stack position (`st pr-doc`)

**ALL commands support `--json` flag for machine-readable output.**

## When to Use Me

Load this skill when:
- User asks about stacked branches or dependent branches
- User mentions "stacked PRs" or "branch stacking"
- User wants to create branches that build on each other
- User asks how to manage parent-child branch relationships
- User is using git workty and wants stack awareness
- User needs to parse `st` command output programmatically

## Core Concepts

### Branch Stacking
- **Parent-child relationships**: Each branch can have one parent and multiple children
- **Metadata storage**: Stack info stored in `~/.config/st/metadata.json`
- **Repository key**: Branches keyed by git remote URL (works across worktrees)
- **Navigation**: Move up/down the stack with simple commands

### Workty Integration (Optional)
- **Auto-detected**: Activates if `.git/workty.toml` exists
- **Worktree awareness**: Shows which worktree each branch is in
- **Safety checks**: Prevents rebasing branches checked out elsewhere
- **Optional worktree creation**: `--worktree` flag creates new worktrees

## Commands Reference

### `st status` - Check Stack Position

**Purpose:** Show if current branch is in a stack and display its position.

**Usage:**
```bash
st status          # Human-readable output
st status --json   # Machine-readable JSON
```

**JSON Output:**
```json
{
  "in_stack": true,
  "current_branch": "feature-auth",
  "parent": "main",
  "children": ["feature-ui", "feature-tests"],
  "worktree_path": "/path/to/worktree"
}
```

**JSON Fields:**
- `in_stack` (boolean): Whether branch is tracked in st
- `current_branch` (string): Current branch name
- `parent` (string | null): Parent branch, `null` if root
- `children` (array | null): Child branches, `null` if none
- `worktree_path` (string, optional): Path if using workty

**When to Use:**
- Check if operations like `st up` or `st down` are valid
- Determine base branch for PRs (use parent)
- Find dependent branches before making changes

---

### `st ls` - Visualize Stack Tree

**Purpose:** Display all branches in stack as tree structure.

**Usage:**
```bash
st ls          # Tree visualization
st ls --json   # Complete branch data
```

**JSON Output:**
```json
{
  "remote_url": "https://github.com/user/repo.git",
  "branches": [
    {
      "name": "main",
      "parent": null,
      "children": ["feature-auth"],
      "is_current": false,
      "worktree_path": null
    },
    {
      "name": "feature-auth",
      "parent": "main",
      "children": ["feature-ui"],
      "is_current": true,
      "worktree_path": "/path/to/worktree"
    }
  ]
}
```

**JSON Fields:**
- `remote_url` (string): Git remote URL
- `branches` (array): All branches in stack
  - `name` (string): Branch name
  - `parent` (string | null): Parent branch
  - `children` (array): Child branch names
  - `is_current` (boolean): Whether this is current branch
  - `worktree_path` (string | null): Worktree path if applicable

**When to Use:**
- Get complete stack structure for analysis
- Find all branches that depend on a given branch
- Visualize stack before complex operations

---

### `st new <branch-name>` - Create Child Branch

**Purpose:** Create a new branch that depends on current branch.

**Usage:**
```bash
st new feature-ui              # Create child in same workspace
st new feature-ui --worktree   # Create child in new worktree
st new feature-ui --json       # Get JSON confirmation
```

**JSON Output:**
```json
{
  "branch_name": "feature-ui",
  "parent": "feature-auth",
  "created_with_worktree": false,
  "worktree_path": null
}
```

**JSON Fields:**
- `branch_name` (string): Created branch name
- `parent` (string): Parent branch
- `created_with_worktree` (boolean): Whether worktree was created
- `worktree_path` (string, optional): Worktree path if created

**When to Use:**
- Creating features that build on other features
- Starting work that depends on unmerged changes
- Building a stack of related changes

---

### `st up` / `st down` - Navigate Stack

**Purpose:** Move between parent and child branches.

**Usage:**
```bash
st up          # Move to child branch
st down        # Move to parent branch
st up --json   # Get JSON confirmation
```

**JSON Output:**
```json
{
  "from_branch": "feature-auth",
  "to_branch": "feature-ui",
  "direction": "up"
}
```

**JSON Fields:**
- `from_branch` (string): Starting branch
- `to_branch` (string): Destination branch
- `direction` (string): "up" or "down"

**When to Use:**
- Reviewing dependent changes
- Switching between related features
- Moving through stack sequentially

**Notes:**
- `st up` errors if multiple children (use `st ls` to see options)
- `st down` errors if no parent (already at root)

---

### `st remove <branch-name>` - Delete Branch

**Purpose:** Remove branch from stack, auto-restacking children to parent.

**Usage:**
```bash
st remove feature-old          # Delete and restack
st remove feature-old --json   # Get JSON details
```

**JSON Output:**
```json
{
  "removed_branch": "feature-old",
  "parent": "main",
  "reparented_children": ["feature-new-1", "feature-new-2"],
  "switched_to_branch": "main"
}
```

**JSON Fields:**
- `removed_branch` (string): Deleted branch name
- `parent` (string, optional): Parent of removed branch
- `reparented_children` (array): Children moved to parent
- `switched_to_branch` (string, optional): Branch checked out after removal

**When to Use:**
- Cleaning up merged branches
- Removing intermediate branches from stack
- Note: Children automatically re-parented, not deleted

**Safety:**
- Blocks if branch checked out in worktree (with workty)
- Checks out parent if removing current branch

---

### `st restack` - Rebase Stack

**Purpose:** Rebase current branch onto parent, recursively rebasing children.

**Usage:**
```bash
st restack          # Rebase current + children
st restack --json   # Get rebase results
```

**JSON Output:**
```json
{
  "branch": "feature-auth",
  "parent": "main",
  "restacked_children": ["feature-ui", "feature-tests"],
  "skipped_children": [
    {
      "branch": "feature-old",
      "reason": "branch no longer exists"
    }
  ]
}
```

**JSON Fields:**
- `branch` (string): Rebased branch
- `parent` (string): Parent branch rebased onto
- `restacked_children` (array): Successfully rebased children
- `skipped_children` (array): Children skipped with reasons
  - `branch` (string): Skipped branch name
  - `reason` (string): Why it was skipped

**When to Use:**
- After parent branch is updated
- Keeping stack up-to-date with base branch
- After making changes to parent that children need

**Safety:**
- Requires clean working tree
- Aborts on conflicts (doesn't leave repo in bad state)
- Blocks if current or parent branch checked out in worktree
- Skips children checked out elsewhere

---

### `st pr-doc` - Generate PR Documentation

**Purpose:** Generate markdown showing stack position for PR bodies.

**Usage:**
```bash
st pr-doc          # Markdown output
st pr-doc --json   # Structured data
```

**JSON Output:**
```json
{
  "current": {
    "branch": "feature-auth-ui",
    "pr_number": "124"
  },
  "parent": {
    "branch": "feature-auth",
    "pr_number": "123"
  },
  "children": [
    {
      "branch": "feature-auth-ui-tests",
      "pr_number": "125"
    }
  ]
}
```

**JSON Fields:**
- `current` (object): Current branch info
  - `branch` (string): Branch name
  - `pr_number` (string, optional): PR number if exists
- `parent` (object, optional): Parent branch info
- `children` (array): Child branches

**When to Use:**
- Creating PR descriptions with stack context
- Documenting dependencies for reviewers
- Showing approval order for stacked PRs

**Requirements:**
- Needs `gh` CLI for PR number lookup
- Gracefully shows "(PR: ???)" if PR not found

## JSON Output Guidelines for AI

**ALWAYS use `--json` flag when programmatically using `st`:**

```bash
# ✅ Correct - parseable output
st status --json | jq -r '.parent'

# ❌ Wrong - fragile text parsing
st status | grep "Parent:"
```

**Why JSON?**
- Human output formats may change
- JSON is stable and machine-parseable
- Fields are typed and documented
- Optional fields handled consistently

**Common Patterns:**

```bash
# Check if in stack before operations
IN_STACK=$(st status --json | jq -r '.in_stack')
if [ "$IN_STACK" = "true" ]; then
  # Stack operations
fi

# Get parent for PR base branch
PARENT=$(st status --json | jq -r '.parent // "main"')

# Check if can navigate up
CHILDREN=$(st status --json | jq -r '.children | length')
if [ "$CHILDREN" -gt 0 ]; then
  st up
fi

# List all branches in stack
st ls --json | jq -r '.branches[].name'
```

## Workflows

### Creating a Stack

```bash
# Start from main
git checkout main

# Create feature stack
st new feature-auth
st new feature-auth-ui       # Child of feature-auth
st down                      # Back to feature-auth
st new feature-auth-tests    # Another child

# View stack
st ls
```

### Updating Stack After Parent Changes

```bash
# Main branch updated
git checkout main
git pull

# Update entire feature stack
git checkout feature-auth
st restack  # Rebases feature-auth and all children
```

### With Worktree Integration

```bash
# Create worktree-based stack
git workty new feature-auth
st new feature-ui --worktree
st new feature-tests --worktree

# View with worktree paths
st ls

# Safe operations - blocked if checked out elsewhere
cd ~/main-repo
git checkout feature-auth
st restack  # ERROR: Branch checked out in worktree!
```

### Creating PRs for Stack

```bash
# Create PRs for each branch
git checkout feature-auth
gh pr create --base main

git checkout feature-auth-ui
gh pr create --base feature-auth

# Add stack documentation to PR
st pr-doc >> pr-body.md
gh pr edit --body-file pr-body.md
```

## Troubleshooting

### "Detached HEAD detected"
**Problem:** Not on a branch
**Solution:** `git checkout <branch>` first

### "Remote 'origin' not found"
**Problem:** Repository has no remote
**Solution:** `git remote add origin <url>`

### "Branch 'X' is checked out in worktree"
**Problem:** Trying to rebase branch open elsewhere
**Solution:** Close that worktree or switch it to different branch

### "Multiple children found"
**Problem:** `st up` when current has multiple children
**Solution:** Use `st ls` to see options, then `git checkout <child>`

### "--worktree requires git workty"
**Problem:** Using --worktree without workty installed
**Solution:** Install git-workty from https://github.com/binbandit/workty

## Technical Details

### Metadata Storage
- **Location:** `~/.config/st/metadata.json`
- **Format:** JSON keyed by git remote URL
- **Atomicity:** Uses temp file + rename for safe writes
- **Worktree-safe:** Shared across worktrees (same remote URL)

### Performance
- **Context caching:** Loads git data once per command
- **Fast operations:** `st ls` ~71ms for typical repos
- **Minimal git calls:** No redundant subprocess calls

### Error Exit Codes
- **1:** User error (invalid input, bad arguments)
- **2:** Git error (command failed, not a repo)
- **3:** State error (branch not in metadata)
- **4:** System error (file I/O, permissions)

## Best Practices

1. **Start from stable base** - Create stacks from main/develop
2. **Keep stacks shallow** - 3-4 levels deep maximum
3. **Restack frequently** - Keep children updated with parent changes
4. **Use descriptive names** - Branch names should indicate purpose
5. **Clean up merged** - Use `st remove` after merge
6. **Document in PRs** - Use `st pr-doc` for stack context

## Integration Notes

### With GitHub CLI (`gh`)
- `st pr-doc` uses `gh pr list` for PR numbers
- Gracefully shows "(PR: ???)" if `gh` not available
- Combine with `gh pr create`, `gh pr edit`

### With git workty
- Auto-detects `.git/workty.toml`
- Shows worktree paths in output
- Blocks operations on branches checked out elsewhere
- `st new --worktree` creates via workty

### With OpenCode `/create-pr` command
- Uses `st status --json` for stack detection
- Uses `st pr-doc --json` for PR body documentation
- Updates all related PRs when stack structure changes
