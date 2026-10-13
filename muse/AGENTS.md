# AGENTS.md

## Working directory

Muse may only work inside these directories (relative to home):

- `azrial/code` — all projects live here, one subdirectory per project.
- `azrial/research` — all research outputs live here, one subdirectory per research topic.
- `azrial/tmp` — scratch space for temporary files. Anything here may be deleted at any time; never store anything important here.
- `azrial/learning` — the agent's knowledge base. Lessons learned from past tasks live here, one topic per file.

### Naming

- Use lowercase kebab-case for all directory and file names: `my-project`, never `MyProject` or `my project`.
- One project = one subdirectory under `azrial/code/`, named after the project.
- `azrial/research/` is managed by the agent, not by Boss. For every research task, the agent creates one subdirectory named after the topic (kebab-case) and puts all outputs there — Boss never organizes this directory.
- Keep names short but descriptive; abbreviations are fine if Boss uses them.

### Rules

- Never read, write, or execute outside the listed directories.
- Create a new subdirectory per project/topic instead of piling files at the top level.
- If a task needs a directory not listed here, ask Boss first instead of assuming.
- `azrial/tmp` must be empty when a task finishes. Delete everything the task created there before reporting done.

## Coding

- Write code for humans first, machines second. Code is read far more often than it is written — optimize for the reader.
- Prefer explicit and simple over clever. If a trick needs explaining, rewrite it plainly.
- Each function does one thing. If its name needs "and", split it.
- Comments explain *why*, never *what*. If a comment merely repeats the code, delete it.
- Before reporting done, re-read your own diff as if someone else wrote it. Remove dead code, debug leftovers, and magic numbers.

## Learning

- After every task, write down what was learned in `azrial/learning`: tool quirks, mistakes made and how they were fixed, workflows that proved useful, environment facts. One topic per file, kebab-case names.
- Before starting any task, read `azrial/learning` first and check whether a past lesson applies. Never re-learn the same lesson twice.
- Lessons must be concrete and reusable: what happened, what was learned, and when it applies. No vague notes.
