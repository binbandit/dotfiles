local M = {}

local function current_hostname()
  local uname = (vim.uv or vim.loop).os_uname() or {}
  local name = uname.nodename
  if not name or name == "" then
    local ok, host = pcall(vim.fn.hostname)
    if ok then
      name = host
    end
  end
  return (name or ""):lower()
end

M.hostname = current_hostname()

local function env_truthy(name)
  local value = vim.env[name]
  if not value then
    return false
  end
  value = value:lower()
  return value == "1" or value == "true" or value == "yes" or value == "on"
end

function M.is_low_power()
  return env_truthy("NVIM_LIGHT_MODE") or env_truthy("NVIM_LOW_POWER")
end

return M
