return {
	-- {
	-- 	"nyoom-engineering/oxocarbon.nvim",
	-- 	lazy = false,
	-- 	config = function()
	-- 		vim.opt.background = "dark" -- set this to dark or light
	-- 		vim.cmd("colorscheme oxocarbon")
	-- 	end,
	-- }
  {
    "vague-theme/vague.nvim",
     lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other plugins
  config = function()
    -- NOTE: you do not need to call setup if you don't want to.
    require("vague").setup({
      -- optional configuration here
    })
    vim.cmd("colorscheme vague")
  end
  }
	-- { "bettervim/yugen.nvim", lazy = false, priority = 1000 },
	-- { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
}
