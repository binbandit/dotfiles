return {
  {
    "yioneko/nvim-vtsls",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("vtsls").config({})
    end,
  },
}
