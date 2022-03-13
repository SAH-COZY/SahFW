Bucket = {}
Bucket.List = {}
setmetatable(Bucket, {})

function Bucket:Create(BucketID, BucketOwner)
    if BucketID and not Bucket:Exists(BucketID) then
        self.List[tostring(BucketID)] = InitBucket(BucketOwner)
        -- SetRoutingBucketEntityLockdownMode(BucketID, "strict")
        -- SetRoutingBucketPopulationEnabled(BucketID, false)
        local Player = Player:GetFromIdentifier(BucketOwner)
        Bucket:Set(Player:_getID(), BucketID)
    end
end

function Bucket:Set(PlayerID, BucketID)
    if PlayerID and BucketID then
        SetPlayerRoutingBucket(PlayerID, BucketID)
    end
end

function Bucket:Get(BucketID)
    if BucketID then
        if self.List[tostring(BucketID)] then
            return self.List[tostring(BucketID)]
        end
    end
end

function Bucket:ListPlayers(BucketID)
    if BucketID then
        local TheBucket = self.List[tostring(BucketID)]
        return {
            TheBucket.BucketOwner, 
            TheBucket.CoPartner
        }
    end
end

function Bucket:Exists(BucketID)
    if BucketID then 
        if Bucket.List[tostring(BucketID)] then 
            return true 
        else
            return false
        end
    end
end

RegisterCommand("debug:selfbucket", function(src)
    local _src = src
    print(GetPlayerRoutingBucket(_src))
end)