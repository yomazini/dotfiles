return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",                -- Recommended
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>nn", ":e ~/notes/README.md<cr>", desc = "Notes Home" },
      { "<leader>nf", ":ObsidianQuickSwitch<cr>", desc = "Find Note" },
      { "<leader>ng", ":ObsidianSearch<cr>", desc = "Search Notes" },
      { "<leader>nt", ":ObsidianToday<cr>", desc = "Today Note" },
      { "<leader>on", ":ObsidianNew<cr>", desc = "New Note" },
    },
    opts = {
      workspaces = {
        { name = "notes", path = "~/notes" },
      },
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
    },
  },
}
