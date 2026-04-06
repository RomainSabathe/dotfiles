return {
  "williamboman/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        -- Python
        "ruff",           -- Python linter/formatter (also LSP via `ruff server`)
        "ty",             -- Python type checker (also LSP via `ty server`)
        "basedpyright",   -- Strict Python type checker (diagnostics)

        -- Lua
        "lua-language-server",
        "stylua",

        -- Web development
        "prettier",
        "eslint_d",

        -- Nix
        "alejandra",

        -- Shell
        "shfmt",

        -- YAML/JSON
        "yamllint",

        -- SQL
        "sqruff",

        -- Other LSP servers
        "hydra-lsp",
      },
      auto_update = false,
      run_on_start = true,
    })
  end,
}
