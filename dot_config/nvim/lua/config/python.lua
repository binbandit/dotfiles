local M = {}

local uv = vim.uv or vim.loop
local path_sep = package.config:sub(1, 1) == "\\" and ";" or ":"
local is_win = package.config:sub(1, 1) == "\\"

local host_venv = vim.fs.joinpath(vim.fn.stdpath("config"), ".uv-python")
local original_path = vim.env.PATH or ""
local current_bin

local function python_from_venv(venv)
  if not venv or venv == "" then
    return nil
  end

  if is_win then
    local exe = vim.fs.joinpath(venv, "Scripts", "python.exe")
    if uv.fs_stat(exe) then
      return exe
    end
    exe = vim.fs.joinpath(venv, "python.exe")
    if uv.fs_stat(exe) then
      return exe
    end
    return nil
  end

  local candidates = {
    vim.fs.joinpath(venv, "bin", "python3"),
    vim.fs.joinpath(venv, "bin", "python"),
  }

  for _, candidate in ipairs(candidates) do
    if uv.fs_stat(candidate) then
      return candidate
    end
  end

  return nil
end

local function bin_dir(venv)
  if not venv or venv == "" then
    return nil
  end
  if is_win then
    return vim.fs.joinpath(venv, "Scripts")
  end
  return vim.fs.joinpath(venv, "bin")
end

local function update_path_prefix(new_prefix)
  local path = vim.env.PATH or original_path
  if current_bin and current_bin ~= "" then
    local escaped = vim.pesc(current_bin)
    path = path:gsub("^" .. escaped .. path_sep, "")
    path = path:gsub(path_sep .. escaped .. "$", "")
    path = path:gsub(path_sep .. escaped .. path_sep, path_sep)
  end

  if new_prefix and new_prefix ~= "" then
    if path == "" then
      path = new_prefix
    else
      path = new_prefix .. path_sep .. path
    end
  end

  vim.env.PATH = path
  current_bin = new_prefix
end

local function notify(message, level)
  vim.schedule(function()
    vim.notify(message, level or vim.log.levels.INFO, { title = "Python" })
  end)
end

M.host_venv = host_venv

function M.host_python()
  return python_from_venv(host_venv)
end

function M.setup()
  local python = M.host_python()
  if python then
    vim.g.python3_host_prog = python
  else
    notify(
      ("uv-based Python host not found at %s.\nRun `uv venv --python 3.14 %s` and `uv pip install --python %s pynvim` to bootstrap it."):format(
        host_venv,
        host_venv,
        host_venv
      ),
      vim.log.levels.WARN
    )
  end

  vim.api.nvim_create_user_command("PythonVenvSelect", function()
    M.select_venv()
  end, { desc = "Select a Python virtual environment for this Neovim session" })

  vim.api.nvim_create_user_command("PythonVenvDeactivate", function()
    M.deactivate_venv()
  end, { desc = "Deactivate the active Python virtual environment" })
end

local venv_patterns = {
  ".venv",
  ".uv",
  ".uv-env",
  ".uv-python",
  ".env",
  "venv",
}

function M.find_project_venv(root_dir)
  if not root_dir or root_dir == "" then
    return nil
  end
  local resolved = vim.fs.normalize(root_dir)
  local matches = vim.fs.find(function(name)
    for _, pattern in ipairs(venv_patterns) do
      if name == pattern then
        return true
      end
    end
    if name:match("^%.venv") or name:match("^%.uv") then
      return true
    end
    return false
  end, {
    path = resolved,
    type = "directory",
    limit = 1,
    follow = false,
    upward = false,
  })
  return matches[1]
end

function M.infer_python(root_dir)
  if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
    local python = python_from_venv(vim.env.VIRTUAL_ENV)
    if python then
      return python
    end
  end

  if root_dir and root_dir ~= "" then
    local venv = M.find_project_venv(root_dir)
    if venv then
      local python = python_from_venv(venv)
      if python then
        return python
      end
    end
  end

  return M.host_python()
end

function M.pyright_settings()
  return {
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "basic",
        useLibraryCodeForTypes = true,
      },
    },
  }
end

function M.pyright_on_new_config(config, root_dir)
  root_dir = root_dir or config.root_dir
  config.settings = config.settings or {}
  config.settings.python = config.settings.python or {}

  local python = M.infer_python(root_dir)
  if python then
    config.settings.python.pythonPath = python
  end

  local venv = root_dir and M.find_project_venv(root_dir) or nil
  if venv then
    config.settings.python.venvPath = vim.fs.dirname(venv)
    config.settings.python.venv = vim.fs.basename(venv)
  else
    config.settings.python.venvPath = nil
    config.settings.python.venv = nil
  end
end

local function build_selection_list()
  local roots = {}
  local cwd = vim.loop.cwd()
  if cwd and cwd ~= "" then
    table.insert(roots, vim.fs.normalize(cwd))
  end

  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname ~= "" then
    local dir = vim.fs.dirname(bufname)
    if dir and dir ~= "" then
      table.insert(roots, vim.fs.normalize(dir))
    end
  end

  for _, client in pairs(vim.lsp.get_active_clients({ name = "pyright" })) do
    if client.config.root_dir then
      table.insert(roots, vim.fs.normalize(client.config.root_dir))
    end
  end

  for _, client in pairs(vim.lsp.get_active_clients({ name = "ruff" })) do
    if client.config.root_dir then
      table.insert(roots, vim.fs.normalize(client.config.root_dir))
    end
  end

  local seen = {}
  local items = {}

  for _, root in ipairs(roots) do
    if root and not seen[root] then
      seen[root] = true
      local venv = M.find_project_venv(root)
      if venv then
        table.insert(items, {
          label = vim.fs.basename(root) .. " → " .. venv,
          path = venv,
        })
      end
    end
  end

  return items
end

function M.select_venv()
  local items = build_selection_list()
  if #items == 0 then
    notify(
      "No project virtual environments detected. Use `uv venv` or `uv sync` in your project to create one.",
      vim.log.levels.WARN
    )
    return
  end

  vim.ui.select(items, {
    prompt = "Select Python environment",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    M.activate_venv(choice.path)
  end)
end

function M.activate_venv(venv)
  local python = python_from_venv(venv)
  if not python then
    notify(("Could not find a Python interpreter inside %s"):format(venv), vim.log.levels.ERROR)
    return
  end

  update_path_prefix(bin_dir(venv))
  vim.env.VIRTUAL_ENV = venv
  notify(("Activated Python environment: %s"):format(venv))

  local ok = pcall(vim.cmd, "LspRestart pyright ruff")
  if not ok then
    notify("Restart pyright and ruff manually to pick up the new environment.", vim.log.levels.WARN)
  end
end

function M.deactivate_venv()
  update_path_prefix(nil)
  vim.env.VIRTUAL_ENV = nil
  notify("Deactivated Python environment")

  local ok = pcall(vim.cmd, "LspRestart pyright ruff")
  if not ok then
    notify("Restart pyright and ruff manually to pick up the change.", vim.log.levels.WARN)
  end
end

return M
