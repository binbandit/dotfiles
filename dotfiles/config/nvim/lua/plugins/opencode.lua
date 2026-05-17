return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...)
                return require("opencode").snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<A-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      local map = vim.keymap.set
      local opencode = require("opencode")

      vim.g.opencode_opts = {}
      vim.o.autoread = true -- Required for opencode's buffer reload events.

      map({ "n", "x" }, "<leader>oa", function()
        opencode.ask("@this: ", { submit = true })
      end, { desc = "Ask opencode" })

      map({ "n", "x" }, "<leader>os", function()
        opencode.select()
      end, { desc = "Select opencode action" })

      map("n", "<leader>ot", function()
        opencode.toggle()
      end, { desc = "Toggle opencode" })

      map({ "n", "x" }, "go", function()
        return opencode.operator("@this ")
      end, { desc = "Add range to opencode", expr = true })

      map("n", "goo", function()
        return opencode.operator("@this ") .. "_"
      end, { desc = "Add line to opencode", expr = true })
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>o", group = "opencode" },
      },
    },
  },
}
