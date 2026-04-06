return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			-- Disable the CursorHold autocmd — Comment.nvim calls the plugin
			-- directly when needed. The autocmd crashes on buffers without a
			-- treesitter parser (e.g. CodeDiff's vscodediff:// virtual buffers)
			-- because vim.treesitter.get_parser() returns nil in Neovim 0.12.
			opts = { enable_autocmd = false },
		},
	},
	-- Custom keymappings that are easier to type IMO (at least on Gallium)
	opts = {
		toggler = {
			line = "<leader>cc",
			block = "<leader>cb",
		},
		opleader = {
			line = "<leader>cc",
			block = "<leader>cb",
		},
		extra = {
			above = "<leader>cO",
			below = "<leader>co",
			eol = "<leader>cA",
		},
	},
}
