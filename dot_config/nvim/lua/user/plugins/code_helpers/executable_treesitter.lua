-- nvim-treesitter: parser management, highlight queries, and indentation.
--
-- IMPORTANT: requires the `tree-sitter` CLI >= 0.26.1 to compile parsers.
-- Install via: `npm install -g tree-sitter-cli` (NOT `brew install tree-sitter`
-- which only installs the library, not the CLI).
--
-- The `main` branch is required for Neovim 0.12+ — the old `master` branch is
-- frozen and incompatible. The API is a full rewrite: `require("nvim-treesitter.configs")`
-- no longer exists, highlighting is enabled via `vim.treesitter.start()`, and
-- parsers are compiled locally (not downloaded as pre-built binaries).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Install parsers (runs asynchronously, only downloads missing ones)
      require("nvim-treesitter").install({
        -- Essential
        "python", "markdown", "markdown_inline", "yaml", "toml",
        "json", "json5", "csv", "bash", "dockerfile",
        "git_rebase", "gitcommit", "gitignore",
        -- Development tools
        "ini", "sql", "html", "css", "javascript", "regex", "vim", "lua",
        -- Optional
        "cmake", "rust", "xml", "diff", "make", "rst", "vimdoc",
      })

      -- Enable treesitter highlighting and indentation for all filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
