RegisterNetEvent("SahFW:UpdatePlayerLoadout")
AddEventHandler("SahFW:UpdatePlayerLoadout", function(player_loadout)
    Player:SetLoadout(player_loadout)
end)

RegisterNetEvent("SahFW:AddWeaponPickup")
AddEventHandler("SahFW:AddWeaponPickup", function(weapon_data)
    local _src = source
    Weapon:AddPickup(weapon_data)
end)

RegisterNetEvent("SahFW:PlayerLoaded")
AddEventHandler("SahFW:PlayerLoaded", function(PlayerData)
    local model = GetHashKey("mp_m_freemode_01")
    if GetEntityModel(GetPlayerPed(-1)) ~= model then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end

        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(GetPlayerPed(-1))
    end
    SetModelAsNoLongerNeeded(model)
    Player:SetLoadout(PlayerData.Loadout)
    Player:Loaded()
end)