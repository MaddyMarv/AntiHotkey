local mod = get_mod("AntiHotkey")
local dmf = get_mod("DMF")

--Put the mod file name here 
--Example: ["mod_name"] = true,
local whitelisted_mods = {
    ["DMF"] = true,
    ["AntiHotkey"] = true,
    ["your_mod_here?"] = true,
}

if dmf then
    mod:hook(dmf, "safe_call_nr", function(func, target_mod, error_prefix_data, inner_func, ...)
        local input_manager = Managers.input

        if type(error_prefix_data) == "table" and error_prefix_data[1] == "[Keybindings] function_call 'mod.%s'" then
            if input_manager and input_manager:cursor_active() then
                local mod_name = target_mod:get_name()
                
                if not whitelisted_mods[mod_name] then
                    return
                end
            end
        end

        return func(target_mod, error_prefix_data, inner_func, ...)
    end)
    
    mod:hook(dmf, "keybind_toggle_view", function(func, target_mod, view_name, transition_data, can_perform_action, is_pressed)
        local input_manager = Managers.input

        if input_manager and input_manager:cursor_active() then
            local mod_name = target_mod:get_name()
            
            if not whitelisted_mods[mod_name] then
                return
            end
        end

        return func(target_mod, view_name, transition_data, can_perform_action, is_pressed)
    end)
end

mod:hook_require("scripts/managers/ui/ui_manager", function(instance)
    mod:hook(instance, "_update_view_hotkeys", function(func, self)
        local input_manager = Managers.input
        
        if mod:get("suppress_vanilla_inventory") and input_manager and input_manager:cursor_active() then
            local hotkey_settings = self._update_hotkeys
            
            if hotkey_settings and hotkey_settings.hotkeys then
                local inventory_hotkey
                
                for hotkey, view_name in pairs(hotkey_settings.hotkeys) do
                    if view_name == "inventory_background_view" then
                        inventory_hotkey = hotkey
                        break
                    end
                end
                
                if inventory_hotkey then
                    hotkey_settings.hotkeys[inventory_hotkey] = nil
                    
                    local result = func(self)
                    
                    hotkey_settings.hotkeys[inventory_hotkey] = "inventory_background_view"
                    
                    return result
                end
            end
        end

        return func(self)
    end)
end)
