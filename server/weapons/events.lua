RegisterNetEvent("SahFW:AddWeaponToList")
AddEventHandler("SahFW:AddWeaponToList", function(weaponData)
    local _src = source
    if Player:IsAdmin(_src) then
        Weapon:AddData(weaponData)
    end
end)

RegisterNetEvent("SahFW:RequestWeaponsList")
AddEventHandler("SahFW:RequestWeaponsList", function()
    local _src = source
    TriggerClientEvent("SahFW:ReceiveWeaponsList", _src, Weapon.List)
end)

RegisterNetEvent("SahFW:PickupWeapon")
AddEventHandler("SahFW:PickupWeapon", function(weapon_data)
    local _src = source
    if weapon_data then
        DeleteEntity(weapon_data.handle)
        Player:AddWeapon(_src, weapon_data.weaponData.name, weapon_data.weaponData.ammo, true)
        Weapon.Pickups[weapon_data.id] = nil
    end
end)