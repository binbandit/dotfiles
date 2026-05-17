return {
  {
    "saghen/blink.compat",
    version = "2.*",
    lazy = true,
    opts = {},
  },
  {
    "ThePrimeagen/99",
    lazy = true,
    dependencies = {
      "saghen/blink.compat",
    },
    config = function()
      local _99 = require("99")

      _99.setup({
        logger = {
          level = _99.INFO,
          path = nil,
          print_on_error = true,
        },
        tmp_dir = "./tmp",
        md_files = {
          "AGENTS.md",
          "AGENT.md",
          "CLAUDE.md",
        },
        completion = {
          source = "blink",
          custom_rules = {
            vim.fn.expand("~/.dots/dotfiles/agents/skills/"),
          },
          files = {
            enabled = true,
          },
        },
      })
    end,
    keys = {
      {
        "<leader>9s",
        function()
          require("99").search()
        end,
        desc = "Search project",
      },
      {
        "<leader>9v",
        function()
          require("99").vibe()
        end,
        desc = "Vibe",
      },
      {
        "<leader>9v",
        function()
          require("99").visual()
        end,
        mode = "v",
        desc = "Rewrite selection",
      },
      {
        "<leader>9w",
        function()
          require("99").Extensions.Worker.set_work()
        end,
        desc = "Set work",
      },
      {
        "<leader>9W",
        function()
          require("99").Extensions.Worker.search()
        end,
        desc = "Search work",
      },
      {
        "<leader>9a",
        function()
          require("99").Extensions.Worker.vibe()
        end,
        desc = "Apply work",
      },
      {
        "<leader>9o",
        function()
          require("99").open()
        end,
        desc = "Open results",
      },
      {
        "<leader>9l",
        function()
          require("99").view_logs()
        end,
        desc = "View logs",
      },
      {
        "<leader>9i",
        function()
          require("99").info()
        end,
        desc = "Info",
      },
      {
        "<leader>9x",
        function()
          require("99").stop_all_requests()
        end,
        desc = "Stop requests",
      },
      {
        "<leader>9c",
        function()
          require("99").clear_previous_requests()
        end,
        desc = "Clear history",
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>9", group = "99" },
      },
    },
  },
}
