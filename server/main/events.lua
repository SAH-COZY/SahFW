RegisterNetEvent('SahFW:playerJoined')
AddEventHandler('SahFW:playerJoined', function()
    local _src = source
    if not Players:GetList()[_src] then
        Player:Joined(_src)
    end
end)