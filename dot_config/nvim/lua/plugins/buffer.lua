return {
  "j-morano/buffer_manager.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  config = function(_, opts)
    require("buffer_manager").setup(opts)
  end,
  keys = {
    { "<leader>bb", function() require("buffer_manager.ui").toggle_quick_menu() end, desc = "Buffer manager" },
  },
}
