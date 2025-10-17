local M = {}

local function current_hostname()
  local uname = vim.loop.os_uname() or {}
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
M.supermaven_hosts = {
  "braydens-macbook-pro",
}
M.low_power_hosts = {}

local function matches_any(host, patterns)
  for _, pattern in ipairs(patterns) do
    if host == pattern or host:find(pattern, 1, true) then
      return true
    end
  end
  return false
end

function M.uses_supermaven()
  return matches_any(M.hostname, M.supermaven_hosts)
end

local function env_truthy(name)
  local value = vim.env[name]
  if not value then
    return false
  end
  value = value:lower()
  return value == "1" or value == "true" or value == "yes" or value == "on"
end

function M.is_low_power()
  if env_truthy("NVIM_LIGHT_MODE") or env_truthy("NVIM_LOW_POWER") then
    return true
  end
  return matches_any(M.hostname, M.low_power_hosts)
end

return M
