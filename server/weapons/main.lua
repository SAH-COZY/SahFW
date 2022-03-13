Citizen.CreateThread(function()
    WeaponShared:SetData(Weapon:LoadList())
end)

RegisterCommand("admin:weaponsmanagement", function(src)
    if Player:IsAdmin(src) then
        TriggerClientEvent("SahFW:AdminWeaponManagement", src)
    end
end, false)