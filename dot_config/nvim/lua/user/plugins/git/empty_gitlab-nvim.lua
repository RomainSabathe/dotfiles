return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "stevearc/dressing.nvim",                                  -- Recommended but not required. Better UI for pickers.
    "nvim-tree/nvim-web-devicons",                             -- Recommended but not required. Icons in discussion tree.
  },
  build = function() require("gitlab.server").build(true) end, -- Builds the Go binary
  config = function()
    require("gitlab").setup({
      discussion_tree = {           -- The discussion tree that holds all comments
        draft_mode = true,          -- Whether comments are posted as drafts as part of a review
        tree_type = "by_file_name", -- Type of discussion tree - "simple" means just list of discussions, "by_file_name" means file tree with discussions under file
      },
      keymaps = {
        disable_all = false,                   -- Disable all mappings created by the plugin
        help = "g?",                           -- Open a help popup for local keymaps when a relevant view is focused (popup, discussion panel, etc)
        global = {
          disable_all = false,                 -- Disable all global mappings created by the plugin
          add_label = "<leader>rl",
          create_note = "<leader>rN",          -- Create a note (comment not linked to a specific line)
          publish_all_drafts = "<leader>rp",   -- Publish all draft comments/notes
          choose_merge_request = "<leader>rr", -- Start review for the currently checked-out branch
          start_review = "<leader>rs",         -- Start review for the currently checked-out branch
        },
        discussion_tree = {
          disable_all = false,                 -- Disable all default mappings for the discussion tree window
          edit_comment = "e",                  -- Edit comment
          reply = "r",                         -- Reply to comment
          toggle_resolved = "-",               -- Toggle the resolved status of the whole discussion
          delete_comment = "x",                -- Toggle the resolved status of the whole discussion
          jump_to_file = "a",                  -- Jump to comment location in file
          jump_to_reviewer = "a",              -- Jump to the comment location in the reviewer window
          open_in_browser = "b",               -- Jump to the URL of the current note/discussion
          copy_node_url = "u",                 -- Copy the URL of the current node to clipboard
          switch_view = "c",                   -- Toggle between the notes and discussions views
          toggle_tree_type = "i",              -- Toggle type of discussion tree - "simple", or "by_file_name"
          publish_draft = "P",                 -- Publish the currently focused note/comment
          toggle_draft_mode = "D",             -- Toggle between draft mode (comments posted as drafts) and live mode (comments are posted immediately)
          toggle_sort_method = "st",           -- Toggle whether discussions are sorted by the "latest_reply", or by "original_comment", see `:h gitlab.nvim.toggle_sort_method`
          toggle_node = "<right>",             -- Open or close the discussion
          toggle_all_discussions = "T",        -- Open or close separately both resolved and unresolved discussions
          toggle_resolved_discussions = "R",   -- Open or close all resolved discussions
          toggle_unresolved_discussions = "U", -- Open or close all unresolved discussions
          refresh_data = "<C-R>",              -- Refresh the data in the view by hitting Gitlab's APIs again
          print_node = "<leader>p",            -- Print the current node (for debugging)
        },
        popup = {
          disable_all = false,         -- Disable all default mappings for the popup windows (comments, summary, MR creation, etc.)
          perform_action = "<return>", -- Once in normal mode, does action (like saving comment or applying description edit, etc)
          discard_changes = "ZQ",      -- Quit the popup discarding changes, the popup content is not saved to the `temp_registers` (see `:h gitlab.nvim.temp-registers`)
        },
        reviewer = {
          disable_all = false,                    -- Disable all default mappings for the reviewer windows
          create_comment = "<leader>rc",          -- Create a comment for the lines that the following {motion} moves over. Repeat the key(s) for creating comment for the current line
          move_to_discussion_tree = "<leader>ra", -- Jump to the comment in the discussion tree
        }
      }
    })
  end,
}
