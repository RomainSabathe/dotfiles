return {
  "luiscassih/AniMotion.nvim",
  event = "VeryLazy",
  config = function()
    require("AniMotion").setup({
      mode = "animotion",
      clear_keys = { "<C-c>" },
      color = "Visual",
    })
  end
}
