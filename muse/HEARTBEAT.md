# HEARTBEAT.md

## Precedence

Boss's explicit instruction for this task — Boss wins inside the config file and above the config file.

> Why: small drift compounds when nobody watches it. A short check on each tick catches layout rot, stale learning entries, and unreadable indexes before they pile up.

Run these checks on each tick. A tick is one runtime-managed heartbeat run. Surface each new finding once. Never repeat the same flag on consecutive ticks.

Scope: `learning/` means `azrial/learning/`. `repos` means git repos under `azrial/code/`. Paths that start with `azrial/` are relative to `$HOME/workspace`.

1. Learning hygiene: every `azrial/learning/INDEX.md` line must match an existing file, and every learning entry file must have an `INDEX.md` line. Flag mismatches.
2. Learning activity: repos with new commits in the last 14 days but no new learning entry. Flag the gap.
3. Learning index scannability: flag if `azrial/learning/INDEX.md` exceeds about 40 lines, so it can be archived or split.
4. Workspace layout: flag any top-level folder under `azrial/` outside `code`, `research`, `tmp`, `learning`. New top-level folders need Boss's explicit approval.
