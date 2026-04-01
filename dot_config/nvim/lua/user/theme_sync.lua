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
---   2. The autocmd resolves the Neovim colorscheme name to a Ghostty theme:
---        - ghostty-* slugs  → reverse-lookup via ghostty_themes._slug_to_name
---        - curated plugins  → explicit NVIM_TO_GHOSTTY mapping table below
---        - unknown themes   → no sync (we don't guess)
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
---   :lua vim.cmd("colorscheme ghostty-nord")               -- triggers sync
---   cat ~/.config/ghostty/theme                            -- check Ghostty side
---   To test reload: osascript -e 'tell application "System Events" to key code 43 using {command down, shift down}'
---
--- Dependencies:
---   - user.ghostty_themes (parse_theme, _slug_to_name)
---   - osascript (macOS only — the reload mechanism is macOS-specific)
---   - Ghostty config: config-file = ?theme  (in ~/.config/ghostty/config)

local M = {}

local gt = require("user.ghostty_themes")

local NVIM_THEME_FILE = vim.fn.stdpath("config") .. "/.theme"
local GHOSTTY_THEME_FILE = vim.fn.expand("~/.config/ghostty/theme")

--- Manual mapping for the curated Neovim theme plugins → Ghostty built-in names.
--- ghostty-* themes don't need entries here; they're resolved automatically
--- via ghostty_themes._slug_to_name.
---
--- To add a new curated theme: install the plugin in colorsheme.lua, then add
--- the Neovim colorscheme name (run :colorscheme <Tab> to discover it) mapped
--- to the Ghostty theme name (run: ghostty +list-themes | grep -i <name>).
local NVIM_TO_GHOSTTY = {
  ["catppuccin-macchiato"] = "Catppuccin Macchiato",
  ["catppuccin-mocha"] = "Catppuccin Mocha",
  ["catppuccin-frappe"] = "Catppuccin Frappe",
  ["catppuccin-latte"] = "Catppuccin Latte",
  ["kanagawa-wave"] = "Kanagawa Wave",
  ["kanagawa"] = "Kanagawa Wave",
  ["kanagawa-dragon"] = "Kanagawa Dragon",
  ["kanagawa-lotus"] = "Kanagawa Lotus",
  ["rose-pine"] = "Rose Pine",
  ["rose-pine-moon"] = "Rose Pine Moon",
  ["rose-pine-dawn"] = "Rose Pine Dawn",
  ["everforest"] = "Everforest Dark Hard",
  ["gruvbox"] = "Gruvbox Dark",
  ["tokyonight-night"] = "TokyoNight Night",
  ["tokyonight-storm"] = "TokyoNight Storm",
  ["tokyonight-moon"] = "TokyoNight Moon",
  ["tokyonight-day"] = "TokyoNight Day",
  ["tokyonight"] = "TokyoNight",
  ["github_dark"] = "GitHub Dark",
  ["github_dark_default"] = "GitHub Dark Default",
  ["github_dark_dimmed"] = "GitHub Dark Dimmed",
  ["github_light"] = "GitHub Light Default",
  ["github_light_default"] = "GitHub Light Default",
  ["dracula"] = "Dracula",
  ["dracula-soft"] = "Dracula",
  ["onedark"] = "Atom One Dark",
  ["nightfox"] = "Nightfox",
  ["nordfox"] = "Nordfox",
  ["dawnfox"] = "Dawnfox",
  ["duskfox"] = "Duskfox",
  ["carbonfox"] = "Carbonfox",
  ["terafox"] = "Terafox",
  ["dayfox"] = "Dayfox",
  ["material-darker"] = "Material Darker",
  ["material-oceanic"] = "Material Ocean",
  ["material-deep-ocean"] = "Material Dark",
  ["material"] = "Material Darker",
  ["nord"] = "Nord",
  ["melange"] = "Melange Dark",
}

--- Resolve a Neovim colorscheme name to its Ghostty theme name.
--- @return string|nil  Ghostty theme name, or nil if no mapping exists.
local function resolve_ghostty_theme(colorscheme)
  return gt._slug_to_name[colorscheme] or NVIM_TO_GHOSTTY[colorscheme]
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
--- Tracks the last Ghostty theme we synced to, so we can skip no-op writes
--- and restore correctly on Telescope cancel.
local last_ghostty_theme = nil

local function write_ghostty_theme(ghostty_name)
  local f = io.open(GHOSTTY_THEME_FILE, "w")
  if f then
    f:write("theme = " .. ghostty_name .. "\n")
    f:close()
  end
end

local function reload_ghostty_config()
  -- Key code 43 = comma on macOS. This simulates the Ghostty keybinding
  -- Cmd+Shift+, which is bound to the reload_config action by default.
  -- If the user has remapped this keybinding, this will break — update the
  -- key code accordingly.
  vim.fn.jobstart({
    "osascript", "-e",
    'tell application "System Events" to key code 43 using {command down, shift down}',
  }, { detach = true })
end

--- Write Ghostty theme file and schedule a debounced config reload.
local function sync_ghostty(ghostty_name)
  if ghostty_name == last_ghostty_theme then return end
  last_ghostty_theme = ghostty_name

  write_ghostty_theme(ghostty_name)

  if reload_timer then
    reload_timer:stop()
  end
  reload_timer = vim.defer_fn(reload_ghostty_config, 150)
end

--- Sync Ghostty to match the current Neovim colorscheme.
local function sync_terminal(colorscheme)
  local ghostty_name = resolve_ghostty_theme(colorscheme)
  if ghostty_name then
    sync_ghostty(ghostty_name)
  end
  -- No fallback for themes without a Ghostty equivalent — we don't
  -- want to write garbage to the Ghostty config.
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
  local before_ghostty = last_ghostty_theme
  local selected = false

  local colors = vim.fn.getcompletion("", "color")

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
        sync_ghostty(before_ghostty)
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
