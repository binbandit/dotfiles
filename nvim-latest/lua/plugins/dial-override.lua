return {
  -- Override dial.nvim to use Ctrl+= and Ctrl+- for increment/decrement
  {
    "monaqa/dial.nvim",
    optional = true,
    keys = {
      -- Use Ctrl+= for increment
      {
        "<C-=>",
        function()
          return require("dial.map").inc_normal()
        end,
        expr = true,
        desc = "Increment",
        mode = { "n" },
      },
      -- Use Ctrl+- for decrement
      {
        "<C-->",
        function()
          return require("dial.map").dec_normal()
        end,
        expr = true,
        desc = "Decrement",
        mode = { "n" },
      },
      -- Add Ctrl+A for select all
      {
        "<C-a>",
        function()
          vim.cmd("normal! ggVG")
          return ""
        end,
        expr = true,
        desc = "Select All",
        mode = { "n" },
      },
    },
  },
}
