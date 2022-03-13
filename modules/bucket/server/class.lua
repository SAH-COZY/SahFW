function InitBucket(BucketOwner, BucketID)
    self = {}
    self.BucketOwner = BucketOwner
    self.BucketID = BucketID
    self.CoPartner = nil
    self.WaitingList = nil

    self._invitePlayer = function(playerID, customMsg)
        if playerID then
            local Owner = Player:GetFromIdentifier(self.BucketOwner)
            self.WaitingList[tostring(playerID)] = true
            local Player = Player:Get(playerID)
            Player:_receiveCoopRequest(Owner:ID(), customMsg)
            SetTimeout(60000, function()
                if self.WaitingList[tostring(playerID)] then
                    self.WaitingList[tostring(playerID)] = nil
                    Owner:_triggerEvent("SahFW:RefusedCoopInvite")
                end
            end)
        end
    end

    self._acceptInvite = function(playerID)
        if playerID and self.WaitingList[tostring(playerID)] then
            table.insert(self.Co_Partners, playerID)
            local Owner = Player:GetFromIdentifier(self.BucketOwner)
            Owner:_triggerEvent("SahFW:AcceptedCoopInvite")
            local Player = Player:Get(playerID)
            Bucket:Set(playerID, self.BucketID)
        end
    end

    self._copartnerQuit = function(playerID, set_player_to_default_bucket)
        for i,v in ipairs(self.Co_Partners) do
            if v == playerID then
                table.remove(self.Co_Partners, i)
            end
        end
        if set_player_to_default_bucket then
            local Player = Player:Get(playerID)
            Bucket:Set(playerID, Player:CampaignID())
        end
    end

    return self
end