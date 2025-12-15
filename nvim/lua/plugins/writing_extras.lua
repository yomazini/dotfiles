return {
  {
    "LazyVim/LazyVim",
    keys = {
      { "<leader>id", function() vim.api.nvim_put({ os.date("%Y-%m-%d") }, "c", true, true) end, desc = "Insert Date (Year-Month-Day)" },
      { "<leader>it", function() vim.api.nvim_put({ os.date("%H:%M") }, "c", true, true) end, desc = "Insert Time (Hour:Minute)" },
    },
  },
}
