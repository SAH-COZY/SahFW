Player = {}
setmetatable(Player, {})

function Player:Register(ID)
    local Identifier = Player:Identifier(ID)
    local Data = Player:DefaultValues()
    Data.Identifier = Identifier
    Data.CampaignId = Campaign:Register(Identifier)
    Data.Name = GetPlayerName(ID)
    return Data
end

function Player:Get(ID)
    if Players:GetList()[ID] then return Players:GetOne(ID) else Errors:PlayerIdNotValid(ID, debug.getinfo(1, "n").name) end
end

function Player:Load(Data)
    local self = {}
    self.Identifier = Data.Identifier
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
        if to_remove then
            self.Level = self.Level+to_remove
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
            
        end
    end
end

function Player:Join(ID)

end

function Player:Identifier(ID)
    if ID then
        for k,v in pairs(GetPlayerIdentifiers(playerid)) do
            if string.sub(v, 1, string.len("license:")) == "license:" then
                return v
            end
        end
    else
        Errors:MissingArg(ID, debug.getinfo(1, "n").name)
    end
end

function Player:DefaultValues()
    return {
        Level = 0,
        Group = "user",
        Money = SharedValues.DefaultPlayerMoney,
        Inventory = {},
        Loadout = {},
        Position = {},
        OwnedVehicles = {},
        Companions = {}
    }
end