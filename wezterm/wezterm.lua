local wezterm = require("wezterm")

require("actions")
require("open_file_with_vim")

local act = wezterm.action
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = true

-- Plugin laden und mit Defaults konfigurieren
-- local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
-- modal.use({}) -- aktiviert Standard-Modus und Defaults
-- modal.apply_to_config(config)

config.leader = { key = "Space", mods = "CTRL|SHIFT", timeout_milliseconds = 1000 }
-- https://github.com/MLFlexer/.dotfiles/blob/main/home-manager/config/wezterm/keybinds.lua
-- config.keys = require("keybinds")
-- config.mouse_bindings = require("mousebinds")

config.check_for_updates = false
config.automatically_reload_config = true
config.quit_when_all_windows_are_closed = true

config.window_padding = {
	left = "0.5cell",
	right = "1.1cell",
	top = "0.8cell",
	bottom = "0.3cell",
}

config.min_scroll_bar_height = "3cell"
config.enable_scroll_bar = true
config.scrollback_lines = 5000

config.font = wezterm.font("Hack")
config.font_size = 12.5
config.line_height = 1.0

-- config.color_scheme = "Cyberpunk"
-- config.color_scheme = "Aurora"

config.color_scheme = "Tokyo Night"
config.colors = {
	scrollbar_thumb = "#5e1b28",
	split = "#5e1b28",
}

config.inactive_pane_hsb = {
	saturation = 0.7,
	brightness = 0.5,
}

config.selection_word_boundary = "\t\n{}[]()\"'´` .,;:=@"

config.hyperlink_rules = wezterm.default_hyperlink_rules()
for i, rule in ipairs(config.hyperlink_rules) do
	if rule.format == "mailto$0" then
		table.remove(config.hyperlink_rules, i)
		break
	end
end

config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false

config.window_decorations = "TITLE | RESIZE"

config.keys = {
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(1) },
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

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL",
		action = act.ActivateTab(i - 1),
	})
end

return config
