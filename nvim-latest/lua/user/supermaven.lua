-- Module for supermaven toggle functionality
local M = {}

-- Function to toggle supermaven
function M.toggle()
  -- Get the supermaven API module
  local ok, api = pcall(require, "supermaven-nvim.api")

  if not ok then
    vim.notify("Supermaven API module not found", vim.log.levels.ERROR)
    return
  end

  -- Check if supermaven is running
  local is_running = api.is_running()

  if is_running then
    -- Stop supermaven
    api.stop()
    vim.g.supermaven_enabled = false
    vim.notify("Supermaven AI autocomplete disabled", vim.log.levels.INFO)
  else
    -- Start supermaven
    api.start()
    vim.g.supermaven_enabled = true
    vim.notify("Supermaven AI autocomplete enabled", vim.log.levels.INFO)
  end
end

return M
