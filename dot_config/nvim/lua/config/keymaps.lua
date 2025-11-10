local env = require("config.env")
local map = vim.keymap.set
local opts = { silent = true }
local use_supermaven = env.uses_supermaven()

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
map("n", "<leader>h", "<cmd>nohlsearch<CR>", vim.tbl_extend("keep", { desc = "Clear highlights" }, opts))
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
map(
  "n",
  "gl",
  vim.diagnostic.open_float,
  vim.tbl_extend("keep", { desc = "Line diagnostics" }, opts)
)
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

-- Folding keymaps
map("n", "za", "za", vim.tbl_extend("keep", { desc = "Toggle fold under cursor" }, opts))
map("n", "zA", "zA", vim.tbl_extend("keep", { desc = "Toggle all folds under cursor" }, opts))
map("n", "zo", "zo", vim.tbl_extend("keep", { desc = "Open fold under cursor" }, opts))
map("n", "zO", "zO", vim.tbl_extend("keep", { desc = "Open all folds under cursor" }, opts))
map("n", "zc", "zc", vim.tbl_extend("keep", { desc = "Close fold under cursor" }, opts))
map("n", "zC", "zC", vim.tbl_extend("keep", { desc = "Close all folds under cursor" }, opts))
map("n", "zm", "zm", vim.tbl_extend("keep", { desc = "Fold more" }, opts))
map("n", "zM", "zM", vim.tbl_extend("keep", { desc = "Close all folds" }, opts))
map("n", "zr", "zr", vim.tbl_extend("keep", { desc = "Fold less" }, opts))
map("n", "zR", "zR", vim.tbl_extend("keep", { desc = "Open all folds" }, opts))

if use_supermaven then
  map("n", "<leader>ai", function()
    require("lazy").load({ plugins = { "supermaven-nvim" } })

    local ok, api = pcall(require, "supermaven-nvim.api")
    if not ok then
      vim.notify("Supermaven is not available", vim.log.levels.ERROR, { title = "Supermaven" })
      return
    end

    api.toggle()
    local status = api.is_running()
    local message = status and "Supermaven enabled" or "Supermaven disabled"
    local level = status and vim.log.levels.INFO or vim.log.levels.WARN
    vim.notify(message, level, { title = "Supermaven" })
    vim.cmd("redrawstatus")
  end, vim.tbl_extend("keep", { desc = "Toggle AI" }, opts))
else
  map("n", "<leader>ai", function()
    require("lazy").load({ plugins = { "copilot.lua" } })

    local ok, suggestion = pcall(require, "copilot.suggestion")
    if not ok then
      vim.notify("Copilot is not available", vim.log.levels.ERROR, { title = "Copilot" })
      return
    end

    suggestion.toggle_auto_trigger()
    local enabled = vim.b.copilot_suggestion_auto_trigger ~= false
    local message = enabled and "Copilot enabled" or "Copilot disabled"
    local level = enabled and vim.log.levels.INFO or vim.log.levels.WARN
    vim.notify(message, level, { title = "Copilot" })
    vim.cmd("redrawstatus")
  end, vim.tbl_extend("keep", { desc = "Toggle AI" }, opts))
end
