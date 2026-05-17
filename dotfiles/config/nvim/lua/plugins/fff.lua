return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  lazy = false,
  opts = {
    lazy_sync = true,
    layout = {
      prompt_position = "bottom",
      preview_position = "right",
      preview_size = 0.5,
    },
    preview = {
      enabled = true,
      line_numbers = false,
    },
    frecency = { enabled = true },
    history = { enabled = true },
    grep = {
      modes = { "plain", "regex", "fuzzy" },
      smart_case = true,
    },
    git = {
      status_text_color = true,
    },
  },
  keys = {
    {
      "<leader><leader>",
      function() require("fff").find_files() end,
      desc = "Find files",
    },
    {
      "<leader>ff",
      function() require("fff").find_files() end,
      desc = "Find files",
    },

    {
      "<leader>/",
      function() require("fff").live_grep() end,
      desc = "Live grep",
    },
    {
      "<leader>fw",
      function() require("fff").live_grep({ query = vim.fn.expand("<cword>") }) end,
      desc = "Grep word under cursor",
    },
    {
      "<leader>fz",
      function()
        require("fff").live_grep({
          grep = { modes = { "fuzzy", "plain" } },
        })
      end,
      desc = "Fuzzy grep",
    },
  },
}
