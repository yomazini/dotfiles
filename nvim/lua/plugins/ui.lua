return {
  -- Twilight (Focus Mode)
  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.25, -- amount of dimming
      },
    },
    cmd = "Twilight",
    keys = { { "<leader>ut", "<cmd>Twilight<cr>", desc = "Toggle Twilight" } },
  },

  -- Rainbow Delimiters (Colored Brackets)
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -- Colorizer (Highlight Hex Codes)
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        names = false, -- "Name" codes like Blue or Red
        RRGGBB = true, -- #RRGGBB hex codes
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode = "background", -- Set the display mode.
        tailwind = true, -- Enable tailwind colors
        sass = { enable = true, parsers = { "css" }, }, -- Enable sass colors
        virtualtext = "■",
      },
    },
  },

  -- Bufferline (Cleaner Tabs)
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slant", -- Can be "slant" | "slope" | "thick" | "thin" | { 'any', 'any' }
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
    },
  },
  
  -- Indent Blankline (Visual Scope Lines)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        indent = {
            char = "│",
            tab_char = "│",
        },
        scope = { enabled = true, show_start = false, show_end = false },
        exclude = {
            filetypes = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "Trouble",
                "trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
            },
        },
    },
  }
}
