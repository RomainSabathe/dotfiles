return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		capabilities.offsetEncoding = { "utf-16" }

		-- Automatically setup servers installed by Mason
		-- mason_lspconfig.setup_handlers({
		--   function(server_name)
		--     lspconfig[server_name].setup({
		--       capabilities = capabilities,
		--     })
		--   end,
		-- })

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

				local keymap = vim.keymap

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

