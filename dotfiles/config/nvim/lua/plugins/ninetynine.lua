return {
  "ThePrimeagen/99",
  event = "VeryLazy",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local _99 = require("99")

    local cwd = vim.uv.cwd() or ""
    local basename = vim.fs.basename(cwd)

    _99.setup({
      logger = {
        level = _99.WARN,
        path = "/tmp/" .. (basename ~= "" and basename or "nvim") .. ".99.debug",
        print_on_error = true,
      },
      tmp_dir = "./tmp",
      completion = {
        source = "cmp",
        custom_rules = {},
        files = {
          exclude = { ".git", "node_modules", "dist", "build", ".next", "coverage" },
        },
      },
      md_files = {
        "AGENT.md",
      },
    })

    vim.keymap.set("n", "<leader>99", function()
      _99.search()
    end, { desc = "99 search" })

    vim.keymap.set("n", "<leader>9s", function()
      _99.search()
    end, { desc = "99 search" })

    vim.keymap.set("v", "<leader>9v", function()
      _99.visual()
    end, { desc = "99 visual edit" })

    vim.keymap.set("n", "<leader>9x", function()
      _99.stop_all_requests()
    end, { desc = "99 stop requests" })

    vim.keymap.set("n", "<leader>9i", function()
      _99.info()
    end, { desc = "99 session info" })

    vim.keymap.set("n", "<leader>9l", function()
      _99.view_logs()
    end, { desc = "99 view logs" })
  end,
}
