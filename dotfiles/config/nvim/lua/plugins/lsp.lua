return {
  -- Mason: install LSP servers, formatters, linters, debug adapters
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUpdate",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonInstallAll",
    },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- LSP
        "lua-language-server",
        "basedpyright",
        "ruff",
        "vtsls",
        "eslint-lsp",
        -- Formatters
        "biome",
        "stylua",
        "prettier",
        -- Debug adapters
        "debugpy",
        "codelldb",
        "js-debug-adapter",
      },
    },
    config = function(_, opts)
      require("mason").setup()
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        local mr = require("mason-registry")
        mr.refresh(function()
          for _, tool in ipairs(opts.ensure_installed) do
            local ok, pkg = pcall(mr.get_package, tool)
            if ok and not pkg:is_installed() then
              pkg:install()
            end
          end
        end)
      end, { desc = "Install configured Mason tools" })
    end,
  },

  -- Conform: formatting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      format_on_save = false, -- Disabled by default
      formatters_by_ft = {
        javascript = { "biome" },
        javascriptreact = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        css = { "biome" },
        python = { "ruff_format", "ruff_fix" },
        rust = { "rustfmt" },
        lua = { "stylua" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
      },
    },
  },

  -- lazydev: proper Lua LSP support for Neovim config/plugin development
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
}
