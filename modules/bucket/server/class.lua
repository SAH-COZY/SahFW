function InitBucket(BucketOwner, BucketID)
    self = {}
    self.BucketOwner = BucketOwner
    self.BucketID = BucketID
    self.Co_Partners = {}
    self.WaitingList = {}

    self._invitePlayer = function(playerID, customMsg)
        if playerID then
            self.WaitingList[tostring(playerID)] = true
            SetTimeout(60000, function()
                if self.WaitingList[tostring(playerID)] then
                    self.WaitingList[tostring(playerID)] = nil
                    TriggerClientEvent("SahFW:RefusedCoopInvite", )
                end
            end)
            local Owner = Player:GetFromIdentifier(self.BucketOwner)
            local Player = Player:Get(playerID)
            Player:_receiveCoopRequest(Owner:ID(), customMsg)
        end
    end
end