return {
	"glacambre/firenvim",
	build = ":call firenvim#install(0)",
	config = function()
		vim.g.firenvim_config = {
			localSettings = {
				[".*"] = {
					takeover = "never",
					-- takeover = "always",
					-- content = "html",
				},
			},
		}
		--
		-- -- From https://github.com/glacambre/firenvim/issues/323#issuecomment-774665328
		-- vim.g.firenvim_config = {
		-- 	globalSettings = {
		-- 		["alt"] = "all",
		-- 	},
		-- 	localSettings = {
		-- 		[".*"] = {
		-- 			cmdline = "neovim",
		-- 			content = "html",
		-- 			selector = "#tinymce",
		-- 			takeover = "never",
		-- 		},
		-- 	},
		-- }
		--
		vim.api.nvim_create_autocmd({ "UIEnter" }, {
			callback = function(event)
				local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
				if client ~= nil and client.name == "Firenvim" then
					-- vim.o.laststatus = 0
					vim.opt.background = "light"
					vim.opt.textwidth = 9999999
				end
			end,
		})

		-- Convert markdown to HTML and format with prettier
		vim.keymap.set(
			"v",
			"<leader>ml",
			"<cmd>!pandoc -f markdown -t html - -o - | npx prettier --parser html<cr>",
			{ silent = true }
		)

		-- Convert HTML to markdown and format with prettier
		vim.keymap.set(
			"v",
			"<leader>mh",
			"<cmd>!pandoc -f html -t markdown - -o - | npx prettier --parser markdown<cr>",
			{ silent = true }
		)
	end,
}
