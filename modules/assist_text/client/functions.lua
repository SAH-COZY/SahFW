AssistText = {}
setmetatable(AssistText, {})

function AssistText:Draw(key, msg)
    AssistText:_drawText(key, 0.35, {r = 0, g = 0, b = 0, a = 180}, false, 0.5, 0.7575)
    AssistText:_drawText(msg, 0.50, {r = 255, g = 255, b = 255, a = 255}, true, 0.5, 0.8)
    DrawSprite("buttons", "bg_key", 0.5, 0.77, (64/1920)/1.7, (64/1080)/1.7, 0.0, 255, 255, 255, 255)
end

function AssistText:_drawText(text, scale, rgba, shadow, x, y)
    SetTextFont(0)
    SetTextScale(scale, scale)
    SetTextColour(rgba.r or 255, rgba.g or 255, rgba.b or 255, rgba.a or 255)
    if shadow then
        SetTextDropShadow(0, 0, 0, 0,255)
    end
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(x, y)
end

Citizen.CreateThread(function()
    RequestStreamedTextureDict("buttons", true)
    while not HasStreamedTextureDictLoaded("buttons") do
        Wait(1)
    end
end)