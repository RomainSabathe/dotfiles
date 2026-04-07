-- Colorscheme plugins with lazy-loading.
--
-- Only the plugin that provides the currently persisted theme (stored in
-- ~/.config/nvim/.theme) is eager-loaded at startup. All others are lazy
-- and load on demand when selected via :colorscheme or <leader>fk.
--
-- To add a new colorscheme plugin:
--   1. Add an entry to `schemes` below with its spec and theme names
--   2. Add the Ghostty mapping in theme_sync.lua (optional, for terminal sync)

local DEFAULT_COLORSCHEME = "github_dark"

-- Read the persisted theme before any plugin loads.
local function read_theme()
  local f = io.open(vim.fn.stdpath("config") .. "/.theme", "r")
  if not f then return nil end
  local name = f:read("*l")
  f:close()
  return (name and name ~= "") and name or nil
end

local active = read_theme() or DEFAULT_COLORSCHEME

-- Each entry: { spec = <lazy.nvim plugin spec>, themes = <list of colorscheme names> }
local schemes = {
  -- Catppuccin -- latte, frappe, macchiato, mocha
  {
    spec = {
      "catppuccin/nvim",
      name = "catppuccin",
      opts = { flavour = "macchiato", transparent_background = false },
    },
    themes = { "catppuccin", "catppuccin-latte", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha" },
  },
  -- Kanagawa -- wave, dragon, lotus
  {
    spec = { "rebelot/kanagawa.nvim" },
    themes = { "kanagawa", "kanagawa-wave", "kanagawa-dragon", "kanagawa-lotus" },
  },
  -- Rose Pine -- main, moon, dawn
  {
    spec = { "rose-pine/neovim", name = "rose-pine", opts = { variant = "main" } },
    themes = { "rose-pine", "rose-pine-main", "rose-pine-moon", "rose-pine-dawn" },
  },
  -- Everforest -- dark/light, hard/medium/soft
  {
    spec = {
      "sainnhe/everforest",
      config = function()
        vim.g.everforest_background = "medium"
        vim.g.everforest_better_performance = 1
      end,
    },
    themes = { "everforest" },
  },
  -- Gruvbox -- dark/light, hard/soft contrast
  {
    spec = { "ellisonleao/gruvbox.nvim", opts = { contrast = "hard" } },
    themes = { "gruvbox" },
  },
  -- TokyoNight -- night, storm, moon, day
  {
    spec = { "folke/tokyonight.nvim", opts = { style = "night" } },
    themes = { "tokyonight", "tokyonight-night", "tokyonight-storm", "tokyonight-moon", "tokyonight-day" },
  },
  -- GitHub -- dark, dark_default, dark_dimmed, light, light_default, etc.
  {
    spec = { "projekt0n/github-nvim-theme" },
    themes = {
      "github_dark", "github_dark_default", "github_dark_dimmed",
      "github_dark_colorblind", "github_dark_high_contrast", "github_dark_tritanopia",
      "github_light", "github_light_default", "github_light_colorblind",
      "github_light_high_contrast", "github_light_tritanopia",
    },
  },
  -- Dracula
  {
    spec = { "Mofiqul/dracula.nvim" },
    themes = { "dracula", "dracula-soft" },
  },
  -- OneDark -- dark, darker, cool, deep, warm, warmer
  {
    spec = { "navarasu/onedark.nvim", opts = { style = "dark" } },
    themes = { "onedark" },
  },
  -- Nightfox -- nightfox, nordfox, dawnfox, duskfox, carbonfox, terafox, dayfox
  {
    spec = { "EdenEast/nightfox.nvim" },
    themes = { "nightfox", "nordfox", "dawnfox", "duskfox", "carbonfox", "terafox", "dayfox" },
  },
  -- Material -- darker, lighter, oceanic, palenight, deep ocean
  {
    spec = {
      "marko-cerovac/material.nvim",
      config = function()
        vim.g.material_style = "darker"
      end,
    },
    themes = { "material", "material-darker", "material-lighter", "material-oceanic", "material-palenight", "material-deep-ocean" },
  },
  -- Nord
  {
    spec = { "shaunsingh/nord.nvim" },
    themes = { "nord" },
  },
  -- Edge -- default, aura, neon
  {
    spec = {
      "sainnhe/edge",
      config = function()
        vim.g.edge_style = "aura"
        vim.g.edge_better_performance = 1
      end,
    },
    themes = { "edge" },
  },
  -- Melange -- dark/light
  {
    spec = { "savq/melange-nvim" },
    themes = { "melange" },
  },
  -- Cyberdream -- dark/light, high-contrast futuristic
  {
    spec = { "scottmckendry/cyberdream.nvim" },
    themes = { "cyberdream" },
  },
  -- Zenbones -- zenbones, zenwritten, neobones, vimbones, rosebones, etc.
  {
    spec = { "zenbones-theme/zenbones.nvim", dependencies = { "rktjmp/lush.nvim" } },
    themes = { "zenbones", "zenwritten", "duckbones", "kanagawabones", "neobones", "nordbones", "rosebones", "seoulbones", "vimbones", "zenburned" },
  },
  -- OneDarkPro -- onedark, onelight, onedark_vivid, onedark_dark
  {
    spec = { "olimorris/onedarkpro.nvim" },
    themes = { "onedark_vivid", "onedark_dark", "onelight" },
  },
  -- VSCode -- dark/light
  {
    spec = { "Mofiqul/vscode.nvim" },
    themes = { "vscode" },
  },
  -- Sonokai -- default, atlantis, andromeda, shusia, maia, espresso
  {
    spec = {
      "sainnhe/sonokai",
      config = function()
        vim.g.sonokai_style = "default"
        vim.g.sonokai_better_performance = 1
      end,
    },
    themes = { "sonokai" },
  },
  -- Gruvbox Material -- dark/light, hard/medium/soft
  {
    spec = {
      "sainnhe/gruvbox-material",
      config = function()
        vim.g.gruvbox_material_background = "medium"
        vim.g.gruvbox_material_better_performance = 1
      end,
    },
    themes = { "gruvbox-material" },
  },
  -- Nightfly
  {
    spec = { "bluz71/vim-nightfly-colors", name = "nightfly" },
    themes = { "nightfly" },
  },
  -- Moonfly
  {
    spec = { "bluz71/vim-moonfly-colors", name = "moonfly" },
    themes = { "moonfly" },
  },
  -- Oxocarbon -- dark/light
  {
    spec = { "nyoom-engineering/oxocarbon.nvim" },
    themes = { "oxocarbon" },
  },
  -- Modus -- modus_operandi (light), modus_vivendi (dark), + tinted/deuteranopia/tritanopia variants
  {
    spec = { "miikanissi/modus-themes.nvim" },
    themes = { "modus", "modus_vivendi", "modus_operandi" },
  },
  -- Night Owl
  {
    spec = { "oxfist/night-owl.nvim" },
    themes = { "night-owl" },
  },
  -- Bamboo -- dark/light, multiplex, vulgaris
  {
    spec = { "ribru17/bamboo.nvim", opts = {} },
    themes = { "bamboo", "bamboo-multiplex", "bamboo-vulgaris" },
  },
  -- Bluloco -- dark/light
  {
    spec = { "uloco/bluloco.nvim", dependencies = { "rktjmp/lush.nvim" } },
    themes = { "bluloco", "bluloco-dark", "bluloco-light" },
  },
  -- Everviolet (formerly rose pine inspired)
  {
    spec = { "everviolet/nvim", name = "everviolet" },
    themes = { "evergarden", "evergarden-fall", "evergarden-spring", "evergarden-summer", "evergarden-winter" },
  },
  -- Mellifluous -- multiple sub-themes
  {
    spec = { "ramojus/mellifluous.nvim" },
    themes = { "mellifluous" },
  },
  -- Mellow
  {
    spec = { "mellow-theme/mellow.nvim" },
    themes = { "mellow" },
  },
}

-- Export the full list of theme names so the Telescope picker (theme_sync.lua)
-- can show all available themes without needing every plugin to be loaded.
local all_themes = {}
for _, entry in ipairs(schemes) do
  for _, t in ipairs(entry.themes) do
    all_themes[#all_themes + 1] = t
  end
end
table.sort(all_themes)
_G._colorscheme_list = all_themes

-- Build the final spec list.
-- The plugin matching the active theme gets lazy=false + priority=1000.
-- All others get lazy=true and load on demand via :colorscheme.
local specs = {}
for _, entry in ipairs(schemes) do
  local is_active = false
  for _, t in ipairs(entry.themes) do
    if t == active then is_active = true; break end
  end
  local s = entry.spec
  s.lazy = not is_active
  if is_active then s.priority = 1000 end
  specs[#specs + 1] = s
end

-- ── Infrastructure ─────────────────────────────────────────────

-- Telescope colorscheme picker with Ghostty sync + persistence
specs[#specs + 1] = {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>fk",
      function() require("user.theme_sync").create_picker() end,
      desc = "Colorscheme picker (syncs Ghostty)",
    },
  },
}

-- Apply persisted colorscheme on startup + set up Ghostty sync
specs[#specs + 1] = {
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
}

return specs
