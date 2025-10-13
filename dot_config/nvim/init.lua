vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.loader then
  vim.loader.enable()
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
