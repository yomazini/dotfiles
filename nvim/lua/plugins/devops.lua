return {
  -- 1. Docker / DevOps Popup (LazyDocker)
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>ld",
        function()
          Snacks.terminal("lazydocker", {
            win = {
              position = "float",
              backdrop = 60,
              height = 0.9,
              width = 0.9,
              zindex = 50,
            },
          })
        end,
        desc = "LazyDocker",
      },
    },
  },

  -- 2. Syntax Highlighting (Treesitter)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "dockerfile", "terraform", "hcl" })
      end
    end,
  },

  -- 3. LSP Servers (Intelligence)
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "docker-compose-language-service",
        "dockerfile-language-server",
        "terraform-ls",
        "tflint",
      })
    end,
  },

  -- 4. LSP Config
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
        terraformls = {},
      },
    },
  },
}
