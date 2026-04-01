return {
  dir = "~/git/nvim/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  opts = {
    explorer = {
      view_mode = "tree",
    },
    keymaps = {
      view = {
        quit = "<leader>x", -- disable
        stage_hunk = "<leader>ds",
      }
    }
  }
}
