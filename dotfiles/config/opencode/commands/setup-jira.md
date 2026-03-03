# /setup-jira - Jira Integration Setup

Initial setup wizard for Jira integration. Configures team, project, and epic information.

## Prerequisites

- Atlassian MCP server configured in `opencode.json`
- Access to your team's Jira workspace

## What This Command Does

1. Detects your Jira workspace and account automatically
2. Guides you through selecting your primary project
3. Configures default issue types and board settings
4. Fetches current epics for quick selection
5. Creates configuration files in `~/.config/jira/`

## State Files Created

This command creates and manages:

```
~/.config/jira/
├── team.json      - Team and project configuration
└── epics.json     - Current epic list for ticket creation
```

### `team.json` Schema

```json
{
  "cloudId": "workspace-cloud-id",
  "accountId": "your-account-id",
  "projectKey": "HSP",
  "projectName": "Helix Platform",
  "boardId": "123",
  "defaultIssueType": "Story",
  "team": "Helix Engineering",
  "workspaceUrl": "https://commbank.atlassian.net",
  "lastUpdated": "2026-03-04T08:44:00Z"
}
```

### `epics.json` Schema

```json
{
  "epics": [
    {
      "key": "HSP-100",
      "summary": "Q1 2026 Authentication",
      "status": "In Progress",
      "url": "https://commbank.atlassian.net/browse/HSP-100"
    }
  ],
  "lastRefreshed": "2026-03-04T08:44:00Z"
}
```

## Instructions

### Phase 1: Detect Workspace and User

1. **Get accessible Atlassian resources:**
   ```
   Use: atlassian_getAccessibleAtlassianResources
   ```
   - Extract: `cloudId`, `url` (workspace URL), `name`
   - Store cloudId and workspaceUrl for later use

2. **Get current user info:**
   ```
   Use: atlassian_atlassianUserInfo
   ```
   - Extract: `account_id`, `name`, `email`
   - Store accountId for JQL queries

3. **Display detected info:**
   ```
   ✅ Detected Jira Workspace
   
   Workspace: {name} ({url})
   User: {name} ({email})
   ```

### Phase 2: Project Selection

4. **Fetch available projects:**
   ```
   Use: atlassian_getVisibleJiraProjects(cloudId, expandIssueTypes=true)
   ```
   - Get all projects user has access to
   - Include issue type metadata

5. **Present project selection:**
   ```
   📋 Available Projects:
   
   1. HSP - Helix Platform (Team: Engineering)
   2. MOB - Mobile App (Team: Mobile)
   3. API - API Gateway (Team: Platform)
   
   Which project do you work on primarily?
   ```
   - Ask user to select project by number or key
   - If user provides project key directly, validate it exists

6. **Store selected project:**
   - Extract: `key`, `name`, `id`
   - Note available issue types for later

### Phase 3: Issue Type Configuration

7. **Get project issue types:**
   ```
   From: Previous project fetch (expandIssueTypes=true)
   or
   Use: atlassian_getJiraProjectIssueTypesMetadata(cloudId, projectIdOrKey)
   ```

8. **Ask for default issue type:**
   ```
   📝 Available Issue Types for {projectKey}:
   
   1. Story
   2. Task
   3. Bug
   4. Epic
   
   What should be the default issue type? (Usually "Story" or "Task")
   ```
   - Default suggestion: "Story"
   - Store user's selection

### Phase 4: Fetch Current Epics

9. **Query for epics in project:**
   ```
   Use: atlassian_searchJiraIssuesUsingJql(
     cloudId,
     jql: "project = {projectKey} AND type = Epic AND status != Done ORDER BY created DESC",
     fields: ["summary", "status"],
     maxResults: 50
   )
   ```

10. **Display found epics:**
    ```
    📚 Found {count} Active Epics:
    
    - HSP-100: Q1 2026 Authentication (In Progress)
    - HSP-200: Q1 2026 API Improvements (To Do)
    - HSP-300: Q1 2026 UI Refresh (In Progress)
    ```

### Phase 5: Save Configuration

11. **Create ~/.config/jira directory:**
    ```bash
    mkdir -p ~/.config/jira
    ```

12. **Write team.json:**
    ```json
    {
      "cloudId": "{detected-cloud-id}",
      "accountId": "{user-account-id}",
      "projectKey": "{selected-project-key}",
      "projectName": "{selected-project-name}",
      "defaultIssueType": "{selected-issue-type}",
      "team": "{project-team-name}",
      "workspaceUrl": "{workspace-url}",
      "lastUpdated": "{current-iso-timestamp}"
    }
    ```

13. **Write epics.json:**
    ```json
    {
      "epics": [
        {
          "key": "HSP-100",
          "summary": "Q1 2026 Authentication",
          "status": "In Progress",
          "url": "{workspaceUrl}/browse/HSP-100"
        }
      ],
      "lastRefreshed": "{current-iso-timestamp}"
    }
    ```

### Phase 6: Confirmation

14. **Display success message:**
    ```
    ✅ Jira Integration Setup Complete!
    
    Configuration saved to: ~/.config/jira/
    
    📋 Project: {projectKey} - {projectName}
    📚 Epics loaded: {epic-count}
    👤 User: {name} ({email})
    
    🎯 Next Steps:
    - Use `/jira` to create or update tickets
    - Use `/today` to see your assigned tickets
    - Use `/refresh-jira` to update epic list (quarterly)
    - Use `/move` to transition ticket status
    - Use `/attach-ticket` to link tickets to PRs
    
    💡 Tip: Run `/refresh-jira` at the start of each quarter to update your epic list.
    ```

## Re-running Setup

If setup has been run before, detect existing configuration:

1. Check if `~/.config/jira/team.json` exists
2. If exists, show current config:
   ```
   ⚠️  Existing Jira configuration found
   
   Current Project: {projectKey} - {projectName}
   Last Updated: {lastUpdated}
   
   Do you want to:
   1. Reconfigure (overwrites existing setup)
   2. Cancel (keep current setup)
   ```
3. If user selects "Reconfigure", proceed with setup
4. If user cancels, exit gracefully

## Error Handling

### No Atlassian Access

```
❌ Error: Cannot access Atlassian workspace

The Atlassian MCP server is not configured or you don't have access.

Fix:
1. Check opencode.json has atlassian MCP configured
2. Verify your Atlassian authentication
3. Ensure you have Jira access in your workspace
```

### No Projects Found

```
❌ Error: No Jira projects found

You don't have access to any Jira projects.

Fix:
1. Ask your Jira admin to grant you project access
2. Verify you're looking at the correct workspace
```

### No Epics Found

```
⚠️  Warning: No active epics found in {projectKey}

This is okay - you can still use Jira commands.
Epic selection will be skipped when creating tickets.

Consider:
- Creating epics for quarterly planning
- Running `/refresh-jira` after epics are created
```

## Rules

1. **Always use JSON output from Atlassian tools** - Parse structured data, don't scrape text
2. **Handle missing data gracefully** - Some projects may not have epics or boards
3. **Validate user input** - Ensure project keys and issue types are valid
4. **Create parent directory** - Use `mkdir -p` to ensure `~/.config/jira/` exists
5. **Use ISO timestamps** - Format: `2026-03-04T08:44:00Z`
6. **Include full URLs in epic data** - Makes it easy to click through from other commands
7. **Don't ask for board ID** - Most teams have one board per project; fetch automatically if needed later

## Testing Checklist

- [ ] First-time setup (no existing config)
- [ ] Re-running setup (existing config found)
- [ ] Project with no epics
- [ ] User with multiple project access
- [ ] User with single project access
- [ ] Invalid project key handling
- [ ] MCP server not configured
- [ ] Successful config file creation
- [ ] Proper timestamp formatting
- [ ] Epic URLs are clickable
