return {
  "mbbill/undotree",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
  },
  config = function()
    -- Set up undotree configuration
    vim.g.undotree_WindowLayout = 2  -- Layout style (2 is right panel)
    vim.g.undotree_ShortIndicators = 1  -- Use short indicators
    vim.g.undotree_SplitWidth = 30  -- Width of the undotree panel
    vim.g.undotree_DiffpanelHeight = 10  -- Height of the diff panel
    vim.g.undotree_SetFocusWhenToggle = 1  -- Focus on the undotree when toggled

    -- Note: The undo directory and persistent undo settings are configured in options.lua
  end,
}
