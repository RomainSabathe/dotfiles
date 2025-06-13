return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
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

    mason_lspconfig.setup({
      ensure_installed = {
        -- LSP servers
        "ruff",      -- Python (also)
        -- "pyright", -- deprecated in favor of ruff
        "lua_ls",    -- Lua
        "yamlls",    -- YAML
        "bashls",    -- Bash/Shell
        "jsonls",    -- JSON
        -- "nil_ls", -- Nix - Can't it get to work with Mason right now.
        "hydra-lsp", -- Hydra config files
      },
      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        -- Python tools
        "ruff", -- Python linter
        -- All the following are deprecated in favor of ruff
        -- "pyright", -- Python LSP
        -- "black", -- Python formatter
        -- "isort", -- Python import sorter

        -- Lua tools
        "lua_ls", -- Lua LSP
        "stylua", -- Lua formatter

        -- Web development
        "prettier", -- Multi-language formatter
        "eslint_d", -- Fast JS/TS linter

        -- Nix
        "alejandra", -- Nix formatter

        -- Shell
        "shfmt", -- Shell formatter

        -- YAML/JSON
        "yamllint", -- YAML linter

        -- SQL
        "sqruff", -- SQL linter
      },
      auto_update = false,
      run_on_start = true,
    })
  end,
}
