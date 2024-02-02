local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config = {
	color_scheme = "catppuccinMocha",
	font = wezterm.font_with_fallback({
		{
			family = "FiraCode Nerd Font",
			weight = "Regular",
			italic = false,
		},
		"Noto Color Emoji",
	}),
	font_size = "12.0",

	hide_tab_if_only_one_tab = false,
}

return config
