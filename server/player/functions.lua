Player = {}
setmetatable(Player, {})

function Player:Joined(ID)
    local identifier = Player:Identifier(ID)
    exports.mongodb:findOne({ collection = "Players", query = { Identifier = identifier } }, function (success, result)
        if success then
            if SharedFunc:GetTableSize(result) < 1 then
                result = nil
                result = Player:Register(ID)
                while not result do
                    Wait(1)
                end
                Player:Load(result)
            else
                result[1].Id = ID
                Player:Load(result[1])
            end
        else
            MongoDB:PrintError(result, debug.getinfo(1, "n").name)
        end
    end)
end

function Player:IsAdmin(ID)
    if ID then
        for k,v in pairs(AdminsList) do
            if v == Player:Identifier(ID) then
                return true
            end
        end
        return false
    end
end

function Player:Register(ID)
    local identifier = Player:Identifier(ID)
    local Data = Player:DefaultValues()
    Data.Identifier, Data.CampaignID, Data.Name, Data.Id = identifier, Campaign:Register(ID), GetPlayerName(ID), ID
    exports.mongodb:insertOne({ collection="Players", document = { Identifier = Data.Identifier, CampaignID = Data.CampaignID, Name = Data.Name, Level = Data.Level, Group = Data.Group, Money = Data.Money, Skin = Data.Skin, Inventory = Data.Inventory, Loadout = Data.Loadout, Position = Data.Position, OwnedVehicles = Data.OwnedVehicles, UnlockedOutfits = Data.UnlockedOutfits, Companions = Data.Companions} }, function(success)
        if not success then
            DropPlayer(Data.Id, "Something strange append. Try to reconnect later")
        end
    end)

    return Data
end

function Player:Get(ID)
    local ID = tostring(ID)
    if Players:GetList()[ID] then 
        return Players:GetList()[ID]
    else 
        Errors:PlayerIdNotValid(ID, debug.getinfo(1, "n").name) 
    end
end

function Player:GetIDFromIdentifier(Identifier)
    for k,v in pairs(Players:GetList()) do
        if v.Identifier == Identifier then
            return v.Id
        end
    end
end

function Player:GetFromIdentifier(Identifier)
    for k,v in pairs(Players:GetList()) do
        if v.Identifier == Identifier then
            return v
        end
    end
    Errors:PlayerIdentifierNotValid(Identifier, debug.getinfo(1, "n").name)
end

function Player:GiveLoadout(ID)
    if ID then
        local ThePlayer = Player:Get(ID)
        ThePlayer.initLoadout()
    end
end

function Player:Load(Data)
    local PlayerData = InitPlayer(Data)
    Players:AddPlayerToList(PlayerData)
    PlayerData._initLoadout()
    Campaign:Load(PlayerData.CampaignID, PlayerData.Id)
    TriggerClientEvent("SahFW:PlayerLoaded", PlayerData.Id, PlayerData)
end

function Player:TriggerEvent(ID, event, ...)
    if ID and event then
        local ThePlayer = Player:Get(ID)
        ThePlayer._triggerEvent(event, ...)
    end
end

function Player:ReturnPlayerData(ID)
    if ID then
        local ThePlayer = Player:Get(ID)
        return ThePlayer._getID()
    end
end

function Player:Message(toid, from, message)
    local ThePlayer = Player:Get(toid)
    ThePlayer._triggerEvent("SahFW:SendMessage", from, message)
end

function Player:Identifier(ID)
    if ID then
        for k,v in pairs(GetPlayerIdentifiers(ID)) do
            if string.sub(v, 1, string.len("license:")) == "license:" then
                return v
            end
        end
    else
        Errors:MissingArg(ID, debug.getinfo(1, "n").name)
    end
end

function Player:ID(ID)
    if ID then
        local ThePlayer = Player:Get(ID)
        return ThePlayer._getID()
    end
end

function Player:SetName(ID, new_name)
    if new_name and type(new_name) == "string" then
        local ThePlayer = Player:Get(ID)
        ThePlayer._changeName(new_name)
    end
end

function Player:Name(ID)
    if ID then
        local ThePlayer = Player:Get(ID)
        return Player.Name
    end
end

function Player:Inventory(ID)
    if ID then
        local ThePlayer = Player:Get(ID)
        return Player.Inventory
    end
end

function Player:AddWeapon(ID, weapon, ammo, equipNow)
    local ThePlayer = Player:Get(ID)
    ThePlayer._addWeapon(weapon, ammo, equipNow)
end

function Player:AddWeaponComponent(ID, weapon, component)
    local ThePlayer = Player:Get(ID)
    ThePlayer._addWeaponComponent(weapon, component)
end

function Player:AddInventoryItem(ID, item, count)
    if ID and item and count then
        local ThePlayer = Player:Get(ID)
        ThePlayer._addInventoryItem(item, count)
        return Player:Inventory(ID)
    end
end

function Player:RemoveInventoryItem(ID, item, count)
    if ID and item and count then
        local ThePlayer = Player:Get(ID)
        ThePlayer._removeInventoryItem(item, count)
        return Player:Inventory(ID)
    end
end

function Player:CampaignID(ID)
    if ID then
        local ThePlayer = Player:Get(ID)
        return Player.CampaignID
    end
end

function Player:Level(ID)
    if ID then
        local ThePlayer = Player:Get(ID)
        return Player.Level
    end
end

function Player:AddXP(ID, ToAdd)
    if ID and ToAdd then
        local ThePlayer = Player:Get(ID)
        ThePlayer._addXP(ToAdd)
        return Player:Level(ID)
    end
end

function Player:RemoveXP(ID, ToRemove)
    if ID and ToAdd then
        local ThePlayer = Player:Get(ID)
        ThePlayer._removeXP(ToRemove)
        return Player:Level(ID)
    end
end

function Player:Money(ID)
    if ID then 
        local ThePlayer = Player:Get(ID)
        return Player.Money
    end
end

function Player:AddMoney(ID, ToAdd)
    if ID then 
        local ThePlayer = Player:Get(ID)
        Player._addMoney(ToAdd)
        return Player.Money
    end
end

function Player:RemoveMoney(ID, ToRemove)
    if ID then 
        local ThePlayer = Player:Get(ID)
        Player._removeMoney(ToRemove)
        return Player.Money
    end
end

function Player:SetSkin(ID, SkinTable)
    if ID and SkinTable then
        local ThePlayer = Player:Get(ID)
        ThePlayer._setSkin(SkinTable)
    end
end

function Player:SetModel(ID, model)
    if ID and model then
        local ThePlayer = Player:Get(ID)
        ThePlayer._setModel(model)
    end
end

function Player:LastPosition(ID)
    if ID then
        local ThePlayer = Player:Get(ID)
        return Player.Position
    end
end

function Player:AddOwnedVehicle(ID, vehicle_model, vehicle_data)
    if ID and vehicle_model and Vehicle:Exists(vehicle_model) and Vehicle:InShop(vehicle_model) then
        local ThePlayer = Player:Get(ID)
        ThePlayer._addOwnedVehicle(vehicle_model, vehicle_data)
    end
end

function Player:RemoveOwnedVehicle(ID, vehicle_model)
    if ID and vehicle_model and Vehicle:Exists(vehicle_model) and Vehicle:InShop(vehicle_model) then
        local ThePlayer = Player:Get(ID)
        ThePlayer._removeOwnedVehicle(vehicle_model)
    end
end

function Player:UnlockedOutfit(ID, outfit_name)
    if ID and outfit_name then
        local ThePlayer = Player:Get(ID)
        ThePlayer._unlockOutfit(outfit_name)
        return Player.UnlockedOutfits
    end
end

function Player:AddCompanion(ID, comp_name)
    if ID and comp_name and Companion:Exists(comp_name) then
        table.insert(self.Companions, comp_name)
    end
end

function Player:DefaultValues()
    return {
        Level = 0,
        Group = "user",
        Money = SharedValues.DefaultPlayerMoney,
        Skin = {},
        Inventory = {},
        Loadout = {},
        Position = {},
        OwnedVehicles = {},
        UnlockedOutfits = {},
        Companions = {},
    }
end

RegisterCommand("pl", function(src)
    print(Player:IsAdmin(src))
end, false)