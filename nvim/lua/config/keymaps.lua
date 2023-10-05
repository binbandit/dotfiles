-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


-- This file is automatically loaded by lazyvim.config.init
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Move to window using the <ctrl> hjkl keys
map("n", "<M-Left>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<M-Down>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<M-Up>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<M-Right>", "<C-w>l", { desc = "Go to right window", remap = true })

-- -- HARPOON! --
-- -- Description for the main key binding. Ensure to verify this as it only provides a name.
-- map("n", "m", function() end, { desc = " Harpoon" })

-- -- Harpoon mappings
-- map("n", "mm", ":lua require('harpoon.mark').add_file()<cr>", { desc = "Mark file", remap = true })
-- map("n", "mt", ":lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = "Toggle UI", remap = true })
-- map("n", "ma", ":lua require('harpoon.ui').nav_file(1)<cr>", { desc = "Goto mark 1", remap = true })
-- map("n", "ms", ":lua require('harpoon.ui').nav_file(2)<cr>", { desc = "Goto mark 2", remap = true })
-- map("n", "md", ":lua require('harpoon.ui').nav_file(3)<cr>", { desc = "Goto mark 3", remap = true })
-- map("n", "mf", ":lua require('harpoon.ui').nav_file(4)<cr>", { desc = "Goto mark 4", remap = true })
-- map("n", "mg", ":lua require('harpoon.ui').nav_file(5)<cr>", { desc = "Goto mark 5", remap = true })
-- map("n", "mq", ":lua require('harpoon.ui').nav_file(6)<cr>", { desc = "Goto mark 6", remap = true })
-- map("n", "mw", ":lua require('harpoon.ui').nav_file(7)<cr>", { desc = "Goto mark 7", remap = true })
-- map("n", "me", ":lua require('harpoon.ui').nav_file(8)<cr>", { desc = "Goto mark 8", remap = true })
-- map("n", "mr", ":lua require('harpoon.ui').nav_file(9)<cr>", { desc = "Goto mark 9", remap = true })
-- map("n", "mn", ":lua require('harpoon.ui').nav_next()<cr>", { desc = "Next file", remap = true })
-- map("n", "mp", ":lua require('harpoon.ui').nav_prev()<cr>", { desc = "Prev file", remap = true })