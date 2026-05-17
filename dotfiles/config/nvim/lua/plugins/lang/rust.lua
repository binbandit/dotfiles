return {
  -- rustaceanvim: the SOLE manager of rust-analyzer
  -- do NOT add rust_analyzer to vim.lsp.enable() or lsp/ directory
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          -- use system rust-analyzer, not mason's (avoids toolchain mismatch)
          cmd = function()
            return { "rust-analyzer" }
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = true,
              check = { command = "clippy" },
              procMacro = { enable = true },
            },
          },
          -- prevent attaching if another rust-analyzer is already attached
          on_attach = function(client, bufnr)
            local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })
            if #clients > 1 then
              -- another instance exists, stop this one
              client:stop()
            end
          end,
        },
      }
    end,
  },

  -- crates.nvim: cargo.toml integration
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        cmp = { enabled = false },
        crates = { enabled = true },
      },
    },
  },
}
