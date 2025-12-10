return {
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		config = function()
			vim.opt.background = "dark" -- set this to dark or light
			vim.cmd("colorscheme oxocarbon")
		end,
	}
	-- { "bettervim/yugen.nvim", lazy = false, priority = 1000 },
	-- { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
}
