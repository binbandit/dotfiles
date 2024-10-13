require("me")

local ok, catppuccin = pcall(require, "catppuccin")
if not ok then return end
catppuccin.setup({
    flavour = "latte",
    transparent_background = true,
})
-- vim.cmd [[colorscheme catppuccin]]
vim.cmd [[colorscheme carbonfox]]

vim.cmd([[
augroup user_colors
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
augroup END
]])
