# /plan - Feature Planning

Plan a feature or change before writing code. Think first, code second. Prevents over-engineering and ensures alignment with our principles.

## Usage

```
/plan <feature or task description>
```

## Instructions

1. Understand the requirement fully
2. Explore the existing codebase for relevant context
3. Design the simplest solution that works
4. Identify risks and unknowns
5. Break down into implementable steps

## Planning Output

### 1. Problem Statement
- What are we trying to solve?
- Who benefits and how?
- What does success look like?

### 2. Context Analysis
- What existing code is relevant?
- What patterns does the codebase already use?
- What can we reuse vs. build new?

### 3. Proposed Solution

**Approach**: One paragraph describing the solution

**Key Design Decisions**:
- Decision 1: [choice] because [reason]
- Decision 2: [choice] because [reason]

**Files to Create/Modify**:
| File | Action | Purpose |
|------|--------|---------|
| path/to/file | create/modify | what and why |

### 4. Simplicity Check

Answer these before proceeding:
- [ ] Is this the simplest solution that works?
- [ ] Can a junior developer understand this?
- [ ] Are we adding complexity only where we must?
- [ ] Are we avoiding premature abstraction?
- [ ] Are we reusing existing patterns/libraries?

### 5. Risks & Unknowns
- What could go wrong?
- What do we not know yet?
- What assumptions are we making?

### 6. Implementation Steps

Break down into small, atomic tasks:

1. [ ] First step (should be completable in isolation)
2. [ ] Second step
3. [ ] ...

Each step should be:
- Independently testable
- Small enough to complete in one session
- Clear in its success criteria

### 7. Out of Scope

Explicitly list what we are NOT doing (prevents scope creep).

## Principles to Apply

- **Modularity**: Are we creating clean interfaces?
- **Separation**: Is policy separate from mechanism?
- **Simplicity**: Are we adding only necessary complexity?
- **Extensibility**: Will this be easy to change later?
- **Parsimony**: Do we really need to build this?

## After Planning

Once the plan is approved, use the todo list to track implementation.
