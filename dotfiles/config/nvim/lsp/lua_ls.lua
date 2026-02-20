--- @type vim.lsp.Config
return {
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
