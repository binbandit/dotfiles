return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      -- Initialize the global variable to track supermaven state (enabled by default)
      vim.g.supermaven_enabled = true

      -- Create the user directory if it doesn't exist
      local user_dir = vim.fn.stdpath("config") .. "/lua/user"
      if vim.fn.isdirectory(user_dir) == 0 then
        vim.fn.mkdir(user_dir, "p")
      end

      -- Setup supermaven
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
