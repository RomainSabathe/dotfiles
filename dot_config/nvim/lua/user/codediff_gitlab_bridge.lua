--- Bridge: Create GitLab MR comments from CodeDiff diff buffers.
--- Reuses gitlab.nvim's Go backend server and popup UI.
---
--- This module connects CodeDiff's diff view (with its superior syntax
--- highlighting and diff engine) to gitlab.nvim's commenting system,
--- enabling inline MR comments and the discussion tree from CodeDiff buffers.

local Popup = require("nui.popup")
local Layout = require("nui.layout")
local state = require("gitlab.state")
local job = require("gitlab.job")
local u = require("gitlab.utils")
local popup = require("gitlab.popup")
local discussions = require("gitlab.actions.discussions")
local draft_notes = require("gitlab.actions.draft_notes")
local miscellaneous = require("gitlab.actions.miscellaneous")

local M = {}

local augroup = vim.api.nvim_create_augroup("CodeDiffGitlabBridge", { clear = true })

-- ============================================================================
-- Context extraction from CodeDiff
-- ============================================================================

--- Extract context from the current CodeDiff session.
--- Returns nil if the current window is not a CodeDiff diff pane.
--- @return table|nil { is_new_side, file_name, old_file_name, line }
function M.get_codediff_context()
  local ok, lifecycle = pcall(require, "codediff.ui.lifecycle")
  if not ok then
    return nil
  end

  local tabpage = vim.api.nvim_get_current_tabpage()
  local session = lifecycle.get_session(tabpage)
  if not session then
    return nil
  end

  local current_win = vim.api.nvim_get_current_win()
  local original_win, modified_win = lifecycle.get_windows(tabpage)
  local is_new_side = (current_win == modified_win)
  local is_old_side = (current_win == original_win)
  if not is_new_side and not is_old_side then
    return nil
  end

  local original_path, modified_path = lifecycle.get_paths(tabpage)
  local line = vim.api.nvim_win_get_cursor(current_win)[1]

  return {
    is_new_side = is_new_side,
    file_name = modified_path,
    old_file_name = (original_path ~= modified_path) and original_path or "",
    line = line,
  }
end

-- ============================================================================
-- Position data for GitLab API
-- ============================================================================

--- Build the position payload for the Go server.
--- @param ctx table from get_codediff_context()
--- @param start_line integer
--- @param end_line integer
--- @return table
function M.build_position_data(ctx, start_line, end_line)
  local revision = state.MR_REVISIONS[1]
  local data = {
    file_name = ctx.file_name,
    old_file_name = ctx.old_file_name,
    base_commit_sha = revision.base_commit_sha,
    start_commit_sha = revision.start_commit_sha,
    head_commit_sha = revision.head_commit_sha,
  }

  if ctx.is_new_side then
    data.new_line = end_line
  else
    data.old_line = end_line
  end

  -- Multi-line range (visual mode)
  if start_line ~= end_line then
    local line_key = ctx.is_new_side and "new_line" or "old_line"
    local side_type = ctx.is_new_side and "new" or "old"
    data.line_range = {
      start = { [line_key] = start_line, type = side_type },
      ["end"] = { [line_key] = end_line, type = side_type },
    }
  end

  return data
end

-- ============================================================================
-- Comment submission
-- ============================================================================

--- Submit the comment to GitLab's Go server.
--- @param text string
--- @param is_draft boolean
--- @param position_data table
function M.submit_comment(text, is_draft, position_data)
  local endpoint = is_draft and "/mr/draft_notes/" or "/mr/comment"
  local body = u.merge({ type = "text", comment = text }, position_data)
  job.run_job(endpoint, "POST", body, function()
    u.notify(is_draft and "Draft comment created!" or "Comment created!", vim.log.levels.INFO)
    if is_draft then
      draft_notes.load_draft_notes(function()
        discussions.rebuild_view(false)
      end)
    else
      discussions.rebuild_view(false)
    end
  end)
end

-- ============================================================================
-- Comment popup UI (reuses gitlab.nvim's popup modules)
-- ============================================================================

--- Open the comment popup.
--- @param position_data table
--- @param file_name string
--- @param start_line integer
--- @param end_line integer
function M.open_comment_popup(position_data, file_name, start_line, end_line)
  local popup_settings = state.settings.popup
  local title = popup.create_title("Comment", file_name, start_line, end_line)
  local settings = u.merge(popup_settings, popup_settings.comment or {})

  local current_win = vim.api.nvim_get_current_win()
  local comment_popup = Popup(popup.create_popup_state(title, settings))
  local draft_popup = Popup(popup.create_box_popup_state("Draft", false, settings))

  local internal_layout = Layout.Box({
    Layout.Box(comment_popup, { grow = 1 }),
    Layout.Box(draft_popup, { size = 3 }),
  }, { dir = "col" })

  local layout = Layout({
    position = settings.position,
    relative = "editor",
    size = {
      width = settings.width,
      height = settings.height,
    },
  }, internal_layout)

  popup.set_cycle_popups_keymaps({ comment_popup, draft_popup })
  popup.set_up_autocommands(comment_popup, layout, current_win)

  -- Draft toggle popup keymaps
  popup.set_popup_keymaps(draft_popup, function()
    local text = u.get_buffer_text(comment_popup.bufnr)
    local is_draft = draft_popup and u.string_to_bool(u.get_buffer_text(draft_popup.bufnr))
    M.submit_comment(text, is_draft, position_data)
    vim.api.nvim_set_current_win(current_win)
  end, miscellaneous.toggle_bool, popup.non_editable_popup_opts)

  -- Comment text popup keymaps
  popup.set_popup_keymaps(comment_popup, function(text)
    local is_draft = draft_popup and u.string_to_bool(u.get_buffer_text(draft_popup.bufnr))
    M.submit_comment(text, is_draft, position_data)
    vim.api.nvim_set_current_win(current_win)
  end, miscellaneous.attach_file, popup.editable_popup_opts)

  -- Pre-fill draft toggle from settings
  vim.schedule(function()
    local draft_mode = state.settings.discussion_tree.draft_mode
    vim.api.nvim_buf_set_lines(draft_popup.bufnr, 0, -1, false, { u.bool_to_string(draft_mode) })
  end)

  layout:mount()
end

-- ============================================================================
-- User-facing comment creation
-- ============================================================================

--- Normal mode: create a single-line comment.
function M.create_comment()
  local ctx = M.get_codediff_context()
  if not ctx then
    u.notify("Not in a CodeDiff diff pane", vim.log.levels.ERROR)
    return
  end

  local position_data = M.build_position_data(ctx, ctx.line, ctx.line)
  M.open_comment_popup(position_data, ctx.file_name, ctx.line, ctx.line)
end

--- Visual mode: create a multi-line comment.
function M.create_multiline_comment()
  local ctx = M.get_codediff_context()
  if not ctx then
    u.notify("Not in a CodeDiff diff pane", vim.log.levels.ERROR)
    return
  end

  local start_line, end_line = u.get_visual_selection_boundaries()
  local position_data = M.build_position_data(ctx, start_line, end_line)
  u.press_escape()
  M.open_comment_popup(position_data, ctx.file_name, start_line, end_line)
end

-- ============================================================================
-- Auto-setup: register keymaps on CodeDiff buffers
-- ============================================================================

--- Set comment keymaps on a buffer if an MR is loaded.
--- @param buf integer
local function set_comment_keymaps(buf)
  if not state.INFO or not state.INFO.diff_refs then
    return
  end
  if not state.MR_REVISIONS or not state.MR_REVISIONS[1] then
    return
  end
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  vim.keymap.set("n", "<leader>rc", M.create_comment, {
    buffer = buf,
    desc = "Create GitLab MR comment (CodeDiff)",
  })
  vim.keymap.set("v", "<leader>rc", M.create_multiline_comment, {
    buffer = buf,
    desc = "Create GitLab MR multi-line comment (CodeDiff)",
  })
end

--- Register autocmd to set buffer-local keymaps on CodeDiff virtual buffers.
function M.setup()
  -- Listen for virtual file loads (virtual buffers, e.g. commit SHAs)
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeDiffVirtualFileLoaded",
    group = augroup,
    callback = function(ev)
      local buf = ev.data and ev.data.buf
      set_comment_keymaps(buf)
    end,
  })

  -- Also listen for CodeDiff opening (handles real file buffers too)
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeDiffOpen",
    group = augroup,
    callback = function(ev)
      if not ev.data or not ev.data.tabpage then
        return
      end

      local lifecycle = require("codediff.ui.lifecycle")
      local orig_buf, mod_buf = lifecycle.get_buffers(ev.data.tabpage)
      if orig_buf then
        set_comment_keymaps(orig_buf)
      end
      if mod_buf then
        set_comment_keymaps(mod_buf)
      end
    end,
  })
end

return M
