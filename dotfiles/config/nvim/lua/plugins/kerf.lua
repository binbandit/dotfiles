return {
  {
    "binbandit/kerf.nvim",
    event = "VeryLazy",
    cmd = {
      "Kerf",
      "KerfEdit",
      "KerfFunction",
      "KerfLine",
      "KerfInsert",
      "KerfAsk",
      "KerfAgain",
      "KerfBackend",
      "KerfModel",
      "KerfStatus",
      "KerfStop",
      "KerfHealth",
    },
    opts = {
      backend = "codex",
      mappings = {
        enabled = true,
        prefix = "<leader>k",
      },
      backends = {
        codex = {
          type = "codex",
          cmd = "codex",
          app_server_args = {},
          model = nil,
          effort = nil,
          summary = "concise",
          approval_policy = "never",
          sandbox_policy = {
            type = "readOnly",
            access = { type = "fullAccess" },
          },
          approval_response = "decline",
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>k", group = "kerf" },
      },
    },
  },
}
