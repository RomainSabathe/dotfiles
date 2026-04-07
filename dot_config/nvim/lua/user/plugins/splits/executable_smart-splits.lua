return {
  "mrjones2014/smart-splits.nvim",
  config = function()
    local smart_splits = require("smart-splits")

    -- Navigation (<C-h/j/k/l>) is handled by zellij-nav.nvim, which
    -- seamlessly moves between Neovim splits AND Zellij panes.
    -- smart-splits only handles resizing here.
    vim.keymap.set("n", "<C-S-h>", smart_splits.resize_left)
    vim.keymap.set("n", "<C-S-Left>", smart_splits.resize_left)
    vim.keymap.set("n", "<C-S-j>", smart_splits.resize_down)
    vim.keymap.set("n", "<C-S-Down>", smart_splits.resize_down)
    vim.keymap.set("n", "<C-S-k>", smart_splits.resize_up)
    vim.keymap.set("n", "<C-S-Up>", smart_splits.resize_up)
    vim.keymap.set("n", "<C-S-l>", smart_splits.resize_right)
    vim.keymap.set("n", "<C-S-Right>", smart_splits.resize_right)
  end,
}
