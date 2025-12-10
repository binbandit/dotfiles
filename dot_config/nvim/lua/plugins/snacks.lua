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
		image = { enabled = true },
		lazygit = { enabled = true },
		bufdelete = { enabled = true },
		zen = { enabled = true },
		terminal = { enabled = true },
		input = { enabled = true },
		toggle = { enabled = true },
		statuscolumn = { enabled = true },
		quickfile = { enabled = true },
	},
	config = function(_, opts)
		require("snacks").setup(opts)

		vim.keymap.set({"n", "t"}, "<C-\\>", function()
			require("snacks").terminal.toggle()
		end, { desc = "Toggle terminal" })
	end,
}
