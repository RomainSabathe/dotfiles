return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bufdelete = { enabled = true },
    quickfile = { enabled = true },
    indent = { enabled = true },
    bigfile = { enabled = true },
    statuscolumn = { enabled = true },

    scroll = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    input = { enabled = false },
    notifier = { enabled = false },
    picker = { enabled = false },
    scope = { enabled = false },
    words = { enabled = false },
  },
  keys = {
    { "<leader>qq", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
  }
}
