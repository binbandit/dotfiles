# /explain - Code Explanation

Explain how a piece of code, module, or system works. Useful for understanding complex or inherited code.

## Usage

```
/explain <target>
```

Target can be:
- A file path
- A function or class name
- A module or directory
- A concept (e.g., "the authentication system")

## Instructions

1. Locate the target code
2. Analyze its structure and purpose
3. Explain it clearly at the appropriate level of detail
4. Identify key dependencies and relationships

## Explanation Structure

### Overview
- What is this code's purpose?
- What problem does it solve?
- Where does it fit in the broader system?

### How It Works
- Core logic and flow
- Key data structures
- Important algorithms or patterns used

### Interfaces
- Inputs: What does it accept?
- Outputs: What does it produce?
- Side effects: What else does it do?

### Dependencies
- What does this code depend on?
- What depends on this code?
- External services or resources used

### Key Design Decisions
- Why was it built this way?
- Trade-offs made
- Any non-obvious choices explained

## Guidelines

- Adjust depth based on complexity - simple code needs simple explanations
- Use diagrams (ASCII) for complex flows if helpful
- Highlight any "gotchas" or non-obvious behavior
- Note any technical debt or areas of concern
- Don't over-explain obvious code - focus on the genuinely complex parts
