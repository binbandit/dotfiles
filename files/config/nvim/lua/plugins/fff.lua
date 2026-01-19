return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  lazy = false,
  init = function()
    vim.g.fff = vim.g.fff or {}
    vim.g.fff.lazy_sync = true
  end,
  config = function()
    local download = require("fff.download")
    local uv = vim.uv or vim.loop

    local function ensure_backend()
      local binary_path = download.get_binary_path()
      local stat = uv.fs_stat(binary_path)
      if stat and stat.type == "file" then
        require("fff.core").ensure_initialized()
        return
      end

      download.ensure_downloaded({}, function(download_ok, download_err)
        if download_ok then
          vim.schedule(function() require("fff.core").ensure_initialized() end)
          return
        end

        download.build_binary(function(build_ok, build_err)
          if not build_ok then
            local msg = build_err or download_err or "unknown error"
            vim.schedule(function()
              vim.notify("fff.nvim: failed to install Rust backend: " .. msg, vim.log.levels.ERROR)
              vim.notify('Run :lua require("fff.download").download_or_build_binary() then restart Neovim.', vim.log.levels.WARN)
            end)
            return
          end

          vim.schedule(function() require("fff.core").ensure_initialized() end)
        end)
      end)
    end

    if vim.v.vim_did_enter == 1 then
      ensure_backend()
    else
      vim.api.nvim_create_autocmd("UIEnter", {
        group = vim.api.nvim_create_augroup("fff.autobuild", { clear = true }),
        once = true,
        callback = ensure_backend,
      })
    end
  end,
  keys = {
    {
      "ff", -- try it if you didn't it is a banger keybinding for a picker
      function() require('fff').find_files() end,
      desc = 'FFFind files',
    }
  }
}
