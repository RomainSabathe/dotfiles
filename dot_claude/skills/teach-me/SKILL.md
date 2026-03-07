---
name: teach-me
description: >
  Write a high-quality prompt for another LLM to teach the user a technical
  topic in depth. Use when the user says things like "I want to understand X
  better", "teach me about Y", "write me a learning prompt about Z", or
  "I'm confused about how X works". The skill produces a standalone markdown
  prompt file the user can paste into any LLM conversation.
---

# Teach Me — Learning Prompt Generator

Generate a self-contained prompt that the user can give to any LLM to get a
deep, personalised explanation of a technical topic.

## Workflow

1. **Identify the topic and knowledge gaps.** Review the conversation for what
   the user is trying to learn, what they already understand, and where
   confusion lies. Ask clarifying questions if the gaps are unclear.

2. **Gather grounding context.** Look at the codebase, config files, logs, or
   conversation history for concrete details that make the prompt specific to
   the user's real project — not generic.

3. **Draft the prompt.** Follow the structure below.

4. **Save the file.** Write the prompt to a markdown file at a path the user
   chooses (default: session workspace `files/` directory). Show a brief
   summary of what was written.

## Prompt Structure

Use this structure as a default. Adapt section names and ordering to the topic,
but keep all five concerns represented.

```markdown
# Prompt: Teach Me <Topic>

## Context
Who I am, what I'm working on, and what happened that triggered this learning
need. Include concrete details from the project (framework versions, cluster
specs, code snippets, log output). State current understanding honestly,
including uncertainty ("I suspect …", "I don't know …").

## What I Don't Understand
Break into numbered subtopics, each with a short title and a bulleted list of
specific questions. Questions should expose the edges of the user's mental
model — not just "what is X?" but "is X a process or a thread?", "does Y
actually enforce Z or is it just a hint?".

## How I'd Like You to Teach This
Explicit pedagogical preferences. Good defaults (remove any that don't fit):
- Analogies grounded in everyday concepts before technical detail
- Relate every concept back to my specific project
- Distinguish physical resources from scheduling/logical abstractions
- Call out common misconceptions explicitly
- Provide decision heuristics and rules of thumb
- Use ASCII diagrams where they help

## My Setup for Reference
Bullet list of versions, specs, and relevant config so the teaching LLM can
give precise, version-accurate answers.
```

Read `references/example_prompt.md` for a complete worked example that
demonstrates the tone, specificity, and level of detail to aim for.

## Writing Guidelines

- **Be concrete, not generic.** Pull real values from the codebase: version
  numbers, parameter names, resource specs, log lines. A prompt about "Ray
  clusters" should mention the user's actual cluster size and workload profile.
- **State uncertainty honestly.** Use phrases like "I suspect", "I don't know",
  "my mental model is shaky here". This tells the teaching LLM where to focus.
- **Questions should probe boundaries.** Not "what is an actor?" but "is an
  actor a process, a thread, or a container? Can multiple actors share one
  worker process?"
- **Keep it self-contained.** The prompt will be pasted into a fresh LLM
  session with no access to the user's codebase. Include enough context inline.
- **Match the user's voice.** Write in first person as the user, not as an
  assistant. The user should be able to paste it without editing.
