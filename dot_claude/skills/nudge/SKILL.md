---
name: nudge
description: Apply when the user explicitly invokes the nudge skill; scan files modified in the current session for language-specific comments starting with AI! or AI? to make inline code changes or answer questions, then automatically remove those comments after processing.
---

# Nudge

## Core workflow

- Determine which files were modified in the current session.
- Scan those files for language-specific comments whose content (after the comment marker and optional whitespace) starts with AI! or AI?. Use `rg` to identify said-files.
- For each AI! comment, treat the remainder of the line as an inline suggestion and implement the change in the nearby code.
- For each AI? comment, answer the question in the conversation, using the current context.
- After processing each AI!/AI? comment, immediately remove that comment. Leave other comments untouched.

## Comment parsing guidance

- Treat both line comments and block comments as valid, based on the file’s language.
- Match only when the comment text itself begins with AI! or AI? after optional whitespace.
- Ignore occurrences in strings or code; only act on actual comments.
- When a block comment spans multiple lines, treat each comment line independently.

## Execution notes

- Make minimal, local changes aligned with each AI! hint.
- If a hint is ambiguous, ask a clarifying question before changing code.
- Always delete processed AI!/AI? comments after handling them.
