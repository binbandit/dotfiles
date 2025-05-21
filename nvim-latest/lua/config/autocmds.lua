-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Apply custom highlights whenever colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Apply custom highlights after colorscheme changes",
  group = vim.api.nvim_create_augroup("custom_highlights", { clear = true }),
  callback = function()
    -- Apply custom highlights
    vim.defer_fn(function()
      require("config.highlights").setup()
    end, 10)
  end,
})

-- Force alpha to show on startup
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Start Alpha when vim is opened with no arguments",
  group = vim.api.nvim_create_augroup("alpha_autostart", { clear = true }),
  callback = function()
    -- Only start Alpha when there are no arguments and not in a git commit
    local should_skip = false
    if vim.fn.argc() > 0 or vim.fn.line2byte('$') ~= -1 or vim.fn.getbufinfo('%')[1].name:match('COMMIT_EDITMSG$') then
      should_skip = true
    end

    if not should_skip then
      -- Hide UI elements
      vim.opt.laststatus = 0
      vim.opt.showtabline = 0
      vim.opt.cmdheight = 0

      -- Hide line numbers and signcolumn
      vim.opt.number = false
      vim.opt.relativenumber = false
      vim.opt.signcolumn = "no"

      -- Delay alpha slightly to ensure everything is loaded
      vim.defer_fn(function()
        require('alpha').start(true)
      end, 10)
    end
  end,
  once = true, -- Only trigger once
})
