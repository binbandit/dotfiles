--- @type vim.lsp.Config
return {
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false },
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
      diagnostics = {
        -- lazydev.nvim handles globals like `vim`
        disable = { "missing-fields" },
      },
    },
  },
}
