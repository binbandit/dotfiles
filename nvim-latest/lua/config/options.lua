-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set font to DankMono Nerd Font
if vim.g.neovide then
  vim.o.guifont = "DankMonoNF-Regular:h14"
end

-- Store the default font size for the showcase command
vim.g.default_font_size = 14
vim.g.font_name = "DankMonoNF-Regular"

-- Disable tabs
vim.opt.showtabline = 0

-- Set hidden to ensure terminals are not discarded when closed
vim.opt.hidden = true

-- Set termguicolors for better color support
vim.opt.termguicolors = true

-- Set up persistent undo
local undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.undofile = true
vim.opt.undodir = undodir

-- Create the undodir if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
