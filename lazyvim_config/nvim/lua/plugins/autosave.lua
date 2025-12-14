return {
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle", -- Allow toggling with :ASToggle
    event = { "InsertLeave", "TextChanged" }, -- Trigger on typing stop or leave insert
    opts = {
      enabled = true, -- Start enabled
      trigger_events = { -- See :h events
        enable = true,
        dim = 0.18, -- Dim the text when saving (visual feedback)
        events = { "InsertLeave", "TextChanged" }, -- Save when changing text or leaving insert
      },
      -- The "Pro" Smoothness settings
      debounce_delay = 1000, -- Wait 1 second after typing stops before saving
      
      -- Prevents saving while you are actively typing in Insert mode
      -- This is CRITICAL for "smoothness" so Prettier doesn't jump your cursor
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")
        
        -- Don't save if in Insert mode (wait until I press Esc)
        if fn.mode() == "i" then
          return false
        end

        -- Don't save special buffers (like NeoTree, Telescope)
        if utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
          return true
        end
        return false
      end,
      
      -- Subtle notification (don't spam output)
      execution_message = {
        message = function() return ("") end, -- Silent save (Pro style)
        dim = 0.18,
        cleaning_interval = 1000,
      },
    },
  },
}
