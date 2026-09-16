return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`anti_keybinds` mod must be lower than DMF in load order.")

		new_mod("anti_keybinds", {
			mod_script       = "anti_keybinds/scripts/mods/anti_keybinds/anti_keybinds",
			mod_data         = "anti_keybinds/scripts/mods/anti_keybinds/anti_keybinds_data",
			mod_localization = "anti_keybinds/scripts/mods/anti_keybinds/anti_keybinds_localization",
		})
	end,
	packages = {},
}
