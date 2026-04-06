-- ty: Python type checker and language server (by Astral)
-- Provides completions, go-to-definition, hover, rename, inlay hints, diagnostics
return {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', '.git' },
}
