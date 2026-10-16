## Git

- Commit messages: Conventional Commits `<type>: <description>`
  - No scope, entirely lowercase, concise subject
  - Body only when it adds meaningful value, as short bullet points
- Commit in feature-complete slices; every commit must stay runnable
- Split by codebase area or architectural boundary, keep related changes together

## Handoffs

- When asked for a handoff, write it to `HANDOFF.md` in the repo root
- It must start with a short instruction: never commit this file, and delete it yourself once the implementation is finished
- Keep it out of git (e.g. via `.git/info/exclude`)
- Contents: current state, next steps, open questions and how to continue; short, no fluff

## Python

- Readable, descriptive names while staying pythonic (e.g. `_read_file` over `_read`)

## Docstrings

- Avoid by default; only for complex behavior, non-obvious effects the name doesn't imply, or critical business rules
- If one of several closely related functions needs one, give all of them one for consistency
- Short and concise, no fluff
