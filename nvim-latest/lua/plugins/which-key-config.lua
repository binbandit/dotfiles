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
      }, { prefix = "<leader>" })
    end,
  },
}
