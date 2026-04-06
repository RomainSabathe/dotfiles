-- File Explorer
vim.cmd("let g:netrw_liststyle = 3") -- Show nested tree in vim's file explorer

-- Editor UI
vim.opt.number = true         -- Show absolute line number at cursor
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true     -- Highlight cursor line
vim.opt.signcolumn = "yes:1"  -- Always show gutter with 1-col width
vim.opt.scrolloff = 7         -- Minimum lines to keep above/below cursor
vim.opt.sidescrolloff = 8     -- Minimum columns to keep left/right of cursor

-- Editor Behavior
vim.opt.updatetime = 250 -- Faster completion
vim.opt.timeoutlen = 300 -- Time to wait for mapped sequence
vim.opt.undofile = true  -- Enable persistent undo
vim.opt.wrap = true      -- Wrap long lines (good for prose)
vim.opt.textwidth = 88   -- Max line length for auto -formatting

-- Indentation and Tabs
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.shiftwidth = 2     -- Spaces for each indent level
vim.opt.tabstop = 2        -- Spaces a tab counts for
vim.opt.smartindent = true -- Smart autoindenting on new lines

-- Search and Replace
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true  -- Case sensitive if search has uppercase

-- Split Behavior
vim.opt.splitright = true -- Open vertical splits to the right
vim.opt.splitbelow = true -- Open horizontal splits below

-- File Handling
vim.opt.swapfile = false -- Disable swap files

-- Use LSP to handle folding
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"

-- Open file at the last position it was edited earlier
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Open file at the last position it was edited earlier",
  group = misc_augroup,
  pattern = "*",
  command = 'silent! normal! g`"zv',
})

-- Language-specific confs
-- LaTeX
vim.api.nvim_create_augroup("LatexFormatting", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "LatexFormatting",
  pattern = { "tex", "plaintex", "latex" },
  callback = function()
    -- Disable automatic line breaks while typing
    vim.opt_local.textwidth = 0
    -- Enable formatting with gq
    vim.opt_local.formatoptions = vim.opt_local.formatoptions + "t"
  end,
})

-- Keymap (e.g. ZMK)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dts" },
  callback = function()
    -- Disable automatic line breaks while typing
    vim.opt_local.textwidth = 0
  end,
})

-- System Integration
-- WSL-specific clipboard configuration
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
else
  -- Use OSC 52 for copy only
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = { 'cat', '/dev/null' },
      ['*'] = { 'cat', '/dev/null' },
    },
  }

  -- Auto-copy yanked text to system clipboard without affecting paste
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      if vim.v.event.operator == 'y' then
        vim.fn.setreg('+', vim.fn.getreg('"'))
      end
    end,
  })
end

-- Attach LSP to diff viewer buffers (vscodediff://, diffview://) for code navigation
-- during reviews. Both plugins intentionally suppress filetype to prevent LSP attachment,
-- but modern LSP servers handle custom URI schemes fine (they process text content sent
-- via textDocument/didOpen). We re-set filetype after the plugin finishes buffer setup.
local diff_lsp_augroup = vim.api.nvim_create_augroup("DiffBufLsp", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = diff_lsp_augroup,
  callback = function(ev)
    local buf = ev.buf
    local name = vim.api.nvim_buf_get_name(buf)
    if not (name:match("^vscodediff://") or name:match("^diffview://")) then
      return
    end

    local function try_set_ft()
      if not vim.api.nvim_buf_is_valid(buf) then return end
      if vim.bo[buf].filetype ~= "" then return end
      local ft = vim.filetype.match({ filename = name, buf = buf })
      if ft then
        vim.bo[buf].filetype = ft
      end
    end

    -- Try on next event loop tick (works for synchronously loaded buffers like diffview)
    vim.schedule(try_set_ft)

    -- Fallback: try on first cursor movement (works for async loaded buffers like CodeDiff)
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = diff_lsp_augroup,
      buffer = buf,
      once = true,
      callback = try_set_ft,
    })
  end,
})

-- Suppress diagnostics on diff buffers (keep hover, go-to-definition, references, etc.)
vim.api.nvim_create_autocmd("LspAttach", {
  group = diff_lsp_augroup,
  callback = function(ev)
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name:match("^vscodediff://") or name:match("^diffview://") then
      vim.diagnostic.enable(false, { bufnr = ev.buf })
    end
  end,
})

-- Manually attach running LSP clients to vscodediff:// buffers.
-- lspconfig's root_dir detection fails on virtual URIs, so LSP servers like pyright
-- never auto-attach. We find running clients that match the buffer's filetype and
-- attach them manually after vscode-diff finishes loading the buffer.
vim.api.nvim_create_autocmd("User", {
  pattern = "VscodeDiffVirtualFileLoaded",
  group = diff_lsp_augroup,
  callback = function(ev)
    local buf = ev.data and ev.data.buf
    if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
    local ft = vim.bo[buf].filetype
    if ft == "" then return end

    for _, client in ipairs(vim.lsp.get_clients()) do
      local filetypes = client.config.filetypes
      if filetypes and vim.tbl_contains(filetypes, ft) then
        if not vim.lsp.buf_is_attached(buf, client.id) then
          vim.lsp.buf_attach_client(buf, client.id)
        end
      end
    end
  end,
})

-- Ensures that when exiting NeoVim, Zellij returns to normal mode
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*",
  command = "silent !zellij action switch-mode normal",
})
