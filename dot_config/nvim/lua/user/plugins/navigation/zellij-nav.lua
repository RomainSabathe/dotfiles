return {
	"swaits/zellij-nav.nvim",
	lazy = true,
	event = "VeryLazy",
	keys = {
		{ "<c-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left or tab" } },
		{ "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
		{ "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
		{ "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right or tab" } },
		{ "<c-Left>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left or tab" } },
		{ "<c-Down>", "<cmd>ZellijNavigate<cr>", { silent = true, desc = "navigate down" } },
		{ "<c-Up>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
		{ "<c-Right>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right or tab" } },
	},
	opts = {},
}
