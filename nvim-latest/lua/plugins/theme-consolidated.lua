return {
  -- Vague theme
  {
    "vague2k/vague.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
      "rktjmp/lush.nvim",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("vague").setup({
        -- Adjust the theme as needed
        transparent = vim.g.transparent_enabled, -- Use the transparent.nvim setting
        style = "default", -- Choose style: default, warm, cold
        style = {
          comments = "italic",
          strings = "italic",
          keywords = "none",
          functions = "none",
          variables = "none",
        },
      })
      vim.cmd.colorscheme("vague")
    end,
  },

  -- Configure LazyVim to use vague theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vague",
    },
  },

  -- Transparent background
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup({
        groups = { -- table: default groups
          "Normal",
          "NormalNC",
          "Comment",
          "Constant",
          "Special",
          "Identifier",
          "Statement",
          "PreProc",
          "Type",
          "Underlined",
          "Todo",
          "String",
          "Function",
          "Conditional",
          "Repeat",
          "Operator",
          "Structure",
          "LineNr",
          "NonText",
          "SignColumn",
          "CursorLine",
          "CursorLineNr",
          "StatusLine",
          "StatusLineNC",
          "EndOfBuffer",
        },
        extra_groups = {
          "NormalFloat",
          -- Add more groups here
        },
        exclude_groups = {}, -- table: groups you don't want to clear
        on_clear = function() end,
      })

      -- Enable transparency by default
      vim.cmd("TransparentEnable")

      -- Add a keymap to toggle transparency
      vim.keymap.set(
        "n",
        "<leader>tt",
        ":TransparentToggle<CR>",
        { noremap = true, silent = true, desc = "Toggle Transparency" }
      )
    end,
  },
}
