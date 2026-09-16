return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`AntiHotkey` mod must be lower than DMF in load order.")

		new_mod("AntiHotkey", {
			mod_script       = "AntiHotkey/scripts/mods/AntiHotkey/AntiHotkey",
			mod_data         = "AntiHotkey/scripts/mods/AntiHotkey/AntiHotkey_data",
			mod_localization = "AntiHotkey/scripts/mods/AntiHotkey/AntiHotkey_localization",
		})
	end,
	packages = {},
}
