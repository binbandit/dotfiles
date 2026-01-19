-- Autocmds
local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})

-- LSP attach keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    end,
})

-- Treesitter folding
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "*" },
    callback = function()
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldlevel = 99
    end,
})
