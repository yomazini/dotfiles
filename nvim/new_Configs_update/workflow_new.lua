return {
  -- 1. Vim Tmux ff Navigator
  -- "Pro" Config: Explicit mappings to prevent conflicts
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    init = function()
      -- Disable default mappings so we can define them cleanly below
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Window Left" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Window Down" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Window Up" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Window Right" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Window Previous" },
    },
  },

  -- 2. Tabout.nvim
  -- "Pro" Config: Added support for C++ Templates (< >)
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      tab_key = "<Tab>",
      shift_tab_key = "<S-Tab>",
      act_as_tab = true,
      act_as_shift_tab = false,
      enable_backwards = true,
      completion = true,
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        -- ADDED FOR C++: Support jumping out of template brackets <T>
        { open = "<", close = ">" }, 
      },
      ignore_beginning = true,
      exclude = {}, -- Can exclude filetypes here if needed
    },
  },
}
