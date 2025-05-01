return {
  -- Vague theme
  {
    "2nthony/vague.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("vague").setup({
        -- Any custom configuration options
      })
      vim.cmd.colorscheme("vague")
    end,
  },
  
  -- Transparent background
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup({
        groups = { -- table: default groups
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLineNr', 'EndOfBuffer',
        },
        extra_groups = {}, -- table: additional groups that should be cleared
        exclude_groups = {}, -- table: groups you don't want to clear
      })
      
      -- Enable transparency by default
      vim.cmd("TransparentEnable")
    end,
  },
}
