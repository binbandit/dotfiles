return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          -- Change the accept key to Tab
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-]>",
          accept_word = "<Tab>",
        },
        -- Other configuration options
        ignore_filetypes = { TelescopePrompt = true },
        color = {
          suggestion_color = "#888888",
        },
        log_level = "info",
      })
    end,
  },
}
