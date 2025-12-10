local map = vim.keymap.set
local opts = { silent = true }

local function write_buffer()
  if vim.bo.readonly or not vim.bo.modifiable then
    vim.notify("Current buffer is not writable", vim.log.levels.WARN, { title = "Save" })
    return
  end

  local ok, err = pcall(vim.cmd, "silent update")
  if not ok then
    vim.notify(("Write failed: %s"):format(err), vim.log.levels.ERROR, { title = "Save" })
  end
end

map({ "n", "v" }, "<leader>w", write_buffer, vim.tbl_extend("keep", { desc = "Write buffer" }, opts))
map("n", "<leader>qq", "<cmd>confirm quit<CR>", vim.tbl_extend("keep", { desc = "Quit" }, opts))

map(
  "n",
  "<leader>ti",
  function()
    require("config.lsp").toggle_inlay_hints()
  end,
  vim.tbl_extend("keep", { desc = "Toggle inlay hints" }, opts)
)
map("n", "<leader>bd", "<cmd>bdelete<CR>", vim.tbl_extend("keep", { desc = "Close buffer" }, opts))
map("n", "<leader>`", "<cmd>b#<CR>", vim.tbl_extend("keep", { desc = "Alternate buffer" }, opts))
map("n", "<leader>?", function()
  require("fzf-lua").commands()
end, vim.tbl_extend("keep", { desc = "Command palette" }, opts))
map("n", "<leader>/", function()
  require("fzf-lua").live_grep()
end, vim.tbl_extend("keep", { desc = "Live grep" }, opts))

map("n", "<leader>|", "<cmd>vsplit<CR>", vim.tbl_extend("keep", { desc = "Vertical split" }, opts))
map("n", "<leader>sv", "<cmd>vsplit<CR>", vim.tbl_extend("keep", { desc = "Split right" }, opts))
map("n", "<leader>sh", "<cmd>split<CR>", vim.tbl_extend("keep", { desc = "Split below" }, opts))
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-]>", "<C-w>w", opts)
map("n", "<C-[>", "<C-w>W", opts)
map("n", "<C-a>", "ggVG", vim.tbl_extend("keep", { desc = "Select entire file" }, opts))
