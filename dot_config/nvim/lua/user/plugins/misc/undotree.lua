-- Built-in undo tree navigator (Neovim 0.12). Ships with Neovim but opt-in.
-- Opens a visual tree of undo branches so you can jump to any past state,
-- even states that normal u/Ctrl-R can't reach (e.g. after branching edits).
return {
  "nvim.undotree",
  dir = vim.env.VIMRUNTIME .. "/pack/dist/opt/nvim.undotree",
  cmd = "Undotree",
  keys = {
    { "<leader>u", "<cmd>Undotree<cr>", desc = "Toggle undo tree" },
  },
}
