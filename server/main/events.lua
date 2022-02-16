RegisterNetEvent('SahFW:playerJoined')
AddEventHandler('SahFW:playerJoined', function()
    local _src = source
    if not Main:List()[_src] then
        Player:Joined(_src)
    end
end)