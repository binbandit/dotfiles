---
name: today
description: Show Jira tickets assigned to you for today that you should focus on
compatibility: opencode
---

# Today's Jira Tickets

Display Jira tickets assigned to you that you should focus on today, filtered by your team's current sprint.

## Prerequisites

- Run `setup-jira` skill first to configure your Jira workspace
- Configuration files exist in `~/.config/jira/` (`team.json`)

## What This Command Does

1. Fetches tickets assigned to you in the current sprint
2. Filters by status (In Progress, To Do, In Review)
3. Displays tickets in priority order with key details
4. Shows ticket count and estimated workload

## Instructions

### Phase 1: Load Configuration

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
     - `accountId` - Your user account ID for filtering
     - `projectKey` - Your project key
     - `workspaceUrl` - Base URL for ticket links
   
   **Validation**:
   - Validate `projectKey` matches pattern: `^[A-Z][A-Z0-9]*$`
   - This prevents JQL injection if config file is corrupted or maliciously modified
   - If validation fails: Show error and prompt to re-run `setup-jira`

### Phase 2: Query Today's Tickets

3. **Build JQL query for current sprint tickets:**
   ```jql
   assignee = currentUser() 
   AND project = {projectKey} 
   AND sprint in openSprints() 
   AND status IN ("To Do", "In Progress", "In Review")
   ORDER BY priority DESC, updated DESC
   ```
   - `assignee = currentUser()` - Only your tickets
   - `sprint in openSprints()` - Current active sprint(s)
   - Status filters out "Done" and "Blocked" tickets
   - Orders by priority then recently updated

4. **Execute search:**
   ```
   Use: atlassian_searchJiraIssuesUsingJql(
     cloudId,
     jql: {query from step 3},
     fields: ["summary", "status", "priority", "issuetype", "parent", "updated", "timeestimate"],
     maxResults: 50
   )
   ```

### Phase 3: Format and Display Results

5. **Group tickets by status:**
   - Create three groups:
     - **In Progress** - Currently being worked on
     - **In Review** - Waiting for review/approval
     - **To Do** - Not started yet
   
6. **Display grouped tickets:**
   ```
   📅 Today's Focus - {date}
   
   👤 Assigned to: {userName} ({projectKey})
   
   🔄 In Progress ({count})
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   {issueKey} [{priority}] {summary}
   └─ Epic: {parent.summary if exists}
   └─ Updated: {relative time} ago
   └─ Link: {workspaceUrl}/browse/{issueKey}
   
   {repeat for all in progress tickets}
   
   
   👀 In Review ({count})
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   {issueKey} [{priority}] {summary}
   └─ Epic: {parent.summary if exists}
   └─ Updated: {relative time} ago
   └─ Link: {workspaceUrl}/browse/{issueKey}
   
   {repeat for all in review tickets}
   
   
   📋 To Do ({count})
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   {issueKey} [{priority}] {summary}
   └─ Epic: {parent.summary if exists}
   └─ Priority: {priority level}
   └─ Link: {workspaceUrl}/browse/{issueKey}
   
   {repeat for all to do tickets}
   
   
   📊 Summary
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Total tickets: {total count}
   In Progress: {in progress count}
   In Review: {in review count}
   To Do: {to do count}
   
   💡 Quick Actions:
   - Move ticket: skill("move", "{issueKey}")
   - Update ticket: skill("jira", "{issueKey}")
   - View all tickets: {workspaceUrl}/issues/?jql=assignee=currentUser()
   ```

7. **Handle empty results:**
   - If no tickets found:
     ```
     ✨ All Clear!
     
     No tickets assigned to you in the current sprint.
     
     Possible reasons:
     1. You've completed all your sprint tickets 🎉
     2. No active sprint running
     3. Tickets not assigned yet
     
     🔗 View board: {workspaceUrl}/jira/software/projects/{projectKey}/board
     ```

### Phase 4: Additional Context (Optional)

8. **Show blocked tickets separately (if any exist):**
   - Run additional query:
     ```jql
     assignee = currentUser() 
     AND project = {projectKey} 
     AND sprint in openSprints() 
     AND status = "Blocked"
     ```
   - If blocked tickets found, add section:
     ```
     🚫 Blocked ({count})
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     {issueKey} [{priority}] {summary}
     └─ Reason: {blocking reason from comments/description}
     └─ Link: {workspaceUrl}/browse/{issueKey}
     ```

## Error Handling

### Configuration Not Found

```
❌ Error: Jira not configured

Please run the setup-jira skill first:
skill("setup-jira")

This will configure your Jira workspace and project.
```

### No Sprint Active

```
ℹ️  No Active Sprint

Your project doesn't have an active sprint running.

Showing all open tickets assigned to you instead:

{list all tickets with status != Done}

🔗 Start a sprint: {workspaceUrl}/jira/software/projects/{projectKey}/board
```

### API Failure

```
❌ Error: Cannot fetch tickets

Failed to connect to Jira. Possible reasons:
1. Atlassian MCP server not configured
2. Network connectivity issues
3. Invalid credentials

Try:
- Check opencode.json has atlassian MCP configured
- Re-run setup-jira skill to refresh credentials
```

## Rules

1. **Always use currentUser() in JQL** - Don't hardcode account IDs in queries
2. **Filter by sprint** - Only show tickets in active sprint(s) for focus
3. **Exclude Done tickets** - Don't clutter output with completed work
4. **Group by status** - Makes it clear what needs attention
5. **Show relative timestamps** - "2 hours ago" is more useful than absolute time
6. **Include quick action hints** - Help user know what to do next
7. **Handle no sprint gracefully** - Fall back to showing all open tickets
8. **Priority matters** - Sort by priority to highlight most important work
9. **Show epic context** - Helps understand ticket's bigger picture
10. **Keep it scannable** - Use clear visual separators and hierarchy
11. **Validate projectKey** - Must match `^[A-Z][A-Z0-9]*$` to prevent JQL injection
12. **Handle API errors** - Distinguish 401 (auth), 404 (not found), 500 (API issue)
13. **Implement pagination** - Note maxResults=50 limit, warn if truncated

## JQL Query Variations

### Today's Focus (Default)
```jql
assignee = currentUser() 
AND project = {projectKey} 
AND sprint in openSprints() 
AND status IN ("To Do", "In Progress", "In Review")
ORDER BY priority DESC, updated DESC
```

### Include Blocked Tickets
```jql
assignee = currentUser() 
AND project = {projectKey} 
AND sprint in openSprints() 
AND status IN ("To Do", "In Progress", "In Review", "Blocked")
ORDER BY status ASC, priority DESC
```

### Fallback (No Active Sprint)
```jql
assignee = currentUser() 
AND project = {projectKey} 
AND status != Done
ORDER BY priority DESC, updated DESC
```

### This Week's Completed
```jql
assignee = currentUser() 
AND project = {projectKey} 
AND status = Done 
AND resolved >= -7d
ORDER BY resolved DESC
```

## Examples

### Example Output - Typical Day

```
📅 Today's Focus - Wed Mar 04 2026

👤 Assigned to: Brayden Moon (HSP)

🔄 In Progress (2)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HSP-456 [High] Implement OAuth2 token refresh
└─ Epic: Q1 2026 Authentication
└─ Updated: 30 minutes ago
└─ Link: https://commbank.atlassian.net/browse/HSP-456

HSP-478 [Medium] Add user profile API endpoint
└─ Epic: Q1 2026 API Improvements
└─ Updated: 2 hours ago
└─ Link: https://commbank.atlassian.net/browse/HSP-478


👀 In Review (1)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HSP-445 [High] Fix authentication race condition
└─ Epic: Q1 2026 Authentication
└─ Updated: 1 day ago
└─ Link: https://commbank.atlassian.net/browse/HSP-445


📋 To Do (3)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HSP-490 [High] Add rate limiting to API
└─ Epic: Q1 2026 API Improvements
└─ Priority: High
└─ Link: https://commbank.atlassian.net/browse/HSP-490

HSP-501 [Medium] Update API documentation
└─ Epic: Q1 2026 API Improvements
└─ Priority: Medium
└─ Link: https://commbank.atlassian.net/browse/HSP-501

HSP-512 [Low] Refactor user service tests
└─ No epic
└─ Priority: Low
└─ Link: https://commbank.atlassian.net/browse/HSP-512


📊 Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total tickets: 6
In Progress: 2
In Review: 1
To Do: 3

💡 Quick Actions:
- Move ticket: skill("move", "HSP-456")
- Update ticket: skill("jira", "HSP-456")
- View all tickets: https://commbank.atlassian.net/issues/?jql=assignee=currentUser()
```

### Example Output - All Clear

```
✨ All Clear!

No tickets assigned to you in the current sprint.

Possible reasons:
1. You've completed all your sprint tickets 🎉
2. No active sprint running
3. Tickets not assigned yet

🔗 View board: https://commbank.atlassian.net/jira/software/projects/HSP/board
```
