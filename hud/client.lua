-- https://github.com/frederic2ec/onsetrp

local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local minimap

function OnPackageStart()
    minimap = CreateWebUI(0, 0, 0, 0, 0, 32)
    SetWebVisibility(minimap, WEB_HITINVISIBLE)
    SetWebAnchors(minimap, 0, 0, 1, 1)
    SetWebAlignment(minimap, 0, 0)
    SetWebURL(minimap, "http://asset/battleroyal/hud/minimap/minimap.html")
    ShowWeaponHUD(true)
end
AddEvent("OnPackageStart", OnPackageStart)

AddEvent( "OnGameTick", function()
    --Minimap refresh
    local x, y, z = GetCameraRotation()
    local px,py,pz = GetPlayerLocation()
    ExecuteWebJS(minimap, "SetHUDHeading("..(360-y)..");")
    ExecuteWebJS(minimap, "SetMap("..px..","..py..","..y..");")
end )

function SetHUDMarker(name, h, r, g, b)
    if h == nil then
        ExecuteWebJS(minimap, "SetHUDMarker(\""..name.."\");");
    else
        ExecuteWebJS(minimap, "SetHUDMarker(\""..name.."\", "..h..", "..r..", "..g..", "..b..");");
    end
end

AddRemoteEvent("SetHUDMarker", SetHUDMarker)
