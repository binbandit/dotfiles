return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/which-key.nvim", -- Add which-key as a dependency
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        menu = {
          width = 60,
          height = 10,
        },
      })

      -- We'll use the which-key-harpoon.lua file for group registration instead

      -- Add file to harpoon
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { desc = "Harpoon Add File" })

      -- Toggle quick menu
      vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })

      -- Navigate to files (1-4)
      vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon File 1" })
      vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon File 2" })
      vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon File 3" })
      vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon File 4" })

      -- Navigate to next/prev file
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon Next File" })
      vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon Prev File" })

      -- Clear all harpoon marks
      vim.keymap.set("n", "<leader>hc", function() harpoon:list():clear() end, { desc = "Harpoon Clear All" })
    end,
  },
}
