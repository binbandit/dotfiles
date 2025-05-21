return {
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/which-key.nvim",
    },
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      -- Main lazygit toggle
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
      -- Open lazygit with current file
      { "<leader>gf", "<cmd>LazyGitCurrentFile<CR>", desc = "LazyGit Current File" },
      -- Open lazygit config
      { "<leader>gc", "<cmd>LazyGitConfig<CR>", desc = "LazyGit Config" },
    },
    config = function()
      -- Check if lazygit is installed
      local lazygit_exists = vim.fn.executable("lazygit") == 1
      if not lazygit_exists then
        vim.notify(
          "LazyGit executable not found! Please install lazygit:\n" ..
          "  - macOS: brew install lazygit\n" ..
          "  - Linux: Follow instructions at https://github.com/jesseduffield/lazygit#installation\n" ..
          "  - Windows: choco install lazygit or scoop install lazygit",
          vim.log.levels.WARN,
          { title = "LazyGit Missing", timeout = 10000 }
        )
      end

      -- Configure lazygit.nvim
      vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- customize border chars
      vim.g.lazygit_floating_window_use_plenary = 1 -- use plenary.nvim to manage floating window if available
      vim.g.lazygit_use_neovim_remote = 0 -- fallback to 0 if neovim-remote is not installed
      vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1

      -- Register with which-key
      local wk = require("which-key")
      wk.register({
        g = {
          name = "Git",
          g = { "<cmd>LazyGit<CR>", "LazyGit" },
          f = { "<cmd>LazyGitCurrentFile<CR>", "LazyGit Current File" },
          c = { "<cmd>LazyGitConfig<CR>", "LazyGit Config" },
        },
      }, { prefix = "<leader>" })
    end,
  },
}
