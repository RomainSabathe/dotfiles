return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		-- Sources
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"saadparwaiz1/cmp_luasnip",
		-- Snippets
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
		},
		"rafamadriz/friendly-snippets",
		-- Utilities
		"VonHeikemen/lsp-zero.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local cmp_action = require("lsp-zero").cmp_action()
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		-- Loading snippets.
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			sources = {
				-- The order is important! First items get more priority
				{ name = "luasnip" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "nvim_lsp", max_item_count = 3 },
				{
					name = "buffer",
					max_item_count = 3,
					-- Sourcing from *all* buffers (but default it only sources from the current
					-- buffer).
					option = {
						get_bufnrs = function()
							return vim.api.nvim_list_bufs()
						end,
					},
				},
				{ name = "path" },
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				-- Found in https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
				["<CR>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						if luasnip.expandable() then
							luasnip.expand()
						else
							cmp.confirm({
								select = true,
							})
						end
					else
						fallback()
					end
				end),
				-- Supertab is useful to navigate snippet fields
				["<Tab>"] = cmp_action.luasnip_supertab(),
				["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
			}),
			-- Makes the first item in completion menu always selected
			preselect = "item",
			completion = {
				completeopt = "menu,menuone,preview,noinsert",
			},
		})

		-- Add parentheses after selecting function or method items.
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
