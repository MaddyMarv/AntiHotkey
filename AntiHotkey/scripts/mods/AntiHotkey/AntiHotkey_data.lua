local mod = get_mod("AntiHotkey")

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = {
            {
                setting_id = "suppress_vanilla_inventory",
                type = "checkbox",
                default_value = true,
            },
        },
    },
}
