return {
  "xiyaowong/transparent.nvim",
  config = function()
    -- Optional, you don't have to run setup.
    require("transparent").setup({
      -- table: default groups
      groups = {
        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
        'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
        'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
        'EndOfBuffer',
      },
      -- table: additional groups that should be cleared
      extra_groups = {
        "NormalFloat",
        -- Add more groups here
      },
      -- table: groups you don't want to clear
      exclude_groups = {},
      -- function: code to be executed after highlight groups are cleared
      -- Also the user event "TransparentClear" will be triggered
      on_clear = function() end,
    })
    
    -- Enable transparent mode on startup
    vim.cmd("TransparentEnable")
    
    -- Add a keymap to toggle transparency
    vim.keymap.set('n', '<leader>tt', ':TransparentToggle<CR>', { noremap = true, silent = true, desc = "Toggle Transparency" })
  end
}
