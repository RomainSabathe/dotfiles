return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
		"echasnovski/mini.diff",
		{ "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
	},
	opts = {
		display = {
			diff = {
				provider = "mini_diff",
			},
			opts = {
				log_level = "DEBUG",
			},
		},
		strategies = {
			chat = {
				adapter = "anthropic",
			},
			inline = {
				adapter = "anthropic", -- "copilot" is better suited
			},
		},
		adapters = {
			anthropic = function()
				return require("codecompanion.adapters").extend("anthropic", {
					env = {
						api_key = "{{ anthropic_api_key }}",
					},
				})
			end,
		},
		prompt_library = {
			["Docstring writter"] = {
				strategy = "inline",
				description = "Write docstrings for functions.",
				opts = {
					mapping = "<leaderr>ad",
					modes = { "v" },
					short_name = "docstring",
					auto_submit = true,
					stop_context_insertion = true,
					user_prompt = false,
				},
				prompts = {
					{
						role = "system",
						content = function(context)
							return "I want you to act as a senior "
								.. context.filetype
								.. " developer and machine learning expert. If python, assume it is python>=3.10. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
						end,
					},
					{
						role = "user",
						content = function(context)
							local text =
								require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

							return "I have the following code:\n\n```"
								.. context.filetype
								.. "\n"
								.. text
								.. "\n```\n\n Add a docstring to this function. Use Google's docstring convention (Args:...). Don't include the type hint in the list of args since it is already included in the function signature. If an argument is missing a type hint, use your best judgment to propose a type hint."
						end,
						opts = {
							contains_code = true,
						},
					},
				},
			},
		},
	},
	keys = {
		{
			"<leader>aa",
			"<cmd>CodeCompanionActions<cr>",
			mode = { "n", "v" },
			desc = "CodeCompanion Actions",
		},
		{
			"<leader>ac",
			"<cmd>CodeCompanionChat Toggle<cr>",
			mode = { "n", "v" },
			desc = "CodeCompanion Chat",
		},
		{
			"<leader>aA",
			"<cmd>CodeCompanionChat Add<cr>",
			mode = "v",
			desc = "CodeCompanion Chat Add",
		},
		{
			"<leader>ad",
			"<cmd>CodeCompanion /docstring<cr>",
			mode = "v",
			desc = "CodeCompanion Docstring",
		},
	},
}
