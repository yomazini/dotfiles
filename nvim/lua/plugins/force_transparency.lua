return {
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local hl_groups = {
            "NeoTreeNormal",
            "NeoTreeNormalNC",
            "NeoTreeEndOfBuffer",
            "NeoTreeWinSeparator",
            "Normal",
            "NormalNC",
            "NormalFloat",
          }
          for _, name in ipairs(hl_groups) do
            vim.api.nvim_set_hl(0, name, { bg = "NONE" })
          end
        end,
      })
    end,
  },
}
