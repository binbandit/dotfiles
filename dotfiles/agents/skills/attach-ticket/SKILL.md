---
name: attach-ticket
description: Attach a Jira ticket to the current pull request by updating the PR body
compatibility: opencode
---

# Attach Jira Ticket to Pull Request

Update the current pull request's body to include a reference to the associated Jira ticket.

## Prerequisites

- Run `setup-jira` skill first to configure your Jira workspace
- Configuration file exists: `~/.config/jira/team.json`
- Current branch has an open pull request
- GitHub CLI (`gh`) installed and authenticated

## What This Command Does

1. Detects the current branch's pull request
2. Prompts for (or auto-detects) the Jira ticket to attach
3. Formats a Jira reference section
4. Updates the PR body to include the ticket link
5. Optionally updates the Jira ticket with the PR link

## Usage Patterns

- `skill("attach-ticket")` - Interactive: prompts for ticket key
- `skill("attach-ticket", "HSP-123")` - Direct: attaches specific ticket

## Instructions

### Phase 1: Load Configuration and Find PR

1. **Check if setup has been run:**
   ```bash
   test -f ~/.config/jira/team.json
   ```
   - If file doesn't exist: Display error and prompt to run `setup-jira` skill
   - If file exists: Continue to step 2

2. **Load configuration:**
   ```bash
   cat ~/.config/jira/team.json
   ```
   - Parse JSON to extract:
     - `cloudId` - Workspace identifier
     - `projectKey` - Your project key
     - `workspaceUrl` - Base URL for ticket links

3. **Get current branch:**
   ```bash
   git branch --show-current
   ```

4. **Find pull request for current branch:**
   ```bash
   gh pr view --json number,title,body,url
   ```
   - If no PR found:
     ```
     ❌ Error: No pull request found for current branch
     
     Current branch: {branchName}
     
     Create a PR first:
     - Use gh pr create
     - Or use skill("create-pr")
     ```
   - If PR found, extract:
     - `number` - PR number
     - `title` - PR title
     - `body` - Current PR body
     - `url` - PR URL

### Phase 2: Determine Jira Ticket

5. **Check if ticket key provided:**
   - If argument provided: Use that ticket key
   - If no argument: Try to auto-detect, then prompt

#### 5A: Auto-Detection Strategies

6. **Try detecting ticket from branch name:**
   - Pattern: `{project}-{number}` anywhere in branch name
   - Examples:
     - `feature/HSP-123-oauth` → HSP-123
     - `bugfix/HSP-456-fix-login` → HSP-456
     - `HSP-789` → HSP-789

7. **Try detecting ticket from PR title:**
   - Look for `{project}-{number}` pattern in title
   - Example: "HSP-123: Implement OAuth2" → HSP-123

8. **Try detecting ticket from PR body:**
   - Look for Jira ticket links or keys in current body
   - Pattern: `{workspaceUrl}/browse/{project}-{number}`

#### 5B: Prompt User if Not Found

9. **If no auto-detection successful:**
   ```
   🔍 Could not auto-detect Jira ticket
   
   PR #{prNumber}: {prTitle}
   
   Enter Jira ticket key (e.g., HSP-123):
   ```
   - Validate input format: `{PROJECT}-{NUMBER}`
   - If invalid, re-prompt

### Phase 3: Verify Ticket Exists

10. **Fetch ticket details from Jira:**
    ```
    Use: atlassian_getJiraIssue(
      cloudId,
      issueIdOrKey: ticketKey,
      fields: ["summary", "status", "issuetype", "priority"]
    )
    ```
    - If ticket not found:
      ```
      ❌ Error: Ticket {ticketKey} not found
      
      The ticket doesn't exist or you don't have permission to view it.
      
      Try:
      - Verify ticket key: {workspaceUrl}/browse/{ticketKey}
      - Check you're using the right project key
      ```

11. **Display ticket info:**
    ```
    ✅ Found Jira Ticket
    
    {ticketKey}: {summary}
    Status: {status}
    Type: {issueType}
    Priority: {priority}
    
    🔗 {workspaceUrl}/browse/{ticketKey}
    ```

### Phase 4: Update PR Body

12. **Check if ticket already attached:**
    - Look for existing Jira section markers:
      - `<!-- jira-ticket-start -->` and `<!-- jira-ticket-end -->`
    - Or look for ticket key in body
    - If already attached:
      ```
      ℹ️  Ticket already attached
      
      PR #{prNumber} already references {ticketKey}.
      
      Do you want to:
      1. Update ticket information
      2. Change to different ticket
      3. Cancel
      ```

13. **Build Jira reference section:**
    ```markdown
    <!-- jira-ticket-start -->
    ## 🎫 Jira Ticket
    
    **[{ticketKey}: {escaped_summary}]({workspaceUrl}/browse/{ticketKey})**
    
    - **Status:** {status}
    - **Type:** {issueType}
    - **Priority:** {priority}
    
    ---
    <!-- jira-ticket-end -->
    ```
    
    **Markdown Escaping**:
    - Escape special characters in `summary` before inserting:
      - Backticks: `` ` `` → `` \` ``
      - Asterisks: `*` → `\*`
      - Square brackets: `[`, `]` → `\[`, `\]`
      - Underscores: `_` → `\_`
    - Example: `Fix `auth` bug [URGENT]` → `Fix \`auth\` bug \[URGENT\]`
    - Prevents broken Markdown rendering in PR body

14. **Update PR body:**
    - If markers exist: Replace content between markers
    - If no markers: Prepend section to existing body
    - Format: `{jira-section}\n\n{existing-body}`

15. **Execute PR update:**
    ```bash
    # Use --body-file to avoid shell escaping issues with multiline content
    echo "$updatedBody" > /tmp/pr-body.txt
    gh pr edit {prNumber} --body-file /tmp/pr-body.txt
    rm /tmp/pr-body.txt
    ```
    
    **Note**: `--body-file` is safer than `--body` for multiline content with special characters

### Phase 5: Update Jira Ticket (Optional)

16. **Ask user if they want to link PR to Jira:**
    ```
    🔗 Link PR to Jira ticket?
    
    Add PR URL to {ticketKey}'s description? (y/n)
    ```

17. **If yes, update Jira ticket:**
    - Fetch current ticket description:
      ```
      Use: atlassian_getJiraIssue(cloudId, ticketKey, fields: ["description"])
      ```
    
    - Check if "Pull Requests" section already exists
    - If exists: Append new PR to existing list
    - If not: Create new "Pull Requests" section
    - Append PR link section:
      ```markdown
      {existing description}
      
      ---
      
      ## Pull Requests
      
      - [PR #{prNumber}: {escaped_prTitle}]({prUrl})
      ```
    
    - Escape special Markdown characters in `prTitle` (see step 13)
    
    - Update ticket:
      ```
      Use: atlassian_editJiraIssue(
        cloudId,
        ticketKey,
        fields: { description: {updatedDescription} }
      )
      ```
    
    - **Handle Partial Failure**:
      - If Jira update fails after PR update succeeded:
        ```
        ⚠️  Warning: PR updated but Jira update failed
        
        PR #{prNumber} now references {ticketKey}, but the reverse link couldn't be added.
        
        Error: {error message}
        
        You can manually add PR link to ticket:
        {workspaceUrl}/browse/{ticketKey}
        
        Or retry with: skill("attach-ticket", "{ticketKey}")
        ```
      - Don't fail the entire operation - partial success is acceptable
      - User can manually fix or retry

### Phase 6: Confirm Success

18. **Display final result:**
    ```
    ✅ Jira Ticket Attached Successfully
    
    PR #{prNumber}: {prTitle}
    🔗 {prUrl}
    
    Linked to:
    {ticketKey}: {summary}
    🔗 {workspaceUrl}/browse/{ticketKey}
    
    ✓ PR body updated with ticket reference
    ✓ Jira ticket updated with PR link
    
    💡 Quick Actions:
    - Move ticket status: skill("move", "{ticketKey}", "in review")
    - View ticket details: skill("jira", "{ticketKey}")
    - View today's tickets: skill("today")
    ```

## Error Handling

### No Pull Request Found

```
❌ Error: No pull request found

Current branch: {branchName}

No open pull request found for this branch.

Create a PR first:
- gh pr create
- skill("create-pr")
```

### Configuration Not Found

```
❌ Error: Jira not configured

Please run the setup-jira skill first:
skill("setup-jira")
```

### GitHub CLI Not Available

```
❌ Error: GitHub CLI not found

This skill requires the GitHub CLI (gh) to be installed.

Install:
- macOS: brew install gh
- Linux: See https://cli.github.com/
- Windows: See https://cli.github.com/

After installation, authenticate:
gh auth login
```

### Invalid Ticket Key Format

```
❌ Error: Invalid ticket key format

"{input}" is not a valid Jira ticket key.

Format: {PROJECT}-{NUMBER}
Examples: HSP-123, MOB-456, API-789

Try again with a valid ticket key.
```

### Ticket Not Found

```
❌ Error: Cannot attach ticket to PR #{prNumber}

Ticket {ticketKey} not found or you don't have permission to view it.

Context:
- Current branch: {branchName}
- Pull request: {prTitle}
- Attempted operation: Attaching Jira ticket to PR body

Possible reasons:
1. Ticket key is misspelled (format: PROJECT-NUMBER)
2. Ticket is in a different project (expected: {projectKey})
3. Ticket was deleted from Jira
4. You don't have access to this ticket

Next steps:
- Verify ticket exists: {workspaceUrl}/browse/{ticketKey}
- Check project key is correct
- Try a different ticket key: skill("attach-ticket", "CORRECT-KEY")
```

### Authentication Issues

```
❌ Error: Cannot attach ticket to PR #{prNumber}

Authentication with Jira failed (401 Unauthorized).

Context:
- Atlassian workspace: {workspaceUrl}
- Your account: {accountId}
- Attempted operation: Fetching ticket {ticketKey}

Possible reasons:
1. Atlassian API token expired
2. MCP server credentials need refresh
3. You were logged out of Atlassian

Next steps:
- Re-run setup to refresh credentials: skill("setup-jira")
- Check MCP server config in opencode.json
- Verify you can access Jira in browser: {workspaceUrl}
```

## Rules

1. **Always use HTML comment markers** - `<!-- jira-ticket-start -->` and `<!-- jira-ticket-end -->` for future updates
2. **Preserve existing content** - Don't overwrite PR body, only add/update Jira section
3. **Auto-detect when possible** - Try branch name, PR title, PR body before prompting
4. **Validate ticket exists** - Always verify ticket in Jira before attaching
5. **Bidirectional linking** - Offer to link PR in Jira ticket as well
6. **Prepend Jira section** - Place ticket reference at top of PR body for visibility
7. **Handle already attached** - Detect if ticket already referenced and offer options
8. **Use JSON output** - `gh pr view --json` for reliable parsing
9. **Show full context** - Display both PR and ticket details before updating
10. **Confirm both updates** - Show success for both PR and Jira updates
11. **Escape Markdown** - Escape special chars (`` ` `` `*` `[` `]` `_`) in summary/title
12. **Handle partial failures** - If PR updates but Jira fails, warn user clearly (don't fail entirely)
13. **Use --body-file** - Safer than --body for multiline content with special characters
14. **Validate ticket key format** - Must match `^[A-Z][A-Z0-9]*-\d+$`
15. **Check for multiple PRs** - Handle case where branch has multiple PRs (rare)

## Auto-Detection Patterns

### Branch Name Patterns (Priority Order)

1. `{PROJECT}-{NUMBER}` anywhere in name:
   - `feature/HSP-123-oauth` → HSP-123
   - `HSP-456/bugfix` → HSP-456
   - `refactor/api-HSP-789-cleanup` → HSP-789

2. Ticket at start:
   - `HSP-123-implement-auth` → HSP-123

3. Ticket in path:
   - `feat/auth/HSP-123` → HSP-123

### PR Title Patterns

1. Ticket at start with delimiter:
   - `HSP-123: Implement OAuth2` → HSP-123
   - `[HSP-123] Fix login bug` → HSP-123
   - `(HSP-123) Update docs` → HSP-123

2. Ticket anywhere in title:
   - `Implement OAuth2 (HSP-123)` → HSP-123

### PR Body Patterns

1. Existing Jira section markers
2. Jira URL: `{workspaceUrl}/browse/{PROJECT}-{NUMBER}`
3. Plain ticket reference: `{PROJECT}-{NUMBER}`

## Examples

### Example 1: Auto-Detection from Branch

```
User: skill("attach-ticket")

Output:
🔍 Detecting Jira ticket...

Current branch: feature/HSP-456-oauth-refresh
PR #123: Implement OAuth2 token refresh

✅ Found ticket from branch name: HSP-456

Fetching ticket details...

✅ Found Jira Ticket

HSP-456: Implement OAuth2 token refresh
Status: In Progress
Type: Story
Priority: High

🔗 https://commbank.atlassian.net/browse/HSP-456

Updating PR body...

✅ Jira Ticket Attached Successfully

PR #123: Implement OAuth2 token refresh
🔗 https://github.com/org/repo/pull/123

Linked to:
HSP-456: Implement OAuth2 token refresh
🔗 https://commbank.atlassian.net/browse/HSP-456

✓ PR body updated with ticket reference

🔗 Link PR to Jira ticket?

Add PR URL to HSP-456's description? (y/n)
```

### Example 2: Manual Ticket Entry

```
User: skill("attach-ticket")

Output:
🔍 Detecting Jira ticket...

Current branch: feature/oauth-improvements
PR #124: Add OAuth2 improvements

🔍 Could not auto-detect Jira ticket

PR #124: Add OAuth2 improvements

Enter Jira ticket key (e.g., HSP-123): HSP-500

Fetching ticket details...

✅ Found Jira Ticket

HSP-500: OAuth2 Performance Optimization
Status: To Do
Type: Task
Priority: Medium

🔗 https://commbank.atlassian.net/browse/HSP-500

Updating PR body...

✅ Jira Ticket Attached Successfully

PR #124: Add OAuth2 improvements
🔗 https://github.com/org/repo/pull/124

Linked to:
HSP-500: OAuth2 Performance Optimization
🔗 https://commbank.atlassian.net/browse/HSP-500

✓ PR body updated with ticket reference
✓ Jira ticket updated with PR link
```

### Example 3: Direct Ticket Specification

```
User: skill("attach-ticket", "HSP-789")

Output:
Current branch: feature/api-improvements
PR #125: API performance improvements

Fetching ticket details...

✅ Found Jira Ticket

HSP-789: API Rate Limiting
Status: In Progress
Type: Story
Priority: High

🔗 https://commbank.atlassian.net/browse/HSP-789

Updating PR body...

✅ Jira Ticket Attached Successfully

PR #125: API performance improvements
🔗 https://github.com/org/repo/pull/125

Linked to:
HSP-789: API Rate Limiting
🔗 https://commbank.atlassian.net/browse/HSP-789

✓ PR body updated with ticket reference
✓ Jira ticket updated with PR link
```

### Example 4: Already Attached

```
User: skill("attach-ticket")

Output:
🔍 Detecting Jira ticket...

Current branch: feature/HSP-456-oauth-refresh
PR #123: Implement OAuth2 token refresh

ℹ️  Ticket already attached

PR #123 already references HSP-456.

Do you want to:
1. Update ticket information
2. Change to different ticket
3. Cancel

Choice: 1

Updating ticket information...

✅ Jira Ticket Updated

PR #123: Implement OAuth2 token refresh
🔗 https://github.com/org/repo/pull/123

Linked to:
HSP-456: Implement OAuth2 token refresh
Status: In Review (updated from In Progress)
🔗 https://commbank.atlassian.net/browse/HSP-456

✓ PR body updated with latest ticket info
```

## Integration with Other Skills

This skill works well in typical development workflows:

```bash
# 1. Start work
skill("move", "HSP-456", "in progress")

# 2. Do the work, create commits

# 3. Create PR
skill("create-pr")

# 4. Attach ticket to PR
skill("attach-ticket", "HSP-456")

# 5. Move to review
skill("move", "HSP-456", "in review")

# 6. After approval, mark done
skill("move", "HSP-456", "done")
```

Or retroactive workflow:

```bash
# 1. Work already done, PR already exists

# 2. Create ticket for the work
skill("jira")  # Creates ticket based on PR

# 3. Attach ticket to existing PR
skill("attach-ticket", "HSP-999")

# 4. Mark ticket done
skill("move", "HSP-999", "done")
```
