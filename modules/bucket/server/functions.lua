Bucket = {}
Bucket.List = {}
setmetatable(Bucket, {})

function Bucket:Create(BucketID, BucketOwner)
    if BucketID and not Bucket:Exists(BucketID) then
        Bucket.List[tostring(BucketID)] = InitBucket(BucketOwner)
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