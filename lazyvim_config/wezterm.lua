local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- LOOK & FEEL
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 11.0
config.line_height = 1.0

-- WINDOW (Clean, Minimal)
config.window_decorations = "RESIZE"
config.window_padding = { left = 5, right = 5, top = 4, bottom = 0 }

-- VISUALS (Cyberpunk/V1 Vibes)
config.window_background_opacity = 1.0
config.macos_window_background_blur = 30
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.7 }

-- TABS (Hidden for Tmux)
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- 🎨 TOP 3 SOLID BACKGROUNDS
local backgrounds = {
	-- #1: Deep Lavender Gradient (BEST - Catppuccin Perfect Match) 👑
	{
		name = "Deep Lavender",
		config = {
			{
				source = {
					Gradient = {
						colors = { "#1a1625", "#1e1e2e" },
						orientation = "Vertical",
					},
				},
				width = "100%",
				height = "100%",
				opacity = 1.0,
			},
		},
	},

	-- #2: Midnight Blue Gradient (Professional & Sleek) 🌊
	{
		name = "Midnight Blue",
		config = {
			{
				source = {
					Gradient = {
						colors = { "#0d1117", "#161b22" },
						orientation = "Vertical",
					},
				},
				width = "100%",
				height = "100%",
				opacity = 1.0,
			},
		},
	},

	-- #3: Dark Teal Gradient (Modern Cyberpunk) ⚡
	{
		name = "Dark Teal",
		config = {
			{
				source = {
					Gradient = {
						colors = { "#0a1420", "#0f1c28" },
						orientation = "Vertical",
					},
				},
				width = "100%",
				height = "100%",
				opacity = 1.0,
			},
		},
	},
}

-- WALLPAPER BACKGROUND
local wallpaper_bg = {
	{
		source = { File = "/home/thejoceph/Pictures/Camera/wallpaper5.jpg" },
		width = "100%",
		height = "100%",
		opacity = 1.0,
	},
	{
		source = { Color = "#1e1e2e" },
		width = "100%",
		height = "100%",
		opacity = 0.92,
	},
}

-- INITIALIZE STATE (FIXED)
if not wezterm.GLOBAL.bg_state then
	wezterm.GLOBAL.bg_state = {
		wallpaper_enabled = true,
		current_bg_index = 1,
	}
end

-- SET DEFAULT BACKGROUND
config.background = wallpaper_bg

-- 🎮 KEYBINDINGS (FULLY FIXED)
config.keys = {
	{ key = "F11", action = wezterm.action.ToggleFullScreen },

	-- F12: Toggle Wallpaper ON/OFF (FIXED)
	{
		key = "F12",
		action = wezterm.action_callback(function(window, _)
			local state = wezterm.GLOBAL.bg_state
			local overrides = window:get_config_overrides() or {}

			state.wallpaper_enabled = not state.wallpaper_enabled

			if state.wallpaper_enabled then
				overrides.background = wallpaper_bg
			else
				overrides.background = backgrounds[state.current_bg_index].config
			end

			window:set_config_overrides(overrides)
		end),
	},

	-- Ctrl+Shift+B: Cycle Backgrounds (FIXED)
	{
		key = "b",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, _)
			local state = wezterm.GLOBAL.bg_state
			local overrides = window:get_config_overrides() or {}

			if not state.wallpaper_enabled then
				state.current_bg_index = (state.current_bg_index % #backgrounds) + 1
				overrides.background = backgrounds[state.current_bg_index].config

				window:set_config_overrides(overrides)

				window:toast_notification("WezTerm", backgrounds[state.current_bg_index].name, nil, 1000)
			else
				window:toast_notification("WezTerm", "Press F12 first to disable wallpaper", nil, 1500)
			end
		end),
	},
}

return config
