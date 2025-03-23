return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		local noop = function() end -- Empty function to bypass the initialization of certain servers

		-- Setting up the language servers via Mason
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "pyright", "lua_ls", "ruff" },
			handlers = {
				function(server_name)
					-- Create base config with folding capabilities
					local config = {
						capabilities = {
							textDocument = {
								foldingRange = {
									dynamicRegistration = false,
									lineFoldingOnly = true,
								},
							},
						},
					}

					-- Merge capabilities with blink.cmp capabilities
					config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)

					require("lspconfig")[server_name].setup(config)
				end,

				-- Disabling some servers
				pylyzer = noop, -- Prefer to use pyright
			},
		})

		-- Disable LSP's code formatter in favor of something else (e.g. conform.lua)
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				vim.bo[args.buf].formatexpr = nil
			end,
		})

		-- Keybindings
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local function opts(desc)
					return { buffer = event.buf, desc = "LSP: " .. desc }
				end

				keymap = vim.keymap

				-- Information
				keymap.set("n", "<leader>hd", vim.lsp.buf.hover, opts("Show hover documentation"))
				keymap.set("n", "<leader>hs", vim.lsp.buf.signature_help, opts("Show signature help"))

				-- Refactoring
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
				keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code actions"))
			end,
		})
	end,
}
