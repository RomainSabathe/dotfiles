return {
	"declancm/maximize.nvim",
	config = function()
		require("maximize").setup()
		vim.keymap.set("n", "<leader>sf", "<cmd>Maximize<cr>", { desc = "Toggle maximize split" })
	end,
}
