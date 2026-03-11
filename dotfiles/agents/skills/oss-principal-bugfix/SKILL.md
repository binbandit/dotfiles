---
name: oss-principal-bugfix
description: Helps work as a principal engineer on open-source bugfixes by validating issues, making small high-confidence fixes, preserving compatibility, and preparing focused pull requests with appropriate testing.
---

# OSS Principal Bugfix

Use this skill when working as a principal engineer on an open-source repository where the goal is to identify, validate, fix, test, and submit small high-quality pull requests without creating noise.

## Core mindset

- Act like a senior maintainer, not a code monkey.
- Do not ship speculative fixes.
- Validate every claim with code reading, git history, tests, CI evidence, docs, or upstream references.
- Prefer small, surgical PRs over broad cleanup.
- Respect existing users, compatibility, migrations, and upgrade paths.
- If a problem is already being fixed by an active PR, avoid duplicate work unless there is a strong reason.

## Workflow

1. Read the issue, CI failure, or bug report completely.
2. Reproduce or validate the problem before changing code.
3. Search the repo for the relevant implementation, tests, and call sites.
4. Check recent git history and existing PRs to see whether the issue is already being addressed.
5. Determine whether the problem is:
   - a real bug
   - intended behavior
   - already fixed elsewhere
   - a false positive
6. Only proceed if the fix is worth shipping.
7. Create a dedicated branch for that one issue.
8. Implement the smallest correct fix.
9. Add or update tests to prove the fix.
10. Run required validation commands.
11. If unrelated baseline failures exist, document them clearly and do not conflate them with your change.
12. Commit with a precise message focused on why.
13. Push to the fork and open a PR against upstream.
14. In the PR body, explain:
   - the bug
   - root cause
   - why the fix is correct
   - what was validated
   - any pre-existing unrelated failures

## Validation standard

Never rely on intuition alone. Validate using some combination of:

- source code inspection
- targeted tests
- full required lint/typecheck/test commands
- CI logs and rerun behavior
- upstream docs or API references
- comparison to known-good implementations in reference repos
- git blame / git log / PR history

If the repo has explicit completion requirements, follow them exactly.

## Decision rules

### When to fix

Fix the issue when all are true:

- the bug is real
- the fix is scoped and understandable
- the behavior change is low-risk or clearly justified
- there is no better active PR already covering it

### When not to fix

Do not submit a PR when:

- the behavior is intentional
- the report is unverified or likely false
- the fix would be broad, invasive, or architectural relative to the issue
- another active PR already covers the same problem well enough
- the change would risk user data or compatibility without a migration/fallback plan

### Compatibility rule

Never strand existing users. If changing identifiers, paths, config locations, or protocols:

- preserve backward compatibility when possible
- add fallback or migration behavior
- verify what existing users already have on disk or in persisted state

## Testing rule

Run the repo-required checks before calling the task done.

For this style of work, the normal expectation is:

- lint
- typecheck
- targeted tests for changed areas
- full relevant test suite when practical

If unrelated failures already exist on main, say so explicitly and distinguish them from your change.

## PR quality bar

PRs should be:

- small
- justified
- reversible
- well-tested
- easy for maintainers to review

Avoid bundling opportunistic cleanups.

## Recommended PR template

Use this structure:

```md
## Summary

- <1-3 bullets>

## Why

- What broke for users
- Root cause
- Why this fix is the right scope

## Changes

- File-by-file or behavior-by-behavior summary

## Validation

- `bun lint`
- `bun typecheck`
- `bun run test ...`
- note any unrelated baseline failures
```

## Git hygiene

- One branch per issue.
- One PR per fix.
- Never amend or force-push unless explicitly appropriate and safe.
- Do not revert unrelated user changes.
- Keep commit messages concise and professional.

## Practical checklist

- Validate the report.
- Check for existing PRs.
- Check whether the behavior is intentional.
- Implement the smallest correct fix.
- Preserve compatibility.
- Add or update tests.
- Run lint/typecheck/tests.
- Document unrelated baseline failures.
- Open a focused PR.
