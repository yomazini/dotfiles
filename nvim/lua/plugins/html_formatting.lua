return {
  -- 1. Ensure Prettier is installed via Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "prettier" })
    end,
  },
  -- 2. Configure Conform to use Prettier for HTML
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["html"] = { "prettier" },
        ["css"] = { "prettier" },
        ["json"] = { "prettier" },
      },
    },
  },
}
