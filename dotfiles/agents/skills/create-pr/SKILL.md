---
name: create-pr
description: Create GitHub pull requests with the GitHub CLI
compatibility: opencode
---

# Create Pull Request

Create a GitHub pull request using the `gh` CLI.

## Critical: JSON Output Mode

**ALWAYS use `--json` flags for predictable, parseable output:**

- ✅ `gh pr create --json url,number` - Not plain `gh pr create`
- ✅ `gh repo view --json defaultBranchRef` - Not plain `gh repo view`

**Why:** Human-readable output formats change; JSON output is stable and machine-parseable.

## Instructions

1. **Determine base branch:**
   - Get repository default branch:
     ```bash
     gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'
     ```
   - Use that as the default base branch unless the user explicitly asks for another base

2. **Prepare PR body:**
   - Get the user's PR description, or generate a concise one from the branch commits

3. **Create PR using gh CLI with JSON output:**
   ```bash
   gh pr create --base <base-branch> --title "<title>" --body "<body>" --json url,number
   ```
   - Use the base branch determined in step 1
   - Use `--json url,number` for structured output

4. **Capture PR number from JSON:**
   - Parse JSON output: `jq -r '.number'`
   - Store PR URL for final output

5. **Output summary:**
    ```
    ✅ Pull Request Created
    
    PR #<number>: <title>
    URL: https://github.com/<org>/<repo>/pull/<number>
    Base: <base-branch>
    ```

## Rules

### General Rules
1. **Always use `--json` flag** with `gh` commands for structured output
2. **Use `gh` CLI** for all GitHub operations (not git remote URLs)
3. **Handle missing tools gracefully**: If `gh` is not installed, inform the user
4. **PR title:**
   - If not provided: Generate from latest commit message
5. **Base branch selection:**
   - Use the repo default branch unless the user explicitly requests another base
   - Never ask the user when the default branch is sufficient

## Dependencies

- **Required:**
  - `gh` (GitHub CLI): For creating and updating PRs
     - **CRITICAL:** Must support `--json` flag (gh version 2.0+)
  - `git`: For repository operations
  - `jq`: For JSON parsing from `gh` commands
