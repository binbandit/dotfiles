---
name: jira
description: Create new Jira tickets under epics or update existing ticket descriptions and acceptance criteria
compatibility: opencode
---

# Jira Ticket Management

Create new Jira tickets under epics or update existing ticket descriptions and acceptance criteria.

## Prerequisites

- Run `setup-jira` skill first to configure your Jira workspace
- Configuration files exist in `~/.config/jira/` (`team.json` and `epics.json`)

## What This Command Does

1. **Create Mode**: Creates a new Jira ticket under a selected epic
   - For new feature work (proactive)
   - For retroactive ticketing of completed work (after PR is merged)
   
2. **Update Mode**: Updates an existing ticket's description and acceptance criteria
   - Refines ticket details based on user input or PR context
   - Keeps ticket synced with actual implementation

## Instructions

### Phase 0: Load Configuration

1. **Check if setup has been run:**
   ```bash
   test -f ~/.config/jira/team.json && test -f ~/.config/jira/epics.json
   ```
   - If files don't exist: Display error and prompt to run `setup-jira` skill
   - If files exist: Continue to step 2

2. **Load configuration:**
   ```bash
   cat ~/.config/jira/team.json
   cat ~/.config/jira/epics.json
   ```
   - Parse JSON to extract:
     - From `team.json`: `cloudId`, `projectKey`, `defaultIssueType`, `workspaceUrl`
     - From `epics.json`: Array of available epics with `key`, `summary`, `status`

### Phase 1: Determine Mode (Create vs Update)

3. **Ask user for intent:**
   - If user provides ticket key (e.g., "HSP-123"): Go to **Update Mode** (Phase 3)
   - If user wants to create a ticket: Go to **Create Mode** (Phase 2)
   - If unclear, ask: "Do you want to (1) Create a new ticket or (2) Update an existing ticket?"

### Phase 2: Create Mode

#### 2A: Gather Ticket Information

4. **Ask for ticket details:**
   - **Summary (title)**: Required - one-line description
     - Example: "Add user authentication to API"
   - **Description**: Required - detailed description (Markdown supported)
     - If user mentions "for this PR" or provides GitHub context:
       - Fetch current branch: `git branch --show-current`
       - Get PR info: `gh pr view --json title,body,url,number`
       - Use PR title as default summary
       - Use PR body as default description (but NOT acceptance criteria - see below)
       - Include PR URL in ticket description
   - **Acceptance Criteria**: Optional - separate from description
     - If user provides success criteria/acceptance criteria, store separately
     - Will be added as a field after ticket creation (see step 8)
   - **Issue Type**: Optional - defaults to `defaultIssueType` from config
     - Ask: "Issue type? (Story/Task/Bug) [default: {defaultIssueType}]"
   - **Assignee**: Always defaults to current user (from config's `accountId`)
     - Only prompt if user explicitly specifies a different assignee
     - If user wants different assignee: 
       ```
       Use: atlassian_lookupJiraAccountId(cloudId, searchString)
       ```
   - **Sprint**: Always assign to current sprint
     - Fetch active sprint:
       ```
       Use: atlassian_searchJiraIssuesUsingJql(
         cloudId,
         jql: "project = {projectKey} AND sprint in openSprints()",
         fields: ["sprint"]
       )
       ```
     - Extract sprint ID from any returned issue's sprint field
     - If no active sprint found, skip sprint assignment

5. **Select epic (if available):**
   - Load epics from `~/.config/jira/epics.json`
   - If epics exist, display:
     ```
     📚 Select an epic for this ticket:
     
     1. HSP-100: Q1 2026 Authentication (In Progress)
     2. HSP-200: Q1 2026 API Improvements (To Do)
     3. HSP-300: Q1 2026 UI Refresh (In Progress)
     4. [No epic]
     
     Which epic? (1-4)
     ```
   - If no epics in config, skip epic selection
   - If user selects "No epic", set parent to null

#### 2B: Create the Ticket

6. **Fetch epic issue ID if epic selected:**
   - If user selected an epic, need to get its issue ID (not just key)
   - Epics from `epics.json` only have `key`, but API needs numeric `id`
   - Fetch epic details:
     ```
     Use: atlassian_getJiraIssue(
       cloudId,
       issueIdOrKey: epicKey,
       fields: ["id"]
     )
     ```
   - Extract `id` field from response for next step
   - If epic fetch fails:
     - Epic may have been deleted
     - Remove from `epics.json` cache
     - Prompt user: "Epic {epicKey} no longer exists. Continue without epic? (y/n)"
     - If yes: proceed without parent
     - If no: re-show epic list or abort

7. **Create Jira issue:**
   ```
   Use: atlassian_createJiraIssue(
     cloudId,
     projectKey,
     issueTypeName,
     summary,
     description (Markdown - NO acceptance criteria here),
     assignee_account_id (from config's accountId - always assign to current user),
     additional_fields: {
       parent: { id: "10100" },  // If epic selected - use numeric ID from step 6
       sprint: sprintId  // If active sprint found in step 4
     }
   )
   ```
   
   **Important**: 
   - `parent.id` must be the numeric issue ID, not the issue key
   - `assignee_account_id` is passed as a string parameter, not in additional_fields
   - If epic not selected, omit `parent` field entirely (don't pass null)
   - If no active sprint found, omit `sprint` field
   - Description should NOT contain acceptance criteria (those go in step 8)

8. **Handle acceptance criteria:**
   - If user provided acceptance criteria in step 4:
     - ALWAYS use Jira's "Acceptance Criteria" field (NEVER put in description)
     - First, get the field metadata to find the acceptance criteria field ID:
       ```
       Use: atlassian_getJiraIssueTypeMetaWithFields(
         cloudId,
         projectIdOrKey,
         issueTypeId
       )
       ```
     - Search response for field with name "Acceptance Criteria" or similar (case-insensitive)
     - Extract the field key (e.g., "customfield_10100")
     - Update the ticket with acceptance criteria:
       ```
       Use: atlassian_editJiraIssue(
         cloudId,
         issueIdOrKey,
         fields: {
           "customfield_XXXXX": "- [ ] {criterion 1}\n- [ ] {criterion 2}\n- [ ] {criterion 3}"
         }
       )
       ```
     - Format as checklist items (one per line with `- [ ]` prefix)
     - **NEVER append acceptance criteria to description field**

#### 2C: Report Success and Ask About Status

9. **Display created ticket:**
   ```
   ✅ Jira Ticket Created
   
   {issueKey}: {summary}
   URL: {workspaceUrl}/browse/{issueKey}
   Epic: {epicKey} - {epicSummary}
   Assignee: {currentUserName} (you)
   Sprint: {sprintName} (current sprint)
   Type: {issueType}
   Status: Open
   
   📋 Description:
   {truncated description preview}
   
   {If acceptance criteria added:}
   ✅ Acceptance Criteria:
   - [ ] {criterion 1}
   - [ ] {criterion 2}
   ```

10. **Ask about status transition:**
    - Present user with question:
      ```
      Should I move this ticket to In Progress now, or do you want to set a different status?
      
      Options:
      1. Keep as "Open" (default)
      2. Move to "In Progress"
      3. Choose another status
      ```
    - If user selects option 2 or 3:
      - Fetch available transitions:
        ```
        Use: atlassian_getTransitionsForJiraIssue(cloudId, issueIdOrKey)
        ```
      - For option 2: Find "In Progress" transition and apply it
      - For option 3: Show list of available transitions and let user choose
      - Apply transition:
        ```
        Use: atlassian_transitionJiraIssue(
          cloudId,
          issueIdOrKey,
          transition: { id: transitionId }
        )
        ```
      - Confirm: "✅ Ticket moved to {newStatus}"
    
11. **Show next steps:**
    ```
    🎯 Next Steps:
    - Use skill("move", issueKey) to change ticket status later
    - Use skill("attach-ticket") to link this ticket to a PR
    ```

### Phase 3: Update Mode

#### 3A: Fetch Existing Ticket

12. **Get ticket details:**
    ```
    Use: atlassian_getJiraIssue(
      cloudId,
      issueIdOrKey,
      fields: ["summary", "description", "status", "issuetype", "assignee", "parent"]
    )
    ```
    
    **Error Handling**:
    - If API returns 401/403: Display authentication error (not "ticket not found")
    - If API returns 404: Ticket doesn't exist or no permission
    - If API returns 500: Jira service issue
    - Always validate response has expected structure before accessing fields

13. **Display current state:**
     ```
     📋 Current Ticket: {issueKey}
     
     Summary: {summary}
     Status: {status}
     Type: {issueType}
     Epic: {parent.key if exists}
     
     Description:
     {current description}
     
     What would you like to update?
     1. Description
     2. Acceptance Criteria
     3. Both
     ```

#### 3B: Update Description and/or Acceptance Criteria

14. **Gather updates:**
    - If user wants to update description:
      - Ask: "New description (Markdown supported):"
      - Or if updating "for this PR":
        - Get PR info: `gh pr view --json title,body,url`
        - Use PR body as new description
        - Include PR URL
     - If user wants to update/add acceptance criteria:
       - Ask: "Acceptance criteria (one per line, will be formatted as checkboxes):"
       - Will be added to Acceptance Criteria field (not description) - see step 15

15. **Update the ticket:**
     - Build new description:
       - If updating description only: Use new description (NO acceptance criteria in description)
       - If updating AC only: Use Acceptance Criteria field (see below)
       - If both: Update description field + Acceptance Criteria field separately
     
     - For description updates:
       ```
       Use: atlassian_editJiraIssue(
         cloudId,
         issueIdOrKey,
         fields: {
           description: {updated description}
         }
       )
       ```
     
     - For acceptance criteria updates:
       - ALWAYS use the "Acceptance Criteria" field (NEVER append to description)
       - Get field metadata to find the acceptance criteria field ID:
         ```
         Use: atlassian_getJiraIssueTypeMetaWithFields(cloudId, projectIdOrKey, issueTypeId)
         ```
       - Search for field with name "Acceptance Criteria" (case-insensitive)
       - Extract field key (e.g., "customfield_10100")
       - Update with formatted criteria:
         ```
         Use: atlassian_editJiraIssue(
           cloudId,
           issueIdOrKey,
           fields: {
             "customfield_XXXXX": "- [ ] {criterion 1}\n- [ ] {criterion 2}"
           }
         )
         ```
       - **NEVER append acceptance criteria to description field**

#### 3C: Report Success

16. **Display updated ticket:**
    ```
    ✅ Ticket Updated
    
    {issueKey}: {summary}
    URL: {workspaceUrl}/browse/{issueKey}
    
    📝 Changes:
    - Description: {updated / unchanged}
    - Acceptance Criteria: {added / updated / unchanged}
    
    🔗 View ticket: {workspaceUrl}/browse/{issueKey}
    ```

## Error Handling

### Configuration Not Found

```
❌ Error: Jira not configured

Please run the setup-jira skill first:
skill("setup-jira")

This will configure your Jira workspace, project, and epics.
```

### Ticket Not Found (Update Mode)

```
❌ Error: Ticket {issueKey} not found

Possible reasons:
1. Ticket doesn't exist in project {projectKey}
2. You don't have permission to view this ticket
3. Ticket key is misspelled

Try:
- Verify ticket key in Jira: {workspaceUrl}/browse/{issueKey}
- Check you're in the right project
```

### Epic Not Found (Create Mode)

```
⚠️  Warning: Epic {epicKey} not found

Epics may be outdated. Run skill("refresh-jira") to update epic list.

Continue without epic? (y/n)
```

### Permission Denied

```
❌ Error: Permission denied

You don't have permission to create/update tickets in {projectKey}.

Fix:
1. Ask your Jira admin for project access
2. Verify you're creating tickets with valid issue types
```

## Rules

1. **Always load config first** - Don't proceed without valid `team.json` and `epics.json`
2. **Use Markdown for descriptions** - Jira supports Markdown formatting
3. **Validate ticket keys** - Format: `{PROJECT}-{NUMBER}` (e.g., "HSP-123"), regex: `^[A-Z][A-Z0-9]*-\d+$`
4. **Handle PR context smartly** - If user mentions "this PR" or "current PR", fetch PR details automatically
5. **Preserve existing content** - When updating, don't overwrite unrelated fields
6. **Acceptance Criteria ONLY in dedicated field** - ALWAYS use the "Acceptance Criteria" custom field. NEVER put acceptance criteria in description field under any circumstances
7. **Format acceptance criteria** - Always use checkbox format: `- [ ] {criterion}`
8. **Include PR URLs** - When creating tickets for existing PRs, include PR URL in description
9. **Epic selection is optional** - Don't require epic if none exist or user declines
10. **Always assign to current user** - Use `accountId` from config for assignee, unless user explicitly specifies otherwise
11. **Always assign to current sprint** - Find active sprint and assign ticket to it automatically
12. **Always ask about status** - After creating ticket, ask if user wants to move it to "In Progress" or another status
13. **Show full URLs** - Always display clickable Jira URLs in output
14. **Epic linking requires issue ID** - Use numeric issue ID (from getJiraIssue), not issue key
15. **Handle stale epics gracefully** - If epic deleted, remove from cache and prompt user
16. **Validate API responses** - Check for null/undefined fields before accessing
17. **Distinguish auth errors** - 401/403 = auth issue, 404 = not found, 500 = API issue
18. **Escape Markdown** - Escape special characters in user-provided text displayed in Markdown contexts

## Examples

### Example 1: Create Ticket for New Feature

```
User: skill("jira")

Output:
Do you want to (1) Create a new ticket or (2) Update an existing ticket? 1

Summary (title): Implement OAuth2 authentication

Description: Add OAuth2 authentication flow with token refresh support

Issue type? (Story/Task/Bug) [default: Story]: Story

📚 Select an epic for this ticket:

1. HSP-100: Q1 2026 Authentication (In Progress)
2. HSP-200: Q1 2026 API Improvements (To Do)
3. [No epic]

Which epic? (1-3) 1

Creating ticket...

✅ Jira Ticket Created

HSP-567: Implement OAuth2 authentication
URL: https://commbank.atlassian.net/browse/HSP-567
Epic: HSP-100 - Q1 2026 Authentication
Assignee: Brayden Moon (you)
Sprint: Sprint 42 (current sprint)
Type: Story
Status: Open

📋 Description:
Add OAuth2 authentication flow with token refresh support

Should I move this ticket to In Progress now, or do you want to set a different status?

Options:
1. Keep as "Open" (default)
2. Move to "In Progress"
3. Choose another status

User: 1

🎯 Next Steps:
- Use skill("move", "HSP-567") to transition ticket status
- Use skill("attach-ticket") to link this ticket to a PR
```

### Example 2: Create Ticket for Existing PR

```
User: skill("jira") - create ticket for this PR

Output:
Fetching current PR...

Current branch: feature/oauth-improvements
PR #123: Add OAuth2 token refresh

Using PR details for ticket...

📚 Select an epic for this ticket:

1. HSP-100: Q1 2026 Authentication (In Progress)
2. HSP-200: Q1 2026 API Improvements (To Do)
3. [No epic]

Which epic? (1-3) 1

Creating ticket...

✅ Jira Ticket Created

HSP-568: Add OAuth2 token refresh
URL: https://commbank.atlassian.net/browse/HSP-568
Epic: HSP-100 - Q1 2026 Authentication
Assignee: Brayden Moon (you)
Sprint: Sprint 42 (current sprint)
Type: Story
Status: Open

📋 Description:
{PR body content}

---
Pull Request: https://github.com/org/repo/pull/123

Should I move this ticket to In Progress now, or do you want to set a different status?

Options:
1. Keep as "Open" (default)
2. Move to "In Progress"
3. Choose another status

User: 2

✅ Ticket moved to In Progress

🎯 Next Steps:
- Use skill("move", "HSP-568") to transition ticket status
- Use skill("attach-ticket") to link this ticket to PR #123
```

### Example 3: Update Existing Ticket

```
User: skill("jira", "HSP-456")

Output:
📋 Current Ticket: HSP-456

Summary: Implement OAuth2 token refresh
Status: In Progress
Type: Story
Epic: HSP-100

Description:
Add token refresh functionality to OAuth2 flow

What would you like to update?
1. Description
2. Acceptance Criteria
3. Both

Choice: 3

New description (Markdown supported):
Add token refresh functionality to OAuth2 flow with automatic retry logic

Acceptance criteria (one per line):
Token refresh triggered before expiry
Failed refresh shows user error
Refresh token stored securely
Automatic retry on network failure

Updating ticket...

✅ Ticket Updated

HSP-456: Implement OAuth2 token refresh
URL: https://commbank.atlassian.net/browse/HSP-456

📝 Changes:
- Description: updated
- Acceptance Criteria: added

🔗 View ticket: https://commbank.atlassian.net/browse/HSP-456
```