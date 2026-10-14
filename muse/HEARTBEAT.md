# HEARTBEAT.md

Run these checks on each tick. Surface each new finding once — never repeat the same flag on consecutive ticks.

1. learning/ hygiene: every INDEX.md line must match an existing file, and every learning entry file must have an INDEX.md line — flag mismatches.
2. learning/ activity: repos with new commits in the last 14 days but no new learning entry — flag the gap.
3. learning/INDEX.md scannability: flag if it exceeds ~40 lines, so it can be archived or split.
4. azrial/ layout: flag any top-level folder under azrial/ outside {code, research, tmp, learning} — new top-level folders need Boss's explicit approval.
