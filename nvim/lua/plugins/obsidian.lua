return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },

  keys = {
    -- Navigation
    { "<leader>oh", function() vim.cmd("e ~/notes/index.md") end, desc = "Obsidian Home" },
    { "<leader>oi", function() vim.cmd("e ~/notes/inbox.md") end, desc = "Obsidian Inbox (Quick)" }, -- NEW
    
    -- Actions
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Notes" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
  },

  config = function(_, opts)
    require("obsidian").setup(opts)

    -- AUTO-TEMPLATE LOGIC
    local group = vim.api.nvim_create_augroup("ObsidianDefaultTemplate", { clear = true })
    vim.api.nvim_create_autocmd("BufNewFile", {
      group = group,
      pattern = "*.md",
      callback = function()
        local current_file = vim.fn.expand("%:p")
        if string.find(current_file, "/notes/") then
            local template_path = vim.fn.expand("~/notes/templates/standard-note.md")
            if vim.fn.filereadable(template_path) == 1 then
                local lines = vim.fn.readfile(template_path)
                local title = vim.fn.expand("%:t:r")
                local date = os.date("%Y-%m-%d")
                local id = tostring(os.time())
                
                for i, line in ipairs(lines) do
                    local l = line
                    l = string.gsub(l, "{{title}}", title)
                    l = string.gsub(l, "{{date}}", date)
                    l = string.gsub(l, "{{id}}", id)
                    lines[i] = l
                end
                vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
            end
        end
      end,
    })
  end,

  opts = {
    workspaces = { { name = "brain", path = "~/notes" } },
    completion = { nvim_cmp = false },
    templates = { subdir = "templates" },
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else for _ = 1, 4 do suffix = suffix .. string.char(math.random(65, 90)) end end
      return tostring(os.time()) .. "-" .. suffix
    end,
  },
}
