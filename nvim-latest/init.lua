-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Create a user command to force show the alpha dashboard
vim.api.nvim_create_user_command("ShowDashboard", function()
  -- Hide UI elements
  vim.opt.laststatus = 0
  vim.opt.showtabline = 0
  vim.opt.cmdheight = 0

  -- Hide line numbers and signcolumn
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.cursorline = false

  -- Start alpha
  require("alpha").start(true)
end, { desc = "Force show the dashboard" })

-- Create autocmd to hide line numbers in alpha
vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.cursorline = false
    vim.opt_local.statuscolumn = ""
  end,
})

-- Handle directory opening directly in init.lua for immediate effect
if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
  -- Set a flag to indicate we're opening a directory
  vim.g.open_directory = true

  -- Create an autocmd to handle this after VimEnter
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if vim.g.open_directory then
        -- Close any existing buffers
        vim.cmd("silent! %bd")

        -- Hide UI elements
        vim.opt.laststatus = 0
        vim.opt.showtabline = 0
        vim.opt.cmdheight = 0

        -- Hide line numbers and signcolumn
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.signcolumn = "no"

        -- Show alpha dashboard
        vim.schedule(function()
          require("alpha").start(true)
        end)

        -- Clear the flag
        vim.g.open_directory = nil
      end
    end,
    once = true,
  })
end
