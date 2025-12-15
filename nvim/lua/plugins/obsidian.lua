return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = false, -- Load immediately

  dependencies = { "nvim-lua/plenary.nvim" },

  keys = {
    -- FAILSAFE: Open the file directly using Vim command, NOT plugin command
    {
      "<leader>nn",
      function()
        vim.cmd("e ~/notes/index.md")
      end,
      desc = "Notes Index (Home)",
    },

    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Create New Note" },
    { "<leader>ng", "<cmd>ObsidianSearch<cr>", desc = "Search Notes" },
  },

  opts = {
    workspaces = {
      {
        name = "brain",
        path = "~/notes",
      },
    },

    -- Safety: No completion to avoid crash
    completion = { nvim_cmp = false },

    -- ID Gen
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,

    disable_frontmatter = false,
  },
}
