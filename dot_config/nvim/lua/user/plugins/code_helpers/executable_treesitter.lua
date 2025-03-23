return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local treesitter = require("nvim-treesitter.configs")

			treesitter.setup({
				ensure_installed = {
					-- Essential
					"python",
					"markdown",
					"yaml",
					"toml",
					"json",
					"json5",
					"jsonc",
					"csv",
					"bash",
					"dockerfile",
					"git_rebase",
					"gitcommit",
					"gitignore",
					"requirements",

					-- Development Tools
					"ini",
					"sql",
					"html",
					"css",
					"javascript",
					"regex",
					"vim",
					"lua",

					-- Optional
					"cmake",
					"rust",
					"xml",
					"diff",
					"make",
					"rst",
					"vimdoc",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				autotag = { enable = true },
			})
		end,
	},
}
