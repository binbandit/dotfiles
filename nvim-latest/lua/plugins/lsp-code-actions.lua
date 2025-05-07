return {
  -- Add VSCode-like shortcuts for code actions
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
    },
    config = function(_, opts)
      -- Try to map Ctrl+. for code actions (may not work in all terminals)
      vim.keymap.set({ "n", "i" }, "<C-.>", function()
        if vim.fn.mode() == "i" then
          -- If in insert mode, exit insert mode first
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end
        -- Show code actions
        vim.lsp.buf.code_action()
      end, { desc = "Code Action (VSCode style)" })

      -- Alternative mapping that works in all terminals
      vim.keymap.set({ "n" }, "<leader>.", function()
        vim.lsp.buf.code_action()
      end, { desc = "Code Action (VSCode style)" })

      -- Also map Alt+. as another alternative
      vim.keymap.set({ "n", "i" }, "<A-.>", function()
        if vim.fn.mode() == "i" then
          -- If in insert mode, exit insert mode first
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end
        -- Show code actions
        vim.lsp.buf.code_action()
      end, { desc = "Code Action (Alt+.)" })

      -- Add a more reliable mapping for insert mode
      vim.keymap.set({ "i" }, "<C-;>", function()
        -- Exit insert mode first
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        -- Show code actions
        vim.lsp.buf.code_action()
      end, { desc = "Code Action (Insert Mode)" })
    end,
  },
}
