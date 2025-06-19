return {
  'opdavies/toggle-checkbox.nvim',
  config = function()
    -- require("toggleterm").setup()
    vim.keymap.set("n", "<leader>tt", ":lua require('toggle-checkbox').toggle()<CR>")
  end,
}
