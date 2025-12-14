return {
  -- Add Bash to Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "bash" })
      end
    end,
  },

  -- Add Mason packages for Bash
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server", -- LSP
        "shfmt",                -- Formatter
        "shellcheck",           -- Linter
      })
    end,
  },

  -- Setup bash-ls via nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
    },
  },
}
