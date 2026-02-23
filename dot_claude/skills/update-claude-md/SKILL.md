---
name: update-claude-md
description: Add, update, or remove global instructions in ~/.claude/CLAUDE.md. Use when the user says things like "always do X", "never do Y", "remember this globally", "add this to CLAUDE.md", "stop doing X", or expresses a persistent preference that should apply across all sessions and projects.
---

# Update CLAUDE.md

Manage persistent global instructions in `~/.claude/CLAUDE.md`.

## Critical constraint

CLAUDE.md is **always loaded into context** for every session. Every line has a token cost. Treat it like premium real estate.

## Workflow

1. **Read** `~/.claude/CLAUDE.md` first — always.
2. **Check for duplicates** — if a similar instruction exists, update it rather than adding a new one.
3. **Apply the change** — add, edit, or remove the instruction.
4. **Show the user** the updated file content so they can verify.

## Writing rules

- **One bullet per instruction.** No prose, no explanations, no rationale.
- **Imperative form.** "Use `uv run`" not "You should use `uv run`".
- **Only write what Claude doesn't already know.** Don't add "write clean code" or "follow best practices".
- **Group under short `##` section headers** by topic (e.g., `## Python`, `## Git`, `## System`).
- **Use bold for the key constraint**, then a dash and details. Example: `- **Always use uv** — never raw pip or python3.`
- **No redundancy.** If two instructions can merge into one, merge them.
- **Remove stale instructions** if the user says to stop or if they contradict a new instruction.

## What belongs in CLAUDE.md vs elsewhere

| CLAUDE.md | Memory files | Project CLAUDE.md |
|-----------|-------------|-------------------|
| Global tool/workflow preferences | Session learnings, skill notes | Project-specific conventions |
| System environment facts | Debugging insights | Repo-specific build/test commands |
| Universal "always/never" rules | Historical context | Team coding standards |
