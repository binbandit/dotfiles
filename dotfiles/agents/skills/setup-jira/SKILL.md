---
name: setup-jira
description: Initial setup wizard for Jira integration. Configures team, project, and epic information.
compatibility: opencode
---

# Jira Integration Setup

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
    ```bash
    # Write atomically to prevent corruption:
    cat > ~/.config/jira/team.json.tmp <<EOF
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
    EOF
    
    # Atomic rename
    mv ~/.config/jira/team.json.tmp ~/.config/jira/team.json
    ```

13. **Write epics.json:**
    ```bash
    # Write atomically:
    cat > ~/.config/jira/epics.json.tmp <<EOF
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
    EOF
    
    # Atomic rename
    mv ~/.config/jira/epics.json.tmp ~/.config/jira/epics.json
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
    - Use skill("jira") to create or update tickets
    - Use skill("today") to see your assigned tickets
    - Use skill("refresh-jira") to update epic list (quarterly)
    
    💡 Tip: Run refresh-jira skill at the start of each quarter to update your epic list.
    ```

## Re-running Setup

If setup has been run before, detect existing configuration:

1. Check if `~/.config/jira/team.json` exists
2. If exists, show current config and ask to reconfigure or cancel
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
```

## Rules

1. **Always use JSON output from Atlassian tools** - Parse structured data, don't scrape text
2. **Handle missing data gracefully** - Some projects may not have epics or boards
3. **Validate user input** - Ensure project keys and issue types are valid
4. **Create parent directory** - Use `mkdir -p` to ensure `~/.config/jira/` exists
5. **Use ISO timestamps** - Format: `2026-03-04T08:44:00Z`
6. **Include full URLs in epic data** - Makes it easy to click through from other commands
7. **Atomic writes** - Use temp file + rename pattern to prevent file corruption
8. **Validate projectKey format** - Must match `^[A-Z][A-Z0-9]*$` before storing
9. **Handle getAccessibleAtlassianResources array** - May return array, extract first element or prompt to select
10. **Verify expand parameter** - Check if `expandIssueTypes` is correct parameter name for API version
