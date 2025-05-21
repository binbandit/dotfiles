-- Module for command-related functionality
local M = {}

-- Function to list all available commands
function M.list_commands()
  -- Get all user-defined commands
  local user_commands = vim.api.nvim_get_commands({})

  -- Create a buffer for displaying commands
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  -- Prepare content
  local lines = {
    "Available Commands:",
    "==================",
    "",
    "User-defined Commands:",
    "---------------------",
  }

  -- Sort commands alphabetically
  local sorted_commands = {}
  for name, cmd in pairs(user_commands) do
    table.insert(sorted_commands, {name = name, cmd = cmd})
  end

  table.sort(sorted_commands, function(a, b) return a.name < b.name end)

  -- Add user commands to the list
  for _, cmd_info in ipairs(sorted_commands) do
    local name = cmd_info.name
    local cmd = cmd_info.cmd

    -- Get description
    local desc = cmd.desc or ""
    if desc == "" then
      desc = cmd.definition or ""
    end

    -- Format usage based on nargs
    local usage = ""
    if cmd.nargs and cmd.nargs ~= "0" then
      if cmd.nargs == "1" then
        usage = " [arg]"
      elseif cmd.nargs == "*" then
        usage = " [args...]"
      elseif cmd.nargs == "?" then
        usage = " [optional]"
      elseif cmd.nargs == "+" then
        usage = " [args...]"
      end
    end

    -- Format the command line
    local cmd_line = string.format(":%s%s", name, usage)

    -- Add padding for alignment
    local padding = string.rep(" ", math.max(1, 30 - #cmd_line))

    -- Add the command with description
    table.insert(lines, string.format("%s%s%s", cmd_line, padding, desc))
  end

  -- Add note about fzf-lua
  table.insert(lines, "")
  table.insert(lines, "Note: For a searchable interface, use <leader>? or <leader>fc to open fzf-lua command finder")

  -- Set buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Create a window for the buffer
  local width = math.min(80, vim.o.columns - 4)
  local height = math.min(#lines + 2, vim.o.lines - 4)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set window options
  vim.api.nvim_win_set_option(win, 'winblend', 10)
  vim.api.nvim_win_set_option(win, 'cursorline', true)

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'help')

  -- Set keymaps for the buffer
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', {noremap = true, silent = true})
end

return M
