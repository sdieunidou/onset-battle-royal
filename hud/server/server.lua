-- https://github.com/frederic2ec/onsetrp

AddRemoteEvent("getHudData", function (player)
    local rank = GetPlayerPropertyValue(player, "position")
    local kills = GetPlayerPropertyValue(player, "kills")

    CallRemoteEvent(player, "updateHud", rank, kills)
end)

function SetHUDMarker(player, name, heading, r, g, b)
    CallRemoteEvent(player, "SetHUDMarker", name, heading, r, g, b)
end