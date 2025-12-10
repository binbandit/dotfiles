return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      
      -- REQUIRED: Setup harpoon
      harpoon:setup()
      
      -- Global key mappings for harpoon (intuitive mappings)
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon toggle menu" })
      
      -- Navigation to harpoon marks (using leader key for which-key compatibility)
      vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon goto 1" })
      vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon goto 2" })
      vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon goto 3" })
      vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon goto 4" })
      
      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon previous" })
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon next" })
      
    end,
    keys = {
      "<leader>ha",
      "<leader>he",
      "<leader>h1",
      "<leader>h2",
      "<leader>h3",
      "<leader>h4",
      "<leader>hp",
      "<leader>hn",
    },
  }
