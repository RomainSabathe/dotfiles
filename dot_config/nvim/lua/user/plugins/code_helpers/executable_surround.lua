return {
	"kylechui/nvim-surround",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	version = "*",
	event = "VeryLazy",
	config = true,
	-- opts = {
	--     keymaps = {
	--         insert = "<M-z>",           -- Insert mode (Alt+z)
	--         insert_line = "<M-Z>",      -- Insert mode, line-wise (Alt+Shift+z)
	--         normal = "<leader>z",       -- Normal mode
	--         normal_cur = "<leader>zz",  -- Normal mode, current word
	--         normal_line = "<leader>zZ", -- Normal mode, line-wise
	--         visual = "<leader>z",       -- Visual mode
	--         visual_line = "<leader>zZ", -- Visual mode, line-wise
	--         delete = "<leader>zd",      -- Delete surroundings
	--         change = "<leader>zr",      -- Change surroundings
	--     },
	-- },
}
