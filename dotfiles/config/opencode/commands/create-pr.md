# /create-pr - Create Pull Request with Stack Awareness

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
2. **Always use `--json` flag** with `gh` commands for structured output (e.g., `gh pr create --json`, `gh pr view --json`, `gh pr list --json`)
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

### Error Cases

**If `st` not installed:**
- Inform user and continue with standard PR creation
- Use default base branch (main/master)

**If `gh` not installed:**
- Error: Cannot create PR without GitHub CLI
- Show installation instructions: `brew install gh`

**If not in git repository:**
- Error: Must be in a git repository
- Exit early

**If no remote configured:**
- Error: No GitHub remote found
- Show help: `git remote add origin <url>`

**If branch not pushed:**
- Attempt to push: `git push -u origin <branch>`
- If push fails: Error and exit

## Example Execution

### Example 1: Stack-aware PR creation

```bash
# User runs: /create-pr

# Step 1: Check st
$ which st
/usr/local/bin/st

# Step 2: Check stack status
$ st status --json
{
  "in_stack": true,
  "current_branch": "feature-auth-ui",
  "parent": "feature-auth",
  "children": ["feature-auth-ui-tests"],
  "worktree_path": null
}

# Base branch: feature-auth (from parent field)

# Step 3: Generate stack docs
$ st pr-doc --json
{
  "current": {"branch": "feature-auth-ui", "pr_number": null},
  "parent": {"branch": "feature-auth", "pr_number": "123"},
  "children": [{"branch": "feature-auth-ui-tests", "pr_number": null}]
}

# Step 4: Create PR with JSON output
$ gh pr create --base feature-auth --title "Add authentication UI" --body "..." --json url,number
{
  "url": "https://github.com/org/repo/pull/124",
  "number": 124
}

# Step 5: Update parent PR #123 with new child info
$ gh pr view 123 --json body --jq '.body'
[Parse and update stack section]

$ gh pr edit 123 --body "[updated with new child #124]"
```

### Example 2: Non-stack PR creation

```bash
# User runs: /create-pr

# Step 1: Check st
$ which st
/usr/local/bin/st

# Step 2: Check stack status
$ st status --json
{
  "in_stack": false,
  "current_branch": "fix-typo",
  "parent": null,
  "children": null,
  "worktree_path": null
}

# Not in stack - use default base branch

# Step 3: Get default branch
$ gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'
main

# Step 4: Create PR (no stack docs) with JSON output
$ gh pr create --base main --title "Fix typo in README" --body "..." --json url,number
{
  "url": "https://github.com/org/repo/pull/125",
  "number": 125
}
```

## Implementation Notes

### JSON Parsing with jq

Use `jq` for parsing JSON from `st` and `gh` commands:

```bash
# Parse st status
IN_STACK=$(st status --json | jq -r '.in_stack')
PARENT=$(st status --json | jq -r '.parent // empty')
CHILDREN=$(st status --json | jq -r '.children // []')

# Parse st pr-doc
PARENT_PR=$(st pr-doc --json | jq -r '.parent.pr_number // "N/A"')
CURRENT_BRANCH=$(st pr-doc --json | jq -r '.current.branch')

# Parse gh pr create output
PR_OUTPUT=$(gh pr create --base main --title "..." --body "..." --json url,number)
PR_NUMBER=$(echo "$PR_OUTPUT" | jq -r '.number')
PR_URL=$(echo "$PR_OUTPUT" | jq -r '.url')

# Parse gh pr list
EXISTING_PR=$(gh pr list --head feature-branch --json number --jq '.[0].number // empty')
```

### Updating PR Body with Stack Section

```bash
# Get current body
BODY=$(gh pr view $PR_NUM --json body --jq '.body')

# Check for markers
if echo "$BODY" | grep -q "<!-- st-stack-start -->"; then
  # Replace content between markers
  BEFORE=$(echo "$BODY" | sed -n '1,/<!-- st-stack-start -->/p' | sed '$d')
  AFTER=$(echo "$BODY" | sed -n '/<!-- st-stack-end -->/,$p' | tail -n +2)
  NEW_BODY="$BEFORE\n<!-- st-stack-start -->\n$STACK_SECTION\n<!-- st-stack-end -->\n$AFTER"
else
  # Append stack section
  NEW_BODY="$BODY\n\n$STACK_SECTION"
fi

# Update PR
gh pr edit $PR_NUM --body "$NEW_BODY"
```

### Stack Markdown Template

```markdown
---

## 📚 Stack Information

This PR is part of a stack of dependent changes:

### Stack Position
- **⬇️ Parent:** [`parent-branch`](https://github.com/org/repo/pull/123) - This PR builds on top of it
- **📍 Current:** `current-branch` (this PR)
- **⬆️ Children:** 
  - [`child-1`](https://github.com/org/repo/pull/125) - Builds on this PR
  - [`child-2`](https://github.com/org/repo/pull/126) - Builds on this PR

### Review Guidelines
1. 🔍 **Review this PR:** Can be reviewed independently - focus on changes in this branch only
2. ✅ **After approval:** This will be merged into parent branch (not main/master)
3. ⏳ **Parent review:** Parent PR is reviewed last, after all children are merged into it

### Stack Structure
<!-- st-stack-start -->
```
main
  └─ feature-auth (#123) ← Parent
      └─ feature-auth-ui (#124) ← This PR
          └─ feature-auth-ui-tests (#125) ← Child
```
<!-- st-stack-end -->

> 💡 **Stack managed by [`st`](https://github.com/user/st)** - This section auto-updates when the stack changes.
```

## Output Format

For successful PR creation:

```
✅ Pull Request Created Successfully

📝 PR Details:
   Number: #124
   Title: Add authentication UI
   URL: https://github.com/org/repo/pull/124
   Base: feature-auth ← parent branch from stack
   
📚 Stack Status: ENABLED
   Parent: feature-auth (#123)
   Current: feature-auth-ui (#124) ← this PR
   Children: 1 branch
   
🔄 Updated Related PRs:
   ✅ #123 (parent) - stack section updated
   
🎯 Next Steps:
   1. Request review for this PR
   2. After approval, merge into parent branch
   3. Once all sibling PRs are merged, parent PR can be reviewed and merged to main
   
📖 View PR: gh pr view 124 --web
```

For non-stack PR creation:

```
✅ Pull Request Created Successfully

📝 PR Details:
   Number: #125
   Title: Fix typo in README
   URL: https://github.com/org/repo/pull/125
   Base: main
   
📚 Stack Status: Not in a stack
   
📖 View PR: gh pr view 125 --web
```

## Advanced Features

### Automatic PR Description Generation

If user doesn't provide description, generate from commits:

```bash
# Get commits since base branch
COMMITS=$(git log $BASE_BRANCH..HEAD --pretty=format:"- %s")

# Generate description
DESCRIPTION="## Changes\n\n$COMMITS\n\n## Testing\n\n[Describe how to test these changes]"
```

### Stack Visualization ASCII Art

Generate visual tree representation:

```bash
st ls --json | jq -r '.branches | to_entries | map(.value | "  " * .level + "└─ " + .name) | .[]'
```

### PR Template Integration

If `.github/pull_request_template.md` exists, use it as base and append stack section.

## Dependencies

- **Required:**
  - `gh` (GitHub CLI): For creating and updating PRs
    - **CRITICAL:** Must support `--json` flag (gh version 2.0+)
    - Test: `gh version` should show 2.0.0 or higher
  - `git`: For repository operations
  - `jq`: For JSON parsing from `st` and `gh` commands
    - **CRITICAL:** All JSON parsing must use `jq`, not grep/sed/awk
    - Test: `jq --version` should be installed

- **Optional:**
  - `st`: For stack management (gracefully degrades without it)
    - **If available:** Must support `--json` flag (all commands)
    - Test: `st status --json` should output valid JSON

## Testing Checklist

Before considering this command complete:

- [ ] Test with `st` installed and branch in stack
- [ ] Test with `st` installed but branch NOT in stack
- [ ] Test without `st` installed (graceful degradation)
- [ ] Test updating multiple related PRs in stack
- [ ] Test when parent PR doesn't exist yet
- [ ] Test when child PRs already exist
- [ ] Test PR body update with existing markers
- [ ] Test PR body update without markers (first time)
- [ ] Test with worktree-based branches
- [ ] Test error handling (no remote, not pushed, etc.)
