return {
	"nvim-focus/focus.nvim",
	version = "*",
	opts = {},
	config = function()
		require("focus").setup({
			autoresize = {
				enable = true,
				width = 110,
				height = 45,
				minwidth = 10,
				minheight = 10,
			},
		})

		local ignore_filetypes = { "neo-tree", "NvimTree", "DiffviewFiles" }
		-- local ignore_buftypes = { "nofile", "prompt", "popup" }
		local ignore_buftypes = { "prompt", "popup" }

		local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

		-- Setting autofocus on or off depending on the filetype and buffertype.
		vim.api.nvim_create_autocmd("WinEnter", {
			group = augroup,
			callback = function(_)
				if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
					vim.w.focus_disable = true
				else
					vim.w.focus_disable = false
				end
			end,
			desc = "Disable focus autoresize for BufType",
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			callback = function(_)
				if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
					vim.b.focus_disable = true
				else
					vim.b.focus_disable = false
				end
			end,
			desc = "Disable focus autoresize for FileType",
		})
	end,
	keys = {
		{ "<leader>sF", "<cmd>FocuToggle<cr>", desc = "Toggle Focus mode" },
	},
}
