return { {
  "mrcjkb/rustaceanvim",
  version = '^5',
  lazy = false,
},
  {
    "saecki/crates.nvim",
    event = { "BufReadPre Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local crates = require("crates")
      crates.setup({})

      local group = vim.api.nvim_create_augroup("CratesExtras", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        group = group,
        pattern = "Cargo.toml",
        callback = function(event)
          local ok, mapped = pcall(vim.api.nvim_buf_get_var, event.buf, "crates_mapped")
          if ok and mapped then return end

          local function buf_map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
          end
          buf_map("<leader>cu", crates.update_crate, "Update crate under cursor")
          buf_map("<leader>cU", crates.update_all_crates, "Update all crates")
          buf_map("<leader>cv", crates.show_versions_popup, "Show crate versions")
          buf_map("<leader>cf", crates.show_features_popup, "Show crate features")
          buf_map("<leader>cd", crates.open_documentation, "Open crate documentation")

          vim.api.nvim_buf_set_var(event.buf, "crates_mapped", true)
        end,
      })
    end,
  },
}
