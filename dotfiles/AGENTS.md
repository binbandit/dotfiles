# Brayden's agent instructions

These are common instructions for Brayden's agents across all scenarios.

## General Guidelines

- Never use the em dash "—". Use plain dash "-" instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- For one-off or infrequent operational work, start with the simplest direct end-to-end path. Do not build wrappers, control planes, policy layers, custom verifiers, or automation unless the direct path exposes a concrete blocker or repeated need that justifies the added machinery.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.
- Before using "dynamic workflows", "ultra code" or any harness feature that immediately spawns a large swarm of subagents, always explain the tradeoffs and ask the user for explicit approval.
- Always drop the co-author comment / attributes from commit bodies and pull requests.
- If a pull request has commits committed by a bot, but authored by Brayden, update the commits so they are committed by Brayden instead.

## Coding Guidelines
- Reduce complexity where possible; channel "yagni" energy unless told otherwise.
- Typesafety is useful, take advantage of it
- Don't be scared to propose bold ideas if they can meaningfully benefit our work.
- Be careful with destructive actions that are not explicitly requested by the user.
- Tests should be focused, not slop.
- Comments are a great way to clarify functionality and how code is used. Don't comment every line, but feel free to describe (concisely).
    - If the code requires a lot of comments to explain how the code solves the problem, the code itself is the problem; change it.
    - If the code has comments that parrot what can already be infered by the code in a simple way, they aren't needed and are just bloat.
- Update comments when the code changes. Never let a comment be out of date with the implementation.

## Coding Preferences
- `any` should not be used. Inferred tpyes are our friend. Our systems should adapt to changes, instead of requiring changes everywhere.
- If your TS code looks like a python developer wrote it, its bad TS code.
- Avoid one-line functions that are just casting wrappers.
- Write TypeScript in ways that Matt Pocock would be proud of.
- For typescript, Brayden prefer's "@/" imports over "../" imports.
- Using a "src" folder in typescript is prefered over root level files for libraries etc.

## Tech preferences
- Typescript
    - Bun over pnpm, but pnpm over any other package manager
    - React
    - Tailwind
    - Vite
    - Zustand
    - ArkType (or zod if perf isn't an issue)
- Rust
    - anyhow
    - thiserror
    - clap
- Golang
- Mobile
    - SwiftUI
    - Swift

## Brayden's Opinions

When you are working on something that would benefit from being informed by Brayden's viewpoints, read ~/OPTIONS.md to understand.

## Voice Profile

When you are talking/posting on behalf of Brayden using his identity, read ~/VOICE.md to see how Brayden talks.

## Questions are read-only

A question is a request for an answer, not for changes. If the message opens with "how hard would it be", "what are your thoughts", "why does", "should we", "is it possible", "can X do Y", or otherwise asks rather than instructs: answer it, and do not edit files.
If the Answer is obvious and the change is trivial, still answer first and offer the change. Ask before making it.

## Match ceremony to the task

- Do not spawn subagents or a multi-agent panel for work a single agent finishes in one pass. Delgation is for bredth or adversarial review, not for ordinary tasks.
- When serveral agents do work in parallel, state file ownership up front so they do not collide.

## Blast radius

- Never touch production, live databases, or daily-driver build/preview channels unless explicitly told to. When a task is adjacent to any of them, name what you are about to touch before touching it.

## Pull Requests

- Make sure titles follow conventions from the repo. They should be simple and easy to understand. Conventional commit styles in projects that use them, i.e. "fix(web): new threads no longer spike CPU"
- PR descriptions should aim for simplicity. Open with a minimal, clear description of the problem. Follow up with how you solved it.
- Open a real PR, not a fraft. Drafts do not get review-bot coverage.
- Rebase onto latest `main` before opening. Stale branches conflict and waste a review round.
- When asked to monitor or babysit a PR: poll checks and comments newer than the last push; verify each bot finding, against the source before acting on it; fix real ones and dismiss false positives with a written reason; fix CI failures, distinguishing real breaks from known infra flakes. If nothing is new, stay quiet - do not post filler comments. Stop when the repo's review bots are green on the latest commit.
- Merge only per the disposition given in the request (merge when green, or stop and report). If none was given, report and ask.
