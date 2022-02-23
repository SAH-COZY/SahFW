Citizen.CreateThread(function()
    while true do
        Wait(300000)
        for k,v in pairs(Players:GetList()) do
            local Player = Player:Get(tostring(v.Id))
            Player:_save()
        end
        print("^2[FRAMEWORK] Players successfully saved^7") 
    end
end)