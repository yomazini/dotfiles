return {
  -- 1. Disable "Blue/Green Lines" (Indent Guides)
  { "lukas-reineke/indent-blankline.nvim", enabled = true },

  -- 2. Disable "Rainbow Brackets" (Colored parens)
  { "HiPhish/rainbow-delimiters.nvim", enabled = true },

  -- 3. Disable "Scope Animation" (The moving line near cursor)
  -- FIXED: Updated name from 'echasnovski/mini.indentscope' to prevent warning
  { "echasnovski/mini.indentscope", enabled = true },
  { "nvim-mini/mini.indentscope", enabled = true }, -- Cover both bases just in case
}
