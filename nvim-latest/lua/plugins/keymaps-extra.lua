return {
  -- Add extra keymaps
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Add Ctrl+A to select all text in insert mode
      vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Select all text" })

      -- Add Ctrl+= and Ctrl+- for increment/decrement in insert mode
      vim.keymap.set("i", "<C-=>", "<Esc><C-=>", { desc = "Increment" })
      vim.keymap.set("i", "<C-->", "<Esc><C-->", { desc = "Decrement" })

      -- Note: We don't need to add Ctrl+S to save as it's already included in LazyVim
    end,
  },
}
