Keys = {}
Keys.RegisterList = {}
setmetatable(Keys, {})

function Keys:Register(act_name, k_control, action, desc)
    RegisterCommand("+"..act_name, action, false)
    RegisterCommand("-"..act_name, function() end, false)
    if type(k_control) == "table" then
        RegisterKeyMapping('+'..act_name, desc, k_control.controlType, k_control.control)
        print("^2[KEYS SYSTEM]^7 Registered control "..k_control.control.." to "..desc)
    else
        RegisterKeyMapping('+'..act_name, desc, 'KEYBOARD', k_control)
        print("^2[KEYS SYSTEM]^7 Registered control "..k_control.." to "..desc)
    end
    table.insert(self.RegisterList, {action_name = act_name, keyboard_input = k_control, description = desc})
    print(json.encode(self.RegisterList))
end

function Keys:Exist(k_control)
    for k,v in pairs(self.RegisterList) do
        if v.keyboard_input == k_control then
            return true
        end
    end
    return false
end
