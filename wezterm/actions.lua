local wezterm = require("wezterm")
local act = wezterm.action

return {
	key_tables = {
		search_mode = {
			{ key = "e", mods = "CTRL", action = act.CopyMode("EditPattern") },
		},
		copy_mode = {
			key = "v",
			mods = "NONE",
			action = act.CopyMode({ SetSelectionMode = "Cell" }),
		},
	},
}
