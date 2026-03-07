-- ABOUTME: Minuet AI-powered code completion plugin configuration
-- ABOUTME: Provides AI completions through various LLM providers with blink-cmp integration
return {
  "milanglacier/minuet-ai.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "saghen/blink.cmp",
  },
  opts = {
    -- Active provider - comment/uncomment to switch
    provider = "gemini",
    -- provider = "codestral", -- for mistral codestral models
    -- provider = "openai_compatible", -- for openrouter

    throttle = 1000,
    debounce = 400,
    request_timeout = 3,
    context_window = 16000,
    n_completions = 3,
    notify = "debug",
    add_single_line_entry = true, -- Only show single-line completions to avoid obscuring code

    -- Provider configurations
    provider_options = {
      gemini = {
        model = "gemini-3-flash-preview",
        api_key = "GEMINI_API_KEY",
        stream = true,
        optional = {
          generationConfig = {
            maxOutputTokens = 256,
          },
        },
      },
      codestral = {
        model = "codestral-latest",
        end_point = "https://codestral.mistral.ai/v1/fim/completions",
        api_key = "CODESTRAL_API_KEY",
        stream = true,
        optional = {
          max_tokens = 256,
          stop = { "\n\n" },
        },
      },
      openai_compatible = {
        model = "x-ai/grok-code-fast-1",
        end_point = "https://openrouter.ai/api/v1/chat/completions",
        api_key = "OPENROUTER_API_KEY",
        name = "Openrouter",
        stream = false,
        optional = {
          max_tokens = 256,
          stop = { "\n\n" },
        },
      },
    },
  },
  keys = {
    {
      "<A-y>",
      function()
        require("blink.cmp").show({ providers = { "minuet" } })
      end,
      mode = "i",
      desc = "Minuet Manual Completion",
    },
  },
}
