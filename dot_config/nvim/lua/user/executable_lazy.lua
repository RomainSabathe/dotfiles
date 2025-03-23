-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- We import everything expect for the "disabled" dir
		{ import = "user.plugins" },
		{ import = "user.plugins.ai" },
		{ import = "user.plugins.code_helpers" },
		{ import = "user.plugins.git" },
		{ import = "user.plugins.look" },
		{ import = "user.plugins.lsp" },
		{ import = "user.plugins.misc" },
		{ import = "user.plugins.navigation" },
		{ import = "user.plugins.splits" },
	},
	change_detection = { notify = false },
	-- automatically check for plugin updates
	-- checker = { enabled = true },
})
