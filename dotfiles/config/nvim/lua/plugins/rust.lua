return {
  {
    "mrcjkb/rustaceanvim",
    version = "^8",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            auto_focus = true,
          },
          test_executor = "background", -- failed tests show as diagnostics
          code_actions = {
            ui_select_fallback = true,
          },
        },
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              checkOnSave = true,
              check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              inlayHints = {
                bindingModeHints = { enable = false },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true, minLines = 25 },
                closureReturnTypeHints = { enable = "with_block" },
                lifetimeElisionHints = { enable = "never" },
                maxLength = 25,
                parameterHints = { enable = true },
                reborrowHints = { enable = "never" },
                renderColons = true,
                typeHints = {
                  enable = true,
                  hideClosureInitialization = false,
                  hideNamedConstructor = false,
                },
              },
            },
          },
        },
      }
    end,
  },

  {
    "saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
        completion = {
          crates = {
            enabled = true,
            min_chars = 3,
            max_results = 8,
          },
          blink = {
            use_custom_kind = true,
            kind_text = {
              version = "Version",
              feature = "Feature",
            },
            kind_highlight = {
              version = "BlinkCmpKindVersion",
              feature = "BlinkCmpKindFeature",
            },
          },
        },
      })

      -- Cargo.toml keymaps
      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("CratesKeymaps", { clear = true }),
        pattern = "Cargo.toml",
        callback = function(event)
          local crates = require("crates")
          local buf = event.buf
          local function buf_map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
          end
          buf_map("<leader>cu", crates.update_crate, "Update crate")
          buf_map("<leader>cU", crates.update_all_crates, "Update all crates")
          buf_map("<leader>cv", crates.show_versions_popup, "Crate versions")
          buf_map("<leader>cf", crates.show_features_popup, "Crate features")
          buf_map("<leader>cd", crates.open_documentation, "Crate docs")
          buf_map("<leader>cH", crates.open_homepage, "Crate homepage")
          buf_map("<leader>cR", crates.open_repository, "Crate repository")
        end,
      })
    end,
  },
}
