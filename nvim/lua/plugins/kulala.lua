return {
  {
    "mistweaverco/kulala.nvim",
    opts = {},
    keys = {
      { "<leader>R", function() require("kulala").run() end, desc = "Kulala Run" },
      { "<leader>Ra", function() require("kulala").run_all() end, desc = "Kulala Run All" },
      { "<leader>Ri", function() require("kulala").inspect() end, desc = "Kulala Inspect" },
    },
  },
}
