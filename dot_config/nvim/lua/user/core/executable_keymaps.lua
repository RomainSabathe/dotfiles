vim.g.mapleader = " "     -- setting space as leader key.

local keymap = vim.keymap -- shortcut

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Quick exit when using standard QWERTY keyboard
keymap.set({ "i" }, "fd", "<Esc>")
keymap.set({ "i" }, "fd", "<C-\\><C-n>")

-- Incremental treesitter selection (Neovim 0.12). The built-in keys (an/in)
-- conflict with mini.ai's text object prefix, so we remap to +/-.
-- In visual mode: + expands to the parent AST node, - shrinks to child node.
-- Example on `data` in `process(data, key="name")`:
--   v    → select `data`
--   +    → expand to `data, key="name"` (argument list)
--   +    → expand to `process(data, key="name")` (full call)
--   -    → shrink back down
vim.keymap.del({ 'x', 'o' }, 'an')
vim.keymap.del({ 'x', 'o' }, 'in')
keymap.set('x', '+', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require('vim.treesitter._select').select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = 'Incremental selection: expand to parent node' })
keymap.set('x', '-', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require('vim.treesitter._select').select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = 'Incremental selection: shrink to child node' })

-- select all
keymap.set({ "n" }, "<leader>A", "ggVG", { desc = "Select all", noremap = true })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Making page up/down actually go half the height instead of whole height
keymap.set({ "n", "v" }, "<PageUp>", "<C-u>", { desc = "Go half page up" })
keymap.set({ "n", "v" }, "<PageDown>", "<C-d>", { desc = "Go half page up" })
keymap.set({ "n", "v" }, "<C-up>", "<C-u>", { desc = "Go half page up" })
keymap.set({ "n", "v" }, "<C-down>", "<C-d>", { desc = "Go half page up" })

-- Use j/k to navigate wrapped lines (useful for prose)
keymap.set("n", "j", "gj", { noremap = true })
keymap.set("n", "k", "gk", { noremap = true })
keymap.set("n", "<Down>", "gj", { noremap = true })
keymap.set("n", "<Up>", "gk", { noremap = true })

-- quicker exit
keymap.set("n", "<leader>qq", "<cmd>wq<cr>", { desc = "Save and close the split" })
keymap.set("n", "<leader>qa", "<cmd>wqa<cr>", { desc = "Save all splits and buffers and exit vim" })
keymap.set("n", "<leader>Qq", "<cmd>q!<cr>", { desc = "Close the split without saving" })
keymap.set("n", "<leader>Qa", "<cmd>qa!<cr>", { desc = "Exit vim without saving" })

-- quicker save
keymap.set("n", "<leader>ww", "<cmd>w<cr>", { desc = "Save the current buffer" })

-- splits management
-- Notice how the vertical/horizontal concept has been split. It just works better with my brain and corresponds
-- to how I have configured i3.
keymap.set("n", "<leader>sv", "<C-w>s", { desc = "Split window vertically (creates a window on the right)" })
keymap.set("n", "<leader>sh", "<C-w>v", { desc = "Split window horizontally (creates a window at the bottom)" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- tabs management
keymap.set("n", "<leader>To", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>Tx", "<cmd>tabclose<CR>", { desc = "Close new tab" })
keymap.set("n", "<S-Right>", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<S-Left>", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>Tf", "<cOpen new tabmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- code formatting
keymap.set("v", "<leader>F", "gq", { desc = "Format the seleted text" })
keymap.set("n", "<leader>F", "gqq", { desc = "Format the current line" })

-- exit terminal mode
keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- adding "dp" and "dg" (diffput and diffget) to work in visual mode
local function setup_diff_mappings()
  if vim.opt.diff:get() then
    vim.keymap.set("n", "dp", "dp", { buffer = true })
    vim.keymap.set("v", "dp", ":diffput<CR>", { buffer = true })
    vim.keymap.set("n", "dg", "do", { buffer = true })
    vim.keymap.set("v", "dg", ":diffget<CR>", { buffer = true })
  end
end

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = setup_diff_mappings,
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = setup_diff_mappings,
})
