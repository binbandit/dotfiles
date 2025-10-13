local M = {}

local theme_registry = {
  ["jellybeans"] = { plugin = "jellybeans", colorscheme = "jellybeans" },
  ["rose-pine"] = { plugin = "rose-pine", colorscheme = "rose-pine" },
  ["backpack"] = { plugin = "backpack", colorscheme = "backpack" },
}

local order = { "jellybeans", "rose-pine", "backpack" }

local function ensure_loaded(name)
  local entry = theme_registry[name]
  if not entry then
    return false
  end
  local lazy = require("lazy")
  lazy.load({ plugins = { entry.plugin } })
  vim.cmd.colorscheme(entry.colorscheme)
  vim.g.colors_name = entry.colorscheme
  return true
end

function M.apply(name)
  if not ensure_loaded(name) then
    vim.notify(string.format("Unknown theme %q", name), vim.log.levels.WARN, { title = "Themes" })
  end
end

function M.cycle()
  local current = vim.g.colors_name or order[1]
  local idx = 1
  for i, name in ipairs(order) do
    if name == current then
      idx = i
      break
    end
  end
  local next_idx = (idx % #order) + 1
  M.apply(order[next_idx])
end

return M
