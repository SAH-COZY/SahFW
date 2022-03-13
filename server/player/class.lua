function InitPlayer(Data)
    local self = {}
    self.Identifier = Data.Identifier
    self.Id = Data.Id
    self.CampaignID = Data.CampaignID
    self.Name = Data.Name
    self.Level = Data.Level
    self.Group = Data.Group
    self.Money = Data.Money
    self.Skin = Data.Skin
    self.Inventory = Data.Inventory
    self.Loadout = Data.Loadout
    self.Position = Data.Position
    self.OwnedVehicles = Data.OwnedVehicles
    self.Weight = 0
    self.Companions = Data.Companions
    self.UnlockedOutfits = Data.UnlockedOutfits

    self._returnPlayerData = function()
        local data = {
            CampaignID = self.CampaignID,
            Name = self.Name,
            Level = self.Level,
            Group = self.Group,
            Money = self.Money,
            Skin = self.Skin,
            Inventory = self.Inventory,
            Loadout = self.Loadout,
            Loadout = self.Position,
            OwnedVehicles = self.OwnedVehicles,
            Weight = self.Weight,
            Companions = self.Companions,
            UnlockedOutfits = self.UnlockedOutfits,
        }
        return data
    end

    self._changeName = function(new_name)
        if new_name then
            self.Name = new_name
        end
    end

    self._addXP = function(to_add)
        if to_add then
            self.Level = self.Level+to_add
        end        
    end

    self._removeXP = function(to_remove)
        if to_remove and self.Level - to_remove >= 0 then
            self.Level = self.Level-to_remove
        end
    end

    self._changeGroup = function(new_group)
        if new_group then
            self.Group = new_group
        end
    end

    self._addMoney = function(to_add)
        if to_add then
            self.Money = self.Money+to_add
        end
    end

    self._removeMoney = function(to_remove)
        if to_remove then
            self.Money = self.Money-to_remove
        end
    end

    self._setSkin = function(skin_vals)
        if skin_vals then
            self.Skin = skin_vals
        end
    end

    self._getInventory = function()
        return self.Inventory
    end

    self._getLoadout = function()
        return self.Loadout
    end

    self._initLoadout = function()
        for k,v in pairs(self.Loadout) do
            GiveWeaponToPed(GetPlayerPed(self.Id), v.hash, v.ammo, false, (k == "Primary"))
            if SharedFunc:GetTableSize(v.components) > 0 then
                for k2,v2 in pairs(v.components) do
                    GiveWeaponComponentToPed(GetPlayerPed(self.Id), v.hash, v2.value)
                end
            end
        end
        TriggerClientEvent("SahFW:UpdatePlayerLoadout", self.Id, self.Loadout)
    end

    self._addWeapon = function(weapon, ammo, equipnow)
        if weapon and WeaponShared:Valid(weapon) and ammo and equipnow then
            if not self.Loadout[WeaponShared:GetPlacement(weapon)] then
                self.Loadout[WeaponShared:GetPlacement(weapon)] = {hash = WeaponShared:Hash(weapon), label = WeaponShared:Label(weapon), name = WeaponShared:Name(weapon), ammo = ammo, components = {}}
            else
                RemoveAllPedWeapons(GetPlayerPed(self.Id))
                Weapon:CreatePickup(self.Id, GetEntityCoords(GetPlayerPed(self.Id)), self.Loadout[WeaponShared:GetPlacement(weapon)])
                self.Loadout[WeaponShared:GetPlacement(weapon)] = {hash = WeaponShared:Hash(weapon), label = WeaponShared:Label(weapon), name = WeaponShared:Name(weapon), ammo = ammo, components = {}}
            end
            for k,v in pairs(self.Loadout) do
                local equip = false
                if v.name == weapon then equip = true end
                GiveWeaponToPed(GetPlayerPed(self.Id), v.name, v.ammo, false, equip)
                for k2,v2 in pairs(v.components) do
                    GiveWeaponComponentToPed(GetPlayerPed(self.Id), v.hash, v2.hash)
                end
            end
            TriggerClientEvent("SahFW:UpdatePlayerLoadout", self.Id, self.Loadout)
        end
    end

    self._removeWeapon = function(weapon, drop)
        local cache = {}
        if weapon and WeaponShared:Valid(weapon) then
            if self.Loadout[WeaponShared:GetPlacement(weapon)][weapon] then
                cache.weaponData = self.Loadout[WeaponShared:GetPlacement(weapon)][weapon]
                self.Loadout[WeaponShared:GetPlacement(weapon)] = nil
                if drop then
                    WeaponShared:DropWeapon(GetEntityCoords(GetPlayerPed(self.Id)), cache.weaponData)
                end
            end
            TriggerClientEvent("SahFW:UpdatePlayerLoadout", self.Id, self.Loadout)
        end
    end

    self._addWeaponComponent = function(weapon, component)
        if weapon and WeaponShared:Valid(weapon) and component then
            local ValidComponent, ComponentData = WeaponShared:GetComponent(weapon, component)
            if ValidComponent then
                if not self.Loadout[WeaponShared:GetPlacement(weapon)].components[ComponentData.category] then
                    print('there is no component on this part')
                    self.Loadout[WeaponShared:GetPlacement(weapon)].components[ComponentData.category] = ComponentData
                else
                    print('there is a component on this part')
                    -- Weapon:DropComponent(GetEntityCoords(GetPlayerPed(self.Id)), self.Loadout[Weapon:GetPlacement(weapon)].components[ComponentData.category])
                    self.Loadout[WeaponShared:GetPlacement(weapon)].components[ComponentData.category] = ComponentData
                end
                GiveWeaponComponentToPed(GetPlayerPed(self.Id), WeaponShared:Hash(weapon), ComponentData.hash)
            end
            TriggerClientEvent("SahFW:UpdatePlayerLoadout", self.Id, self.Loadout)
        end
    end

    self._addInventoryItem = function(item, count)
        if Item:Exists(item) then
            if self.Inventory[item] then
                self.Inventory[item].count = self.Inventory[item].count+count
            else
                self.Inventory[item] = {name = item, label = Item:Get(item).label, count = count}
            end
        end
    end

    self._removeInventoryItem = function(item, count)
        if Item:Exists(item) then
            if self.Inventory[item].count - count <= 0 then
                self.Inventory[item] = nil
            else
                self.Inventory[item].count = self.Inventory[item].count - count 
            end
        end
    end

    self._setWeight = function(weight)
        if weight then
            self.Weight = weight
        end
    end

    self._getWeight = function()
        return self.Weight
    end

    self._unlockOutfit = function(outfit_name)
        if outfit_name and Outfit:Exists(outfit_name) then
            table.insert(self.UnlockedOutfit, outfit_name)
        end
    end

    self._addOwnedVehicle = function(vehicle_model, vehicle_data)
        if vehicle_model and vehicle_data and not self.OwnedVehicles[GetHashKey(vehicle_model)] then
            self.OwnedVehicles[GetHashKey(vehicle_model)] = vehicle_data
        end
    end

    self._removeOwnedVehicle = function(vehicle_model)
        if vehicle_model and self.OwnedVehicles[GetHashKey(vehicle_model)] then
            self.OwnedVehicles[GetHashKey(vehicle_model)] = nil
        end
    end

    self._getID = function()
        return self.Id
    end

    self._receiveCoopRequest = function(fromID, customMsg)
        if fromID then
            self._triggerEvent("SahFW:ReceiveCoopRequest", fromID, customMsg or string.format("Hi %s, it's %s. Come play with me !", GetPlayerName(self.Id), GetPlayerName(fromID)))
        end
    end

    self._triggerEvent = function(eventname, ...)
        if eventname then
            TriggerClientEvent(eventname, self.Id, ...)
        end
    end

    self._setModel = function(model)
        if model then
            model = GetHashKey(model)
            SetPlayerModel(GetPlayerFromServerId(self.Id), model)
        end
    end

    self._save = function()
        exports.mongodb:updateOne({ collection="Players", query = { Identifier = self.Identifier }, update = { ["$set"] = { Name = self.Name,  Level = self.Level, Group = self.Group, Money = self.Money, Skin = self.Skin, Inventory = self.Inventory, Loadout = self.Loadout, Position = self.Position, OwnedVehicles = self.OwnedVehicles, Companions = self.Companions} } }, function(success)
            if not success then
                Errors:FailedPlayerSave({self.Identifier, self.Name}, debug.getinfo(1, "n").name)
            end
        end)
    end

    if SharedFunc:GetTableSize(self._getInventory()) > 0 then
        self._setWeight(Inventory:TotalWeight(self._getInventory()))
    end

    return self
end