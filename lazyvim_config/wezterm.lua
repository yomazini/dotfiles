local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- LOOK & FEEL
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 11.2
config.line_height = 1.1

-- WINDOW (Clean, Minimal)
config.window_decorations = "RESIZE" -- Removes title bar
-- config.window_padding = { left = 20, right = 20, top = 20, bottom = 20 }
config.window_padding = { left = 5, right = 5, top = 4, bottom = 0 }

-- VISUALS (Cyberpunk/V1 Vibes)
config.window_background_opacity = 0.95
config.macos_window_background_blur = 30
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.7 } -- Dim inactive panes


-- BACKGROUND SETTINGS
-- Option A: Wallpaper (Active)
config.background = {
	-- Layer 1: The Image
	{
		source = { File = "/home/thejoceph/Pictures/Camera/wallpaper5.jpg" },
		width = "100%",
		height = "100%",
		opacity = 1.0,
	},
	-- Layer 2: The Tint (Dark layer on top for readability)
	{
		source = { Color = "#1e1e2e" },
		width = "100%",
		height = "100%",
		opacity = 0.92, -- 92% Dark (Very subtle wallpaper visibility)
	},
}

-- Option B: Gradient (To use this, comment out Option A above)
-- config.background = {
--   {
--     source = {
--       Gradient = {
--         colors = { '#1e1e2e', '#11111b' },
--         orientation = 'Vertical',
--       }
--     },
--     width = '100%',
--     height = '100%',
--     opacity = 1.0,
--   }
-- }

-- TABS (Hidden for Tmux)
config.enable_tab_bar = false -- True "Headless" mode. No bar.
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- KEYS (Pass-through for Tmux)
-- We disable the WezTerm leader so Ctrl+B goes straight to Tmux.
-- config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
	-- FULLSCREEN (F11 like Gnome)
	{ key = "F11", action = wezterm.action.ToggleFullScreen },
}

return config
