return {
	"mrjones2014/smart-splits.nvim",
	config = function()
		smart_splits = require("smart-splits")
		keymap = vim.keymap

		-- resizing splits
		keymap.set("n", "<C-S-h>", smart_splits.resize_left)
		keymap.set("n", "<C-S-Left>", smart_splits.resize_left)
		keymap.set("n", "<C-S-j>", smart_splits.resize_down)
		keymap.set("n", "<C-S-Down>", smart_splits.resize_down)
		keymap.set("n", "<C-S-k>", smart_splits.resize_up)
		keymap.set("n", "<C-S-Up>", smart_splits.resize_up)
		keymap.set("n", "<C-S-l>", smart_splits.resize_right)
		keymap.set("n", "<C-S-Right>", smart_splits.resize_right)

		-- moving between splits
		keymap.set("n", "<C-h>", smart_splits.move_cursor_left)
		keymap.set("n", "<C-Left>", smart_splits.move_cursor_left)
		keymap.set("n", "<C-j>", smart_splits.move_cursor_down)
		keymap.set("n", "<C-Down>", smart_splits.move_cursor_down)
		keymap.set("n", "<C-k>", smart_splits.move_cursor_up)
		keymap.set("n", "<C-Up>", smart_splits.move_cursor_up)
		keymap.set("n", "<C-l>", smart_splits.move_cursor_right)
		keymap.set("n", "<C-Right>", smart_splits.move_cursor_right)
		keymap.set("n", "<C-\\>", smart_splits.move_cursor_previous)
	end,
}
