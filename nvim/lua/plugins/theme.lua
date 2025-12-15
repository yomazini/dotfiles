return {
  -- Install Catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "mocha", -- mocha, macchiato, frappe, latte
      transparent_background = true, -- Set to true if you want your terminal bg
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
      },
      -- Force transparency on Neo-tree window elements
      custom_highlights = function(colors)
        return {
          NeoTreeNormal = { bg = "NONE" },
          NeoTreeNormalNC = { bg = "NONE" },
          NeoTreeEndOfBuffer = { bg = "NONE" },
        }
      end,
    },
  },

  -- Set as Default Colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
