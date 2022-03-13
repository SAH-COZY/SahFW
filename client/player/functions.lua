Player = {}
Player.Loadout = {}
Player.LoadoutCatList = {"Primary", "Secondary", "Melee", "Throwable"}
Player.LoadoutCatListIndex = 1
setmetatable(Player, {})

function Player:WeaponChangeListener()
    if GetSelectedPedWeapon(GetPlayerPed(-1)) ~= self.Loadout[self.LoadoutCatList[self.LoadoutCatListIndex]].hash then
        GiveWeaponToPed(GetPlayerPed(-1), self.Loadout[self.LoadoutCatList[self.LoadoutCatListIndex]].hash, self.Loadout[self.LoadoutCatList[self.LoadoutCatListIndex]].ammo, false, true)
        for k,v in pairs(self.Loadout[self.LoadoutCatList[self.LoadoutCatListIndex]].components) do
            GiveWeaponComponentToPed(GetPlayerPed(-1), self.Loadout[self.LoadoutCatList[self.LoadoutCatListIndex]].hash, v.hash)
        end
    end
end

function Player:SelectPrimaryWeapon()
    if self.Loadout[self.LoadoutCatList[1]] then
        self.LoadoutCatListIndex = 1
    end
end

function Player:SelectSecondaryWeapon()
    if self.Loadout[self.LoadoutCatList[2]] then
        self.LoadoutCatListIndex = 2
    end
end

function Player:SelectMeleeWeapon()
    if self.Loadout[self.LoadoutCatList[3]] then
        self.LoadoutCatListIndex = 3
    end
end

function Player:SelectNextWeapon()
    if not IsAimCamActive() then
        if self.Loadout[self.LoadoutCatList[self.LoadoutCatListIndex-1]] then
            self.LoadoutCatListIndex = self.LoadoutCatListIndex-1
        else
            for i = 1, #self.LoadoutCatList do
                if self.Loadout[self.LoadoutCatList[i]] then
                    if self.LoadoutCatListIndex - i < 1 then
                        self.LoadoutCatListIndex = SharedFunc:GetTableSize(self.Loadout)
                    else
                        self.LoadoutCatListIndex = self.LoadoutCatListIndex - i
                    end
                end
            end
        end
    end
end

function Player:SelectPreviousWeapon()
    if not IsAimCamActive() then
        if self.Loadout[self.LoadoutCatList[self.LoadoutCatListIndex+1]] then
            self.LoadoutCatListIndex = self.LoadoutCatListIndex+1
        else
            for i = 1, #self.LoadoutCatList do
                if self.Loadout[self.LoadoutCatList[i]] then
                    if self.LoadoutCatListIndex + i > SharedFunc:GetTableSize(self.Loadout) then
                        self.LoadoutCatListIndex = 1
                    else
                        self.LoadoutCatListIndex = self.LoadoutCatListIndex + i
                    end
                end
            end
        end
    end
    
end

function Player:SetLoadout(player_loadout)
    for k,v in pairs(player_loadout) do
        if player_loadout[k] then
            self.Loadout[k] = player_loadout[k]
        else
            self.Loadout[k] = nil
        end
    end
end

function Player:Loaded()
    Keys:Register("go_primary_weapon", "1", function()
        Player:SelectPrimaryWeapon()
    end, "Select primary weapon")

    Keys:Register("go_secondary_weapon", "2", function()
        Player:SelectSecondaryWeapon()
    end, "Select secondary weapon")

    Keys:Register("go_melee_weapon", "3", function()
        Player:SelectMeleeWeapon()
    end, "Select melee weapon")

    Keys:Register("go_next_weapon", {controlType = "MOUSE_WHEEL", control = "IOM_WHEEL_DOWN"}, function()
        Player:SelectNextWeapon()
    end, "Select next weapon")
    
    Keys:Register("go_previous_weapon", {controlType = "MOUSE_WHEEL", control = "IOM_WHEEL_UP"}, function()
        Player:SelectPreviousWeapon()
    end, "Select previous weapon")

    Keys:Register("pickup_weapon_on_ground", "E", function()
        Weapon:PickupWeaponOnGround(Weapon.PickupCloseInfos)
    end, "Pick up weapon on the ground")

    SetRunSprintMultiplierForPlayer(PlayerPedId(), 1.5)

    Citizen.CreateThread(function()
        while true do
            -- _DisableControls()
            -- DisableControlAction(2, 198, true)
            HudWeaponWheelIgnoreSelection()

            -- SetFollowPedCamViewMode(4)
            Player:WeaponChangeListener()

            Weapon:ClosestPickups()
            Wait(0)
        end
    end)
end