return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	config = function()
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		require("ufo").setup()

		local function opts(desc)
			return { desc = "UFO: " .. desc }
		end
		ufo = require("ufo")
		vim.keymap.set("n", "zR", ufo.openAllFolds, opts("Open all folds"))
		vim.keymap.set("n", "zM", ufo.closeAllFolds, opts("Close all folds"))
	end,
}
