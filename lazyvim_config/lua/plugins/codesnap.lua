return {
  "mistricky/codesnap.nvim",
  build = "make",
  cmd = { "CodeSnap", "CodeSnapSave" },
  config = function()
    require("codesnap").setup({
      watermark = "",
      has_breadcrumbs = true,
      bg_theme = "bamboo",
    })
  end,
}
