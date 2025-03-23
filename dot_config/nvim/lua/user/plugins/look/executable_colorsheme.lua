return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		vim.opt.background = "dark" -- Force dark mode for supported colorschemes
		vim.cmd("colorscheme gruvbox")
	end,
}
