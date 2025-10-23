---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "DAP conditional breakpoint",
      },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "DAP REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local python = require("config.python")
      local interpreter = python.infer_python(vim.loop.cwd()) or python.host_python()
      require("dap-python").setup(interpreter, { include_configs = true })
      require("dap-python").test_runner = "pytest"
    end,
  },
  {
    "nvim-neotest/neotest",
    ft = "python",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
    },
    opts = function()
      local python = require("config.python")
      return {
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
            python = function()
              return python.infer_python(vim.loop.cwd()) or python.host_python()
            end,
          }),
        },
        output = { open_on_run = "short" },
        quickfix = { enable = false },
        status = { virtual_text = true },
      }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
    keys = {
      { "<leader>pN", function() require("neotest").run.run() end, desc = "Run nearest Python test" },
      { "<leader>pF", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run Python tests in file" },
      { "<leader>pS", function() require("neotest").summary.toggle() end, desc = "Toggle Python test summary" },
    },
  },
}
