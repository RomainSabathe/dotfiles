return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	config = function()
		flash = require("flash")
		keymap = vim.keymap

		flash.setup()

		keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash" })
		keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash Treesitter" })
		-- -- different binding in "o" mode to avoid conflict with surround.nvim
		-- keymap.set("o", "<leader>s", flash.jump, { desc = "Flash" })
		-- keymap.set("o", "<leader>S", flash.treesitter, { desc = "Flash Treesitter" })
		keymap.set("o", "r", flash.remote, { desc = "Remote Flash" })
		keymap.set({ "o", "x" }, "R", flash.treesitter_search, { desc = "Treesitter Search" })
		keymap.set("c", "<c-s>", flash.toggle, { desc = "Toggle Flash Search" })
	end,
}
