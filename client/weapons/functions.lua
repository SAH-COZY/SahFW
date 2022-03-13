Weapon = {}
Weapon.Pickups = {}
Weapon.PickupClose = false
Weapon.PickupCloseInfos = {}
setmetatable(Weapon, {})

function Weapon:AddPickup(weapon_data)
    local playerPos = GetEntityCoords(GetPlayerPed(-1))
    local forwardPlayerPos = (GetEntityForwardVector(GetPlayerPed(-1))*3.5)
    local obj = CreateWeaponObject(weapon_data.weaponData.hash, 0, playerPos.x, playerPos.y, playerPos.z, true, 1.3, 0)
    for k2, v2 in pairs(weapon_data.weaponData.components) do
        GiveWeaponComponentToWeaponObject(obj, v2.hash)
    end
    SetEntityRotation(obj, 90.0, 0.0, 0.0, 0.0, true)
    ApplyForceToEntity(obj, 3, forwardPlayerPos.x, forwardPlayerPos.y, 2.5, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
    Wait(1100)
    FreezeEntityPosition(obj, true)
    weapon_data.handler = obj
    weapon_data.coords = GetEntityCoords(obj)
    self.Pickups[weapon_data.id] = weapon_data
end

function Weapon:ClosestPickups()
    for k,v in pairs(self.Pickups) do
        local plyPed = GetPlayerPed(-1)
        local PedCoords = GetEntityCoords(plyPed)
        local dist = GetDistanceBetweenCoords(PedCoords, v.coords, true)
        if dist > 1.3 then
            self.PickupClose = false
            self.PickupCloseInfos = {}
        end
        if dist <= 1.3 then
            if SharedFunc:GetTableSize(v.weaponData.components) < 1 then
                InteractionText:Draw("E", v.weaponData.label.." (without attachments)")
            else
                InteractionText:Draw("E", v.weaponData.label.." (with attachments)")
            end
            self.PickupClose = true
            self.PickupCloseInfos = v
        end
    end
end

function Weapon:RemovePickup(weapon_data)
    if SharedFunc:GetTableSize(weapon_data) then
        for k,v in pairs(self.Pickups) do
            if v.weaponData.hash == weapon_data.weaponData.hash then
                table.remove(self.Pickups, i)
            end
        end
    end
end

function Weapon:PickupWeaponOnGround(weapon_data)
    if self.PickupClose then
        if SharedFunc:GetTableSize(weapon_data) then
            Weapon:RemovePickup(weapon_data)
            TriggerServerEvent("SahFW:PickupWeapon", weapon_data)
        end
    else
        print("no weapon on the ground")
    end
end



