return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		indent = { char = "┊" },
	},
}
