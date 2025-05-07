return {
  -- Language support will be enabled via LazyExtras GUI

  -- Add more treesitter parsers for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "rust",
        "toml",
      })
    end,
  },

  -- Configure Mason to install necessary language servers and tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- TypeScript/JavaScript
        "typescript-language-server",
        "eslint-lsp",
        "prettier",
        "js-debug-adapter",

        -- Go
        "gopls",
        "goimports",
        "golangci-lint",
        "delve",

        -- Rust
        "rust-analyzer",
        "rustfmt",
      })
    end,
  },
}
