---
name: refresh-jira
description: Refresh the list of epics from Jira (run quarterly when new epics are created)
compatibility: opencode
---

# Refresh Jira Epics

Refresh the list of epics from your Jira project. Run this quarterly when new epics are created or when epic statuses change.

## Prerequisites

- Run `setup-jira` skill first to configure your Jira workspace
- Configuration file exists: `~/.config/jira/team.json`

## What This Command Does

1. Loads your Jira project configuration
2. Queries for all active epics in your project
3. Updates the `~/.config/jira/epics.json` file
4. Shows what changed (new epics, removed epics, status changes)

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
     - `projectKey` - Your project key
     - `workspaceUrl` - Base URL for epic links
   
   **Validation**:
   - Validate `projectKey` matches pattern: `^[A-Z][A-Z0-9]*$`
   - This prevents JQL injection if config file is corrupted
   - If validation fails: Show error and prompt to re-run `setup-jira`

3. **Load existing epics (if any):**
   ```bash
   cat ~/.config/jira/epics.json
   ```
   - If file exists: Parse to get current epic list for comparison
   - If file doesn't exist: Set `oldEpics = []`

### Phase 2: Fetch Current Epics

4. **Query for active epics:**
   ```
   Use: atlassian_searchJiraIssuesUsingJql(
     cloudId,
     jql: "project = {projectKey} AND type = Epic AND status != Done ORDER BY created DESC",
     fields: ["summary", "status"],
     maxResults: 100
   )
   ```
   - Fetches all epics that are NOT done (active or in progress)
   - Orders by creation date (newest first)
   - Limit to 100 epics (should be sufficient for most projects)

5. **Parse epic data:**
   - Extract for each epic:
     - `key` - Epic key (e.g., "HSP-100")
     - `summary` - Epic title/summary
     - `status` - Current status (e.g., "In Progress", "To Do")
     - Construct `url` - `{workspaceUrl}/browse/{key}`

### Phase 3: Compare and Report Changes

6. **Detect changes:**
   - **New epics**: Epics in fetched list but not in old list
   - **Removed epics**: Epics in old list but not in fetched list (completed or deleted)
   - **Status changes**: Epics where status is different
   - **Unchanged**: Epics with same key and status

7. **Display comparison:**
   ```
   🔄 Refreshing Epics for {projectKey}...
   
   📊 Changes Detected:
   
   ✅ New Epics ({count}):
   - HSP-789: Q2 2026 Performance Optimization (To Do)
   - HSP-800: Q2 2026 Security Audit (In Progress)
   
   ✓ Status Changed ({count}):
   - HSP-100: Q1 2026 Authentication
     Was: In Progress → Now: Done
   
   🗑️  Removed Epics ({count}):
   - HSP-50: Q4 2025 Legacy Migration (Done)
   
   ━ Unchanged ({count}):
   - HSP-200: Q1 2026 API Improvements (In Progress)
   - HSP-300: Q1 2026 UI Refresh (In Progress)
   
   
   📚 Total Active Epics: {total count}
   ```

### Phase 4: Update Configuration

8. **Build updated epics.json:**
   ```json
   {
     "epics": [
       {
         "key": "HSP-789",
         "summary": "Q2 2026 Performance Optimization",
         "status": "To Do",
         "url": "https://commbank.atlassian.net/browse/HSP-789"
       },
       {
         "key": "HSP-800",
         "summary": "Q2 2026 Security Audit",
         "status": "In Progress",
         "url": "https://commbank.atlassian.net/browse/HSP-800"
       }
     ],
     "lastRefreshed": "{current ISO timestamp}"
   }
   ```

9. **Write updated file:**
   ```bash
   # Write atomically to prevent corruption:
   # 1. Write to temporary file
   echo "$json_content" > ~/.config/jira/epics.json.tmp
   
   # 2. Atomic rename (replaces old file only if write succeeded)
   mv ~/.config/jira/epics.json.tmp ~/.config/jira/epics.json
   ```
   
   **Why Atomic Writes**:
   - If write fails mid-operation (disk full, crash), old file remains intact
   - Prevents corrupted JSON that would break other skills
   - `mv` is atomic on most filesystems (POSIX guarantee)

### Phase 5: Confirmation

10. **Display success summary:**
    ```
    ✅ Epic List Refreshed Successfully
    
    Updated: ~/.config/jira/epics.json
    Last refreshed: {timestamp}
    
    📚 Active Epics: {count}
    
    Recent epics:
    - HSP-789: Q2 2026 Performance Optimization (To Do)
    - HSP-800: Q2 2026 Security Audit (In Progress)
    - HSP-200: Q1 2026 API Improvements (In Progress)
    
    💡 Next Steps:
    - Use skill("jira") to create tickets under these epics
    - Run this command quarterly or when new epics are created
    
    🔗 View all epics: {workspaceUrl}/browse/{projectKey}?selectedIssueType=epic
    ```

## Error Handling

### Configuration Not Found

```
❌ Error: Jira not configured

Please run the setup-jira skill first:
skill("setup-jira")

This will configure your Jira workspace and project.
```

### No Epics Found

```
⚠️  No Active Epics Found

No epics found in project {projectKey}.

This could mean:
1. All epics are marked as "Done"
2. Project has no epics yet
3. You don't have permission to view epics

Current epics.json has been cleared.

💡 Tip: Create epics in Jira to organize your work:
{workspaceUrl}/browse/{projectKey}
```

### API Failure

```
❌ Error: Failed to refresh epics

Could not connect to Jira. Possible reasons:
1. Network connectivity issues
2. Atlassian MCP server not configured
3. Invalid credentials

Your existing epic list has not been modified.

Try:
- Check your internet connection
- Re-run setup-jira skill to refresh credentials
- Verify Atlassian MCP server in opencode.json
```

## Rules

1. **Exclude Done epics** - Only fetch active or in-progress epics
2. **Show diff clearly** - Users need to see what changed
3. **Preserve on error** - Don't overwrite epics.json if fetch fails
4. **Use ISO timestamps** - Format: `2026-03-04T08:44:00Z`
5. **Order by creation date** - Newest epics first (DESC)
6. **Include full URLs** - Makes epics clickable in other commands
7. **Limit to reasonable count** - 100 epics max (sufficient for most projects)
8. **Handle empty gracefully** - Clear epics.json if no active epics
9. **Display recent epics** - Show top 3-5 in summary for quick reference
10. **Suggest when to refresh** - Quarterly or when new quarter starts
11. **Atomic writes** - Use temp file + rename to prevent corruption
12. **Validate projectKey** - Must match `^[A-Z][A-Z0-9]*$` to prevent JQL injection
13. **Compare by key and status** - Status changes are important to track

## When to Run This Command

### Recommended Schedule
- **Quarterly**: Start of each quarter when new epics are created
- **After epic changes**: When team creates, completes, or reorganizes epics
- **Before sprint planning**: Ensure epic list is current for ticket creation
- **After setup**: Not needed - `setup-jira` already fetches epics initially

### Signs You Need to Refresh
- Can't find recent epic when creating tickets
- Epic list feels stale or outdated
- Team announced new quarterly objectives
- Notice epics marked "Done" still showing in list

## Examples

### Example Output - Quarterly Refresh

```
🔄 Refreshing Epics for HSP...

📊 Changes Detected:

✅ New Epics (4):
- HSP-789: Q2 2026 Performance Optimization (To Do)
- HSP-800: Q2 2026 Security Audit (In Progress)
- HSP-810: Q2 2026 Mobile App Launch (To Do)
- HSP-820: Q2 2026 Data Migration (To Do)

✓ Status Changed (2):
- HSP-100: Q1 2026 Authentication
  Was: In Progress → Now: Done
- HSP-300: Q1 2026 UI Refresh
  Was: In Progress → Now: In Review

🗑️  Removed Epics (3):
- HSP-50: Q4 2025 Legacy Migration (Done)
- HSP-75: Q4 2025 Testing Infrastructure (Done)
- HSP-90: Q4 2025 Documentation (Done)

━ Unchanged (2):
- HSP-200: Q1 2026 API Improvements (In Progress)
- HSP-250: Q1 2026 DevOps Tooling (In Progress)


📚 Total Active Epics: 8

✅ Epic List Refreshed Successfully

Updated: ~/.config/jira/epics.json
Last refreshed: 2026-03-04T08:44:00Z

Recent epics:
- HSP-820: Q2 2026 Data Migration (To Do)
- HSP-810: Q2 2026 Mobile App Launch (To Do)
- HSP-800: Q2 2026 Security Audit (In Progress)

💡 Next Steps:
- Use skill("jira") to create tickets under these epics
- Run this command quarterly or when new epics are created

🔗 View all epics: https://commbank.atlassian.net/browse/HSP?selectedIssueType=epic
```

### Example Output - No Changes

```
🔄 Refreshing Epics for HSP...

📊 No Changes Detected

All epics are up to date.

━ Active Epics (5):
- HSP-789: Q2 2026 Performance Optimization (To Do)
- HSP-800: Q2 2026 Security Audit (In Progress)
- HSP-200: Q1 2026 API Improvements (In Progress)
- HSP-300: Q1 2026 UI Refresh (In Progress)
- HSP-250: Q1 2026 DevOps Tooling (In Progress)

✅ Epic list is current

Last refreshed: 2026-03-04T08:44:00Z

🔗 View all epics: https://commbank.atlassian.net/browse/HSP?selectedIssueType=epic
```
