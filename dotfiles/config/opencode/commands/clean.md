# /clean - Code Cleanup

Remove clutter and dead weight from the codebase. Focus on recently modified files or the entire repository if specified.

## Instructions

1. Identify target files (recent changes or full repo)
2. Analyze each file for cleanup opportunities
3. Remove identified clutter
4. Report what was removed

## What to Remove

### Dead Code
- Unused functions and methods
- Unused variables and constants
- Unreachable code blocks
- Commented-out code (if no longer relevant)
- Unused class properties and fields

### Unused Imports/Dependencies
- Import statements for unused modules
- Unused package dependencies
- Redundant or duplicate imports

### Redundant Comments
- Comments that describe what the code does (the code should be self-explanatory)
- Outdated comments that no longer match the code
- TODO comments for completed work
- Commented-out code with no explanation
- "Textbook-style" explanatory comments

### Other Clutter
- Empty blocks or placeholder code
- Redundant type annotations (where inference is clear)
- Unnecessary whitespace or formatting inconsistencies
- Debug/console statements left in production code
- Unused configuration or feature flags

## What to Keep

- Comments explaining WHY something is done a certain way
- Comments explaining complex business logic
- License headers and legal notices
- Documentation comments for public APIs
- TODO comments for actual pending work

## Output

For each file cleaned, provide:
1. The file path
2. List of items removed with brief explanation
3. Any items flagged but intentionally kept (with reason)
