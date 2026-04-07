return {
  'opdavies/toggle-checkbox.nvim',
  ft = "markdown",
  keys = {
    { "<leader>tc", function() require('toggle-checkbox').toggle() end, ft = "markdown", desc = "Toggle checkbox" },
  },
}
