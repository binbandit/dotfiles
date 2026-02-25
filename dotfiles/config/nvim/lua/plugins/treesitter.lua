return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    lazy = false,
    opts = {
      ensure_installed = {
        "lua", "vimdoc", "vim", "regex",
        "javascript", "typescript", "tsx", "html", "css", "json",
        "python", "rust", "toml",
        "yaml", "markdown", "markdown_inline",
        "bash", "dockerfile", "gitcommit", "diff",
      },
      auto_install = true,
      highlight = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
