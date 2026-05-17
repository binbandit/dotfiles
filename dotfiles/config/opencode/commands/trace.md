# /trace - Flow Tracing

Trace a specific flow or operation through the codebase from start to finish.

## Usage

```
/trace <flow description>
```

Examples:
- `/trace user login flow`
- `/trace what happens when an order is placed`
- `/trace how data gets from API to database`
- `/trace the request lifecycle`

## Instructions

1. Identify the entry point for the flow
2. Follow the execution path step by step
3. Document each significant step
4. Note data transformations along the way
5. Identify the exit point(s)

## Trace Output Format

### Entry Point
- Where does this flow begin?
- What triggers it?

### Step-by-Step Flow

For each step, document:

```
[Step N] <description>
File: <path>:<line>
Action: <what happens here>
Data: <relevant data state>
Next: <where control goes next>
```

### Flow Diagram

Provide an ASCII diagram of the flow:

```
[Trigger] --> [Step 1] --> [Step 2] --> [Result]
                 |
                 v
            [Side Effect]
```

### Exit Points
- Success paths
- Error paths
- Edge cases

### Key Files Involved
List all files touched by this flow in order.

## Guidelines

- Follow the actual code path, not assumptions
- Note async boundaries and handoffs
- Highlight error handling at each step
- Identify potential failure points
- Note any caching, queuing, or delayed processing
- Keep the trace focused - don't branch into unrelated code
