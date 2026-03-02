return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  opts = {
    dashboard = { enabled = false },
    picker = { enabled = false },
    explorer = { enabled = false },
    image = { enabled = false },
    indent = { enabled = false },
    scope = { enabled = false },
    statuscolumn = { enabled = false },
    scroll = { enabled = false },

    notifier = {
      enabled = true,
      timeout = 3000,
    },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
    lazygit = { enabled = true },
    bufdelete = { enabled = true },
    zen = { enabled = true },
    terminal = { enabled = true },
    input = { enabled = true },
    toggle = { enabled = true },
    dim = { enabled = true },
    rename = { enabled = true },
  },
  keys = {
    {
      "<C-\\>",
      function()
        require("snacks").terminal.toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle terminal",
    },
    {
      "<leader>gg",
      function()
        require("snacks").lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>fn",
      function()
        require("snacks").notifier.show_history()
      end,
      desc = "Notification history",
    },
    {
      "]]",
      function()
        require("snacks").words.jump(1, true)
      end,
      desc = "Next LSP reference",
    },
    {
      "[[",
      function()
        require("snacks").words.jump(-1, true)
      end,
      desc = "Prev LSP reference",
    },
    {
      "<leader>z",
      function()
        require("snacks").zen()
      end,
      desc = "Zen mode",
    },
    {
      "<leader>td",
      function()
        require("snacks").dim()
      end,
      desc = "Toggle dim",
    },
    {
      "<leader>bd",
      function()
        require("snacks").bufdelete()
      end,
      desc = "Delete buffer",
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
}
