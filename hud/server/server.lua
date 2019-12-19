-- https://github.com/frederic2ec/onsetrp

AddRemoteEvent("getHudData", function (player)
    local rank = GetPlayerPropertyValue(player, "position")
    CallRemoteEvent(player, "updateHud", rank)
end)

function SetHUDMarker(player, name, heading, r, g, b)
    CallRemoteEvent(player, "SetHUDMarker", name, heading, r, g, b)
end