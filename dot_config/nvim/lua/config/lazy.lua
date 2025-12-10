-- Bootstrap lazier.nvim (wrapper around lazy.nvim)
local lazier_path = vim.fn.stdpath("data") .. "/lazier/lazier.nvim"
if not (vim.uv or vim.loop).fs_stat(lazier_path) then
  local repo = "https://github.com/jake-stewart/lazier.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--branch=stable-v2", repo, lazier_path })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazier.nvim:\n", "ErrorMsg" },
      { out,                              "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazier_path)

require("config.options")
require("config.autocmds")
require("config.keys")

require("lazier").setup("plugins", {
  lazier = {
    detect_changes = true,
  },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
