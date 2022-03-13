InteractionPoints = {
    ["BaseEnterInteractionPoint"] = {
        Show = true,
        Coords = vector3(1571.852, 2235.708, 78.14475),
        UseZ = true,
        MaxDist = 3.0,
        Action = function(dist)
            InteractionText:Draw("E", "Enter in bunker")
            if IsControlJustReleased(0, 38) then
                TaskPedSlideToCoord(GetPlayerPed(-1), 1571.864, 2240.178, 78.2234, 0.335267931, 1200)
                Wait(1000)
                DoScreenFadeOut(500)
                Wait(2500)
                SetEntityCoords(GetPlayerPed(-1), 896.3665, -3245.816, -98.24342)
                SetEntityHeading(GetPlayerPed(-1), 96.6618041)
                DoScreenFadeIn(1500)
                TaskPedSlideToCoord(GetPlayerPed(-1), 892.6384, -3245.8664, -98.2645, 96.6618041, 1200)
            end
        end
    },
    ["BaseExitInteractionPoint"] = {
        Show = true,
        Coords = vector3(892.6384, -3245.8664, -98.2645),
        UseZ = true,
        MaxDist = 3.0,
        Action = function(dist)
            InteractionText:Draw("E", "Exit the bunker")
            if IsControlJustReleased(0, 38) then
                TaskPedSlideToCoord(GetPlayerPed(-1), 896.3665, -3245.816, -98.24342, 269.160614, 1200)
                Wait(1000)
                DoScreenFadeOut(500)
                Wait(2500)
                SetEntityCoords(GetPlayerPed(-1), 1571.831, 2238.184, 79.24434)
                SetEntityHeading(GetPlayerPed(-1), 181.98670959473)
                DoScreenFadeIn(1750)
                TaskPedSlideToCoord(GetPlayerPed(-1), 1572.016, 2234.556, 79.07252, 181.98674, 1200)
            end
        end
    }
}

Citizen.CreateThread(function()
    local interval = 0
    while true do
        interval = 300
        for k,v in pairs(InteractionPoints) do
            if v.Show then
                local playerPed = GetPlayerPed(-1)
                local dist = GetDistanceBetweenCoords(GetEntityCoords(playerPed), v.Coords, v.UseZ)
                if dist <= v.MaxDist then
                    interval = 1
                    v.Action(dist)
                end
            end
        end
        Wait(interval)
    end
end)