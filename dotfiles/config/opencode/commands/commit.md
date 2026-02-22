# /commit - Smart Commit

Stage and commit changes in logical groups with AI-generated commit messages.

## Instructions

1. Run `git status` to see all modified, added, and deleted files
2. Analyze the changes and group them logically
3. For each logical group:
   - Stage the files with `git add <files>`
   - Run `sg save -a` to commit with an auto-generated message
4. Repeat until all changes are committed

## Grouping Strategy

Group files by logical change, not by file type. Examples:

- **Feature addition**: All files related to a single new feature
- **Bug fix**: The fix and any related test updates
- **Refactor**: Related refactoring changes across files
- **Config changes**: Configuration or build-related changes
- **Documentation**: Doc-only changes
- **Dependencies**: Package/dependency updates

## Rules

1. Each commit should represent ONE logical change
2. Never mix unrelated changes in a single commit
3. Keep commits atomic - each should be independently revertable
4. Stage files before running `sg save -a`

## Process

```bash
# Check what needs to be committed
git status

# For each logical group:
git add <file1> <file2> ...
sg save -a

# Repeat for remaining groups
```

## Output

For each commit made, report:
1. Files included
2. The logical grouping rationale
3. Confirmation that `sg save -a` completed successfully
