return {
	"akinsho/toggleterm.nvim",
	version = "*",
	-- config = true,
	config = function()
		require("toggleterm").setup()
		local Terminal = require("toggleterm.terminal").Terminal

		-- local term = Terminal:new({
		-- 	on_open = function(term)
		-- 		vim.cmd("startinsert!")
		-- 	end,
		-- 	on_close = function(term)
		-- 		vim.cmd("startinsert!")
		-- 	end,
		-- })
		-- function toggle_term()
		-- 	term:toggle()
		-- end
		-- vim.keymap.set("n", "<leader>tt", "<cmd>lua toggle_term()<cr>", { desc = "Toggle terminal" })
		vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
		vim.keymap.set("n", "<leader>tT", "<cmd>ToggleTermToggleAll<cr>", { desc = "Toggle all terminals" })
	end,
}
