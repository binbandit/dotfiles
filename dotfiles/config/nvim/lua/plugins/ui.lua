return {
	-- base46: NvChad themes
	{
		"AvengeMedia/base46",
		branch = "v3.0",
		priority = 1000,
		opts = {
			transparency = true,
			integrations = {
				blink = true,
				flash = true,
				git = true,
				lsp = true,
				mason = true,
				notify = true,
				treesitter = true,
				trouble = true,
				whichkey = true,
			},
			hl_override = {
				-- stronger visual selection against mountain's near-black background
				Visual = { bg = "grey" },
				VisualNOS = { bg = "grey" },

				-- cleaner diagnostics (no bg noise)
				DiagnosticVirtualTextError = { fg = "red", bg = "NONE" },
				DiagnosticVirtualTextWarn = { fg = "yellow", bg = "NONE" },
				DiagnosticVirtualTextInfo = { fg = "blue", bg = "NONE" },
				DiagnosticVirtualTextHint = { fg = "cyan", bg = "NONE" },
			},
		},
		config = function(_, opts)
			require("base46").setup(opts)
			vim.cmd.colorscheme("base46-mountain")
		end,
	},

	-- lualine: base46 theme colors with tmux ▓▒░ separators
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			local in_tmux = vim.env.TMUX ~= nil

			return {
				options = {
					theme = "base46-mountain",
					globalstatus = true,
					component_separators = "",
					section_separators = { left = "▓▒░", right = "░▒▓" },
					disabled_filetypes = {
						statusline = { "snacks_dashboard" },
					},
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(s)
								return s:sub(1, 1)
							end,
						},
					},
					lualine_b = {
						{
							"branch",
							icon = "",
							cond = function()
								return not in_tmux
							end,
						},
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{
							"filename",
							path = 1,
							symbols = { modified = " +", readonly = " ", unnamed = "[No Name]" },
						},
					},
					lualine_c = {
						{
							"diagnostics",
							symbols = { error = " ", warn = " ", info = " ", hint = " " },
						},
					},
					lualine_x = {
						{
							function()
								local reg = vim.fn.reg_recording()
								if reg ~= "" then
									return " " .. reg
								end
								return ""
							end,
						},
						{ "searchcount", maxcount = 999, timeout = 500 },
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
							cond = function()
								return not in_tmux
							end,
						},
						{
							function()
								local clients = vim.lsp.get_clients({ bufnr = 0 })
								if #clients == 0 then
									return ""
								end
								local names = {}
								for _, c in ipairs(clients) do
									table.insert(names, c.name)
								end
								return " " .. table.concat(names, ", ")
							end,
							cond = function()
								return #vim.lsp.get_clients({ bufnr = 0 }) > 0
							end,
						},
					},
					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {},
				},
				extensions = { "lazy", "trouble", "quickfix", "man" },
			}
		end,
	},

	-- better markdown
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
	},
}
