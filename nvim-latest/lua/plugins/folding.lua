return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPost",
    keys = {
      -- More intuitive keymaps that don't override Vim's default folding
      -- Use <leader>f prefix for fold-related commands
      { "<leader>fa", function() require("ufo").openAllFolds() end, desc = "Unfold All Code" },
      { "<leader>fc", function() require("ufo").closeAllFolds() end, desc = "Fold All Code" },
      { "<leader>ff", function() require("ufo").toggleFold() end, desc = "Toggle Fold Under Cursor" },
      { "<leader>fo", function() require("ufo").openFold() end, desc = "Open Fold Under Cursor" },
      { "<leader>fC", function() require("ufo").closeFold() end, desc = "Close Fold Under Cursor" },
      { "<leader>fp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek Fold" },

      -- Fold level commands with intuitive names
      { "<leader>f1", function() require("ufo").closeFoldsWith(1) end, desc = "Fold Level 1" },
      { "<leader>f2", function() require("ufo").closeFoldsWith(2) end, desc = "Fold Level 2" },
      { "<leader>f3", function() require("ufo").closeFoldsWith(3) end, desc = "Fold Level 3" },

      -- Keep some Vim-compatible bindings but don't override all of them
      { "zP", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek Fold" },
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open All Folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close All Folds" },
    },
    opts = {
      -- Use treesitter as the main provider for folding
      provider_selector = function(bufnr, filetype, buftype)
        -- For most filetypes, use treesitter with indent as fallback
        return { "treesitter", "indent" }
      end,

      -- Open all folds when opening a file
      open_fold_hl_timeout = 150,

      -- Customize fold text
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local totalLines = endLnum - lnum
        local foldedLines = "  ⟨ " .. totalLines .. " lines ⟩ "
        local suffix = ("  %d "):format(totalLines)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0

        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)

          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)

            -- If there's still room, add the fold indicator
            if curWidth + chunkWidth < targetWidth then
              table.insert(newVirtText, { foldedLines, "Comment" })
            end

            break
          end

          curWidth = curWidth + chunkWidth
        end

        return newVirtText
      end,

      -- Preview window setup
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
      },
    },
    config = function(_, opts)
      -- Enable folding
      vim.opt.foldenable = true

      -- Don't fold by default when opening a file
      vim.opt.foldlevel = 99

      -- Use treesitter for folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.require'nvim-ufo'.foldexpr()"

      -- Don't show the folding column
      vim.opt.foldcolumn = "0"

      -- Setup UFO
      require("ufo").setup(opts)
    end,
  },
}
