return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		-- add this plugin as dependency for lualine
		"bwpge/lualine-pretty-path",
	},
	opts = {
		-- recommended to use this plugin in lualine_c,
		-- see below for options
		sections = {
			lualine_c = { "pretty_path" },
		},
		inactive_sections = {
			lualine_c = { "pretty_path" },
		},
		-- other lualine config...
	},
}
