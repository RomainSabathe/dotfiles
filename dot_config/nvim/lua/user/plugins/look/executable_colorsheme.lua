-- Fallback if no persisted theme is found
local DEFAULT_COLORSCHEME = "github_dark"

return {
  -- Colorscheme collection
  -- All plugins are eagerly loaded so their colors/ stubs are registered for
  -- :colorscheme <Tab> and the Telescope picker. They don't apply highlights
  -- until actually selected.

  -- Catppuccin — latte, frappe, macchiato, mocha
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "macchiato",
      transparent_background = false,
    },
  },
  -- Kanagawa — wave, dragon, lotus
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Rose Pine — main, moon, dawn
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "main",
    },
  },
  -- Everforest — dark/light, hard/medium/soft
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_better_performance = 1
    end,
  },
  -- Gruvbox — dark/light, hard/soft contrast
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      contrast = "hard",
    },
  },
  -- TokyoNight — night, storm, moon, day
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
    },
  },
  -- GitHub — dark, dark_default, dark_dimmed, light, light_default, etc.
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
  },
  -- Dracula
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
  },
  -- OneDark — dark, darker, cool, deep, warm, warmer
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark",
    },
  },
  -- Nightfox — nightfox, nordfox, dawnfox, duskfox, carbonfox, terafox, dayfox
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Material — darker, lighter, oceanic, palenight, deep ocean
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.material_style = "darker"
    end,
  },
  -- Nord
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Edge — default, aura, neon
  {
    "sainnhe/edge",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.edge_style = "aura"
      vim.g.edge_better_performance = 1
    end,
  },
  -- Melange — dark/light
  {
    "savq/melange-nvim",
    lazy = false,
    priority = 1000,
  },
  -- Cyberdream — dark/light, high-contrast futuristic
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Zenbones — zenbones, zenwritten, neobones, vimbones, rosebones, etc.
  {
    "zenbones-theme/zenbones.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
  },
  -- OneDarkPro — onedark, onelight, onedark_vivid, onedark_dark
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
  },
  -- VSCode — dark/light
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Sonokai — default, atlantis, andromeda, shusia, maia, espresso
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.sonokai_style = "default"
      vim.g.sonokai_better_performance = 1
    end,
  },
  -- Gruvbox Material — dark/light, hard/medium/soft
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
    end,
  },
  -- Nightfly
  {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = false,
    priority = 1000,
  },
  -- Moonfly
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
  },
  -- Oxocarbon — dark/light
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Modus — modus_operandi (light), modus_vivendi (dark), + tinted/deuteranopia/tritanopia variants
  {
    "miikanissi/modus-themes.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Night Owl
  {
    "oxfist/night-owl.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Bamboo — dark/light, multiplex, vulgaris
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Bluloco — dark/light
  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
  },
  -- Everviolet (formerly rosé pine inspired)
  {
    "everviolet/nvim",
    name = "everviolet",
    lazy = false,
    priority = 1000,
  },
  -- Mellifluous — multiple sub-themes
  {
    "ramojus/mellifluous.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Mellow
  {
    "mellow-theme/mellow.nvim",
    lazy = false,
    priority = 1000,
  },

  -- ── Infrastructure ─────────────────────────────────────────────

  -- Telescope colorscheme picker with Ghostty sync + persistence
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fk",
        function() require("user.theme_sync").create_picker() end,
        desc = "Colorscheme picker (syncs Ghostty)",
      },
    },
  },

  -- Apply persisted colorscheme on startup + set up Ghostty sync
  {
    "theme-setup",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 999,
    config = function()
      local sync = require("user.theme_sync")
      sync.setup()

      local theme = sync.load_nvim_theme() or DEFAULT_COLORSCHEME
      local ok = pcall(vim.cmd.colorscheme, theme)
      if not ok then
        vim.cmd.colorscheme(DEFAULT_COLORSCHEME)
      end
    end,
  },
}
