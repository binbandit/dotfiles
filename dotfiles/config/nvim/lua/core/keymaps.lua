local map = vim.keymap.set

-- better escape
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- save / quit
for _, lhs in ipairs({ "<C-s>", "<D-s>" }) do
  map({ "n", "i", "x", "s" }, lhs, "<Esc><cmd>silent! update<cr>", { desc = "Save" })
end
map("n", "<leader>w", "<cmd>update<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- better movement
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- window resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- buffer navigation (helix-inspired: gn/gp for next/prev buffer)
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "gn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "gp", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "ga", "<cmd>e #<cr>", { desc = "Alternate file" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Toggle to previous file" })

-- move lines (alt+j/k)
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- better indenting (stay in visual mode)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- center on navigation
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- don't yank on paste in visual mode
map("x", "p", [["_dP]], { desc = "Paste without yanking" })
-- don't yank on x
map({ "n", "x" }, "x", '"_x')

-- select all (helix: %)
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

-- diagnostics (0.11+ API: vim.diagnostic.jump)
map("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
map("n", "]e", function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })
map("n", "[e", function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev error" })

-- quickfix
map("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<cr>zz", { desc = "Prev quickfix" })

-- terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- helix-inspired: match mode (mm for match brackets)
map("n", "mm", "%", { desc = "Match bracket" })

-- buffers: close buffer without wrecking window layout (defer Snacks access)
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Close buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Close other buffers" })

-- windows: splits, swap, maximize
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>=", "<C-w>=", { desc = "Equalize windows" })
map("n", "<leader>m", "<C-w>|<C-w>_", { desc = "Maximize window" })

-- LSP (set up on LspAttach, see autocmds)
-- Additional global LSP mappings
map("n", "<leader>ti", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"), vim.log.levels.INFO)
end, { desc = "Toggle inlay hints" })
