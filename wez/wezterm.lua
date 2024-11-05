local function color_scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		-- return "Tokyo Night"
		return "Batman"
	else
		return "Tokyo Night Light (Gogh)"
	end
end

local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font = wezterm.font("OperatorMono Nerd Font")
config.font_size = 14.0
config.color_scheme = color_scheme_for_appearance(wezterm.gui.get_appearance())
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.90
config.text_background_opacity = 1.0
config.hide_tab_bar_if_only_one_tab = true
config.native_macos_fullscreen_mode = false

-- Keybindings
config.keys = {
	-- Default QuickSelect keybind (CTRL-SHIFT-Space) gets captured by something
	-- else on my system
	{
		key = "A",
		mods = "CTRL|SHIFT",
		action = wezterm.action.QuickSelect,
	},
	-- Split remapping
	{
		key = "V",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical,
	},
	{
		key = "H",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal,
	},
	-- Close current pane
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
}

-- Return config to WezTerm
return config
