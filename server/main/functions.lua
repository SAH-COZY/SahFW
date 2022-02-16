Main = {}
Main = setmetatable(Main, {})

function Main:PlayerJoined()
    exports.mongodb:findOne({ collection = "Players", query = { Identifier = identifier } }, function (success, result)
        if success then
            if SharedFunc:GetTableSize(result) < 1 then
                result = nil
                result = Player:Register(identifier)
                while not result do
                    Wait(1)
                end
                Player:Load(src, result)
            else
                Player:Load(src, result[1])
            end
        else
            MongoDB:PrintError(result)
        end
    end)
end