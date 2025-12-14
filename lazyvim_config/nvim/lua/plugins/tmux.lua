return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Tmux Left" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Tmux Down" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Tmux Up" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Tmux Right" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Tmux Previous" },
    },
  },
}
