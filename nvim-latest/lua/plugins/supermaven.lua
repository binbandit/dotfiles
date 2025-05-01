return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven").setup({
        keymaps = {
          -- Change the accept key to Tab
          accept_key = "<Tab>",
        },
        -- Other configuration options
        auto_trigger = true,
        debounce_ms = 100,
        suggestion_color = "#888888",
        -- Disable in certain file types if needed
        disable_file_types = { "TelescopePrompt" },
      })
    end,
  },
}
