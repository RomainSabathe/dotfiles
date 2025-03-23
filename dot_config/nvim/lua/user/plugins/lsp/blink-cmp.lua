return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets", "echasnovski/mini.icons" },
	version = "*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = { preset = "super-tab" },

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- Make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
				lsp = {
					min_keyword_length = 2, -- Number of characters to trigger provider
					score_offset = 0, -- Boost/penalize the score of the items
				},
				path = {
					min_keyword_length = 0,
				},
				snippets = {
					min_keyword_length = 2,
					-- Boosting the priority of snippets.
					score_offset = 90,
				},
				buffer = {
					min_keyword_length = 4,
					max_items = 5,
				},
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },

		completion = {
			accept = { auto_brackets = { enabled = true } },
			menu = {
				-- Adding a border around the table of suggestions
				border = "single",
				-- Adding icons
				draw = {
					-- Showing the function name, then the icon, then the type (Function, Snippet, etc.)
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind" },
					},
					treesitter = { "lsp" },
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								return kind_icon
							end,
							-- Optionally, you may also use the highlights from mini.icons
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 250,
				update_delay_ms = 50,
				treesitter_highlighting = true,
				window = { border = "rounded" },
			},
		},
		-- Experimental signature help support
		signature = {
			enabled = true,
			window = { border = "rounded" },
		},
	},
	opts_extend = { "sources.default" },
}
