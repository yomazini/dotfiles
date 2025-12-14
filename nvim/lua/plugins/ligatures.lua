return {
  -- We use a simple init function on a core plugin to ensure this runs
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- Define the autocommand
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
        callback = function()
          local ft = vim.bo.filetype
          local supported_ft = { 
            "javascript", "typescript", "typescriptreact", "javascriptreact", 
            "python", "cpp", "c", "go", "rust", "sh", "lua" 
          }
          
          if vim.tbl_contains(supported_ft, ft) then
            vim.opt_local.conceallevel = 2
            local ligatures = {
              ["!="] = "≠",
              ["=="] = "≡",
              [">="] = "≥",
              ["<="] = "≤",
              ["=>"] = "⇒",
              ["->"] = "→",
              ["<-"] = "←",
              ["::"] = "∷",
            }
            
            for k, v in pairs(ligatures) do
              -- Use matchadd to replace the symbols
              pcall(vim.fn.matchadd, "Conceal", k, 10, -1, { conceal = v })
            end
          end
        end,
      })
      return opts
    end,
  }
}
