# /fix - Code Quality Enforcement

Analyze and fix code in this repository to conform to our strict coding standards. Focus on code that was recently created or modified in this session.

## Instructions

1. First, identify recently modified or created code files in the repository
2. Review each file against the rules below
3. For any violations found, rewrite the code to conform to our standards
4. Explain what was changed and why

## The Unix Philosophy (Core Principles)

1. **Rule of Modularity**: Write simple parts connected by clean interfaces.
2. **Rule of Clarity**: Clarity is better than cleverness.
3. **Rule of Composition**: Design programs to be connected to other programs.
4. **Rule of Separation**: Separate policy from mechanism; separate interfaces from engines.
5. **Rule of Simplicity**: Design for simplicity; add complexity only where you must.
6. **Rule of Parsimony**: Write a big program only when it is clear by demonstration that nothing else will do.
7. **Rule of Transparency**: Design for visibility to make inspection and debugging easier.
8. **Rule of Robustness**: Robustness is the child of transparency and simplicity.
9. **Rule of Representation**: Fold knowledge into data so program logic can be stupid and robust.
10. **Rule of Least Surprise**: In interface design, always do the least surprising thing.
11. **Rule of Silence**: When a program has nothing surprising to say, it should say nothing.
12. **Rule of Repair**: When you must fail, fail noisily and as soon as possible.
13. **Rule of Economy**: Programmer time is expensive; conserve it in preference to machine time.
14. **Rule of Generation**: Avoid hand-hacking; write programs to write programs when you can.
15. **Rule of Optimization**: Prototype before polishing. Get it working before you optimize it.
16. **Rule of Diversity**: Distrust all claims for "one true way".
17. **Rule of Extensibility**: Design for the future, because it will be here sooner than you think.

## General Rules

### 1. Library Usage
- Use existing, well-maintained libraries instead of reinventing the wheel
- Avoid libraries that are not a good fit for the problem or language
- Avoid libraries with large dependency trees
- Consider supply chain security when selecting dependencies

### 2. Comments
- Comments explain the "why", never the "what"
- Only comment genuinely difficult-to-understand situations
- Code should be self-documenting and read like prose
- Remove redundant or obvious comments

### 3. Code as Art
- Every element must exist for a reason
- Variable, function, and method names must prioritize readability
- No abbreviations in names (they reduce readability)
- Names should be descriptive and self-explanatory

### 4. No Over-Engineering
- Simplicity over complexity, always
- Code should be accessible to developers of all skill levels
- Avoid premature abstraction
- If a simple solution works, use it

## Review Checklist

When fixing code, check for:

- [ ] Overly clever code that sacrifices clarity
- [ ] Monolithic functions that should be broken into smaller parts
- [ ] Missing or weak interface boundaries
- [ ] Policy mixed with mechanism
- [ ] Unnecessary complexity
- [ ] Poor error handling (silent failures)
- [ ] Cryptic variable/function names or abbreviations
- [ ] Redundant or "textbook-style" comments
- [ ] Over-engineered abstractions
- [ ] Reinvented wheels (missing library opportunities)

## Output

For each file fixed, provide:
1. The file path
2. Summary of violations found
3. Changes made to fix them
