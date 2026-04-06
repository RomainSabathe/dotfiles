return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    {
      "isak102/telescope-git-file-history.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "tpope/vim-fugitive"
      }
    }, {
    "fdschmidt93/telescope-egrepify.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  }
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
        file_ignore_patterns = { "%.png$", "%.jpg$" },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("git_file_history")
    telescope.load_extension("egrepify")

    -- Navigating files
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
    vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })

    -- Navigating buffers
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Fuzzy find buffer" })
    vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Fuzzy find marks" })

    -- Searching
    vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
    vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })

    -- Override Neovim 0.12's built-in LSP mappings with Telescope pickers
    -- (shows results in a fuzzy finder instead of a quickfix/split).
    vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to definition" })
    vim.keymap.set("n", "grr", builtin.lsp_references, { desc = "List references" })
    vim.keymap.set("n", "gri", builtin.lsp_implementations, { desc = "List implementations" })
    vim.keymap.set("n", "grt", builtin.lsp_type_definitions, { desc = "Go to type definition" })
    vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "List LSP document symbols in cwd" })

    -- Git
    vim.keymap.set("n", "<leader>fgb", builtin.git_branches, { desc = "List git branches" })
    vim.keymap.set("n", "<leader>fgc", builtin.git_commits, { desc = "List git commits" })
    vim.keymap.set(
      "n",
      "<leader>fgC",
      builtin.git_bcommits,
      { desc = "List git commits related to current buffer" }
    )
    vim.keymap.set("n", "<leader>fgh", telescope.extensions.git_file_history.git_file_history,
      { desc = "List git file history" })
  end,
}
