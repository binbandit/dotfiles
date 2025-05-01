return {
  -- Disable bufferline (tab bar)
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  
  -- Disable showtabline
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      -- Disable tabline
      vim.opt.showtabline = 0
    end,
  },
}
