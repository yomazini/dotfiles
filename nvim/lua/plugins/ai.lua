return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves the UI for input
  },
  config = true,
  opts = {
    strategies = {
      chat = {
        adapter = "gemini",
      },
      inline = {
        adapter = "gemini",
      },
      agent = {
        adapter = "gemini",
      },
    },
    adapters = {
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = os.getenv("GEMINI_API_KEY"),
          },
        })
      end,
    },
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat (Gemini)" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "AI Actions (Gemini)" },
    { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", desc = "AI Explain Code" },
    { "<leader>af", "<cmd>CodeCompanion /fix<cr>", desc = "AI Fix Code" },
  },
}
