---
name: st-pr
description: Create GitHub pull requests with automatic stack detection and management using st
compatibility: opencode
---

# Create Stacked Pull Request

Create a GitHub pull request with automatic stack detection and management using the `st` tool.

## Critical: JSON Output Mode

**ALWAYS use `--json` flags for predictable, parseable output:**

- `st status --json`
- `st ls --json`
- `st pr-doc --json`
- `gh pr create --json url,number`
- `gh pr view <num> --json body`
- `gh pr list --json number`
- `gh repo view --json defaultBranchRef`

**Why:** Human-readable output formats change; JSON output is stable and machine-parseable.

## Instructions

### Phase 1: Check Stack Status

1. **Check if `st` is installed:**
   ```bash
   which st || command -v st
   ```
   - If not installed, stop and tell the user to use the plain `create-pr` skill instead

2. **Check if the current branch is in a stack:**
   ```bash
   st status --json
   ```
   - Parse:
     - `in_stack`
     - `current_branch`
     - `parent`
     - `children`
     - `worktree_path`

3. **Determine base branch:**
   - If `in_stack` is true and `parent` is set, use `parent` as the base branch
   - Otherwise use the repository default branch:
     ```bash
     gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'
     ```

### Phase 2: Gather Stack Documentation

4. **Generate stack documentation:**
   ```bash
   st pr-doc --json
   ```
   - Parse:
     - `current.branch`
     - `current.pr_number`
     - `parent.branch`
     - `parent.pr_number`
     - `children`

5. **Build stack markdown section:**
   ```markdown
   ---

   ## Stack Information

   This PR is part of a stack:

   - **Parent:** [parent-branch](#pr-number)
   - **Current:** current-branch (this PR)
   - **Children:**
     - [child-branch-1](#pr-number)
     - [child-branch-2](#pr-number)

   **Stack Structure:**
   <!-- st-stack-start -->
   [Output derived from `st pr-doc`]
   <!-- st-stack-end -->
   ```

### Phase 3: Create Pull Request

6. **Prepare PR body:**
   - Get the user's PR description, or generate one from the branch commits
   - If in a stack, append the stack markdown section

7. **Create the PR:**
   ```bash
   gh pr create --base <base-branch> --title "<title>" --body "<body>" --json url,number
   ```

8. **Capture PR number and URL:**
   - Parse JSON output with `jq`

### Phase 4: Update Related Stack PRs

9. **Get all related PRs in the stack:**
   ```bash
   st ls --json
   ```
   - Parse the `branches` array
   - For each related branch, look up its PR number with `gh pr list --head <branch> --json number --jq '.[0].number'`

10. **Update related PR bodies:**
    - Read each current PR body with `gh pr view <pr-number> --json body --jq '.body'`
    - Replace or append the section between `<!-- st-stack-start -->` and `<!-- st-stack-end -->`
    - Save with `gh pr edit <pr-number> --body "<updated-body>"`

### Phase 5: Report Results

11. **Output summary:**
    ```
    Pull Request Created

    PR #<number>: <title>
    URL: https://github.com/<org>/<repo>/pull/<number>
    Base: <base-branch>

    Stack Status:
    - Parent: <parent> (#<pr-number>)
    - Children: <count> branches
    ```

## Rules

1. **Always use `--json`** with `st` and `gh` commands where supported
2. **Use `gh` CLI** for all GitHub operations
3. **Use the stack parent as base** when available
4. **Place stack info at the end** of the PR body
5. **Preserve non-stack content** when updating existing PR bodies
6. **If related PR updates fail, still report PR creation success**

## Dependencies

- **Required:**
  - `gh`
  - `git`
  - `jq`
  - `st`
