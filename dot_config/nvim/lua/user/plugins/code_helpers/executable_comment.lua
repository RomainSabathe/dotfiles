return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
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
