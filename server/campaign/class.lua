function InitCampaign(Data)
    self = {}
    self.CampaignID = Data.Id
    self.OwnerIdentifier = Data.OwnerIdentifier
    self.BaseMoney = Data.BaseMoney
    self.BaseUpgrades = Data.BaseUpgrades
    self.UnlockedParts = Data.UnlockedParts
    self.Outposts = Data.Outposts

    self._getOwnerIdentifier = function()
        return self.OwnerIdentifier
    end

    self._addBaseMoney = function(to_add)
        if to_add and type(to_add) == "integer" then
            self.BaseMoney = self.BaseMoney + to_add
        end
    end

    self._removeBaseMoney = function(to_remove)
        if to_remove and type(to_remove) == "integer" then
            self.BaseMoney = self.BaseMoney - to_remove
        end
    end

    self._setBaseUpgrade = function(key, value)
        if SharedFunc:GetTableSize(key) == 1 then
            self.BaseUpgrades[key[1]] = value
        elseif SharedFunc:GetTableSize(key) == 2 then
            self.BaseUpgrades[key[1]][key[2]] = value
        elseif SharedFunc:GetTableSize(key) == 3 then
            self.BaseUpgrades[key[1]][key[2]][key[3]] = value
        end
    end

    self._addUnlockedPart = function(part_id)
        if part_id and Map:IsValid(part_id) then
            table.insert(self.UnlockedParts, part_id)
        end
    end

    self._addOutpost = function(outpost_id)
        if outpost_id and Outposts:IsValid(outpost_id) then
            table.insert(self.Outposts, outpost_id)
        end
    end
end