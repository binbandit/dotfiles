-- Autocmds

-- LSP attach keymaps (only for things NOT provided by 0.11 defaults)
-- 0.11 defaults: grn=rename, grr=references, gri=implementation, gra=code_action, gO=doc_symbols, <C-s>=sig_help
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    pcall(vim.lsp.inlay_hint.enable, true, { bufnr = ev.buf })

    -- gd = go to definition (not a 0.11 default, still useful)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("keep", { desc = "Goto definition" }, opts))

    -- Ruff: organize imports keybind
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == "ruff" then
      vim.keymap.set("n", "<leader>co", function()
        vim.lsp.buf.code_action({
          apply = true,
          context = { only = { "source.organizeImports" }, diagnostics = {} },
        })
      end, vim.tbl_extend("keep", { desc = "Organize imports" }, opts))
    end
  end,
})

-- Enable LSP servers lazily on first real buffer
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("BootstrapNativeLsp", { clear = true }),
  once = true,
  callback = function()
    -- rust_analyzer (nvim-lspconfig name) is managed only by rustaceanvim
    vim.lsp.config["rust_analyzer"] = {
      enabled = false,
      autostart = false,
    }

    -- Config lives in lsp/<name>.lua files
    -- NOTE: rust_analyzer is NOT here -- rustaceanvim manages it exclusively
    vim.lsp.enable({
      "lua_ls",
      "basedpyright",
      "ruff",
      "eslint",
      "vtsls",
    })
  end,
})

-- Treesitter folding (only when a parser exists for the filetype)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterFolding", { clear = true }),
  callback = function(args)
    if pcall(vim.treesitter.get_parser, args.buf) then
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt_local.foldlevel = 99
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", {}),
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("ResizeSplits", {}),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Quit Neovim cleanly: close Snacks explorer/dashboard/special windows
-- so you don't need to :q multiple times
vim.api.nvim_create_autocmd("QuitPre", {
  group = vim.api.nvim_create_augroup("QuitCleanup", {}),
  callback = function()
    -- Collect all "real" windows (not floating, not special buffers)
    local real_wins = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative == "" then
        local buf = vim.api.nvim_win_get_buf(win)
        local bt = vim.bo[buf].buftype
        local ft = vim.bo[buf].filetype
        -- Skip snacks explorer, dashboard, notify, terminal, and other special buffers
        local dominated = bt == "nofile"
          or bt == "nowrite"
          or bt == "terminal"
          or ft == "startup_splash"
          or ft == "snacks_dashboard"
          or ft == "snacks_explorer"
          or ft == "snacks_notif"
          or ft == "snacks_terminal"
        if not dominated then
          table.insert(real_wins, win)
        end
      end
    end
    -- If this is the last real window, close all other windows so :q exits cleanly
    if #real_wins <= 1 then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == "" then
          local buf = vim.api.nvim_win_get_buf(win)
          local bt = vim.bo[buf].buftype
          local ft = vim.bo[buf].filetype
          if bt == "nofile" or ft == "startup_splash" or ft == "snacks_dashboard" or ft == "snacks_explorer" or ft == "snacks_notif" then
            pcall(vim.api.nvim_win_close, win, true)
          end
        end
      end
    end
  end,
})

local function get_startup_logo()
  local logo_path = vim.fn.stdpath("config") .. "/logo.txt"
  if vim.fn.filereadable(logo_path) == 1 then
    return vim.fn.readfile(logo_path)
  end

  return {
    " ██████╗ ██╗███╗   ██╗██████╗  █████╗ ███╗   ██╗██████╗ ██╗████████╗",
    " ██╔══██╗██║████╗  ██║██╔══██╗██╔══██╗████╗  ██║██╔══██╗██║╚══██╔══╝",
    " ██████╔╝██║██╔██╗ ██║██████╔╝███████║██╔██╗ ██║██║  ██║██║   ██║   ",
    " ██╔══██╗██║██║╚██╗██║██╔══██╗██╔══██║██║╚██╗██║██║  ██║██║   ██║   ",
    " ██████╔╝██║██║ ╚████║██████╔╝██║  ██║██║ ╚████║██████╔╝██║   ██║   ",
    " ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝   ╚═╝   ",
  }
end

local function show_startup_splash()
  local buf = vim.api.nvim_get_current_buf()
  local logo = get_startup_logo()
  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)
  local pad_top = math.max(0, math.floor((height - #logo) / 2) - 2)
  local lines = {}

  for _ = 1, pad_top do
    table.insert(lines, "")
  end

  for _, line in ipairs(logo) do
    local pad_left = math.max(0, math.floor((width - vim.fn.strdisplaywidth(line)) / 2))
    table.insert(lines, string.rep(" ", pad_left) .. line)
  end

  table.insert(lines, "")
  table.insert(lines, "")
  table.insert(lines, "  <leader><leader> Find files   <leader>e Explorer   <leader>/ Grep")

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "startup_splash"
  vim.bo[buf].buflisted = false
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.statuscolumn = ""
  vim.opt_local.foldcolumn = "0"
  vim.opt_local.cursorline = false
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("StartupLanding", { clear = true }),
  callback = function()
    if #vim.api.nvim_list_uis() == 0 then
      return
    end

    local argc = vim.fn.argc(-1)
    if argc == 1 then
      local target = vim.fn.argv(0)
      if vim.fn.isdirectory(target) == 1 then
        vim.schedule(function()
          local ok = pcall(function()
            require("lazy").load({ plugins = { "mini.pick", "mini.extra" } })
            MiniExtra.pickers.explorer({ cwd = vim.fn.fnamemodify(target, ":p") })
          end)
          if not ok then
            vim.notify("Explorer failed to open", vim.log.levels.WARN)
          end
        end)
        return
      end
    end

    if argc == 0 and vim.api.nvim_buf_get_name(0) == "" and vim.bo.buftype == "" then
      show_startup_splash()
    end
  end,
})

-- Go to last cursor position when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("LastPlace", {}),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf]._last_loc_set then
      return
    end
    vim.b[buf]._last_loc_set = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
