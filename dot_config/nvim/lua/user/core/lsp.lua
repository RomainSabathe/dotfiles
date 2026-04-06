-- Native LSP setup (Neovim 0.12+)
--
-- Server configs live in ~/.config/nvim/lsp/<name>.lua and are auto-discovered
-- by Neovim. This file enables them and resolves conflicts between servers.
--
-- For Python, we run THREE servers simultaneously — each has a distinct role:
--   ruff         → linting, formatting, import sorting (fast, Rust-based)
--   ty           → completions, go-to-definition, hover, rename (Astral's new
--                  type checker, still beta as of 2026-04 but good for navigation)
--   basedpyright → strict type-checking diagnostics (mature, catches more errors
--                  than ty currently does since ty has no strict mode yet)
--
-- Because their capabilities overlap, we selectively disable features on each
-- server below so they don't fight. If ty eventually adds a strict mode, we
-- could drop basedpyright entirely.

vim.lsp.enable({ 'ruff', 'ty', 'basedpyright', 'lua_ls' })

-- When an LSP server attaches to a buffer, selectively disable capabilities
-- that would duplicate or conflict with another server's responsibilities.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if client.name == 'ruff' then
      -- ruff only handles linting/formatting — ty provides better hover docs
      client.server_capabilities.hoverProvider = false
    end

    if client.name == 'basedpyright' then
      -- We only want basedpyright for its diagnostics (type errors, missing
      -- imports, etc.). All interactive features come from ty instead, which
      -- is faster (Rust) and will keep improving.
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.completionProvider = nil
      client.server_capabilities.definitionProvider = false
      client.server_capabilities.referencesProvider = false
      client.server_capabilities.renameProvider = false
      client.server_capabilities.signatureHelpProvider = nil
    end
  end,
})

-- Fix: ty's semantic tokens paint entire decorator blocks in a single color.
-- Without this, something like:
--
--   @click.option("--batch-size", type=int, default=64, help="Number of rows")
--
-- would appear ALL in one color (the @lsp.type.decorator token at priority 200
-- overrides treesitter's per-node highlights for strings, keywords, booleans,
-- etc.). Clearing this highlight group makes it transparent, so treesitter's
-- finer-grained coloring shows through. Revisit if ty improves its token scopes.
vim.api.nvim_set_hl(0, '@lsp.type.decorator.python', {})

-- Disable LSP's built-in formatter — we use conform.nvim instead (see
-- lua/user/plugins/code_helpers/conform.lua).
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].formatexpr = nil
  end,
})

-- CodeLens: shows actionable hints above functions (e.g. "Run test", "Debug").
-- Displayed as virtual lines. Press grx to run the lens at cursor.
vim.lsp.codelens.enable()

-- Linked editing: when you rename an opening HTML/XML tag, the closing tag
-- updates automatically. Only activates for LSP servers that support it.
vim.lsp.linked_editing_range.enable(true)

-- LSP keybindings: we rely on Neovim 0.12's built-in defaults:
--   K          → hover docs
--   <C-s>      → signature help (insert mode)
--   grn        → rename
--   gra        → code action
--   grr        → references
--   gri        → implementation
--   grt        → type definition
--   gd         → go to definition (overridden by Telescope in telescope.lua)
