return {
	"pasky/claude.vim",
	lazy = false,
	config = function()
		-- Load API key from environment variable
		-- local api_key = os.getenv("ANTHROPIC_API_KEY")
		local api_key = "{{ anthropic_api_key }}"
		if api_key then
			vim.g.claude_api_key = api_key
		else
			vim.notify("ANTHROPIC_API_KEY environment variable is not set", vim.log.levels.WARN)
		end

		-- Add keymaps (the default conflict with NVChad.  Skip if you want)
		vim.keymap.set("v", "<leader>ai", ":'<,'>ClaudeImplement ", { noremap = true, desc = "Claude Implement" })
		vim.keymap.set("n", "<leader>ac", ":ClaudeChat<CR>", { noremap = true, silent = true, desc = "Claude Chat" })
	end,
}
