-- File Explorer
vim.cmd("let g:netrw_liststyle = 3") -- Show nested tree in vim's file explorer

-- Editor UI
vim.opt.number = true -- Show absolute line number at cursor
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true -- Highlight cursor line
vim.opt.signcolumn = "yes:1" -- Always show gutter with 1-col width
vim.opt.scrolloff = 7 -- Minimum lines to keep above/below cursor
vim.opt.sidescrolloff = 8 -- Minimum columns to keep left/right of cursor

-- Editor Behavior
vim.opt.updatetime = 250 -- Faster completion
vim.opt.timeoutlen = 300 -- Time to wait for mapped sequence
vim.opt.undofile = true -- Enable persistent undo
vim.opt.wrap = true -- Wrap long lines (good for prose)
vim.opt.textwidth = 88 -- Max line length for auto -formatting

-- Indentation and Tabs
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 2 -- Spaces for each indent level
vim.opt.tabstop = 2 -- Spaces a tab counts for
vim.opt.smartindent = true -- Smart autoindenting on new lines

-- Search and Replace
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- Case sensitive if search has uppercase

-- Split Behavior
vim.opt.splitright = true -- Open vertical splits to the right
vim.opt.splitbelow = true -- Open horizontal splits below

-- File Handling
vim.opt.swapfile = false -- Disable swap files

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
	vim.opt.clipboard:append("unnamedplus") -- Use system clipboard as default register
end
