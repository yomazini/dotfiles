return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    -- 1. WAR ROOM (The Command Center)
    {
      "<leader>ww",
      function()
        vim.cmd("e ~/notes/1_Projects/00_V1_COMMAND_CENTER.md")
      end,
      desc = "V1 Command Center",
    },
    -- 2. Inbox (Quick Capture)
    {
      "<leader>oi",
      function()
        vim.cmd("e ~/notes/0_Inbox/inbox.md")
      end,
      desc = "Obsidian Inbox",
    },

    -- 3. Navigation
    {
      "<leader>oh",
      function()
        vim.cmd("e ~/notes/index.md")
      end,
      desc = "Obsidian Home",
    },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note (to Inbox)" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Notes" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
    { "<leader>om", "<cmd>ObsidianRename<cr>", desc = "Move / Rename Note" },
    -- OPEN IN APP (GUI)
    {
      "<leader>oo",
      function()
        local path = vim.api.nvim_buf_get_name(0)
        local uri = "obsidian://open?path=" .. path
        vim.cmd("silent !xdg-open '" .. uri .. "'")
      end,
      desc = "Open in Desktop App",
    },

    -- OPEN LINK IN APP (Cursor)
    {
      "<leader>ol",
      function()
        -- Get the word under cursor (or visually selected file path)
        local file = vim.fn.expand("<cfile>")
        -- If it has no extension, assume .md, but we want to find the real path
        -- We will use the Obsidian Client to resolve it if possible, or naive search
        local client = require("obsidian").get_client()
        local note = client:resolve_note(file)
        if note then
          local uri = "obsidian://open?path=" .. note.path.filename
          vim.cmd("silent !xdg-open '" .. uri .. "'")
          print("🚀 Opening " .. note.id)
        else
          -- Fallback for non-note files (like images/drawings in assets)
          -- Try to find it in the vault
          vim.cmd("silent !xdg-open 'obsidian://open?file=" .. file .. "'")
        end
      end,
      desc = "Open Cursor Link in App",
    },
  },

  config = function(_, opts)
    require("obsidian").setup(opts)

    -- AUTO-TEMPLATE LOGIC
    local group = vim.api.nvim_create_augroup("ObsidianDefaultTemplate", { clear = true })
    vim.api.nvim_create_autocmd("BufNewFile", {
      group = group,
      pattern = "*.md",
      callback = function()
        local relative = vim.fn.expand("%:p")
        if string.find(relative, "/notes/") then
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

    -- AUTO-OPEN EXCALIDRAW IN APP
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.excalidraw",
      callback = function()
        local path = vim.fn.expand("%:p")
        vim.schedule(function()
          vim.cmd("silent !xdg-open 'obsidian://open?path=" .. path .. "'")
          vim.cmd("bdelete")
        end)
      end,
    })
  end,
  opts = {
    workspaces = { { name = "brain", path = "~/notes" } },
    completion = { nvim_cmp = false },
    templates = { subdir = "templates" },
    new_notes_location = "notes_subdir",
    notes_subdir = "0_Inbox",
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
