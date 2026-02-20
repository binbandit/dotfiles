return {
  -- Mason: install LSP servers, formatters, linters, debug adapters
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- LSP
        "lua-language-server",
        "basedpyright",
        "ruff",
        "vtsls",
        -- Formatters
        "biome",
        -- Debug adapters
        "debugpy",
        "codelldb",
        "js-debug-adapter",
      },
    },
    config = function(_, opts)
      require("mason").setup()
      -- Auto-install tools listed in ensure_installed
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local ok, p = pcall(mr.get_package, tool)
          if ok and not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- Conform: formatting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
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

  -- Fidget: LSP progress indicator
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
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
