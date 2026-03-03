return {
  {
    "dmtrKovalenko/fff.nvim",
    lazy = false,
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      -- Keep startup snappy; fff indexes when first opened.
      lazy_sync = true,
      grep = {
        modes = { "plain", "regex", "fuzzy" },
      },
    },
    keys = {
      {
        "<leader><leader>",
        function()
          require("fff").find_files()
        end,
        desc = "Find files",
      },
      {
        "ff",
        function()
          require("fff").find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>ff",
        function()
          require("fff").find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>/",
        function()
          require("fff").live_grep()
        end,
        desc = "Live grep",
      },
      {
        "<leader>fw",
        function()
          require("fff").live_grep({ query = vim.fn.expand("<cword>") })
        end,
        desc = "Grep word under cursor",
      },
    },
  },
}
