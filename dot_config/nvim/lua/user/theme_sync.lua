--- Neovim ↔ Ghostty theme synchronisation and persistence.
---
--- Problem: when you pick a colorscheme in Neovim, Ghostty's terminal
--- chrome (tab bar, padding, other panes) stays on its old theme. We want
--- both to change together and the choice to survive restarts.
---
--- How it works:
---
---   1. A ColorScheme autocmd fires on every :colorscheme change (including
---      Telescope previews and cancellations).
---
---   2. The autocmd resolves the Neovim colorscheme name to a Ghostty theme
---      via the NVIM_TO_GHOSTTY mapping table below.
---
---   3. If a Ghostty theme is found, we:
---        a) Write it to ~/.config/ghostty/theme  (Ghostty include file)
---        b) Schedule a debounced osascript call that simulates Cmd+Shift+,
---           to trigger Ghostty's reload_config action.
---
--- Why not OSC escape sequences?
---   OSC 10/11/4 (set terminal fg/bg/palette) would be the clean solution,
---   but terminal multiplexers (zellij, tmux) intercept them — they apply
---   to the multiplexer's pane, never reaching Ghostty. The config-file +
---   osascript approach bypasses the multiplexer entirely.
---
--- Persistence:
---   - Neovim side:  ~/.config/nvim/.theme        (one line: colorscheme name)
---   - Ghostty side: ~/.config/ghostty/theme       (one line: theme = <Name>)
---   Ghostty's main config must include:  config-file = ?theme
---   (the ? suppresses errors when the file doesn't exist yet)
---
--- Telescope picker:
---   create_picker() replaces the built-in colorscheme picker with one that:
---   - Previews themes on cursor movement (Neovim + Ghostty change together)
---   - Persists the choice on Enter (writes both .theme files)
---   - Restores the original on Escape (ColorScheme autocmd handles Ghostty)
---
--- Debugging:
---   :lua =require("user.theme_sync").load_nvim_theme()    -- current persisted theme
---   :lua vim.cmd("colorscheme nord")                       -- triggers sync
---   cat ~/.config/ghostty/theme                            -- check Ghostty side
---
--- Dependencies:
---   - osascript (macOS only — the reload mechanism is macOS-specific)
---   - Ghostty config: config-file = ?theme  (in ~/.config/ghostty/config)

local M = {}

local NVIM_THEME_FILE = vim.fn.stdpath("config") .. "/.theme"
local GHOSTTY_THEME_FILE = vim.fn.expand("~/.config/ghostty/theme")

--- Mapping: Neovim colorscheme name → Ghostty built-in theme name.
---
--- To add a new theme: install the plugin in colorsheme.lua, then add the
--- Neovim colorscheme name (run :colorscheme <Tab> to discover it) mapped
--- to the Ghostty theme name (run: ghostty +list-themes | grep -i <name>).
--- Themes without an entry here just won't sync Ghostty — no harm done.
local NVIM_TO_GHOSTTY = {
  -- catppuccin/nvim
  ["catppuccin"] = "Catppuccin Frappe",
  ["catppuccin-macchiato"] = "Catppuccin Macchiato",
  ["catppuccin-mocha"] = "Catppuccin Mocha",
  ["catppuccin-frappe"] = "Catppuccin Frappe",
  ["catppuccin-latte"] = "Catppuccin Latte",
  -- rebelot/kanagawa.nvim
  ["kanagawa-wave"] = "Kanagawa Wave",
  ["kanagawa"] = "Kanagawa Wave",
  ["kanagawa-dragon"] = "Kanagawa Dragon",
  ["kanagawa-lotus"] = "Kanagawa Lotus",
  -- rose-pine/neovim
  ["rose-pine"] = "Rose Pine",
  ["rose-pine-main"] = "Rose Pine",
  ["rose-pine-moon"] = "Rose Pine Moon",
  ["rose-pine-dawn"] = "Rose Pine Dawn",
  -- sainnhe/everforest
  ["everforest"] = "Everforest Dark Hard",
  -- ellisonleao/gruvbox.nvim
  ["gruvbox"] = "Gruvbox Dark",
  -- folke/tokyonight.nvim
  ["tokyonight-night"] = "TokyoNight Night",
  ["tokyonight-storm"] = "TokyoNight Storm",
  ["tokyonight-moon"] = "TokyoNight Moon",
  ["tokyonight-day"] = "TokyoNight Day",
  ["tokyonight"] = "TokyoNight",
  -- projekt0n/github-nvim-theme
  ["github_dark"] = "GitHub Dark",
  ["github_dark_default"] = "GitHub Dark Default",
  ["github_dark_dimmed"] = "GitHub Dark Dimmed",
  ["github_dark_colorblind"] = "GitHub Dark Colorblind",
  ["github_dark_high_contrast"] = "GitHub Dark High Contrast",
  ["github_dark_tritanopia"] = "GitHub Dark",
  ["github_light"] = "GitHub Light Default",
  ["github_light_default"] = "GitHub Light Default",
  ["github_light_colorblind"] = "GitHub Light Colorblind",
  ["github_light_high_contrast"] = "GitHub Light High Contrast",
  ["github_light_tritanopia"] = "GitHub",
  -- Mofiqul/dracula.nvim
  ["dracula"] = "Dracula",
  ["dracula-soft"] = "Dracula",
  -- navarasu/onedark.nvim
  ["onedark"] = "Atom One Dark",
  -- EdenEast/nightfox.nvim
  ["nightfox"] = "Nightfox",
  ["nordfox"] = "Nordfox",
  ["dawnfox"] = "Dawnfox",
  ["duskfox"] = "Duskfox",
  ["carbonfox"] = "Carbonfox",
  ["terafox"] = "Terafox",
  ["dayfox"] = "Dayfox",
  -- marko-cerovac/material.nvim
  ["material"] = "Material Darker",
  ["material-darker"] = "Material Darker",
  ["material-lighter"] = "Material",
  ["material-oceanic"] = "Material Ocean",
  ["material-palenight"] = "Material",
  ["material-deep-ocean"] = "Material Dark",
  -- shaunsingh/nord.nvim
  ["nord"] = "Nord",
  -- savq/melange-nvim
  ["melange"] = "Melange Dark",
  -- scottmckendry/cyberdream.nvim (no Ghostty theme)
  -- zenbones-theme/zenbones.nvim
  ["zenbones"] = "Zenbones",
  ["zenwritten"] = "Zenbones",
  ["duckbones"] = "Duckbones",
  ["kanagawabones"] = "Kanagawabones",
  ["neobones"] = "Neobones Dark",
  ["nordbones"] = "Nord",
  ["seoulbones"] = "Seoulbones Light",
  ["vimbones"] = "Vimbones",
  ["zenburned"] = "Zenburned",
  -- olimorris/onedarkpro.nvim
  ["onedark_vivid"] = "Atom One Dark",
  ["onedark_dark"] = "Atom One Dark",
  -- Mofiqul/vscode.nvim (no exact Ghostty theme)
  -- sainnhe/sonokai
  ["sonokai"] = "Sonokai",
  -- sainnhe/gruvbox-material
  ["gruvbox-material"] = "Gruvbox Material Dark",
  -- bluz71/vim-nightfly-colors (no Ghostty theme)
  -- bluz71/vim-moonfly-colors
  ["moonfly"] = "Moonfly",
  -- nyoom-engineering/oxocarbon.nvim
  ["oxocarbon"] = "Oxocarbon",
  -- miikanissi/modus-themes.nvim
  ["modus"] = "Modus Vivendi",
  ["modus_vivendi"] = "Modus Vivendi",
  ["modus_operandi"] = "Modus Operandi",
  -- oxfist/night-owl.nvim
  ["night-owl"] = "Night Owl",
  -- ribru17/bamboo.nvim (no Ghostty theme)
  -- uloco/bluloco.nvim
  ["bluloco"] = "Bluloco Dark",
  ["bluloco-dark"] = "Bluloco Dark",
  ["bluloco-light"] = "Bluloco Light",
  -- everviolet/nvim (no Ghostty theme)
  -- ramojus/mellifluous.nvim
  ["mellifluous"] = "Mellifluous",
  -- mellow-theme/mellow.nvim
  ["mellow"] = "Mellow",
}

--- Resolve a Neovim colorscheme name to its Ghostty theme name.
--- @return string|nil  Ghostty theme name, or nil if no mapping exists.
local function resolve_ghostty_theme(colorscheme)
  return NVIM_TO_GHOSTTY[colorscheme]
end

-- Ghostty config-file sync ---------------------------------------------
--
-- We write the theme to ~/.config/ghostty/theme (an include file) and then
-- trigger Ghostty's config reload via osascript simulating Cmd+Shift+,.
--
-- The reload is debounced (150ms) so rapid Telescope scrolling only fires
-- one reload after the user stops moving. The theme file is written
-- immediately (cheap) — only the osascript call is debounced.
--
-- Why osascript and not a signal?
--   Ghostty doesn't watch config files for changes (confirmed wontfix in
--   github.com/ghostty-org/ghostty/issues/449). It also doesn't respond to
--   SIGHUP/SIGUSR1. The only reload mechanism is the Cmd+Shift+, keybinding,
--   which osascript can simulate via System Events.

local reload_timer = nil
--- Tracks what we last wrote to the Ghostty theme file (theme name or
--- a content fingerprint), so we can skip no-op writes.
local last_ghostty_sync = nil

local function write_ghostty_file(content)
  local f = io.open(GHOSTTY_THEME_FILE, "w")
  if f then
    f:write(content)
    f:close()
  end
end

local function reload_ghostty_config()
  -- Key code 43 = comma on macOS. This simulates the Ghostty keybinding
  -- Cmd+Shift+, which is bound to the reload_config action by default.
  vim.fn.jobstart({
    "osascript", "-e",
    'tell application "System Events" to key code 43 using {command down, shift down}',
  }, { detach = true })
end

local function schedule_reload()
  if reload_timer then
    reload_timer:stop()
  end
  reload_timer = vim.defer_fn(reload_ghostty_config, 150)
end

--- Extract a hex color from a highlight group's foreground or background.
local function hl_fg(group)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok and hl and hl.fg then return string.format("#%06x", hl.fg) end
  return nil
end

local function hl_bg(group)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok and hl and hl.bg then return string.format("#%06x", hl.bg) end
  return nil
end

--- Write a named Ghostty theme to the config file.
local function sync_ghostty_theme(ghostty_name)
  if ghostty_name == last_ghostty_sync then return end
  last_ghostty_sync = ghostty_name
  write_ghostty_file("theme = " .. ghostty_name .. "\n")
  schedule_reload()
end

--- For themes without a Ghostty equivalent, extract colors from Neovim's
--- active highlights and write them as raw Ghostty config (bg, fg, cursor,
--- selection, and a 16-color ANSI palette derived from semantic groups).
local function sync_ghostty_from_highlights()
  local bg = hl_bg("Normal") or "#000000"
  local fg = hl_fg("Normal") or "#ffffff"

  -- Build an identifier so we can skip no-op writes during rapid scrolling.
  local fingerprint = "hl:" .. bg .. fg
  if fingerprint == last_ghostty_sync then return end
  last_ghostty_sync = fingerprint

  local cursor = hl_fg("Cursor") or fg
  local sel_bg = hl_bg("Visual") or "#444444"
  local sel_fg = hl_fg("Visual") or fg
  local comment = hl_fg("Comment") or "#888888"

  -- Map semantic highlight groups → ANSI palette slots.
  local p = {
    [0]  = bg,
    [1]  = hl_fg("DiagnosticError") or hl_fg("ErrorMsg") or "#cc0000",  -- red
    [2]  = hl_fg("String")          or "#00cc00",                        -- green
    [3]  = hl_fg("Type")            or hl_fg("DiagnosticWarn") or "#cccc00", -- yellow
    [4]  = hl_fg("Function")        or "#0000cc",                        -- blue
    [5]  = hl_fg("Keyword")         or hl_fg("Statement") or "#cc00cc",  -- magenta
    [6]  = hl_fg("Special")         or "#00cccc",                        -- cyan
    [7]  = fg,                                                           -- white
    [8]  = comment,                                                      -- bright black
    [9]  = hl_fg("DiagnosticError") or hl_fg("ErrorMsg") or "#cc0000",  -- bright red
    [10] = hl_fg("String")          or "#00cc00",                        -- bright green
    [11] = hl_fg("Type")            or hl_fg("DiagnosticWarn") or "#cccc00", -- bright yellow
    [12] = hl_fg("Function")        or "#0000cc",                        -- bright blue
    [13] = hl_fg("Keyword")         or hl_fg("Statement") or "#cc00cc",  -- bright magenta
    [14] = hl_fg("Special")         or "#00cccc",                        -- bright cyan
    [15] = fg,                                                           -- bright white
  }

  local lines = {
    "background = " .. bg,
    "foreground = " .. fg,
    "cursor-color = " .. cursor,
    "selection-background = " .. sel_bg,
    "selection-foreground = " .. sel_fg,
  }
  for i = 0, 15 do
    lines[#lines + 1] = string.format("palette = %d=%s", i, p[i])
  end

  write_ghostty_file(table.concat(lines, "\n") .. "\n")
  schedule_reload()
end

--- Sync Ghostty to match the current Neovim colorscheme.
local function sync_terminal(colorscheme)
  local ghostty_name = resolve_ghostty_theme(colorscheme)
  if ghostty_name then
    sync_ghostty_theme(ghostty_name)
  else
    sync_ghostty_from_highlights()
  end
end

-- Persistence -----------------------------------------------------------

function M.load_nvim_theme()
  local f = io.open(NVIM_THEME_FILE, "r")
  if not f then return nil end
  local name = f:read("*l")
  f:close()
  if name and name ~= "" then return name end
  return nil
end

function M.save_nvim_theme(name)
  local f = io.open(NVIM_THEME_FILE, "w")
  if f then
    f:write(name .. "\n")
    f:close()
  end
end

-- Telescope picker ------------------------------------------------------

function M.create_picker(opts)
  opts = opts or {}

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local before_color = vim.g.colors_name or "default"
  local before_bg = vim.o.background
  local before_ghostty = last_ghostty_sync
  local selected = false

  -- Filter out Neovim's built-in colorschemes (no TS/LSP support).
  local builtin = {
    blue = true, darkblue = true, default = true, delek = true,
    desert = true, elflord = true, evening = true, habamax = true,
    industry = true, koehler = true, lunaperche = true, morning = true,
    murphy = true, pablo = true, peachpuff = true, quiet = true,
    retrobox = true, ron = true, shine = true, slate = true,
    sorbet = true, torte = true, unokai = true, vim = true,
    wildcharm = true, zaibatsu = true, zellner = true,
  }
  local colors = {}
  for _, c in ipairs(vim.fn.getcompletion("", "color")) do
    if not builtin[c] then
      colors[#colors + 1] = c
    end
  end

  local picker = pickers.new(opts, {
    prompt_title = "Colorscheme",
    finder = finders.new_table({ results = colors }),
    sorter = conf.generic_sorter(opts),

    attach_mappings = function(prompt_bufnr)
      -- Preview on cursor movement
      local curr_picker = action_state.get_current_picker(prompt_bufnr)
      local orig_set_selection = curr_picker.set_selection
      curr_picker.set_selection = function(self, row)
        orig_set_selection(self, row)
        local selection = action_state.get_selected_entry()
        if selection then
          pcall(vim.cmd.colorscheme, selection.value)
        end
      end

      -- Selection: apply + persist
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if not selection then return end

        selected = true
        actions.close(prompt_bufnr)
        vim.cmd.colorscheme(selection.value)

        M.save_nvim_theme(selection.value)
      end)

      return true
    end,
  })

  -- Restore on cancel
  local orig_close_windows = picker.close_windows
  picker.close_windows = function(status)
    orig_close_windows(status)
    if not selected then
      vim.o.background = before_bg
      pcall(vim.cmd.colorscheme, before_color)
      -- ColorScheme autocmd will restore Ghostty via sync_terminal.
      -- If original theme had no Ghostty mapping, restore explicitly.
      if before_ghostty and not resolve_ghostty_theme(before_color) then
        -- Restore the previous Ghostty state. If it was a named theme,
        -- write it back; otherwise the ColorScheme autocmd already handled it.
        if not before_ghostty:match("^hl:") then
          sync_ghostty_theme(before_ghostty)
        end
      end
    end
  end

  picker:find()
end

-- Setup -----------------------------------------------------------------

function M.setup()
  -- Sync terminal colors on every colorscheme change (preview, select, cancel)
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("GhosttySync", { clear = true }),
    callback = function(ev)
      sync_terminal(ev.match)
    end,
  })
end

return M
