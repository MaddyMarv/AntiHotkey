return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`AntiHotkey` encountered an error loading the Darktide Mod Framework.")

		new_mod("AntiHotkey", {
			mod_script       = "AntiHotkey/scripts/mods/AntiHotkey/AntiHotkey",
			mod_data         = "AntiHotkey/scripts/mods/AntiHotkey/AntiHotkey_data",
			mod_localization = "AntiHotkey/scripts/mods/AntiHotkey/AntiHotkey_localization",
		})
	end,
	packages = {},
}
