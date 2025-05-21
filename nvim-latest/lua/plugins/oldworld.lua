return {
  -- Oldworld theme
  {
    "dgox16/oldworld.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("oldworld").setup({
        -- You can customize the theme here if needed
        terminal_colors = true,
        variant = "default", -- default, oled, cooler
        styles = {
          comments = { italic = true },
          keywords = {},
          identifiers = {},
          functions = {},
          variables = {},
          booleans = { italic = true },
        },
        integrations = {
          -- Enable integrations with plugins
          alpha = true,
          cmp = true,
          flash = true,
          gitsigns = true,
          indent_blankline = true,
          lazy = true,
          lsp = true,
          markdown = true,
          mason = true,
          neo_tree = true,
          noice = true,
          notify = true,
          rainbow_delimiters = true,
          telescope = true,
          treesitter = true,
        },
        -- Add highlight overrides
        highlight_overrides = {
          -- Override alpha dashboard colors to use more neutral colors
          AlphaHeader = { fg = "#c9c7cd" }, -- Use the main foreground color instead of blue
          AlphaButtons = { fg = "#9f9ca6" }, -- Use subtext2 color for buttons
          AlphaFooter = { fg = "#6c6874", italic = true }, -- Keep the footer as is
          AlphaShortcut = { fg = "#90b99f", italic = true }, -- Use green for shortcuts
        },
      })

      -- Set colorscheme
      vim.cmd.colorscheme("oldworld")

      -- Apply custom highlights after colorscheme is set
      vim.defer_fn(function()
        require("config.highlights").setup()
      end, 100)
    end,
  },
}
