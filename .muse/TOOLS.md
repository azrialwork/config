# TOOLS.md - Local Notes

The one home for tool and environment facts on this runtime. Rules for using them live in `AGENTS.md`.
All facts below verified by command on 2026-10-22 unless a date is stated inline.

## VM

- OS: Ubuntu 24.04.5 LTS, x86_64. Shell: `/bin/bash`.
- Home: `/home/hatch` (`~`) persists across VM replacements. `/tmp` is Scratch: ephemeral, never store anything durable there.
- Standing files: the canonical list lives in `AGENTS.md` under *Terms*. Of them, `~/HEARTBEAT.md` and `~/PROACTIVE_PREFERENCES.md` are intentionally empty - no standing checks or proactive preferences approved.
- Workspace: `~/workspace/` with `code/`, `learning/` (plus `INDEX.md`), `research/` (plus `INDEX.md`); goal and user-facing files follow the runtime layout.

## Git and GitHub

- `git` 2.43.0 and GitHub CLI `gh` 2.102.0, both at `/usr/bin/`.
- Global git config: `user.name azrialwork`, `user.email azrial.work@gmail.com`, `init.defaultBranch main`.
- `gh` is logged in to github.com as `azrialwork` (account name Muhammad Azrial, id 263097531), active account, HTTPS protocol. `gh auth setup-git` has been run: `gh` is the credential helper for github.com and gist.github.com.
- SSH keys live under `~/.ssh/`; never expose their contents.

## Notes

- Update a fact here when its verification command shows it changed, and update the verification date with it.
- Do not store secret values here - only where a credential lives, never what it is.
