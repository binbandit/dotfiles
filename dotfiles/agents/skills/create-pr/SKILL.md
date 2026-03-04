---
name: create-pr
description: Create GitHub pull requests with automatic stack detection and management using st tool
compatibility: opencode
---

# Create Pull Request with Stack Awareness

Create a GitHub pull request with automatic stack detection and management using the `st` tool.

## Critical: JSON Output Mode

**ALWAYS use `--json` flags for predictable, parseable output:**

- ✅ `st status --json` - Not `st status`
- ✅ `st ls --json` - Not `st ls`  
- ✅ `st pr-doc --json` - Not `st pr-doc`
- ✅ `gh pr create --json url,number` - Not plain `gh pr create`
- ✅ `gh pr view <num> --json body` - Not plain `gh pr view`
- ✅ `gh pr list --json number` - Not plain `gh pr list`
- ✅ `gh repo view --json defaultBranchRef` - Not plain `gh repo view`

**Why:** Human-readable output formats change; JSON output is stable and machine-parseable.

## Instructions

### Phase 1: Check for st Tool and Stack Status

1. **Check if `st` is installed:**
   ```bash
   which st || command -v st
   ```
   - If NOT installed: Continue with standard PR creation (skip to Phase 3)
   - If installed: Proceed to step 2

2. **Check if current branch is in a stack:**
   ```bash
   st status --json
   ```
   - Parse the JSON output to determine:
     - `in_stack` (boolean): If false, skip stack integration
     - `current_branch` (string): Current branch name
     - `parent` (string | null): Parent branch (this becomes base branch)
     - `children` (array | null): Child branches that depend on this
     - `worktree_path` (string | null): Worktree location if using workty

3. **Determine base branch:**
   - **If in stack** (`in_stack: true`): Use `parent` field as base branch
   - **If not in stack** or `parent` is null: Get repository default branch:
     ```bash
     gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'
     ```
   - Store base branch for PR creation

### Phase 2: Gather Stack Documentation (if in stack)

4. **Generate stack documentation:**
   ```bash
   st pr-doc --json
   ```
   - Parse JSON output:
     - `current.branch` (string): Current branch name
     - `current.pr_number` (string | null): PR number if exists
     - `parent.branch` (string): Parent branch
     - `parent.pr_number` (string | null): Parent's PR number
     - `children` (array): Array of `{branch, pr_number}` objects

5. **Build stack markdown section:**
   ```markdown
   ---
   
   ## 📚 Stack Information
   
   This PR is part of a stack:
   
   - **Parent:** [parent-branch](#pr-number) ← Depends on this
   - **Current:** current-branch (this PR)
   - **Children:** 
     - [child-branch-1](#pr-number) ← Depends on this PR
     - [child-branch-2](#pr-number) ← Depends on this PR
   
   **Stack Structure:**
   <!-- st-stack-start -->
   ```
   [Output from `st pr-doc` command - markdown format]
   ```
   <!-- st-stack-end -->
   
   > ⚠️ **Review Order:** Child PRs are reviewed and merged first into their parent branch. The parent PR is reviewed last after all children are merged.
   > 
   > 💡 **Stack Updates:** This section is automatically updated when the stack structure changes.
   ```

### Phase 3: Create Pull Request

6. **Prepare PR body:**
   - Get user's PR description (or generate from commits)
   - If in stack: Append stack markdown section from step 5
   - Format: `<user_description>\n\n<stack_section>`

7. **Create PR using gh CLI with JSON output:**
   ```bash
   gh pr create --base <base-branch> --title "<title>" --body "<body>" --json url,number
   ```
   - Use base branch determined in step 3
   - Include full body with stack info if applicable
   - Use `--json url,number` for structured output

8. **Capture PR number from JSON:**
   - Parse JSON output: `jq -r '.number'`
   - Store PR number for use in updating related PRs
   - Store PR URL for final output

### Phase 4: Update Related Stack PRs (if in stack)

9. **Get all related PRs in the stack:**
   ```bash
   st ls --json
   ```
   - Parse `branches` array
   - For each branch with `children` or `parent`:
     - Check if PR exists: `gh pr list --head <branch> --json number --jq '.[0].number'`
     - Store branch → PR number mapping

10. **For each related PR, update the stack section:**
    - Get current PR body: `gh pr view <pr-number> --json body --jq '.body'`
    - Check if body contains `<!-- st-stack-start -->` and `<!-- st-stack-end -->` markers
    - If markers exist:
      - Generate fresh stack doc: `st pr-doc --json` (from that branch's context)
      - Replace content between markers with updated stack info
      - Update PR: `gh pr edit <pr-number> --body "<updated-body>"`
    - If markers don't exist:
      - Append stack section to body
      - Update PR: `gh pr edit <pr-number> --body "<original-body>\n\n<stack-section>"`

### Phase 5: Report Results

11. **Output summary:**
    ```
    ✅ Pull Request Created
    
    PR #<number>: <title>
    URL: https://github.com/<org>/<repo>/pull/<number>
    Base: <base-branch>
    
    📚 Stack Status:
    - Parent: <parent> (#<pr-number>)
    - Children: <count> branches
      - <child-1> (#<pr-number>) - updated ✅
      - <child-2> (#<pr-number>) - updated ✅
    
    🔗 Review Order:
    1. Review and approve child PRs first (#<child-numbers>)
    2. Merge children into parent branch
    3. Review parent PR #<number> last (after all children merged)
    ```

## Rules

### General Rules
1. **Always use `--json` flag** with `st` commands for reliable parsing
2. **Always use `--json` flag** with `gh` commands for structured output
3. **Use `gh` CLI** for all GitHub operations (not git remote URLs)
4. **Handle missing tools gracefully**: If `st` or `gh` not installed, inform user
5. **Atomic operations**: Complete PR creation before updating related PRs
6. **Error handling**: If updating related PRs fails, still report successful PR creation

### Stack-Specific Rules
1. **Base branch selection:**
   - In stack: ALWAYS use parent branch from `st status --json`
   - Not in stack: Use repo default (main/master)
   - Never ask user - automate this decision

2. **Stack documentation format:**
   - Use HTML comment markers: `<!-- st-stack-start -->` and `<!-- st-stack-end -->`
   - Always include these markers for future updates
   - Place stack section at END of PR body

3. **Updating related PRs:**
   - Update EVERY PR in the stack that has the markers
   - Use `st pr-doc` to generate fresh content for each PR
   - Preserve all content outside the markers
   - If update fails, log warning but don't fail entire command

4. **PR title:**
   - If not provided: Generate from latest commit message
   - If in stack: Consider prefixing with stack position (optional)

## Dependencies

- **Required:**
  - `gh` (GitHub CLI): For creating and updating PRs
    - **CRITICAL:** Must support `--json` flag (gh version 2.0+)
  - `git`: For repository operations
  - `jq`: For JSON parsing from `st` and `gh` commands

- **Optional:**
  - `st`: For stack management (gracefully degrades without it)
