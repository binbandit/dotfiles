return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
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
                    !   ;;;MMMSSSSSMMMMM;MMMmSS;;._.;;SSmMM;MMMMMSSSSMMM;;;;;;;;;
                        ;;;;*MSSSSSSMMMP;Mm*"'q;'   `;p*"*M;MMMMMSSSSMMM;;;;;;;;;
                        ';;;  ;SS*SSM*M;M;'     `-.        ;;MMMMSSSSSMM;;;;;;;;;,
                         ;;;. ;P  `q; qMM.                 ';MMMMSSSSSMp' ';;;;;;;
                         ';;;       ' mmS';     \.   `.   /  ;MMM' `qSS'    ';;;;;
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
        { key = "f", desc = "Find files", action = ":lua require('fff').find_files()" },
        { key = "g", desc = "Live grep", action = ":lua require('fff').live_grep()" },
        { key = "e", desc = "Explorer", action = ":Neotree toggle current reveal_force_cwd" },
        { key = "q", desc = "Quit", action = ":qa" },
      },
    },
    picker = { enabled = false },
    explorer = { enabled = false },
    image = { enabled = false },
    indent = { enabled = false },
    scope = { enabled = false },
    statuscolumn = { enabled = false },
    scroll = { enabled = false },

    notifier = {
      enabled = true,
      timeout = 3000,
    },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
    lazygit = { enabled = true },
    bufdelete = { enabled = true },
    zen = { enabled = true },
    terminal = { enabled = true },
    input = { enabled = true },
    toggle = { enabled = true },
    dim = { enabled = true },
    rename = { enabled = true },
  },
  keys = {
    {
      "<C-\\>",
      function()
        require("snacks").terminal.toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle terminal",
    },
    {
      "<leader>gg",
      function()
        require("snacks").lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>fn",
      function()
        require("snacks").notifier.show_history()
      end,
      desc = "Notification history",
    },
    {
      "]]",
      function()
        require("snacks").words.jump(1, true)
      end,
      desc = "Next LSP reference",
    },
    {
      "[[",
      function()
        require("snacks").words.jump(-1, true)
      end,
      desc = "Prev LSP reference",
    },
    {
      "<leader>z",
      function()
        require("snacks").zen()
      end,
      desc = "Zen mode",
    },
    {
      "<leader>td",
      function()
        require("snacks").dim()
      end,
      desc = "Toggle dim",
    },
    {
      "<leader>bd",
      function()
        require("snacks").bufdelete()
      end,
      desc = "Delete buffer",
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
}
