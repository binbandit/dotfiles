local opt = vim.opt

-- performance
opt.updatetime = 200
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.redrawtime = 1500

-- encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- ui
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false
opt.pumheight = 12
-- Keep float UIs readable on nightly: blending makes plugin windows translucent.
opt.pumblend = 0
opt.winblend = 0
opt.cmdheight = 1
opt.laststatus = 3 -- global statusline
opt.wrap = false
opt.linebreak = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.fillchars = { eob = " " }
opt.shortmess:append("sWIcC")
opt.winborder = "rounded"

-- editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.shiftround = true

-- search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- undo / swap / backup
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- completion
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full"

-- misc
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.virtualedit = "block"
opt.confirm = true
opt.conceallevel = 2
opt.formatoptions = "jcroqlnt"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
opt.jumpoptions = "stack,view"
opt.smoothscroll = true

-- folding (treesitter-based)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- disable providers we don't need
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- typescript server: 1 = vtsls (stable), 0 = tsgo (fast but experimental)
vim.g.use_vtsls = 0
