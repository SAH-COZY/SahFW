Campaign = {}
Campaign.List = {}
setmetatable(Campaign, {})

function Campaign:Register(CampaignOwner_Id)
    local CampaignData = Campaign:DefaultValues()
    CampaignData.CampaignID, ValidCampaignId = Campaign:GenerateId()
    repeat 
        CampaignData.CampaignID, ValidCampaignId = Campaign:GenerateId()
    until ValidCampaignId == false
    CampaignData.OwnerIdentifier = Player:Identifier(CampaignOwner_Id)
    exports.mongodb:insertOne({collection = "CampaignsData", document = CampaignData }, function(success, result)
        if not success then
            Errors:CampaignRegisterFailed(CampaignOwner_Identifier, debug.getinfo(1, "n").name)
            DropPlayer(CampaignOwner_Id, "Something wrong append, try to reconnect later")
        end
    end)
    return CampaignData.Id
end

function Campaign:Load(Campaign_id)
    exports.mongodb:findOne({ collection = "CampaignsData", query = { CampaignID = Campaign_id } }, function (success, result)
        if success then
            local Campaign = result[1]
            Campaign:AddToList(result)
            local Player = Player:GetFromIdentifier(Campaign:OwnerIdentifier())
            Bucket:SetPlayerIn()
        else
            MongoDB:PrintError(result, debug.getinfo(1, "n").name)
        end
    end)
end

function Campaign:Get(CampaignID)
    if Campaign:Exists(CampaignID) then return Campaign.List[tostring(CampaignID)] else end
end

function Campaign:OwnerIdentifier(CampaignID)
    if CampaignID then
        local Campaign = Campaign:Get(CampaignID)
        return Campaign:_getOwnerIdentifier()
    end
end

function Campaign:AddToList(Data)
    if not Campaign.List[tostring(Data.CampaignID)] then
        Campaign.List[tostring(Data.CampaignID)] = InitCampaign(Data)
    end
end

function Campaign:DefaultValues()
    return {
        BaseUpgrades = {
            ["Style"] = "default", 
            ["Tier"] = "default",
            ["Security"] = "default",
            ["Details"] = {
                ["Office"] = {
                    ["office"] = false,
                    ["officeLocked"] = true
                },
                ["GunLocker"] = false,
                ["ShootingRange"] = {
                    ["RangeLights"] = false,
                    ["RangeWall"] = false,
                    ["RangeLocked"] = true
                },
                ["Schematics"] = false
            }
        },
        UnlockedParts = {},
        BaseMoney = 0,
        Outposts = {}
    }
end

function Campaign:Exists(Campaign_id)
    if Campaign.List[tostring(Campaign_id)] then
        return true
    else
        return false
    end
end

-- TriggerServerEvent("SahFW:OnAddBaseMoney", self.BaseMoney)

function Campaign:GenerateId()
    local function _gen()
        local gentedId = math.random(10000, 999999)
        return gentedId, Campaign:Exists(gentedId)
    end
    return _gen()
end