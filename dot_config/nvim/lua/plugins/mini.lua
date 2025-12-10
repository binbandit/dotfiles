return {
	{ 'nvim-mini/mini.ai', version = '*' },
	{ 'nvim-mini/mini.comment', version = '*' },
	{ 'nvim-mini/mini.surround', version = '*' },
	{ 'nvim-mini/mini.basics', version = '*', opts = {
		options = {
			basic = true,
			extra_ui = false,
			win_borders = 'auto'
		},
		mappings = {
			basic = true,
			option_toggle_prefix = [[\]],
			windows = true,
			move_with_alt = false
		},
		autocommands = {
			basic = true,
			relnum_in_visual_mode = false
		},
		silent = true
	} },
}
