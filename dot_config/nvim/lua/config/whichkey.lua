local M = {}

local leader_groups = {
  { "<leader>b", group = "Buffers" },
  { "<leader>g", group = "Git & GitHub" },
  { "<leader>q", group = "Quit" },
  { "<leader>s", group = "Splits" },
  { "<leader>t", group = "Toggles" },
  { "<leader>w", group = "Write" },
  { "<leader>?", group = "Help" },
  { "<leader>/", desc = "Live Grep" },
  { "<leader>|", desc = "Vertical Split" },
  { "<leader>`", desc = "Alternate Buffer" },
  { "<leader>h", desc = "Clear Highlight" },
  { "<leader>ai", desc = "Toggle AI Assistant" },
  { "<leader>bd", desc = "Close Buffer" },
  { "<leader>bb", desc = "Buffer Manager" },
  { "<leader>sv", desc = "Split Right" },
  { "<leader>sh", desc = "Split Below" },
  { "<leader>gg", desc = "Lazygit" },
  { "<leader>gb", desc = "Git Blame Line" },
  { "<leader>go", desc = "Octo actions" },
  { "<leader>gi", desc = "List Issues" },
  { "<leader>gp", desc = "List Pull Requests" },
  { "<leader>gN", desc = "New Issue" },
  { "<leader>gn", desc = "Notifications" },
  { "<leader>gs", desc = "Stage git hunk" },
  { "<leader>gr", desc = "Reset git hunk" },
  { "<leader>gS", desc = "Stage buffer" },
  { "<leader>gP", desc = "Preview git hunk" },
  { "<leader>gu", desc = "Undo stage hunk" },
  { "<leader>gB", desc = "Git blame (full)" },
  { "<leader>ps", desc = "Open Store" },
  { "<leader>tw", desc = "Toggle Twilight" },
  { "<leader>tb", desc = "Toggle word/boolean" },
  { "<leader>tt", desc = "Toggle task state" },
  { "<leader>tc", desc = "Mark task complete" },
  { "<leader>tu", desc = "Mark task incomplete" },
  { "<leader>tn", desc = "New task below" },
  { "<leader>ta", desc = "Archive checked tasks" },
  { "<leader>tr", desc = "Convert task to text" },
  { "<leader>tR", desc = "Strip task metadata" },
  { "<leader>u", group = "UI" },
  { "<leader>uj", desc = "Use Jellybeans" },
  { "<leader>ur", desc = "Use Rose Pine" },
  { "<leader>ub", desc = "Use Backpack" },
  { "<leader>ut", desc = "Cycle theme" },
  { "<leader>uu", desc = "Toggle Undotree" },
  { "<leader>vd", desc = "Toggle venn mode" },
  { "<leader>vb", desc = "Draw venn box" },
  { "gl", desc = "Line Diagnostics" },
}

function M.setup()
  local wk = require("which-key")
  wk.setup({
    notify = false,
    plugins = {
      marks = false,
      registers = false,
    },
    win = {
      border = "rounded",
    },
  })
  wk.add(leader_groups)
end

return M
