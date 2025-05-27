return {
  "lervag/vimtex",
  lazy = true,
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_enabled = 0

    vim.api.nvim_create_augroup("LatexFormatting", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = "LatexFormatting",
      pattern = { "tex", "plaintex", "latex" },
      callback = function()
        -- Disable automatic line breaks while typing
        vim.opt_local.textwidth = 0
        -- Enable formatting with gq
        vim.opt_local.formatoptions = vim.opt_local.formatoptions + "t"
      end,
    })
  end
}
