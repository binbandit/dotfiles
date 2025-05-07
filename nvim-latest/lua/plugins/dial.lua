return {
  {
    "monaqa/dial.nvim",
    event = "VeryLazy",
    keys = {
      { "<C-=>", function() require("dial.map").inc_normal() end, desc = "Increment" },
      { "<C-->", function() require("dial.map").dec_normal() end, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
        },
      })
    end,
  },
}
