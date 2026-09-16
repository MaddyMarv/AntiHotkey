return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`anti_hotkey` mod must be lower than DMF in load order.")

		new_mod("anti_hotkey", {
			mod_script       = "anti_hotkey/scripts/mods/anti_hotkey/anti_hotkey",
			mod_data         = "anti_hotkey/scripts/mods/anti_hotkey/anti_hotkey_data",
			mod_localization = "anti_hotkey/scripts/mods/anti_hotkey/anti_hotkey_localization",
		})
	end,
	packages = {},
}
