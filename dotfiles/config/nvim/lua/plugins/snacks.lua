return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Dashboard
    dashboard = {
      enabled = true,
      width = 100,
      sections = {
        {
          text = [[
                             .m.                                   ,_
                             ' ;M;                                ,;m `
                               ;M;.           ,      ,           ;SMM;
                              ;;Mm;         ,;  ____  ;,         ;SMM;
                             ;;;MM;        ; (.MMMMMM.) ;       ,SSMM;;
                           ,;;;mMp'        l  ';mmmm;/  j       SSSMM;;
                         .;;;;;MM;         .\,.mmSSSm,,/,      ,SSSMM;;;
                        ;;;;;;mMM;        .;MMmSSSSSSSmMm;     ;MSSMM;;;;
                       ;;;;;;mMSM;     ,_ ;MMmS;;;;;;mmmM;  -,;MMMMMMm;;;;
                      ;;;;;;;MMSMM;     "*;M;( ( '') );m;*"/ ;MMMMMM;;;;;,
                     .;;;;;;mMMSMM;      \(@;! _     _ !;@)/ ;MMMMMMMM;;;;;,
                     ;;;;;;;MMSSSM;       ;,;.*o*> <*o*.;m; ;MMMMMMMMM;;;;;;,
                    .;;;;;;;MMSSSMM;     ;Mm;           ;M;,MMMMMMMMMMm;;;;;;.
                    ;;;;;;;mmMSSSMMMM,   ;Mm;,   '-    ,;M;MMMMMMMSMMMMm;;;;;;;
                    ;;;;;;;MMMSSSMMMMMMMm;Mm;;,  ___  ,;SmM;MMMMMMSSMMMM;;;;;;;;
                    ;;'";;;MMMSSSSMMMMMM;MMmS;;,  "  ,;SmMM;MMMMMMSSMMMM;;;;;;;;.
                    !   ;;;MMMSSSSSMMMMM;MMMmSS;;._.;;SSmMM;MMMMMMSSMMMM;;;;;;;;;
                        ;;;;*MSSSSSSMMMP;Mm*"'q;'   `;p*"*M;MMMMMSSSSMMM;;;;;;;;;
                        ';;;  ;SS*SSM*M;M;'     `-.        ;;MMMMSSSSSMM;;;;;;;;;,
                         ;;;. ;P  `q; qMM.                 ';MMMMSSSSSMp' ';;;;;;;;
                         ;;;; ',    ; .mm!     \.   `.   /  ;MMM' `qSS'    ';;;;;;;
                         ';;;       ' mmS';     ;     ,  `. ;'M'   `S       ';;;;;
]],
          hl = "header",
          padding = 1,
          align = "left",
        },
        { section = "keys", gap = 1, padding = 1 },
        { section = "recent_files", limit = 5, padding = 1 },
        { section = "projects", limit = 5, padding = 1 },
      },
      keys = {
        { key = "f", desc = "Find files", action = ":lua Snacks.picker.files()" },
        { key = "g", desc = "Live grep", action = ":lua Snacks.picker.grep()" },
        { key = "r", desc = "Recent files", action = ":lua Snacks.picker.recent()" },
        { key = "n", desc = "New file", action = ":ene | startinsert" },
        { key = "q", desc = "Quit", action = ":qa" },
      },
    },

    -- Picker: replaces fzf-lua/telescope
    picker = {
      enabled = true,
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
    },

    -- Explorer: replaces fyler/neo-tree/oil for tree browsing
    explorer = { enabled = true },

    -- Notifier: replaces nvim-notify
    notifier = {
      enabled = true,
      timeout = 3000,
    },

    -- Performance: skip expensive features on large files
    bigfile = { enabled = true },

    -- Quick file opening (skip heavy setup for simple file opens)
    quickfile = { enabled = true },

    -- LSP word highlighting under cursor
    words = { enabled = true },

    -- Indent guides
    indent = {
      enabled = true,
      animate = { enabled = false }, -- no animation, just show guides
    },

    -- Scope detection
    scope = { enabled = true },

    -- Image rendering
    image = { enabled = true },

    -- Lazygit integration
    lazygit = { enabled = true },

    -- Buffer delete without messing up layout
    bufdelete = { enabled = true },

    -- Zen mode
    zen = { enabled = true },

    -- Terminal
    terminal = { enabled = true },

    -- Better vim.ui.input
    input = { enabled = true },

    -- Toggles
    toggle = { enabled = true },

    -- Status column
    statuscolumn = { enabled = true },

    -- Smooth scrolling
    scroll = { enabled = true },

    -- Dim inactive code (useful with zen)
    dim = { enabled = true },

    -- Rename with LSP references preview
    rename = { enabled = true },
  },
  config = function(_, opts)
    local Snacks = require("snacks")
    Snacks.setup(opts)

    -- Terminal toggle
    vim.keymap.set({ "n", "t" }, "<C-\\>", function()
      Snacks.terminal.toggle()
    end, { desc = "Toggle terminal" })

    -- Picker keymaps
    vim.keymap.set("n", "<leader><leader>", function() Snacks.picker.files() end, { desc = "Find files" })
    vim.keymap.set("n", "ff", function() Snacks.picker.files() end, { desc = "Find files" })
    vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>?", function() Snacks.picker.commands() end, { desc = "Commands" })
    vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent files" })
    vim.keymap.set("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Git files" })
    vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help tags" })
    vim.keymap.set("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
    vim.keymap.set("n", "<leader>fd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, { desc = "LSP symbols" })
    vim.keymap.set("n", "<leader>fw", function() Snacks.picker.grep_word() end, { desc = "Grep word under cursor" })
    vim.keymap.set("n", "<leader>fc", function() Snacks.picker.git_log() end, { desc = "Git commits" })

    -- Explorer
    vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "File explorer" })
    vim.keymap.set("n", "-", function() Snacks.explorer() end, { desc = "File explorer" })

    -- Lazygit
    vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })

    -- Notification history
    vim.keymap.set("n", "<leader>fn", function() Snacks.notifier.show_history() end, { desc = "Notification history" })

    -- LSP word navigation
    vim.keymap.set("n", "]]", function() Snacks.words.jump(1, true) end, { desc = "Next LSP reference" })
    vim.keymap.set("n", "[[", function() Snacks.words.jump(-1, true) end, { desc = "Prev LSP reference" })

    -- Zen mode
    vim.keymap.set("n", "<leader>z", function() Snacks.zen() end, { desc = "Zen mode" })

    -- Dim mode
    vim.keymap.set("n", "<leader>td", function() Snacks.dim() end, { desc = "Toggle dim" })

    -- Buffer delete (preserves window layout)
    vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })
  end,
}
