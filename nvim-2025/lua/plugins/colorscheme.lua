return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent = true,
      }
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        compile = true,
        undercurl = true,
        transparent = true,
      }
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },

  {
    "foxycorps/lunaria_glow.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.lunaria_glow_transparent = true -- or false
      vim.cmd.colorscheme("lunaria_glow") -- load the scheme
    end,
  },
}
