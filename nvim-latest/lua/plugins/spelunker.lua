return {
  {
    "kamykn/spelunker.vim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "kamykn/popup-menu.nvim", -- For better suggestion UI in Neovim
    },
    init = function()
      -- Disable Vim's built-in spell checker as it conflicts with spelunker
      vim.opt.spell = false
      
      -- Basic spelunker.vim configuration
      vim.g.enable_spelunker_vim = 1
      vim.g.spelunker_target_min_char_len = 4
      vim.g.spelunker_max_suggest_words = 15
      vim.g.spelunker_max_hi_words_each_buf = 100
      
      -- Check type: 1 = File is checked on open/save, 2 = Dynamic check on cursor hold
      vim.g.spelunker_check_type = 1
      
      -- Highlight type: 1 = All types, 2 = SpellBad only
      vim.g.spelunker_highlight_type = 1
      
      -- Disable checking for specific patterns
      vim.g.spelunker_disable_uri_checking = 1
      vim.g.spelunker_disable_email_checking = 1
      vim.g.spelunker_disable_account_name_checking = 1
      vim.g.spelunker_disable_acronym_checking = 1
      vim.g.spelunker_disable_backquoted_checking = 1
      
      -- Override highlight settings for better visual appearance
      vim.cmd([[
        highlight SpelunkerSpellBad cterm=underline ctermfg=247 gui=underline guifg=#9e9e9e
        highlight SpelunkerComplexOrCompoundWord cterm=underline ctermfg=NONE gui=underline guifg=NONE
      ]])
      
      -- Add custom words to the whitelist
      vim.g.spelunker_white_list_for_user = {
        'neovim', 'nvim', 'lazyvim', 'lua', 'javascript', 'typescript',
        'golang', 'rustlang', 'github', 'config', 'init', 'plugins',
        'keymaps', 'autocmds', 'utils', 'util', 'api', 'cmd', 'fn',
        'args', 'opts', 'buf', 'bufnr', 'filetype', 'keymap', 'lsp',
        'cmp', 'treesitter', 'plugin', 'lazygit', 'toggleterm', 'sfm',
        'undotree', 'harpoon', 'supermaven', 'vague', 'colorscheme',
        'statusline', 'bufferline', 'lualine', 'neoscroll', 'showcmd',
        'laststatus', 'showtabline', 'cmdheight', 'signcolumn', 'winblend',
        'termguicolors', 'guifont', 'guicursor', 'cursorline', 'foldenable',
        'foldmethod', 'foldexpr', 'foldlevel', 'scrolloff', 'sidescrolloff',
        'splitbelow', 'splitright', 'wildmenu', 'wildmode', 'wildignore',
        'ignorecase', 'smartcase', 'incsearch', 'hlsearch', 'showmatch',
        'matchtime', 'timeoutlen', 'ttimeoutlen', 'updatetime', 'redrawtime',
        'lazyredraw', 'ttyfast', 'visualbell', 'errorbells', 'backup',
        'writebackup', 'swapfile', 'undofile', 'undodir', 'shadafile',
        'shada', 'viminfo', 'viminfofile', 'runtimepath', 'packpath',
        'loadplugins', 'exrc', 'secure', 'modeline', 'modelines', 'bomb',
        'fileencoding', 'fileencodings', 'fileformat', 'fileformats',
        'binary', 'endofline', 'fixendofline', 'eol', 'startofline',
        'ruler', 'rulerformat', 'title', 'titlestring', 'icon', 'iconstring',
        'lazyredraw', 'ttyfast', 'ttyscroll', 'ttymouse', 'mouse',
        'mousefocus', 'mousehide', 'mousemodel', 'mouseshape', 'mousetime',
      }
    end,
    keys = {
      -- Add keymaps for spell checking
      { "<leader>ss", "<cmd>ZL<cr>", desc = "Correct All Spelling Errors" },
      { "<leader>sw", "<cmd>Zl<cr>", desc = "Correct Word Under Cursor" },
      { "<leader>sf", "<cmd>ZF<cr>", desc = "Fix All Spelling (First Suggestion)" },
      { "<leader>sa", "<cmd>SpelunkerAddAll<cr>", desc = "Add All Misspelled Words to Dictionary" },
      { "<leader>sn", "<cmd>ZN<cr>", desc = "Next Misspelled Word" },
      { "<leader>sp", "<cmd>ZP<cr>", desc = "Previous Misspelled Word" },
      { "<leader>st", "<cmd>ZT<cr>", desc = "Toggle Spell Checker" },
    },
  },
}
