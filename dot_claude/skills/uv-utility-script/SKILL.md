---
name: uv-utility-script
description: Write standalone Python utility scripts that use `uv run --script` with PEP 723 inline metadata. Use when the user asks to create a CLI tool, utility script, helper command, or small standalone program in Python. Triggers on requests like "write me a script to...", "make a CLI tool that...", "create a command for...", or any task that calls for a self-contained executable Python script. Scripts use typer for CLI parsing and rich for terminal output, are placed in ~/.local/bin/custom/ without a .py extension, and are immediately runnable via uv.
---

# uv Utility Script

Write self-contained Python CLI scripts that run via `uv run --script` with zero setup.

## Script Template

Every script follows this exact structure:

```python
#!/usr/bin/env -S uv run --script
#
# /// script
# requires-python = ">=3.12"
# dependencies = ["typer", "rich"]
# ///
#
# <script-name> — One-line description of what this script does.
#
# <Longer explanation of what the script does, why it exists, and any
# important behavioral details. Keep it practical — explain what a user
# needs to know before running it.>
#
# Usage:
#   <script-name> <args>
#   <script-name> --option <value> <args>
#   <script-name> --dry-run <args>
#
# Requirements:
#   - <any non-Python requirements, e.g. "must be run as root">

import typer
from rich.console import Console

console = Console()
app = typer.Typer()


@app.command()
def main(name: str, count: int = 5, verbose: bool = False) -> None:
    """Typer docstring — shown by --help."""
    ...


if __name__ == "__main__":
    app()
```

## Conventions

- **Location**: `~/.local/bin/custom/<script-name>` — no `.py` extension.
- **Executable**: always `chmod +x` after writing.
- **CLI parsing**: always `typer`. Never `click` or `argparse` directly.
- **Terminal output**: always `rich` (`Console`, `Table`, `Progress`, etc.). Never bare `print()`.
- **Dependencies**: declare in the PEP 723 `# /// script` block. Always include `typer` and `rich`. Add others as needed.
- **Let typer infer from type hints**: a bare `name: str` becomes a positional argument, `count: int = 5` becomes `--count` with default 5, `verbose: bool = False` becomes a `--verbose` flag. No `Annotated` needed for simple cases.
- **Underscores become hyphens automatically**: `dry_run: bool = False` becomes `--dry-run` on the CLI. No `Annotated` needed.
- **Use `Annotated` only when customizing** beyond what the type hint conveys: path validation (`exists=True`, `file_okay=False`), custom help text, short flags (`-d`), renamed CLI options, or `min`/`max` constraints.
- **Path arguments**: use `Path` type with typer's built-in validation (`exists=True`, `file_okay=False`, `resolve_path=True`, etc.) via `Annotated`.
- **Header comment block**: always present, includes script name, one-line description, longer explanation, usage examples, and requirements.
- **`--dry-run` flag**: include whenever the script performs side effects (file changes, network requests, etc.). Dry run previews changes without applying them.
- **Naming**: lowercase, hyphen-separated, specific and descriptive. `fix-permissions`, `tag-albums`, `resize-images` — not `util`, `helper`, `tool`.
- **Scope**: one script = one job. Keep it focused.
- **Error handling**: raise `typer.Exit(code=1)` or `typer.Abort()` instead of `sys.exit(1)`.
