return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = true,
        -- Removing custom header to restore default LazyVim logo
        preset = {
            -- header = "..." (Default will be used)
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
