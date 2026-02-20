return {
  "folke/which-key.nvim",
  lazy = false,
  priority = 900,
  config = function()
    require("config.whichkey").setup()
  end,
}
