return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        mode = "n", -- NORMAL mode
        prefix = "<leader>",
        buffer = nil, 
        silent = true,
        noremap = true,
        nowait = true,
    },
    mappings = {
        b = {
            name = "Buffers",
            ["`"] = { "<cmd>BufferLineCyclePrev<CR>", "Previous"},
        }
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({global = false})
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
