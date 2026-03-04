---
name: move
description: Move a Jira ticket to a different status (In Progress, Done, etc.)
compatibility: opencode
---

# Move Jira Ticket

Transition a Jira ticket to a different status using available workflow transitions.

## Prerequisites

- Run `setup-jira` skill first to configure your Jira workspace
- Configuration file exists: `~/.config/jira/team.json`

## What This Command Does

1. Fetches available transitions for a given ticket
2. Allows user to select target status (or auto-detects common transitions)
3. Executes the transition to move ticket to new status
4. Confirms the status change

## Usage Patterns

- `skill("move", "HSP-123")` - Interactive: shows available transitions
- `skill("move", "HSP-123", "in progress")` - Direct: moves to "In Progress"
- `skill("move", "HSP-123", "done")` - Direct: moves to "Done"

## Instructions

### Phase 1: Load Configuration and Parse Input

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

3. **Parse input arguments:**
   - **Argument 1** (required): `ticketKey` - e.g., "HSP-123"
   - **Argument 2** (optional): `targetStatus` - e.g., "done", "in progress", "to do"
   - Validate ticket key format: `{PROJECT}-{NUMBER}`

### Phase 2: Fetch Current Ticket State

4. **Get ticket details:**
   ```
   Use: atlassian_getJiraIssue(
     cloudId,
     issueIdOrKey: ticketKey,
     fields: ["summary", "status", "issuetype"]
   )
   ```

5. **Display current state:**
   ```
   🎫 Ticket: {ticketKey}
   
   Summary: {summary}
   Type: {issueType}
   Current Status: {currentStatus}
   ```

### Phase 3: Get Available Transitions

6. **Fetch available transitions:**
   ```
   Use: atlassian_getTransitionsForJiraIssue(
     cloudId,
     issueIdOrKey: ticketKey
   )
   ```
   - Returns list of possible transitions with:
     - `id` - Transition ID (required for executing transition)
     - `name` - Transition name (e.g., "In Progress", "Done")
     - `to.name` - Target status name

7. **Parse transition options:**
   - Build map of: `status name → transition ID`
   - Common transitions to look for:
     - "To Do" / "Open"
     - "In Progress" / "In Development"
     - "In Review" / "Code Review"
     - "Done" / "Closed" / "Resolved"
     - "Blocked"

### Phase 4: Select Transition

#### 4A: If Target Status Provided (Direct Mode)

8. **Match target status to transition:**
   - Normalize input: `targetStatus.toLowerCase().trim()`
   - Match patterns:
     - "done", "close", "closed" → "Done" / "Closed" / "Resolved"
     - "progress", "in progress", "start" → "In Progress" / "In Development"
     - "review", "in review" → "In Review" / "Code Review"
     - "todo", "to do", "backlog" → "To Do" / "Open"
     - "blocked", "block" → "Blocked"
   
9. **Find matching transition:**
   - Look for transition where `to.name` matches target status
   - If multiple matches, prefer exact match
   - If no match found, show available options and ask user

#### 4B: If No Target Status (Interactive Mode)

10. **Present transition options:**
    ```
    🔀 Available Transitions:
    
    1. In Progress
    2. In Review
    3. Done
    4. Blocked
    
    Where do you want to move {ticketKey}? (1-4)
    ```
    - List all available transitions by number
    - Wait for user selection

### Phase 5: Execute Transition

11. **Transition the ticket:**
    ```
    Use: atlassian_transitionJiraIssue(
      cloudId,
      issueIdOrKey: ticketKey,
      transition: { id: selectedTransitionId }
    )
    ```

12. **Verify new status:**
    ```
    Use: atlassian_getJiraIssue(
      cloudId,
      issueIdOrKey: ticketKey,
      fields: ["status"]
    )
    ```

### Phase 6: Confirm Success

13. **Display result:**
    ```
    ✅ Ticket Moved Successfully
    
    {ticketKey}: {summary}
    
    {oldStatus} → {newStatus}
    
    🔗 View ticket: {workspaceUrl}/browse/{ticketKey}
    
    💡 Quick Actions:
    - Update ticket: skill("jira", "{ticketKey}")
    - View today's tickets: skill("today")
    - Attach to PR: skill("attach-ticket")
    ```

## Error Handling

### Configuration Not Found

```
❌ Error: Jira not configured

Please run the setup-jira skill first:
skill("setup-jira")
```

### Ticket Not Found

```
❌ Error: Cannot move ticket {ticketKey}

Ticket doesn't exist or you don't have permission to view it.

Context:
- Attempted operation: Moving ticket to "{targetStatus}"
- Project: {projectKey}

Possible reasons:
1. Ticket key is misspelled (format: PROJECT-NUMBER)
2. Ticket is in a different project
3. You don't have access to this ticket
4. Ticket was deleted

Next steps:
- Verify ticket in Jira: {workspaceUrl}/browse/{ticketKey}
- Check project key: Current project is {projectKey}
- View your tickets: skill("today")
```

### Authentication Failed

```
❌ Error: Cannot move ticket {ticketKey}

Authentication with Jira failed.

Context:
- Workspace: {workspaceUrl}
- Error code: 401 Unauthorized
- Attempted operation: Moving ticket to "{targetStatus}"

Fix:
- Re-authenticate: skill("setup-jira")
- Verify access in browser: {workspaceUrl}/browse/{ticketKey}
```

### No Valid Transition

```
❌ Error: Cannot transition to "{targetStatus}"

The transition "{targetStatus}" is not available from current status "{currentStatus}".

Available transitions:
1. In Progress
2. Blocked
3. Done

Tip: Use skill("move", "{ticketKey}") to see all available options.
```

### Transition Failed

```
❌ Error: Transition failed

Could not move {ticketKey} to "{targetStatus}".

Possible reasons:
1. Required fields not filled (some transitions need extra info)
2. Workflow restrictions
3. Permission denied

Try:
- Check ticket in Jira manually: {workspaceUrl}/browse/{ticketKey}
- Verify you have permission to transition tickets
- Ask your Jira admin about workflow rules
```

## Rules

1. **Validate ticket key format** - Must match `^[A-Z][A-Z0-9]*-\d+$`
2. **Case-insensitive matching** - "done", "Done", "DONE" all work
3. **Fuzzy matching** - "progress" matches "In Progress"
4. **Show current status** - User should see where ticket is before moving
5. **Verify after transition** - Always confirm status changed successfully
6. **Handle workflow restrictions** - Some transitions require fields or permissions
7. **Preserve ticket data** - Only change status, don't modify other fields
8. **Support common aliases** - "close" = "done", "start" = "in progress"
9. **Interactive fallback** - If no match, show options instead of failing
10. **Display full URLs** - Always include clickable Jira links
11. **Parse transition response carefully** - Structure is `transitions[].to.name`, ID must be string
12. **Handle async transitions** - Some transitions may be async, add retry if verification fails
13. **Detect required fields** - Check transition metadata for required fields, prompt or error clearly

## Common Status Aliases

### "Done" / "Close"
- Matches: "Done", "Closed", "Resolved", "Complete", "Completed"
- User input: "done", "close", "closed", "finish", "finished"

### "In Progress" / "Start"
- Matches: "In Progress", "In Development", "Started", "Working"
- User input: "progress", "in progress", "start", "started", "working"

### "To Do" / "Open"
- Matches: "To Do", "Open", "Backlog", "Ready"
- User input: "todo", "to do", "open", "backlog"

### "In Review"
- Matches: "In Review", "Code Review", "Review", "Testing"
- User input: "review", "in review", "testing"

### "Blocked"
- Matches: "Blocked", "On Hold", "Waiting"
- User input: "blocked", "block", "hold", "waiting"

## Examples

### Example 1: Direct Transition to Done

```
User: skill("move", "HSP-456", "done")

Output:
🎫 Ticket: HSP-456

Summary: Implement OAuth2 token refresh
Type: Story
Current Status: In Progress

🔄 Transitioning to Done...

✅ Ticket Moved Successfully

HSP-456: Implement OAuth2 token refresh

In Progress → Done

🔗 View ticket: https://commbank.atlassian.net/browse/HSP-456

💡 Quick Actions:
- Update ticket: skill("jira", "HSP-456")
- View today's tickets: skill("today")
- Attach to PR: skill("attach-ticket")
```

### Example 2: Interactive Selection

```
User: skill("move", "HSP-456")

Output:
🎫 Ticket: HSP-456

Summary: Implement OAuth2 token refresh
Type: Story
Current Status: To Do

🔀 Available Transitions:

1. In Progress
2. Blocked
3. Done

Where do you want to move HSP-456? (1-3)

User: 1

🔄 Transitioning to In Progress...

✅ Ticket Moved Successfully

HSP-456: Implement OAuth2 token refresh

To Do → In Progress

🔗 View ticket: https://commbank.atlassian.net/browse/HSP-456
```

### Example 3: Invalid Transition

```
User: skill("move", "HSP-456", "archived")

Output:
🎫 Ticket: HSP-456

Summary: Implement OAuth2 token refresh
Type: Story
Current Status: In Progress

❌ Error: Cannot transition to "archived"

The transition "archived" is not available from current status "In Progress".

Available transitions:
1. In Review
2. Blocked
3. Done

Tip: Use skill("move", "HSP-456") to see all available options.
```

### Example 4: Fuzzy Match

```
User: skill("move", "HSP-456", "progress")

Output:
🎫 Ticket: HSP-456

Summary: Implement OAuth2 token refresh
Type: Story
Current Status: To Do

🔄 Transitioning to In Progress...

✅ Ticket Moved Successfully

HSP-456: Implement OAuth2 token refresh

To Do → In Progress

🔗 View ticket: https://commbank.atlassian.net/browse/HSP-456
```

## Workflow Integration

This command integrates well with other Jira skills:

```bash
# Start work on a ticket
skill("move", "HSP-456", "in progress")

# ... do the work ...

# Create PR and attach ticket
skill("attach-ticket")

# Move to review
skill("move", "HSP-456", "in review")

# After approval, mark done
skill("move", "HSP-456", "done")
```

## Advanced: Handling Required Fields

Some Jira workflows require additional fields during transitions (e.g., "Resolution" when marking Done).

If transition fails with required field error:

```
❌ Error: Transition requires additional fields

The transition to "Done" requires the following fields:
- Resolution (required)

This skill currently doesn't support transitions with required fields.

Please complete this transition manually:
{workspaceUrl}/browse/{ticketKey}

Or ask your Jira admin to remove required fields from this transition.
```

**Future Enhancement**: Could add support for common required fields like Resolution.
