return {
  -- Helper commands for vtsls (organize imports, source definition, etc.)
  {
    "yioneko/nvim-vtsls",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("vtsls").config({})
    end,
  },
}
