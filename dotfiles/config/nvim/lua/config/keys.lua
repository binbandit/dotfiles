local map = vim.keymap.set
local opts = { silent = true }

local function merge(extra)
  return vim.tbl_extend("keep", extra, opts)
end

-- Write buffer
local function write_buffer()
  if vim.bo.readonly or not vim.bo.modifiable then
    vim.notify("Current buffer is not writable", vim.log.levels.WARN)
    return
  end
  local ok, err = pcall(vim.cmd, "silent update")
  if not ok then
    vim.notify(("Write failed: %s"):format(err), vim.log.levels.ERROR)
  end
end

map({ "n", "v" }, "<leader>w", write_buffer, merge({ desc = "Write buffer" }))
map("n", "<leader>qq", "<cmd>confirm quit<CR>", merge({ desc = "Quit" }))
map("n", "<leader>`", "<cmd>b#<CR>", merge({ desc = "Alternate buffer" }))

-- Splits
map("n", "<leader>|", "<cmd>vsplit<CR>", merge({ desc = "Vertical split" }))
map("n", "<leader>sv", "<cmd>vsplit<CR>", merge({ desc = "Split right" }))
map("n", "<leader>sh", "<cmd>split<CR>", merge({ desc = "Split below" }))

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Select all
map("n", "<C-a>", "ggVG", merge({ desc = "Select entire file" }))

-- Diagnostics
map("n", "gl", vim.diagnostic.open_float, merge({ desc = "Show diagnostic float" }))
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, merge({ desc = "Previous diagnostic" }))
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, merge({ desc = "Next diagnostic" }))
map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, merge({ desc = "Previous error" }))
map("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, merge({ desc = "Next error" }))

-- Toggle virtual lines (full diagnostic below line)
map("n", "<leader>tl", function()
  local current = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = not current })
  vim.notify("Virtual lines: " .. (current and "OFF" or "ON"), vim.log.levels.INFO)
end, merge({ desc = "Toggle diagnostic virtual lines" }))

-- Toggle inlay hints
map("n", "<leader>ti", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  vim.notify("Inlay hints: " .. (vim.lsp.inlay_hint.is_enabled() and "ON" or "OFF"), vim.log.levels.INFO)
end, merge({ desc = "Toggle inlay hints" }))

-- Better indenting (stay in visual mode)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<cr>==", merge({ desc = "Move line down" }))
map("n", "<A-k>", "<cmd>m .-2<cr>==", merge({ desc = "Move line up" }))
map("v", "<A-j>", ":m '>+1<cr>gv=gv", merge({ desc = "Move selection down" }))
map("v", "<A-k>", ":m '<-2<cr>gv=gv", merge({ desc = "Move selection up" }))

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", merge({ desc = "Clear search highlight" }))
