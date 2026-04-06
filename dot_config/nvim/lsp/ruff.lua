-- Ruff: Python linter, formatter, and import organizer
-- Settings go inside init_options.settings (not top-level settings)
return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  init_options = {
    settings = {
      configurationPreference = 'filesystemFirst',
      fixAll = true,
      organizeImports = true,
      showSyntaxErrors = true,
      lint = { enable = true },
      codeAction = {
        disableRuleComment = { enable = true },
        fixViolation = { enable = true },
      },
    },
  },
}
