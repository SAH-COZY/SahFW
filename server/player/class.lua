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