local M = {}

local defaults = {
  colorscheme = "default",
  light_background = "light",
  dark_background = "dark",
  day_start = 7, -- 7 AM
  night_start = 19, -- 7 PM
  auto_events = { "FocusGained", "VimResume", "CursorHold", "CursorHoldI" },
}

local function current_hour()
  local ok, time_tbl = pcall(os.date, "*t")
  if ok and type(time_tbl) == "table" and type(time_tbl.hour) == "number" then
    return time_tbl.hour
  end
  local hour = tonumber(os.date("%H"), 10)
  return hour or 12
end

local function is_daytime(hour, day_start, night_start)
  if day_start == night_start then
    return true
  end
  if day_start < night_start then
    return hour >= day_start and hour < night_start
  end
  return hour >= day_start or hour < night_start
end

function M.current_background()
  local opts = M.opts or defaults
  if is_daytime(current_hour(), opts.day_start, opts.night_start) then
    return opts.light_background
  end
  return opts.dark_background
end

local function load_colorscheme(name)
  local ok, err = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.schedule(function()
      vim.notify(("Failed to load %s: %s"):format(name, err), vim.log.levels.ERROR)
    end)
  end
end

function M.apply(force)
  local opts = M.opts or defaults
  local background = M.current_background()
  if not force and vim.o.background == background then
    return
  end
  vim.o.background = background
  load_colorscheme(opts.colorscheme)
end

local function set_events(events)
  if M._aug_id then
    pcall(vim.api.nvim_del_augroup_by_id, M._aug_id)
    M._aug_id = nil
  end
  if not events or #events == 0 then
    return
  end
  M._aug_id = vim.api.nvim_create_augroup("ConfigDynamicTheme", { clear = true })
  vim.api.nvim_create_autocmd(events, {
    group = M._aug_id,
    callback = function()
      M.apply(false)
    end,
  })
end

function M.setup(opts)
  M.opts = vim.tbl_extend("force", defaults, opts or {})
  set_events(M.opts.auto_events)
  M.apply(true)
end

return M
