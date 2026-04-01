--- Ghostty theme registration for Neovim.
---
--- Ghostty ships ~463 terminal themes as simple palette files (16 ANSI colors
--- + bg/fg/cursor/selection). This module makes them available as Neovim
--- colorschemes by converting each palette into a full set of highlight groups
--- via mini.base16.
---
--- Architecture:
---   1. register() scans Ghostty's themes directory for filenames.
---   2. For each theme, a tiny stub file is written into a cache directory:
---        ~/.cache/nvim/ghostty-colors/colors/ghostty-<slug>.lua
---      Each stub just calls: require("user.ghostty_themes").apply("<Name>")
---   3. The cache dir is appended to 'runtimepath', so Neovim's :colorscheme
---      and Telescope's picker discover all ghostty-* themes automatically.
---   4. Stubs are only regenerated when the theme list changes (tracked via a
---      manifest file). The reverse lookup table (_slug_to_name) is always
---      rebuilt so theme_sync.lua can map slugs back to original names.
---
--- On-demand loading:
---   When a ghostty-* colorscheme is activated, apply() runs for the first
---   time — it parses the theme file, builds a base16 palette, and calls
---   mini.base16.setup(). This keeps startup fast (no theme files are read
---   until one is selected).
---
--- Dependencies:
---   - echasnovski/mini.base16 (lazy-loaded: only required inside apply())
---
--- Consumed by:
---   - colorsheme.lua (plugin spec that calls register() at startup)
---   - theme_sync.lua (reads _slug_to_name + parse_theme for Ghostty sync)
---
--- Debugging:
---   :lua =require("user.ghostty_themes")._slug_to_name  -- dump reverse map
---   :lua =vim.fn.stdpath("cache") .. "/ghostty-colors"  -- cache location
---   To force stub regeneration: delete the cache dir and restart Neovim.

local M = {}

--- Where Ghostty installs its built-in themes (macOS app bundle path).
--- On Linux this would be something like /usr/share/ghostty/themes.
M.THEMES_DIR = "/Applications/Ghostty.app/Contents/Resources/ghostty/themes"

local CACHE_DIR = vim.fn.stdpath("cache") .. "/ghostty-colors"
local COLORS_DIR = CACHE_DIR .. "/colors"
local PREFIX = "ghostty-"

--- Reverse lookup: Neovim colorscheme slug → original Ghostty theme filename.
--- Built during register(), consumed by theme_sync.lua to resolve ghostty-*
--- colorscheme names back to their Ghostty theme name for config sync.
M._slug_to_name = {}

--- Convert a Ghostty theme name to a Neovim colorscheme slug.
--- "Catppuccin Mocha" → "ghostty-catppuccin-mocha"
--- "Dracula+"         → "ghostty-dracula-plus"  ('+' gets special handling)
function M.slugify(name)
  local s = name:lower():gsub("%+", " plus")
  return PREFIX .. s:gsub("[^%w]+", "-"):gsub("^-+", ""):gsub("-+$", "")
end

local function hex_to_rgb(hex)
  hex = hex:gsub("^#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

--- Parse a Ghostty theme file into its two components.
--- @param name string  The Ghostty theme filename (e.g. "Catppuccin Mocha")
--- @return table palette  ANSI colors indexed 0-15 (e.g. palette[1] = "#f38ba8")
--- @return table props    Named properties (background, foreground, cursor-color, etc.)
---
--- Ghostty theme file format (key = value, one per line):
---   palette = 0=#45475a
---   palette = 1=#f38ba8
---   ...
---   background = #1e1e2e
---   foreground = #cdd6f4
---   cursor-color = #f5e0dc
function M.parse_theme(name)
  local path = M.THEMES_DIR .. "/" .. name
  local palette = {}
  local props = {}
  for line in io.lines(path) do
    local trimmed = line:match("^%s*(.-)%s*$")
    if trimmed ~= "" and not trimmed:match("^#") then
      local key, value = trimmed:match("^(%S+)%s*=%s*(.+)$")
      if key == "palette" then
        local idx, color = value:match("^(%d+)=(.+)$")
        if idx then palette[tonumber(idx)] = color end
      elseif key and value then
        props[key] = value
      end
    end
  end
  return palette, props
end

--- Convert a Ghostty palette into a base16 palette for mini.base16.
---
--- Strategy: use mini_palette(bg, fg) for the shade ramp (base00-base07),
--- which gives a perceptually uniform gradient. Then override the accent
--- slots (base08-base0F) with the theme's actual ANSI colors so each
--- theme retains its distinctive character.
---
--- ANSI → base16 accent mapping:
---   palette[1]  (red)            → base08  (variables, errors, diff deleted)
---   palette[9]  (bright red)     → base09  (constants, booleans)
---   palette[3]  (yellow)         → base0A  (classes, search highlight)
---   palette[2]  (green)          → base0B  (strings, diff inserted)
---   palette[6]  (cyan)           → base0C  (regex, escape characters)
---   palette[4]  (blue)           → base0D  (functions, methods)
---   palette[5]  (magenta)        → base0E  (keywords, storage)
---   palette[11] (bright yellow)  → base0F  (deprecated, delimiters)
function M.to_base16_palette(palette, props)
  local bg = props["background"] or palette[0] or "#000000"
  local fg = props["foreground"] or palette[15] or "#ffffff"

  local base = require("mini.base16").mini_palette(bg, fg, 50)

  if palette[1] then base.base08 = palette[1] end
  if palette[9] then base.base09 = palette[9] end
  if palette[3] then base.base0A = palette[3] end
  if palette[2] then base.base0B = palette[2] end
  if palette[6] then base.base0C = palette[6] end
  if palette[4] then base.base0D = palette[4] end
  if palette[5] then base.base0E = palette[5] end
  if palette[11] then base.base0F = palette[11] end

  return base
end

--- Apply a Ghostty theme as the active Neovim colorscheme.
--- Called from the generated stub files in the cache directory.
function M.apply(ghostty_name)
  local palette, props = M.parse_theme(ghostty_name)
  local base16_palette = M.to_base16_palette(palette, props)

  -- Auto-detect light/dark from background luminance (ITU-R BT.601)
  local bg = props["background"] or palette[0] or "#000000"
  local r, g, b = hex_to_rgb(bg)
  local luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
  vim.o.background = luminance > 0.5 and "light" or "dark"

  -- Needed for mini.base16; auto-set in real terminals but not in --headless
  vim.o.termguicolors = true

  require("mini.base16").setup({
    palette = base16_palette,
    use_cterm = true,
  })

  vim.g.colors_name = M.slugify(ghostty_name)
end

--- Scan Ghostty's themes directory and register all themes as Neovim
--- colorschemes. Safe to call on non-Ghostty systems (silently no-ops).
---
--- This writes stub .lua files into ~/.cache/nvim/ghostty-colors/colors/
--- and appends that directory to 'runtimepath'. Stubs are only regenerated
--- when the theme list changes (detected via a manifest file).
function M.register()
  local stat = vim.uv.fs_stat(M.THEMES_DIR)
  if not stat then return end -- Ghostty not installed; silently skip

  local handle = vim.uv.fs_scandir(M.THEMES_DIR)
  if not handle then return end

  local themes = {}
  while true do
    local name, ftype = vim.uv.fs_scandir_next(handle)
    if not name then break end
    if ftype == "file" then
      table.insert(themes, name)
    end
  end

  -- Always rebuild the reverse lookup (needed by theme_sync.lua even when
  -- stubs are cached). This is cheap — just string operations, no file I/O.
  for _, name in ipairs(themes) do
    M._slug_to_name[M.slugify(name)] = name
  end

  -- Compare against manifest to skip expensive stub regeneration.
  -- The manifest is a newline-separated list of theme filenames.
  local manifest_path = CACHE_DIR .. "/manifest"
  local manifest_content = table.concat(themes, "\n")
  local f = io.open(manifest_path, "r")
  if f then
    local existing = f:read("*a")
    f:close()
    if existing == manifest_content then
      vim.opt.runtimepath:append(CACHE_DIR)
      return
    end
  end

  -- (Re)generate one-liner stub files. Each stub delegates to apply():
  --   require("user.ghostty_themes").apply("Catppuccin Mocha")
  vim.fn.delete(COLORS_DIR, "rf")
  vim.fn.mkdir(COLORS_DIR, "p")

  for _, name in ipairs(themes) do
    local slug = M.slugify(name)
    local filepath = COLORS_DIR .. "/" .. slug .. ".lua"
    local fw = io.open(filepath, "w")
    if fw then
      fw:write(string.format('require("user.ghostty_themes").apply(%q)\n', name))
      fw:close()
    end
  end

  local mf = io.open(manifest_path, "w")
  if mf then
    mf:write(manifest_content)
    mf:close()
  end

  vim.opt.runtimepath:append(CACHE_DIR)
end

return M
