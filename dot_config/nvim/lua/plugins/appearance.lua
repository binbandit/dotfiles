---@type LazySpec
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      variant = "auto",
      dark_variant = "main",
      enable = {
        terminal = true,
      },
      styles = {
        transparency = true,
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dim = { enabled = true },
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
      `;;.        mS;;`;    ;     ;    ;M,!     '        ';;;;
       ';;       .mS;;, ;   '.    ;    MM;                ;;;;
        ';;      MMmS;; `,   ;._.' -_.'MM;                 ;;;
         `;;     MMmS;;; ;   ;      ;  MM;                 ;;;
           `'.   'MMmS;; `;) ',    .' ,M;'                 ;;;
              \    '' ''; ;   ;    ;  ;'                   ;;
               ;        ; `,  ;    ;  ;                   ;;
                        |. ;  ; (. ;  ;      _.-.         ;;
           .-----..__  /   ;  ;   ;' ;\  _.-" .- `.      ;;
         ;' ___      `*;   `; ';  ;  ; ;'  .-'    :      ;
         ;     """*-.   `.  ;  ;  ;  ; ' ,'      /       |
         ',          `-_    (.--',`--'..'      .'        ',
           `-_          `*-._'.\;||\)     ,'
              `"*-._        "*-ll_ll'l    ,'
                 ,==;*-._           "-.  .'
              _-'    "*-=`*;-._        ;'
            ."            ;'  ;"*-.    `
            ;   ____      ;//'     "-   `,
            `+   .-/                 ".\
              `" /                    "'
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
              require("fff").find_files()
            end,
          },
        },
      },
      indent = { enabled = true },
      image = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      toggle = { enabled = true },
      words = { enabled = true },
      zen = { enabled = true },
      terminal = { enabled = true },
      lazygit = { enabled = true, configure = true },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
    end,
    keys = {
      { "<leader>gg", function() Snacks.lazygit() end,        desc = "Lazygit" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<C-\\>",     function() Snacks.terminal() end,       desc = "Terminal" },
    },
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
  {
    "mluders/comfy-line-numbers.nvim",
    lazy = false,
    opts = {
      target_spacing = 4,
      target_clamp = true,
      use_current = true,
      numbering_style = "relative",
      hidden_file_types = { "undotree", "oil" },
      hidden_buffer_types = { "terminal", "nofile" },
    },
    config = function(_, opts)
      require("comfy-line-numbers").setup(opts)
    end,
  },
  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.25,
        inactive = true,
      },
      context = 8,
      expand = { "function", "method", "table", "if_statement" },
      exclude = { "help", "lazy", "mason", "oil", "undotree" },
    },
    keys = {
      { "<leader>tw", "<cmd>Twilight<CR>", desc = "Toggle Twilight" },
    },
  },
  {
    "WTFox/jellybeans.nvim",
    name = "jellybeans",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italics = true,
      bold = true,
      plugins = { auto = true },
    },
    config = function(_, opts)
      require("jellybeans").setup(opts)
      local themes = require("config.themes")
      themes.apply("jellybeans")
      vim.keymap.set("n", "<leader>ut", themes.cycle, { desc = "Cycle theme", silent = true })
      vim.keymap.set("n", "<leader>uj", function()
        themes.apply("jellybeans")
      end, { desc = "Use Jellybeans", silent = true })
      vim.keymap.set("n", "<leader>ur", function()
        themes.apply("rose-pine")
      end, { desc = "Use Rose Pine", silent = true })
      vim.keymap.set("n", "<leader>ub", function()
        themes.apply("backpack")
      end, { desc = "Use Backpack", silent = true })
    end,
  },
  {
    "mitch1000/backpack.nvim",
    name = "backpack",
    lazy = true,
    opts = {
      contrast = "medium",
      commentStyle = { italic = true },
      keywordStyle = { bold = true },
      statementStyle = { bold = true },
      returnStyle = { italic = false, bold = true },
      transparent = true,
      dimInactive = false,
      terminalColors = true,
    },
    config = function(_, opts)
      require("backpack").setup(opts)
    end,
  },
}
