-- General vim options
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.spelllang = "en_gb"
vim.opt.title = true
vim.opt.titlestring = "nvim"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
vim.o.background = "dark"

vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.sidescrolloff = 8
vim.opt.scrolloff = 8

-- Persistent undo
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen" -- keep text on screen when splitting

-- 0.12+ defaults and features
vim.opt.winborder = "rounded" -- default border for all floating windows

if vim.fn.has("nvim-0.12") == 1 then
  vim.opt.pumborder = "rounded"
  vim.opt.completeopt:append("nearest")
else
  vim.schedule(function()
    vim.notify("This config is tuned for Neovim nightly (0.12+). Current version may miss optimizations.", vim.log.levels.WARN)
  end)
end

-- Smoother experience
vim.opt.updatetime = 200 -- faster CursorHold (default 4000ms)
vim.opt.timeoutlen = 300 -- faster which-key popup

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = "",
    spacing = 2,
    source = "if_many",
  },
  virtual_lines = false, -- Toggle with <leader>tl
  float = {
    source = true,
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
