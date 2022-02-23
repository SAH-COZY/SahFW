Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(1)
    end
    TriggerServerEvent("SahFW:playerJoined")
end)