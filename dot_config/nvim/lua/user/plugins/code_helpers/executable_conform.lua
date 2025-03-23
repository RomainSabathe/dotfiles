return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile", "LspAttach" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				python = function(bufnr)
					if require("conform").get_formatter_info("ruff_format", bufnr).available then
						return { "ruff", "ruff_format", "ruff_fix", "ruff_organize_imports" }
					else
						return { "isort", "black" }
					end
				end,
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			},
		})
	end,
}
