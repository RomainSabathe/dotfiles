return {
	"nvzone/timerly",
	dependencies = {
		"nvzone/volt",
	},
	config = {
		minutes = { 55, 10 },
	},

	keys = {
		{
			"<leader>pp",
			"<cmd>TimerlyToggle<cr>",
			mode = { "n" },
			desc = "Timerly Toggle",
		},
	},
}
