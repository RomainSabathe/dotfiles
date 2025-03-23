return {
	"tpope/vim-fugitive",
	dependencies = {
		"shumphrey/fugitive-gitlab.vim",
	},
	config = function()
		vim.g.fugitive_gitlab_domains = { "{{ gitlab_domain }}" }

		--- Toggle fugitive window. If window is open, close it. If window is closed, open it.
		local function toggle_fugitive()
			local fugitive_buf_no = vim.fn.bufnr("^fugitive:")
			local buf_win_id = vim.fn.bufwinid(fugitive_buf_no)

			if fugitive_buf_no >= 0 and buf_win_id >= 0 then
				-- closing fugitive window
				vim.api.nvim_win_close(buf_win_id, false)
			else
				-- opening fugitive window
				vim.cmd(":Git")
			end
		end

		local function opts(desc)
			return { desc = "Fugitive: " .. desc }
		end

		vim.keymap.set("n", "<leader>gg", toggle_fugitive, opts("toggle git status"))
		vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", opts("commit"))
		vim.keymap.set("n", "<leader>gP", "<cmd>Git push<cr>", opts("push"))
		vim.keymap.set("n", "<leader>gr", "<cmd>Gread<cr>", opts("discard changes"))
		vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", opts("open diff view"))
		vim.keymap.set("n", "<leader>gw", "<cmd>Gwrite<cr>", opts("stage changes"))
		vim.keymap.set("n", "<leader>gB", "<cmd>GBrowse<cr>", opts("open browser"))
	end,
}
