return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local nvimtree = require("nvim-tree")
		local api = require("nvim-tree.api")

		-- Helper functions
		-- ----------------
		-- Handles file/folder openining.
		-- See https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#h-j-k-l-style-navigation-and-editing
		local function edit_or_open()
			local node = api.tree.get_node_under_cursor()

			if node.nodes ~= nil then
				-- expand or collapse folder
				api.node.open.edit()
			else
				-- open file
				api.node.open.edit()
			end
		end

		-- Provides a vertical split preview of the file
		-- See https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#h-j-k-l-style-navigation-and-editing
		local function vsplit_preview()
			local node = api.tree.get_node_under_cursor()

			if node.nodes ~= nil then
				-- expand or collapse folder
				api.node.open.edit()
			else
				-- open file as vsplit
				api.node.open.vertical()
			end

			-- Finally refocus on tree if it was lost
			api.tree.focus()
		end

		-- Keybinding functions
		-- ----------------
		-- Global keybindings
		local function setup_global_keymaps()
			local opts = function(desc)
				return { desc = "nvim-tree: " .. desc }
			end

			-- Opening/closing
			vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", opts("Toggle"))
			vim.keymap.set(
				"n",
				"<leader>ef",
				"<cmd>NvimTreeFindFileToggle<CR>",
				opts("Show current file in the explorer")
			)
			vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", opts("Collapse all dirs"))
			vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", opts("Refresh"))
		end

		-- Buffer-local keybindings for nvim-tree (i.e. bindings that are only active
		-- on nvim-tree buffer).
		local function setup_buffer_keymaps(bufnr)
			-- Helper function to provide buffer-specific opts to vim.keybinding.
			local function opts(desc)
				return {
					desc = "nvim-tree: " .. desc,
					buffer = bufnr,
					noremap = true,
					silent = true,
					nowait = true,
				}
			end

			-- Starting with the basis of default mappings.
			api.config.mappings.default_on_attach(bufnr)

			-- Navigating with hjkl and the arrows
			vim.keymap.set("n", "l", edit_or_open, opts("Edit or open file"))
			vim.keymap.set("n", "<Right>", edit_or_open, opts("Edit or open file"))
			vim.keymap.set("n", "L", vsplit_preview, opts("Open file in vertical split"))
			vim.keymap.set("n", "<S-Right>", vsplit_preview, opts("Open file in vertical split"))
			vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
			-- Disabled because it was more cumbersome than anything.
			-- vim.keymap.set("n", "h", api.tree.collapse_all, opts("Collapse all dirs"))
			-- vim.keymap.set("n", "<Left>", api.tree.collapse_all, opts("Collapse all dirs"))
		end

		-- Configuration
		-- ----------------
		-- Disable netrw (vim's built-in file explorer)
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- Enable 24-bit colour
		vim.opt.termguicolors = true

		-- Core nvim-tree setup
		local tree_config = {
			-- Attach buffer-local keymaps
			on_attach = setup_buffer_keymaps,
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 30,
				relativenumber = true,
			},
			renderer = {
				group_empty = true,
			},
			actions = {
				open_file = {
					window_picker = {
						enable = false, -- files open in last active window
					},
				},
			},
			filters = {
				dotfiles = true, -- show hidden files
			},
			git = {
				ignore = false, -- show files from .gitignore
			},
		}

		-- Initialization
		-- ----------------
		nvimtree.setup(tree_config)
		setup_global_keymaps()
	end,
}
