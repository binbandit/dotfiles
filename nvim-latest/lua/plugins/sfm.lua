return {
  {
    "dinhhuy258/sfm-git.nvim",
    lazy = false, -- Load immediately
  },
  {
    "dinhhuy258/sfm.nvim",
    event = "VeryLazy", -- Ensure it loads
    dependencies = {
      "dinhhuy258/sfm-git.nvim",
    },
    config = function()
      -- Basic SFM setup without git integration first
      local sfm_config = {
        -- Add any custom configuration here
        mappings = {
          -- Custom mappings for the file explorer
          custom_only = false, -- If true, only use custom mappings
          list = {
            -- Add your custom mappings here
          },
        },
      }

      -- Setup SFM with the config
      require("sfm").setup(sfm_config)

      -- Map Ctrl+E to toggle the file explorer
      vim.keymap.set(
        "n",
        "<C-e>",
        "<cmd>SFMToggle<CR>",
        { noremap = true, silent = true, desc = "Toggle File Explorer" }
      )
    end,
  },
}
