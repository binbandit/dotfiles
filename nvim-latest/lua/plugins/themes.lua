return {
  -- Add vague.nvim theme
  {
    "vague2k/vague.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- You can customize the theme here
      transparent = true, -- Set to true to work with transparent.nvim
      style = {
        comments = "italic",
        strings = "italic",
        keywords = "none",
        functions = "none",
        variables = "none",
      },
    },
  },

  -- Configure LazyVim to use vague theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vague",
    },
  },
}
