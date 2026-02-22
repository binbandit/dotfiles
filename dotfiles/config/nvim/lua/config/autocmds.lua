-- Autocmds

-- LSP attach keymaps (only for things NOT provided by 0.11 defaults)
-- 0.11 defaults: grn=rename, grr=references, gri=implementation, gra=code_action, gO=doc_symbols, <C-s>=sig_help
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
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

-- Enable LSP servers (the 0.11 native way)
-- Config lives in lsp/<name>.lua files
-- NOTE: rust_analyzer is NOT here -- rustaceanvim manages it exclusively
vim.lsp.enable({
  "lua_ls",
  "basedpyright",
  "ruff",
  "eslint",
  "vtsls",
})

-- Prevent native vim.lsp from ever starting rust_analyzer (rustaceanvim owns it)
vim.lsp.config["rust_analyzer"] = {
  enabled = false,
}

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
          if bt == "nofile" or ft == "snacks_dashboard" or ft == "snacks_explorer" or ft == "snacks_notif" then
            pcall(vim.api.nvim_win_close, win, true)
          end
        end
      end
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
