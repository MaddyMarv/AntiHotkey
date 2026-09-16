local mod = get_mod("anti_hotkey")
local dmf = get_mod("DMF")

--Put the mod file name here 
--Example: ["mod_name"] = true,
local whitelisted_mods = {
    ["DMF"] = true,
    ["anti_hotkey"] = true,
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
