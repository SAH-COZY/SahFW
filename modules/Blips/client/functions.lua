Blip = {}
Blip.List = {}
setmetatable(Blip, {})

function Blip:Get(SrvBlipID)
    local BlipExist, identifier = Blip:Exists(SrvBlipID)
    if BlipExist then
        return identifier
    end
end

function Blip:Exists(SrvBlipID)
    if self.List[SrvBlipID] then
        return true, self.List[SrvBlipID]
    end
    return false, nil
end

function Blip:SetColor(SrvBlipID, color)
    if self.List[SrvBlipID] then
        SetBlipColour(Blip:Get(SrvBlipID), color)
    end
end

-- function Blip:Create(id, xyz, sprite, display, scale, color, as_short_range, blip_name)
--     if id and xyz and sprite and display and scale and color and as_short_range and blip_name then
--         blip = AddBlipForCoord(table.unpack(xyz))
--         SetBlipSprite(blip, tonumber(sprite))
--         SetBlipDisplay(blip, tonumber(display))
--         SetBlipScale(blip, tonumber(scale))
--         SetBlipColour(blip, tonumber(color))
--         SetBlipAsShortRange(blip, as_short_range)
--         BeginTextCommandSetBlipName("STRING")
--         AddTextComponentString(tostring(blip_name))
--         EndTextCommandSetBlipName(blip)
--         self.List[tostring(id)] = blip
--         blip = nil
--     end
-- end

-- RegisterCommand("devtools:createblip", function(src, args)
--     if args[1] and args[2] and args[3] and args[4] and args[5] and args[6] and args[7] and args[8] and args[9] and args[10] then
--         Blip:Create(args[1],{tonumber(args[2]),tonumber(args[3]),tonumber(args[4])},args[5],args[6],args[7],args[8],args[9],args[10])
--     end
-- end, false)