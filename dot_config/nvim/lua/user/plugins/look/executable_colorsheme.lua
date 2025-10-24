-- Set your default colorscheme here
local DEFAULT_COLORSCHEME = "everforest"

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

  -- Telescope for colorscheme picker
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fk", -- f kolor
        "<cmd>Telescope colorscheme enable_preview=true<cr>",
        desc = "Colorscheme picker",
      },
    },
    opts = {
      pickers = {
        colorscheme = {
          enable_preview = true,
        },
      },
    },
  },

  -- Apply default colorscheme
  {
    "default-colorscheme",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 999, -- Load after colorscheme plugins
    config = function()
      vim.cmd("colorscheme " .. DEFAULT_COLORSCHEME)
    end,
  },
}
