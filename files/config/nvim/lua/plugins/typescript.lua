return {
    "pmizio/typescript-tools.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
        "saghen/blink.cmp",
    },
    opts = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        if pcall(require, "blink.cmp") then
            capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
        elseif pcall(require, "cmp_nvim_lsp") then
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        end

        return {
            capabilities = capabilities,
        }
    end,
}
