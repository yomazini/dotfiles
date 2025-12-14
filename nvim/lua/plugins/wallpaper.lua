return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Set Wallpaper + Dark Tint + Opaque Background
          vim.fn.system("kitty @ set-background-image /home/thejoceph/Pictures/Camera/wallpaper3.png")
          vim.fn.system("kitty @ set-background-tint 0.90")
          vim.fn.system("kitty @ set-background-opacity 1.0")
        end,
      })
      
      vim.api.nvim_create_autocmd("VimLeave", {
        callback = function()
          -- Reset to Transparent + No Image
          vim.fn.system("kitty @ set-background-image none")
          vim.fn.system("kitty @ set-background-tint 0.0")
          vim.fn.system("kitty @ set-background-opacity 0.85")
        end,
      })
      return opts
    end,
  }
}
