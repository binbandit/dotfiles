local dashboard_timers = {}
local milli_ns = vim.api.nvim_create_namespace("milli_dashboard_blackhole")
local milli_hl_cache = {}

local function stop_dashboard_timer(buf)
  local timer = dashboard_timers[buf]
  dashboard_timers[buf] = nil

  if timer and not timer:is_closing() then
    timer:stop()
    timer:close()
  end
end

local function milli_hl(fg, bg)
  local key = fg .. "_" .. bg
  if milli_hl_cache[key] then
    return milli_hl_cache[key]
  end

  local name = "MilliDashboard_" .. fg:sub(2) .. "_" .. (bg == "NONE" and "NONE" or bg:sub(2))
  local spec = { fg = fg }
  if bg ~= "NONE" then
    spec.bg = bg
  end
  vim.api.nvim_set_hl(0, name, spec)
  milli_hl_cache[key] = name
  return name
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = { "amansingh-afk/milli.nvim" },
  opts = function()
    local splash = require("milli").load({ splash = "blackhole" })

    local function blackhole_header()
      return {
        header = table.concat(splash.frames[1], "\n"),
        padding = 1,
        render = function(dashboard, pos)
          local buf = dashboard.buf
          stop_dashboard_timer(buf)

          local timer = vim.uv.new_timer()
          if not timer then
            return
          end

          local start_row = pos[1] - 1
          local pad = (dashboard.lines[pos[1]] or ""):match("^( *)") or ""
          local pad_bytes = #pad
          local frame_idx = 1

          dashboard_timers[buf] = timer
          vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
            buffer = buf,
            once = true,
            callback = function()
              stop_dashboard_timer(buf)
            end,
          })

          local function paint()
            if not vim.api.nvim_buf_is_valid(buf) then
              stop_dashboard_timer(buf)
              return false
            end
            if vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "snacks_dashboard" then
              stop_dashboard_timer(buf)
              return false
            end

            local frame = splash.frames[frame_idx]
            local colors = splash.colors and splash.colors[frame_idx]
            if not frame then
              return false
            end

            local lines = {}
            for i, line in ipairs(frame) do
              lines[i] = pad .. line
            end

            vim.bo[buf].modifiable = true
            pcall(vim.api.nvim_buf_set_lines, buf, start_row, start_row + #lines, false, lines)
            vim.bo[buf].modified = false
            vim.bo[buf].modifiable = false

            vim.api.nvim_buf_clear_namespace(buf, milli_ns, start_row, start_row + #lines)
            if colors then
              for row_i, row_runs in ipairs(colors) do
                local buf_row = start_row + row_i - 1
                for _, run in ipairs(row_runs) do
                  local start_col, end_col, fg, bg = run[1], run[2], run[3], run[4]
                  pcall(vim.api.nvim_buf_set_extmark, buf, milli_ns, buf_row, pad_bytes + start_col, {
                    end_col = pad_bytes + end_col,
                    hl_group = milli_hl(fg, bg),
                    priority = 200,
                  })
                end
              end
            end

            frame_idx = frame_idx % #splash.frames + 1
            return true
          end

          local function tick()
            vim.schedule(function()
              if dashboard_timers[buf] ~= timer or not paint() then
                return
              end
              timer:start(splash.delays[frame_idx] or 100, 0, tick)
            end)
          end

          vim.schedule(paint)
          timer:start(splash.delays[frame_idx] or 100, 0, tick)
        end,
      }
    end

    return {
      dashboard = {
        enabled = true,
        width = 100,
        preset = {
          keys = {
            { key = "f", desc = "Find files", action = ":lua require('fff').find_files()" },
            { key = "g", desc = "Live grep", action = ":lua require('fff').live_grep()" },
            { key = "r", desc = "Recent files", action = ":lua Snacks.picker.recent()" },
            { key = "c", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
            { key = "l", desc = "Lazy", action = ":Lazy" },
            { key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          -- Angel ASCII kept for reference.
          --[=[
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
          --]=]
          blackhole_header,
          { section = "keys", gap = 1, padding = 1 },
          { section = "recent_files", limit = 5, padding = 1 },
          { section = "startup" },
        },
      },

      -- snacks modules: only enable what we actually use
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      input = { enabled = true },
      words = { enabled = true },
      indent = {
        enabled = true,
        animate = { enabled = false }, -- no animation, just show guides
      },
      scope = { enabled = true },
      statuscolumn = { enabled = false },
      dim = { enabled = true },
      zen = { enabled = true },
      rename = { enabled = true },
      gitbrowse = { enabled = true },

      -- explicitly disable what we don't use
      picker = {
        enabled = true,
        sources = {
          explorer = {
            auto_close = true, -- close explorer when it loses focus, so :q just works
            actions = {
              fff_grep = function(_, item)
                require("fff").live_grep({
                  cwd = item and Snacks.picker.util.dir(item) or vim.uv.cwd(),
                })
              end,
            },
            win = {
              list = {
                keys = {
                  ["<leader>/"] = "fff_grep",
                },
              },
            },
          },
        },
      },
      explorer = { enabled = true },
      image = { enabled = false },
      scroll = { enabled = false }, -- native smoothscroll is enough
    }
  end,
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
  keys = {
    -- file explorer (toggle: close if open, open if closed)
    {
      "-",
      function()
        local pickers = Snacks.picker.get({ source = "explorer" })
        if #pickers > 0 then
          pickers[1]:close()
        else
          Snacks.explorer()
        end
      end,
      desc = "Toggle file explorer",
    },

    -- terminal
    { "<C-\\>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle terminal" },

    -- git
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git browse", mode = { "n", "v" } },

    -- notifications
    { "<leader>fn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },

    -- LSP word references
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },

    -- zen / focus
    { "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Zoom" },

    -- rename
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file" },

    -- pickers (for things fff doesn't cover)
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols" },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>fg", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader>f'", function() Snacks.picker.resume() end, desc = "Resume last picker" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command history" },

    -- undo tree (native in 0.12)
    { "<leader>uu", "<cmd>Undotree<cr>", desc = "Undo tree" },
  },
}
