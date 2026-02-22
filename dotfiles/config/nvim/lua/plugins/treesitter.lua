return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup()

      -- Install parsers (no-op if already installed)
      require("nvim-treesitter").install({
        "lua", "vimdoc", "vim", "regex",
        "javascript", "typescript", "tsx", "html", "css", "json",
        "python", "rust", "toml",
        "yaml", "markdown", "markdown_inline",
        "bash", "dockerfile", "gitcommit", "diff",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
