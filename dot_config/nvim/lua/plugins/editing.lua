---@type LazySpec
return {
  {
    "folke/which-key.nvim",
    lazy = false,
    priority = 900,
    config = function()
      require("config.whichkey").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      map_cr = true,
      disable_filetype = { "TelescopePrompt", "oil" },
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)
      local ok_lazy, lazy = pcall(require, "lazy")
      if ok_lazy and not package.loaded["blink.cmp"] then
        lazy.load({ plugins = { "blink.cmp" } })
      end
      require("config.autopairs").setup_blink()
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {
      mappings = {
        basic = true,
        extra = false,
      },
    },
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end,
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>st", "<cmd>TodoQuickFix<CR>", desc = "Todo quickfix" },
    },
  },
  {
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
  },
}
