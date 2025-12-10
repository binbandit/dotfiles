return {
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "eslint" }, -- Add more as needed
            })
        end
    },
    {
        "stevearc/conform.nvim",
        config = function()
            require('conform').setup({
                format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
                formatters_by_ft = {
                    javascript = { "biome" },
                    javascriptreact = { "biome" },
                    typescript = { "biome" },
                    typescriptreact = { "biome" }
                }
            })
        end,
    },
    {
      "j-hui/fidget.nvim",
    }
}
