return {
  -- Configure LazyVim to load vague.nvim
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vague",
    },
  },

  -- Vague theme
  {
    "2nthony/vague.nvim",
    dependencies = {
      "rktjmp/lush.nvim",
    },
    priority = 1000, -- Make sure to load this before all the other start plugins
    config = function()
      -- Load the colorscheme
      require("vague").setup({
        -- Adjust the theme as needed
        transparent = vim.g.transparent_enabled, -- Use the transparent.nvim setting
        style = "default", -- Choose style: default, warm, cold
      })
    end,
  },
}
