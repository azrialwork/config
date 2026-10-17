# OpenCode config (global)

Global Markdown configuration for OpenCode, verified against the OpenCode `v1.19.3` source in `upstream-opencode-v1.19.3`. Files or rules with no global loader are not forced in. They are folded into a file that loads, or dropped.

## Install

Copy every file in this folder to `~/.config/opencode/`.

What loads from there:

- `AGENTS.md` loads automatically as global instructions.
- `agent/build.md` loads automatically as the build agent prompt.
- `command/heartbeat.md` loads automatically as `/heartbeat`.
- `opencode.jsonc` is the only config JSON file. It carries the global settings with comments.

## How OpenCode builds the system prompt

Source: `packages/opencode/src/session/llm/request.ts`, `session/prompt.ts`, `session/system.ts`, `session/instruction.ts`, `agent/agent.ts`. Order:

1. Agent prompt if set, else the provider prompt for the model (`system.ts` picks one of `session/prompt/*.txt` per model: anthropic, gpt, gemini, kimi, meta, codex, trinity, astra, beast, default). The agent prompt replaces the provider prompt entirely, so `agent/build.md` restates the kept defaults (concise, no preamble, never commit unless asked, no comments unless asked, batch tool calls, `file_path:line_number` references) instead of assuming they survive.
2. Environment block: model id, working directory, worktree, git status, platform, date, project references.
3. Instructions: global `AGENTS.md` from this folder, then the first project `AGENTS.md` / `CLAUDE.md` / `CONTEXT.md` found walking up, then every file or URL in the project `opencode.json` `instructions`. Each file is prefixed with `Instructions from: <path>`.
4. MCP instructions.
5. Skills.
6. Per-message user system text.

The parts join with newlines into one system message. A plugin transform can append to it.

## Files

| File | What it holds |
|---|---|
| `AGENTS.md` | Workflow rules: precedence, allowed directories, task lifecycle, coding, learning, secrets, outward pre-flight, judgment, scope, no-slop. Also Boss identity and context, durable facts, and tool notes. |
| `agent/build.md` | Persona and tone, plus the kept OpenCode defaults. |
| `command/heartbeat.md` | Workspace hygiene checks as an on-demand `/heartbeat` command. |
| `opencode.jsonc` | Global settings with comments. |
| `README.md` | This file: install, prompt assembly, file list. |

## Dropped, not forced

- Separate memory file: no loader reads one from the global folder. Durable facts (Facts, Preferences, Commitments) live in `AGENTS.md` instead.
- Separate tools file: no loader reads one from the global folder. Tool notes live in `AGENTS.md` instead.
- Background ticks: OpenCode has none, so the hygiene checks are an on-demand `/heartbeat` command.
- Proactive background work: OpenCode has none. The repeat-mistake rule (nudge Boss plus learning entry) lives in `AGENTS.md` as a standing rule.

## No instructions key

No `instructions` key in the global `opencode.jsonc` on purpose. Instruction entries resolve per project, not from the global folder. A project that needs extra instruction files lists them in its own `opencode.json`.

## No-slop

These files follow no-slop Mode 1 (DURING), as defined in `AGENTS.md`.
