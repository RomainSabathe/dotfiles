return {
  "carlos-algms/agentic.nvim",
  opts = {
    provider = "copilot-acp",
    acp_providers = {
      ["copilot-acp"] = {
        name = "Copilot ACP",
        command = "copilot",
        args = { "--acp", "--stdio" },
      },
    },
  },
  keys = {
    { "<leader>a",  nil,                                                          desc = "AI/Agentic" },
    { "<leader>ac", function() require("agentic").toggle() end,                            mode = { "n", "v" }, desc = "Toggle Agentic" },
    { "<leader>an", function() require("agentic").new_session() end,                     mode = { "n", "v" }, desc = "New session" },
    { "<leader>ar", function() require("agentic").restore_session() end,                 mode = { "n", "v" }, desc = "Restore session" },
    { "<leader>af", function() require("agentic").add_selection_or_file_to_context() end, mode = { "n", "v" }, desc = "Add file/selection to context" },
    { "<leader>ad", function() require("agentic").add_current_line_diagnostics() end,     mode = { "n", "v" }, desc = "Add line diagnostics" },
    { "<leader>aD", function() require("agentic").add_buffer_diagnostics() end,           mode = { "n", "v" }, desc = "Add buffer diagnostics" },
    { "<leader>as", function() require("agentic").switch_provider() end,                  mode = { "n", "v" }, desc = "Switch provider" },
  },
}
