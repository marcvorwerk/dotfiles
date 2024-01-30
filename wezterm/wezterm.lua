-- Pull in the wezterm API
local wezterm = require("wezterm")

require("open_file_with_vim")

-- This table will hold the configuration.
local config = {}

local act = wezterm.action

-- enable scrollback bar
config.enable_scroll_bar = false

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- set font
config.font = wezterm.font("Hack")
-- config.font = wezterm.font("MesloLGS NF") -- Alternative mit mehr Höhenabstand

config.font_size = 12.5

config.line_height = 1.0

-- load tokyonight_moon scheme colors
-- Colors, _ = wezterm.color.load_scheme("/home/mstinsky/.config/wezterm/tokyonight_moon.toml")
-- setup terminal color from load scheme
-- config.colors = Colors
-- config.color_scheme = "Catppuccin Frappe"
-- config.color_scheme = "Cyberpunk"
config.color_scheme = "Tokyo Night"
-- config.color_scheme = "Aurora"

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Iteriere über die Regeln und entferne den Mailto-Link
for i, rule in ipairs(config.hyperlink_rules) do
	if rule.format == "mailto:$0" then
		table.remove(config.hyperlink_rules, i)
		break
	end
end

-- setup keybinds
config.keys = {
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = wezterm.action.ReloadConfiguration,
	},
	{
		key = "%",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal,
	},
	{
		key = '"',
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical,
	},
	{
		key = "t",
		mods = "CTRL",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
}
for i = 1, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL",
		action = act.ActivateTab(i - 1),
	})
end

config.scrollback_lines = 10000

config.window_decorations = "TITLE | RESIZE"

-- Return config
return config
