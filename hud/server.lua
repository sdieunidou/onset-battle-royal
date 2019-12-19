-- https://github.com/frederic2ec/onsetrp

function getHudData(player)
    CallRemoteEvent(player, "updateHud", hunger, thirst, cash, bank, healthlife, vehiclefuel)
end
AddRemoteEvent("getHudData", getHudData)

function SetHUDMarker(player, name, heading, r, g, b)
    CallRemoteEvent(player, "SetHUDMarker", name, heading, r, g, b)
end
