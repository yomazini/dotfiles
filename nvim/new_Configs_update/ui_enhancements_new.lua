return 
{
  -- 1. Fidget.nvim dd (LSP Progress Viewer)
  -- "Pro" Config: Smoother animation & cleaner look
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        suppress_on_insert = false, -- Keep showing progress while typing
        ignore_done_already = true, -- Don't show "Done" if it was too fast
        ignore_empty_message = true, -- Don't show empty messages
        display = {
          render_limit = 5, -- Max lines to show (prevents clutter)
          done_ttl = 3, -- Keep "Done" message for 3 seconds
          progress_icon = { pattern = "dots", period = 1 }, -- Smoother animation
        },
      },
      notification = {
        window = {
          winblend = 0, -- Transparent background (blends with theme)
          align = "bottom", -- Stick to bottom right
          x_padding = 1,
        },
      },
    },
  },

  -- 2. Vim Tpipeline (Tmux Status Integration)
  {
    "vimpostor/vim-tpipeline",
    lazy = false,
    init = function()
      -- User Request: Disable status line ALWAYS (only visible in Tmux)
      vim.opt.laststatus = 0
      vim.opt.cmdheight = 1 -- Keep cmdline visible
      
      vim.g.tpipeline_autoembed = 0
      vim.g.tpipeline_statusline_indicator = { insert = "  INSERT  ", normal = "  NORMAL  " }
      
      -- Force refresh on focus gain
      vim.api.nvim_create_autocmd("FocusGained", { command = "redraw!" })
    end,
  },
}
