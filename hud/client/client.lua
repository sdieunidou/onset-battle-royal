-- https://github.com/frederic2ec/onsetrp

local minimap
local speakingHud
local rankHud

AddEvent("OnPackageStart", function ()
    minimap = CreateWebUI(0, 0, 0, 0, 0, 32)
    SetWebVisibility(minimap, WEB_HITINVISIBLE)
    SetWebAnchors(minimap, 0, 0, 1, 1)
    SetWebAlignment(minimap, 0, 0)
    SetWebURL(minimap, "http://asset/"..GetPackageName().."/hud/client/minimap/minimap.html")

    speakingHud = CreateWebUI(0, 0, 0, 0, 0, 28)
    LoadWebFile( speakingHud, "http://asset/"..GetPackageName().."/hud/client/speaking/hud.html" )
    SetWebAlignment( speakingHud, 0, 0 )
    SetWebAnchors( speakingHud, 0, 0, 1, 1 )
    SetWebVisibility( speakingHud, WEB_HITINVISIBLE )

    rankHud = CreateWebUI(0, 0, 0, 0, 0, 28)
    LoadWebFile( rankHud, "http://asset/"..GetPackageName().."/hud/client/rank/hud.html" )
    SetWebAlignment( rankHud, 0, 0 )
    SetWebAnchors( rankHud, 0, 0, 1, 1 )
    SetWebVisibility( rankHud, WEB_HITINVISIBLE )
end)

function updateHud(rank)
print(rank)
    ExecuteWebJS(rankHud, "SetRank("..rank..");")
end
AddRemoteEvent("updateHud", updateHud)

AddEvent( "OnGameTick", function()
    --Speaking icon check
    local player = GetPlayerId()
    if IsPlayerTalking(player) then
        SetWebVisibility(speakingHud, WEB_HITINVISIBLE)
    else
        SetWebVisibility(speakingHud, WEB_HIDDEN)
    end

    --Minimap refresh
    local x, y, z = GetCameraRotation()
    local px,py,pz = GetPlayerLocation()
    ExecuteWebJS(minimap, "SetHUDHeading("..(360-y)..");")
    ExecuteWebJS(minimap, "SetMap("..px..","..py..","..y..");")

    -- Hud refresh
    CallRemoteEvent("getHudData")
end )

AddRemoteEvent("SetHUDMarker", function (name, h, r, g, b)
    if h == nil then
        ExecuteWebJS(minimap, "SetHUDMarker(\""..name.."\");");
    else
        ExecuteWebJS(minimap, "SetHUDMarker(\""..name.."\", "..h..", "..r..", "..g..", "..b..");");
    end
end)

AddRemoteEvent("BattleNewZone", function(x, y, z, radius)
-- todo
end)
