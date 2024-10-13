local g = vim.g
local o = vim.opt

--- [[ Setting core settings ]]
g.mapleader = ' '
g.maplocalleader = ' '

g.have_nerd_font = true

--- [[ Setting general options ]]
o.number = true -- Turn on line numbers
o.showmode = false -- Don't show the mode, since it's on the status line
o.mouse = 'a' -- Enable mouse mode, can be used for resizing splits.
o.breakindent = true -- Enable break indent
o.undofile = true -- Save undo history
o.ignorecase = true -- Case-insensitive searching.
o.smartcase = true -- Keep search case-sensitive when it contains a capital letter.
o.signcolumn = 'yes' -- Show signcolumn
o.updatetime = 250 -- Decrease update time
o.timeoutlen = 300 -- Decrease timeoutlen
o.splitright = true -- Split window right
o.splitbelow = true -- Split window below
o.list = true -- Show list characters
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Set listchars
o.inccommand = 'split' -- Preview substitutions live, as you type!
o.cursorline = true -- Highlight current line
o.scrolloff = 8 -- Minimal number of screen lines to keep above and below the cursor.

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})


-- Disable Unused Built-in Plugins for Performance
local disabled_built_ins = {
    'netrw',
    'netrwPlugin',
    'netrwSettings',
    'netrwFileHandlers',
    'gzip',
    'zip',
    'zipPlugin',
    'tar',
    'tarPlugin',
    'getscript',
    'getscriptPlugin',
    'vimball',
    'vimballPlugin',
    '2html_plugin',
    'logipat',
    'rrhelper',
    'spellfile_plugin',
    'matchit',
}

for _, plugin in ipairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end
