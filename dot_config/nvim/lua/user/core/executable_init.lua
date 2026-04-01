require("user.core.options")
require("user.core.keymaps")

-- Auto-open CodeDiff when inside a gwt worktree (~/worktrees/...)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.getcwd():match("/worktrees/") then
      vim.schedule(function() vim.cmd("CodeDiff") end)
    end
  end,
})
