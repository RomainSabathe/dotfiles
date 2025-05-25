return {
	{
		-- Syntax highlighting, even for templates
		"alker0/chezmoi.vim",
		lazy = false,
		init = function()
			-- This option is required.
			vim.g["chezmoi#use_tmp_buffer"] = true
			-- add other options here if needed.
		end,
	},
	{
		-- Auto-apply
		"xvzc/chezmoi.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.load_extension("chezmoi")
			vim.keymap.set("n", "<leader>fd", telescope.extensions.chezmoi.find_files, {})

			local chezmoi = require("chezmoi")
			require("chezmoi").setup(opts)
			chezmoi.config.edit.watch = true
		end,
	},
}
