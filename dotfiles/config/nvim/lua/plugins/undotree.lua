return {
  "mbbill/undotree",
  init = function()
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_WindowLayout = 3
    vim.g.undotree_SplitWidth = 40
    vim.g.undotree_DiffpanelHeight = 15
  end,
  keys = {
    { "<leader>uu", function() vim.cmd.UndotreeToggle() end, desc = "Toggle Undotree" },
  },
}
