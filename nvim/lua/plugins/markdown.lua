-- return {
--   "MeanderingProgrammer/render-markdown.nvim",
--   -- optional: add dependencies if needed, e.g., for icons or specific parsers
--   dependencies = { "nvim-treesitter/nvim-treesitter" },
--   config = function()
--     require("render-markdown").setup({
--       -- your configuration options go here
--     })
--   end,
-- }
--

--   {
--     "MeanderingProgrammer/render-markdown.nvim",
--     opts = {
--       -- Tables are the highlight here
--       pipe_table = {
--         preset = "heavy", -- Options: "normal", "heavy", "round", "double"
--         style = "full", -- Renders full borders around cells
--         cell = "padded", -- Adds spacing inside cells for readability
--       },
--       -- Enhances other markdown elements for a cohesive look
--       heading = {
--         sign = true, -- Shows icons in the sign column
--         icons = { "   ", "   ", "   ", "   ", "   ", "   " },
--       },
--       code = {
--         sign = true,
--         width = "block", -- Code blocks span the width of the window
--         right_pad = 4,
--       },
--     },
--   },
-- }

-- ============================================================================
-- Complete render-markdown.nvim Configuration
-- Beautiful markdown rendering in Neovim with ALL features enabled
-- ============================================================================

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons", -- For file type icons
    },
    ft = { "markdown", "vimwiki", "quarto" }, -- Load only for markdown files
    opts = {
      -- ========== HEADINGS ==========
      heading = {
        enabled = true,
        sign = true, -- Show icons in sign column
        position = "inline", -- Inline with text (not overlay)
        icons = {
          "󰲡 ", -- H1 - Large dot
          "󰲣 ", -- H2 - Medium dot
          "󰲥 ", -- H3 - Small dot
          "󰲧 ", -- H4 - Smaller dot
          "󰲩 ", -- H5 - Tiny dot
          "󰲫 ", -- H6 - Smallest dot
        },
        -- Different background colors for each heading level
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        -- Foreground colors for heading text
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },

      -- ========== CODE BLOCKS ==========
      code = {
        enabled = true,
        sign = true, -- Show icon in sign column
        style = "full", -- Options: "full", "normal", "language", "none"
        position = "left", -- Code block position
        width = "block", -- Full width code blocks
        left_pad = 2, -- Padding on left
        right_pad = 4, -- Padding on right
        min_width = 80, -- Minimum width
        border = "thin", -- Border style: "thin", "thick", "none"
        above = "▄", -- Character above code block
        below = "▀", -- Character below code block
        highlight = "RenderMarkdownCode", -- Highlight group
        highlight_inline = "RenderMarkdownCodeInline", -- Inline code highlight
      },

      -- ========== TABLES ==========
      pipe_table = {
        enabled = true,
        preset = "heavy", -- Options: "normal", "heavy", "round", "double", "none"
        style = "full", -- Options: "full", "normal", "none"
        cell = "padded", -- Options: "padded", "raw", "overlay"
        -- border = {
        --   "┏",
        --   "┓",
        --   "┗",
        --   "┛",
        --   "┃",
        --   "━", -- Heavy borders
        -- },
        alignment_indicator = "━", -- Character for alignment
        head = "RenderMarkdownTableHead", -- Highlight for header
        row = "RenderMarkdownTableRow", -- Highlight for rows
      },

      -- ========== LISTS & CHECKBOXES ==========
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" }, -- Different levels
        left_pad = 0,
        right_pad = 1,
        highlight = "RenderMarkdownBullet",
      },

      checkbox = {
        enabled = true,
        position = "inline",
        unchecked = {
          icon = "󰄱 ", -- Empty checkbox
          highlight = "RenderMarkdownUnchecked",
        },
        checked = {
          icon = "󰱒 ", -- Checked checkbox
          highlight = "RenderMarkdownChecked",
        },
        custom = {
          todo = {
            raw = "[-]",
            rendered = "󰥔 ", -- In progress
            highlight = "RenderMarkdownTodo",
          },
          important = {
            raw = "[!]",
            rendered = " ", -- Important
            highlight = "DiagnosticWarn",
          },
        },
      },

      -- ========== QUOTES & CALLOUTS ==========
      quote = {
        enabled = true,
        icon = "▋", -- Vertical bar for quotes
        repeat_linebreak = true, -- Continue quote on empty lines
        highlight = "RenderMarkdownQuote",
      },

      -- Obsidian-style callouts (> [!NOTE], > [!WARNING], etc.)
      callout = {
        note = {
          raw = "[!NOTE]",
          rendered = "󰋽 Note",
          highlight = "RenderMarkdownInfo",
        },
        tip = {
          raw = "[!TIP]",
          rendered = "󰌶 Tip",
          highlight = "RenderMarkdownSuccess",
        },
        important = {
          raw = "[!IMPORTANT]",
          rendered = " Important",
          highlight = "RenderMarkdownHint",
        },
        warning = {
          raw = "[!WARNING]",
          rendered = " Warning",
          highlight = "RenderMarkdownWarn",
        },
        caution = {
          raw = "[!CAUTION]",
          rendered = " Caution",
          highlight = "RenderMarkdownError",
        },
        -- Custom callouts
        abstract = {
          raw = "[!ABSTRACT]",
          rendered = "󰨸 Abstract",
          highlight = "RenderMarkdownInfo",
        },
        todo = {
          raw = "[!TODO]",
          rendered = " Todo",
          highlight = "RenderMarkdownTodo",
        },
        success = {
          raw = "[!SUCCESS]",
          rendered = "󰄬 Success",
          highlight = "RenderMarkdownSuccess",
        },
        question = {
          raw = "[!QUESTION]",
          rendered = "󰘥 Question",
          highlight = "RenderMarkdownHint",
        },
        failure = {
          raw = "[!FAILURE]",
          rendered = "󰅖 Failure",
          highlight = "RenderMarkdownError",
        },
        danger = {
          raw = "[!DANGER]",
          rendered = "󱐌 Danger",
          highlight = "RenderMarkdownError",
        },
        bug = {
          raw = "[!BUG]",
          rendered = " Bug",
          highlight = "RenderMarkdownError",
        },
        example = {
          raw = "[!EXAMPLE]",
          rendered = "󰉹 Example",
          highlight = "RenderMarkdownHint",
        },
        quote = {
          raw = "[!QUOTE]",
          rendered = "󱆨 Quote",
          highlight = "RenderMarkdownQuote",
        },
      },

      -- ========== LINKS ==========
      link = {
        enabled = true,
        image = "󰥶 ", -- Icon for images
        email = "󰀓 ", -- Icon for emails
        hyperlink = "󰌹 ", -- Icon for links
        highlight = "RenderMarkdownLink",
        custom = {
          web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
          obsidian = { pattern = "^obsidian://", icon = " ", highlight = "RenderMarkdownLink" },
        },
      },

      -- ========== INLINE ELEMENTS ==========
      inline_highlight = {
        enabled = true,
      },

      -- Inline code (`code`)
      inline_code = {
        enabled = true,
        highlight = "RenderMarkdownCodeInline",
      },

      -- Bold (**text**)
      bold = {
        enabled = true,
        highlight = "RenderMarkdownBold",
      },

      -- Italic (*text*)
      italic = {
        enabled = true,
        highlight = "RenderMarkdownItalic",
      },

      -- Strikethrough (~~text~~)
      strikethrough = {
        enabled = true,
        highlight = "RenderMarkdownStrikethrough",
      },

      -- ========== HORIZONTAL RULES ==========
      dash = {
        enabled = true,
        icon = "─", -- Character for horizontal rules
        width = "full", -- Full width
        highlight = "RenderMarkdownDash",
      },

      -- ========== LATEX MATH ==========
      latex = {
        enabled = true,
        converter = "latex2text", -- Options: "latex2text", "none"
        highlight = "RenderMarkdownMath",
      },

      -- ========== HTML ==========
      html = {
        enabled = true,
        comment = {
          conceal = true, -- Hide HTML comments
          highlight = "RenderMarkdownHtmlComment",
        },
      },

      -- ========== SPECIAL CHARACTERS ==========
      -- Non-breaking spaces
      nbsp = {
        enabled = true,
        highlight = "RenderMarkdownNbsp",
      },

      -- ========== ANTI-CONCEAL ==========
      -- Show raw markdown when cursor is on the line
      anti_conceal = {
        enabled = true, -- Show raw markdown on cursor line
      },

      -- ========== RENDERING OPTIONS ==========
      render_modes = true, -- Enable different modes
      max_file_size = 10.0, -- Max file size in MB to render
      debounce = 100, -- Debounce rendering (ms)

      -- Custom highlights (optional - uses theme colors by default)
      highlights = {
        heading = {
          backgrounds = {
            "DiffAdd",
            "DiffChange",
            "DiffDelete",
            "DiffText",
            "DiffAdd",
            "DiffChange",
          },
          foregrounds = {
            "@markup.heading.1.markdown",
            "@markup.heading.2.markdown",
            "@markup.heading.3.markdown",
            "@markup.heading.4.markdown",
            "@markup.heading.5.markdown",
            "@markup.heading.6.markdown",
          },
        },
      },

      -- ========== FILE TYPES ==========
      file_types = { "markdown", "vimwiki" },

      -- ========== INJECTIONS ==========
      injections = {
        gitcommit = {
          enabled = true,
          query = [[
            ((message) @injection.content
             (#set! injection.combined)
             (#set! injection.include-children)
             (#set! injection.language "markdown"))
          ]],
        },
      },
    },

    -- ========== KEYMAPS ==========
    keys = {
      -- Toggle rendering on/off
      {
        "<leader>um",
        "<cmd>RenderMarkdown toggle<cr>",
        desc = "Toggle Markdown Render",
        ft = "markdown",
      },
      -- Expand/collapse sections (if supported by your setup)
      {
        "<leader>me",
        "<cmd>RenderMarkdown expand<cr>",
        desc = "Expand Markdown Section",
        ft = "markdown",
      },
    },

    -- ========== COMMANDS SETUP ==========
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- Custom command to toggle render
      vim.api.nvim_create_user_command("MarkdownToggle", function()
        vim.cmd("RenderMarkdown toggle")
      end, { desc = "Toggle markdown rendering" })

      -- Auto-enable for markdown files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "vimwiki" },
        callback = function()
          vim.cmd("RenderMarkdown enable")
        end,
      })
    end,
  },

  --
  --
  --   opts = {
  --   default = {
  --     dir_path = "assets",
  --     file_name = "%Y-%m-%d-%H-%M-%S",
  --     prompt_for_file_name = false,
  --     show_dir_path_in_prompt = true,
  --
  --     -- CHANGE THESE TWO LINES:
  --     use_absolute_path = true,       -- Enable absolute paths
  --     relative_to_current_file = false, -- Disable relative paths
  --   },
  --   filetypes = {
  --     markdown = {
  --       dir_path = "assets",
  --       -- The template will now use the absolute path automatically
  --       template = "![$CURSOR]($FILE_PATH)",
  --     },
  --   },
  -- },
  -- ========== IMG-CLIP INTEGRATION ==========
  -- Paste images from clipboard
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        dir_path = "assets", -- Store in assets/ folder
        file_name = "%Y-%m-%d-%H-%M-%S", -- Timestamp naming
        prompt_for_file_name = false,
        show_dir_path_in_prompt = true,
        use_absolute_path = true, -- Relative paths
        relative_to_current_file = false,
      },
      -- File type specific settings
      filetypes = {
        markdown = {
          dir_path = "assets",
          template = "![$CURSOR]($FILE_PATH)",
        },
      },
    },
    keys = {
      {
        "<leader>ip",
        "<cmd>PasteImage<cr>",
        desc = "Paste image from clipboard",
        ft = "markdown",
      },
    },
  },
}
