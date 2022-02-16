Campaign = {}
setmetatable(Campaign, {})

function Campaign:Register(CampainOwner_Identifier)
    local CampainData = Campaign:DefaultValues()
    CampainData.Id = Campaign:_GenerateId()
    CampainData.OwnerIdentifier = CampainOwner_Identifier
    return CampainData.Id
end

function Campaign:Load(Data)

end

function Campaign:DefaultValues()
    return {
        BaseUpgrades = {
            Style = "default", 
            Tier = "default",
            Security = "default",
            Details = {
                Office = {
                    office = false,
                    officeLocked = true
                },
                GunLocker = false,
                ShootingRange = {
                    RangeLights = false,
                    RangeWall = false,
                    RangeLocked = true
                },
                Schematics = false
            }
        },
        UnlockedParts = {},
        BaseMoney = 0,
        Outposts = {}
    }
end

function Campaign:_GenerateId()
    local function _gen()
        local gentedId = math.random(10000, 999999)
        exports.mongodb:findOne({ collection = "Campaigns", query = { CampaignID = gentedId } }, function(success, result)
            if success then
                if result ~= nil then
                    _gen()
                else
                    return gentedId
                end
            else
                MongoDB:PrintError(result)
            end
        end)
    end
end