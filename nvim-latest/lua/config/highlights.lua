-- Custom highlight overrides
local M = {}

-- Function to set highlights
function M.setup()
  -- Alpha dashboard highlights
  vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#c9c7cd" }) -- Use the main foreground color instead of blue
  vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#9f9ca6" }) -- Use subtext2 color for buttons
  vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6c6874", italic = true }) -- Keep the footer as is
  vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#90b99f", italic = true }) -- Use green for shortcuts
end

return M
