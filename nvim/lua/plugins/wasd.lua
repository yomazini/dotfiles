return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      if opts.defaults then
        opts.defaults["<leader>u"] = opts.defaults["<leader>u"] or { group = "ui" }
      end
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Alt + WASD for Navigation (No toggle needed!)
      -- This allows you to type "while" normally, but hold Alt+w to go up.
      
      -- Normal, Visual, and Operator-pending modes
      -- We use a function to handle insert mode gracefully
      
      local map = vim.keymap.set
      
      -- Normal/Visual/Operator modes
      map({ "n", "v", "o" }, "<A-w>", "k", { desc = "Up" })
      map({ "n", "v", "o" }, "<A-a>", "h", { desc = "Left" })
      map({ "n", "v", "o" }, "<A-s>", "j", { desc = "Down" })
      map({ "n", "v", "o" }, "<A-d>", "l", { desc = "Right" })

      -- Insert mode (allows moving cursor while typing without exiting insert mode)
      map("i", "<A-w>", "<Up>", { desc = "Up" })
      map("i", "<A-a>", "<Left>", { desc = "Left" })
      map("i", "<A-s>", "<Down>", { desc = "Down" })
      map("i", "<A-d>", "<Right>", { desc = "Right" })

      vim.notify("WASD Ready: Hold Alt + w/a/s/d", vim.log.levels.INFO)
    end,
  },
}
