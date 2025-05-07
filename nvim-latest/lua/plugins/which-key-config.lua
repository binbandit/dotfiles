return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      local wk = require("which-key")

      -- Register harpoon group
      wk.register({
        h = {
          name = "Harpoon",
          a = { function() require("harpoon"):list():append() end, "Add File" },
          m = { function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, "Menu" },
          ["1"] = { function() require("harpoon"):list():select(1) end, "File 1" },
          ["2"] = { function() require("harpoon"):list():select(2) end, "File 2" },
          ["3"] = { function() require("harpoon"):list():select(3) end, "File 3" },
          ["4"] = { function() require("harpoon"):list():select(4) end, "File 4" },
          n = { function() require("harpoon"):list():next() end, "Next File" },
          p = { function() require("harpoon"):list():prev() end, "Prev File" },
          c = { function() require("harpoon"):list():clear() end, "Clear All" },
        },
        -- Register spell check group
        s = {
          name = "Spell Check",
          s = { "<cmd>ZL<cr>", "Correct All Spelling Errors" },
          w = { "<cmd>Zl<cr>", "Correct Word Under Cursor" },
          f = { "<cmd>ZF<cr>", "Fix All Spelling (First Suggestion)" },
          a = { "<cmd>SpelunkerAddAll<cr>", "Add All Misspelled Words to Dictionary" },
          n = { "<cmd>ZN<cr>", "Next Misspelled Word" },
          p = { "<cmd>ZP<cr>", "Previous Misspelled Word" },
          t = { "<cmd>ZT<cr>", "Toggle Spell Checker" },
        },
        -- Register folding group with more intuitive name and structure
        f = {
          name = "Fold",
          a = { function() require("ufo").openAllFolds() end, "Unfold All Code" },
          c = { function() require("ufo").closeAllFolds() end, "Fold All Code" },
          f = { function() require("ufo").toggleFold() end, "Toggle Fold Under Cursor" },
          o = { function() require("ufo").openFold() end, "Open Fold Under Cursor" },
          C = { function() require("ufo").closeFold() end, "Close Fold Under Cursor" },
          p = { function() require("ufo").peekFoldedLinesUnderCursor() end, "Peek Fold" },
          ["1"] = { function() require("ufo").closeFoldsWith(1) end, "Fold Level 1" },
          ["2"] = { function() require("ufo").closeFoldsWith(2) end, "Fold Level 2" },
          ["3"] = { function() require("ufo").closeFoldsWith(3) end, "Fold Level 3" },
        },
        -- Register code action shortcut
        ["."] = { function() vim.lsp.buf.code_action() end, "Code Action (VSCode style)" },
      }, { prefix = "<leader>" })

      -- Register 'g' prefix group for code navigation with better organization
      wk.register({
        g = {
          name = "Go to/Code Navigation",
          -- Navigation subgroup
          d = { vim.lsp.buf.definition, "Go to Definition" },
          D = { vim.lsp.buf.declaration, "Go to Declaration" },
          i = { vim.lsp.buf.implementation, "Go to Implementation" },
          t = { vim.lsp.buf.type_definition, "Go to Type Definition" },

          -- References and symbols subgroup
          r = { vim.lsp.buf.references, "Find References" },
          s = { vim.lsp.buf.document_symbol, "Document Symbols" },
          S = { vim.lsp.buf.workspace_symbol, "Workspace Symbols" },

          -- Diagnostics subgroup
          n = { vim.diagnostic.goto_next, "Next Diagnostic" },
          p = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
          e = { vim.diagnostic.open_float, "Show Diagnostic Details" },

          -- Documentation subgroup
          k = { vim.lsp.buf.hover, "Show Hover Documentation" },
          K = { vim.lsp.buf.signature_help, "Signature Help" },

          -- Code actions subgroup
          a = { vim.lsp.buf.code_action, "Code Actions" },
          R = { vim.lsp.buf.rename, "Rename Symbol" },
          f = { function() vim.lsp.buf.format({ async = true }) end, "Format Code" },
          l = { vim.lsp.codelens.run, "Run CodeLens" },

          -- If inlay hints are available
          h = {
            function()
              if vim.lsp.inlay_hint then
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
              end
            end,
            "Toggle Inlay Hints"
          },
        },
      })

      -- Also register the same keybindings for visual mode where applicable
      wk.register({
        g = {
          name = "Go to/Code Navigation",
          a = { vim.lsp.buf.code_action, "Code Actions" },
          f = { function() vim.lsp.buf.format({ async = true }) end, "Format Selection" },
        },
      }, { mode = "v" })
    end,
  },
}
