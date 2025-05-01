-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Add Ctrl+S to save files in all modes
vim.keymap.set({ "n", "i", "v", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Add Ctrl+A to select all text
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all text" })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Exit insert mode and select all text" })

-- Add Ctrl+= and Ctrl+- for increment/decrement
vim.keymap.set("n", "<C-=>", function() require("dial.map").inc_normal() end, { desc = "Increment" })
vim.keymap.set("n", "<C-->", function() require("dial.map").dec_normal() end, { desc = "Decrement" })

-- Add handy redo shortcut (Ctrl+Y for redo, complementing the default Ctrl+R which can conflict with other mappings)
vim.keymap.set("n", "<C-y>", "<C-r>", { desc = "Redo" })
vim.keymap.set("n", "<C-r>", "<C-r>", { desc = "Redo" }) -- Keep the default binding too
