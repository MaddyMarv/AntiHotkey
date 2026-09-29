local mod = get_mod("AntiHotkey")
local dmf = get_mod("DMF")

--Put the mod file name here 
--Example: ["mod_name"] = true,
local whitelisted_mods = {
    ["DMF"] = true,
    ["AntiHotkey"] = true,
    ["your_mod_here?"] = true,
}

local _suppress_vanilla_inventory = true

local function _load_settings()
    local val = mod:get("suppress_vanilla_inventory")
    if val ~= nil then
        _suppress_vanilla_inventory = val
    end
end

mod.on_setting_changed = function(setting_id)
    if setting_id == "suppress_vanilla_inventory" then
        local val = mod:get(setting_id)
        if val ~= nil then
            _suppress_vanilla_inventory = val
        end
    end
end

local _orig_perform_keybind_action
local _perform_wrapped = false

local function _intercept_perform_keybind_action(data, is_pressed)
    if mod:is_enabled() and data and data.mod then
        local input_manager = Managers.input
        if input_manager and input_manager:cursor_active() then
            local mod_name = data.mod:get_name()
            if not whitelisted_mods[mod_name] then
                return false
            end
        end
    end
    return _orig_perform_keybind_action(data, is_pressed)
end

local function _wrap_keybind_action()
    if _perform_wrapped or not dmf then
        return
    end

    local check_fn = dmf.check_keybinds
    if not check_fn then
        return
    end

    local target_fn = check_fn
    while true do
        local found = false
        for i = 1, 10 do
            local name, val = debug.getupvalue(target_fn, i)
            if name == "orig" and type(val) == "function" then
                target_fn = val
                found = true
                break
            end
        end
        if not found then
            break
        end
    end

    for i = 1, 10 do
        local name, val = debug.getupvalue(target_fn, i)
        if name == "perform_keybind_action" and type(val) == "function" then
            _orig_perform_keybind_action = val
            debug.setupvalue(target_fn, i, _intercept_perform_keybind_action)
            _perform_wrapped = true
            break
        end
    end
end

_wrap_keybind_action()

mod.on_all_mods_loaded = function()
    _wrap_keybind_action()
end

mod.on_enabled = function()
    _load_settings()
    _wrap_keybind_action()
end

if dmf then
    mod:hook(dmf, "keybind_toggle_view", function(func, target_mod, view_name, transition_data, can_perform_action, is_pressed)
        local input_manager = Managers.input
        if mod:is_enabled() and input_manager and input_manager:cursor_active() then
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
        if mod:is_enabled() and _suppress_vanilla_inventory and input_manager and input_manager:cursor_active() then
            local hotkey_settings = self._update_hotkeys
            local hotkeys = hotkey_settings and hotkey_settings.hotkeys
            if hotkeys then
                local inventory_hotkey
                for hotkey, view_name in pairs(hotkeys) do
                    if view_name == "inventory_background_view" then
                        inventory_hotkey = hotkey
                        break
                    end
                end
                if inventory_hotkey then
                    hotkeys[inventory_hotkey] = nil
                    local result = func(self)
                    hotkeys[inventory_hotkey] = "inventory_background_view"
                    return result
                end
            end
        end
        return func(self)
    end)
end)

_load_settings()
