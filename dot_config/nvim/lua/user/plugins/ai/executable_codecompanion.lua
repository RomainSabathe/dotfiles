return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
		"echasnovski/mini.diff",
		"ravitemer/codecompanion-history.nvim",
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
				adapter = "groq",
			},
			inline = {
				adapter = "groq", -- "copilot" is better suited
			},
		},
		extensions = {
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					show_result_in_chat = true, -- Show mcp tool results in chat
					make_vars = true, -- Convert resources to #variables
					make_slash_commands = true, -- Add prompts as /slash commands
				},
			},
			history = {
				enabled = true,
				opts = {
					-- Keymap to open history from chat buffer (default: gh)
					keymap = "gh",
					-- Keymap to save the current chat manually (when auto_save is disabled)
					save_chat_keymap = "sc",
					-- Save all chats by default (disable to save only manually using 'sc')
					auto_save = true,
					-- Number of days after which chats are automatically deleted (0 to disable)
					expiration_days = 0,
					-- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
					picker = "telescope",
					---Automatically generate titles for new chats
					auto_generate_title = true,
					title_generation_opts = {
						---Adapter for generating titles (defaults to active chat's adapter)
						adapter = "groq", -- e.g "copilot"
						---Model for generating titles (defaults to active chat's model)
						model = "meta-llama/llama-4-scout-17b-16e-instruct", -- e.g "gpt-4o"
					},
					---On exiting and entering neovim, loads the last chat on opening chat
					continue_last_chat = false,
					---When chat is cleared with `gx` delete the chat from history
					delete_on_clearing_chat = false,
					---Directory path to save the chats
					dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
					---Enable detailed logging for history extension
					enable_logging = false,
				},
			},
		},
		adapters = {
			anthropic = function()
				return require("codecompanion.adapters").extend("anthropic", {
					schema = {
						model = {
							default = "claude-sonnet-4-20250514",
						},
					},
					env = {
						api_key = os.getenv("ANTHROPIC_API_KEY") or "",
					},
				})
			end,
			gemini = function()
				return require("codecompanion.adapters").extend("gemini", {
					env = {
						api_key = os.getenv("GEMINI_API_KEY") or "",
					},
					schema = {
						model = {
							default = "gemini-2.5-flash-preview-05-20",
						},
					},
				})
			end,
			openai = function()
				return require("codecompanion.adapters").extend("openai", {
					env = {
						api_key = os.getenv("OPENAI_API_KEY") or "",
					},
					schema = {
						model = {
							default = "gpt-4.1-2025-04-14",
						},
					},
				})
			end,
			deepseek = function()
				return require("codecompanion.adapters").extend("deepseek", {
					env = {
						api_key = os.getenv("DEEPSEEK_API_KEY") or "",
					},
					schema = {
						model = {
							default = "deepseek-reasoner",
						},
					},
				})
			end,
			groq = function()
				return require("codecompanion.adapters").extend("openai", {
					name = "Groq",
					formatted_name = "Groq",
					url = "https://api.groq.com/openai/v1/chat/completions",
					env = {
						api_key = os.getenv("GROQ_API_KEY") or "",
					},
					roles = {
						llm = "assistant",
						user = "user",
					},
					opts = {
						stream = true,
					},
					features = {
						text = true,
						tokens = true,
						vision = false,
					},
					headers = {
						Authorization = "Bearer ${api_key}",
						["Content-Type"] = "application/json",
					},
					schema = {
						---@type CodeCompanion.Schema
						model = {
							order = 1,
							mapping = "parameters",
							type = "enum",
							desc = "ID of the model to use. See the model endpoint compatibility table for details on which models work with the Chat API.",
							default = "meta-llama/llama-4-maverick-17b-128e-instruct",
							-- default = "deepseek-r1-distill-llama-70b",
							-- default = "deepseek-r1-distill-llama-70b",
							-- default = "qwen-2.5-coder-32b",
							-- default = "qwen-qwq-32b",
							choices = {
								["deepseek-r1-distill-llama-70b"] = { opts = { can_reason = false } },
								["deepseek-r1-distill-llama-70b-specdec"] = { opts = { can_reason = false } },
								["qwen-2.5-coder-32b"] = { opts = { can_reason = false } },
								["qwen-qwq-32b"] = { opts = { can_reason = false } },
							},
						},
					},

					handlers = {
						setup = function(self)
							if self.opts and self.opts.stream then
								self.parameters.stream = true
							end
							return true
						end,

						-- Use the OpenAI adapter for the bulk of the work
						tokens = function(self, data)
							return require("codecompanion.adapters.openai").handlers.tokens(self, data)
						end,
						form_parameters = function(self, params, messages)
							return require("codecompanion.adapters.openai").handlers.form_parameters(
								self,
								params,
								messages
							)
						end,
						form_messages = function(self, messages)
							return require("codecompanion.adapters.openai").handlers.form_messages(self, messages)
						end,
						chat_output = function(self, data)
							return require("codecompanion.adapters.openai").handlers.chat_output(self, data)
						end,
						inline_output = function(self, data, context)
							return require("codecompanion.adapters.openai").handlers.inline_output(self, data, context)
						end,
						on_exit = function(self, data)
							return require("codecompanion.adapters.openai").handlers.on_exit(self, data)
						end,
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
