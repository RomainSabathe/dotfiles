return {
	"rmagatti/auto-session",
	lazy = false,

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = ts,
		-- log_level = 'debug',
	},
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
			auto_save_enabled = true,
			auto_restore_enabled = true,
			session_lens = { load_on_setup = true },
			git_use_branch_name = true,
		})

		-- Recommended by the author
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

		vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
		vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for cwd" })
	end,
}
