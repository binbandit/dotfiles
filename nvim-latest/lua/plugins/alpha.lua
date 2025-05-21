return {
  "goolord/alpha-nvim",
  lazy = false,
  priority = 1000,
  enabled = true,
  init = function()
    -- Disable the dashboard-nvim plugin if it exists
    vim.g.dashboard_disable = true
  end,
  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      "         .m.                                   ,_",
      "         ' ;M;                                ,;m `",
      "           ;M;.           ,      ,           ;SMM;",
      "          ;;Mm;         ,;  ____  ;,         ;SMM;",
      "         ;;;MM;        ; (.MMMMMM.) ;       ,SSMM;;",
      "       ,;;;mMp'        l  ';mmmm;/  j       SSSMM;;",
      "     .;;;;;MM;         .\\,.mmSSSm,,/,      ,SSSMM;;;",
      "    ;;;;;;mMM;        .;MMmSSSSSSSmMm;     ;MSSMM;;;;",
      "   ;;;;;;mMSM;     ,_ ;MMmS;;;;;;mmmM;  -,;MMMMMMm;;;;",
      "  ;;;;;;;MMSMM;     \\\"*;M;( ( '') );m;*\"/ ;MMMMMM;;;;;,",
      " .;;;;;;mMMSMM;      \\(@;! _     _ !;@)/ ;MMMMMMMM;;;;;,",
      " ;;;;;;;MMSSSM;       ;,;.*o*> <*o*.;m; ;MMMMMMMMM;;;;;;,",
      ".;;;;;;;MMSSSMM;     ;Mm;           ;M;,MMMMMMMMMMm;;;;;;.",
      ";;;;;;;mmMSSSMMMM,   ;Mm;,   '-    ,;M;MMMMMMMSMMMMm;;;;;;;",
      ";;;;;;;MMMSSSMMMMMMMm;Mm;;,  ___  ,;SmM;MMMMMMSSMMMM;;;;;;;;",
      ';;\'";;;MMMSSSSMMMMMM;MMmS;;,  "  ,;SmMM;MMMMMMSSMMMM;;;;;;;;.',
      "!   ;;;MMMSSSSSMMMMM;MMMmSS;;._.;;SSmMM;MMMMMMSSMMMM;;;;;;;;;",
      "    ;;;;*MSSSSSSMMMP;Mm*\"'q;'   `;p*\"*M;MMMMMSSSSMMM;;;;;;;;;",
      "    ';;;  ;SS*SSM*M;M;'     `-.        ;;MMMMSSSSSMM;;;;;;;;;,",
      "     ;;;. ;P  `q; qMM.                 ';MMMMSSSSSMp' ';;;;;;;",
      "     ;;;; ',    ; .mm!     \\.   `.   /  ;MMM' `qSS'    ';;;;;;;",
      "     ';;;       ' mmS';     ;     ,  `. ;'M'   `S       ';;;;;",
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file", ":lua require('fzf-lua').files()<CR>"),
      dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert<CR>"),
      dashboard.button("r", " " .. " Recent files", ":lua require('fzf-lua').oldfiles()<CR>"),
      dashboard.button("g", " " .. " Find text", ":lua require('fzf-lua').live_grep()<CR>"),
      dashboard.button("G", " " .. " LazyGit", ":LazyGit<CR>"),
      dashboard.button("c", " " .. " Config", ":e $MYVIMRC<CR>"),
      dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
      dashboard.button("q", " " .. " Quit", ":qa<CR>"),
    }

    -- Set footer
    dashboard.section.footer.val = function()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      return "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
    end

    -- Adjust layout
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 2 },
      dashboard.section.footer,
    }

    -- Set highlight colors
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    -- Set button highlight
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end

    return dashboard
  end,
  config = function(_, dashboard)
    -- Close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    -- Create Alpha command
    vim.api.nvim_create_user_command("Alpha", function()
      require("alpha").start(true)
    end, {})

    -- Update footer after lazy is loaded
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "⚡ Neovim loaded "
          .. stats.loaded
          .. "/"
          .. stats.count
          .. " plugins in "
          .. ms
          .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    -- Hide line numbers, signcolumn, and statusline for alpha
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      desc = "Disable status, tabline, and cmdline for alpha",
      callback = function()
        local old_laststatus = vim.opt.laststatus:get()
        vim.api.nvim_create_autocmd("BufUnload", {
          buffer = 0,
          desc = "Re-enable status, tabline, and cmdline after alpha",
          callback = function()
            vim.opt.laststatus = old_laststatus
            vim.opt.showtabline = 0
            vim.opt.cmdheight = 1
          end,
          once = true,
        })

        vim.opt.laststatus = 0
        vim.opt.showtabline = 0
        vim.opt.cmdheight = 0

        -- Hide line numbers and signcolumn
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.cursorline = false
        vim.opt_local.cursorcolumn = false
        vim.opt_local.colorcolumn = ""
        vim.opt_local.foldcolumn = "0"
      end,
    })

    -- Disable netrw completely
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
