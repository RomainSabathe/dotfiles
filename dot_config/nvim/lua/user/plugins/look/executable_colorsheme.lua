-- Fallback if no persisted theme is found
local DEFAULT_COLORSCHEME = "github_dark"

return {
  -- Colorscheme collection
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
      transparent_background = false,
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "main", -- auto, main, moon, or dawn
    },
  },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "medium" -- hard, medium, soft
      vim.g.everforest_better_performance = 1
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      contrast = "hard", -- hard, soft, or empty
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- storm, moon, night, day
    },
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark", -- dark, darker, cool, deep, warm, warmer
    },
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.material_style = "darker" -- darker, lighter, oceanic, palenight, deep ocean
    end,
  },
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "sainnhe/edge",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.edge_style = "aura" -- default, aura, neon
      vim.g.edge_better_performance = 1
    end,
  },
  {
    "savq/melange-nvim",
    lazy = false,
    priority = 1000,
  },

  -- Telescope colorscheme picker with Ghostty sync + persistence
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fk", -- f kolor
        function() require("user.theme_sync").create_picker() end,
        desc = "Colorscheme picker (syncs Ghostty)",
      },
    },
  },

  -- Rendering engine for Ghostty terminal themes → full Neovim colorschemes
  {
    "echasnovski/mini.base16",
    lazy = true,
  },

  -- Register Ghostty themes + set up sync + apply persisted/default colorscheme
  {
    "ghostty-themes",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 999,
    config = function()
      require("user.ghostty_themes").register()

      local sync = require("user.theme_sync")
      sync.setup()

      local theme = sync.load_nvim_theme() or DEFAULT_COLORSCHEME
      vim.cmd("colorscheme " .. theme)
    end,
  },
}
