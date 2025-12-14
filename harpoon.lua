return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    -- 1. Mark file (Add to List)
    { "<leader>H", function() require("harpoon"):list():add() end, desc = "Harpoon Add File" },
    
    -- 2. Toggle Menu (See List)
    { "<leader>h", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon Menu" },
    
    -- 3. Fast Jumps
    { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
    { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
    { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
    { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
  },
}
