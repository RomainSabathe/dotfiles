return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python"),
			},
		})

		local neotest = require("neotest")
		vim.keymap.set("n", "<leader>rt", neotest.run.run(), { desc = "Run the nearest test" })
	end,
}
