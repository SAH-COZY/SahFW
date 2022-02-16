Citizen.CreateThread(function()
    exports.mongodb:find({ collection = "Items", query = {}}, function(success, result)
        if success then
            for k,v in pairs(result) do
                Item.List[v.name] = {
                    name = v.name, 
                    label = v.label, 
                    weight = v.weight,
                    action = nil
                }
            end
        else
            MongoDB.PrintError(result)
        end
    end)
end)