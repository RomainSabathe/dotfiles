return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs_staged_enable = true,
			signcolumn = true,
			numhl = true,
			-- I don't use any of the mappings of gitsigns as I found them
			-- unrealiable. Prefer to use fugitive/lazygit.
		})
	end,
}
