-- Native LSP setup (Neovim 0.12+)
-- Server configs live in ~/.config/nvim/lsp/<name>.lua (auto-discovered)

vim.lsp.enable({ 'ruff', 'ty', 'basedpyright', 'lua_ls' })

-- Disable capabilities that conflict or are immature
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    -- ruff: disable hover (ty handles it)
    if client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end
    -- ty: semantic tokens are mostly fine, but the @lsp.type.decorator highlight
    -- is overly broad (covers entire decorator blocks). We clear that specific
    -- highlight below rather than disabling all semantic tokens.

    -- basedpyright: diagnostics only — ty handles hover, completion, navigation
    if client.name == 'basedpyright' then
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.completionProvider = nil
      client.server_capabilities.definitionProvider = false
      client.server_capabilities.referencesProvider = false
      client.server_capabilities.renameProvider = false
      client.server_capabilities.signatureHelpProvider = nil
    end
  end,
})

-- Clear ty's overly broad decorator semantic token highlight (links to PreProc at
-- priority 200, overriding all treesitter captures inside decorator blocks).
-- Setting it to empty lets treesitter's per-node highlights show through.
vim.api.nvim_set_hl(0, '@lsp.type.decorator.python', {})

-- Disable LSP's code formatter in favor of conform.nvim
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].formatexpr = nil
  end,
})

-- Keybindings
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local function opts(desc)
      return { buffer = event.buf, desc = "LSP: " .. desc }
    end

    local keymap = vim.keymap

    -- Information
    keymap.set("n", "<leader>hd", vim.lsp.buf.hover, opts("Show hover documentation"))
    keymap.set("n", "<leader>hs", vim.lsp.buf.signature_help, opts("Show signature help"))

    -- Refactoring
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
    keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code actions"))
  end,
})
