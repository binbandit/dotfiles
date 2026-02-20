--- @type vim.lsp.Config
return {
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = {
    settings = {
      logLevel = "error",
    },
  },
  on_attach = function(client)
    -- Disable hover in favor of basedpyright
    client.server_capabilities.hoverProvider = false
  end,
}
