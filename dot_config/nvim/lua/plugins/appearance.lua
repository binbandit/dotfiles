local env = require("config.env")

---@type LazySpec
return {
  {
    "abreujp/scholar.nvim",
    name = "scholar",
    lazy = false,
    priority = 1000,
    config = function()
      require("config.theme").setup({
        colorscheme = "scholar",
      })
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
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
        },
        keys = {
          {
            key = "ff",
            desc = "Find files",
            action = function()
              require("fff").open()
            end,
          },
        },
      },
      indent = { enabled = false },
      image = { enabled = false },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      toggle = { enabled = true },
      words = { enabled = false },
      zen = { enabled = false },
      terminal = { enabled = true },
      lazygit = { enabled = false },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Toggle terminal with Ctrl+\
      vim.keymap.set({ "n", "t" }, "<C-\\>", function()
        require("snacks").terminal.toggle()
      end, { desc = "Toggle terminal" })
    end,
  },
  {
    "danilamihailov/beacon.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      require("config.lualine").init()
    end,
    opts = function()
      return require("config.lualine").opts()
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
      require("config.lualine").post_setup()
    end,
  },
}
