-- Change this to switch themes: "koda" | "vague" | "oxocarbon" | "yugen" | "moonfly"
local theme = "moonfly"

local function is_active(name)
	return name == theme
end

return {
	{
		"oskarnurm/koda.nvim",
		lazy = not is_active("koda"),
		priority = is_active("koda") and 1000 or nil,
		config = function()
			require("koda").setup()
			if is_active("koda") then
				vim.cmd("colorscheme koda")
			end
		end,
	},
	{
		"vague-theme/vague.nvim",
		lazy = not is_active("vague"),
		priority = is_active("vague") and 1000 or nil,
		config = function()
			require("vague").setup()
			if is_active("vague") then
				vim.cmd("colorscheme vague")
			end
		end,
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = not is_active("oxocarbon"),
		priority = is_active("oxocarbon") and 1000 or nil,
		config = function()
			if is_active("oxocarbon") then
				vim.cmd("colorscheme oxocarbon")
			end
		end,
	},
	{
		"bettervim/yugen.nvim",
		lazy = not is_active("yugen"),
		priority = is_active("yugen") and 1000 or nil,
		config = function()
			if is_active("yugen") then
				vim.cmd("colorscheme yugen")
			end
		end,
	},
	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
		lazy = not is_active("moonfly"),
		priority = is_active("moonfly") and 1000 or nil,
		config = function()
			if is_active("moonfly") then
				vim.cmd("colorscheme moonfly")
			end
		end,
	},
}
