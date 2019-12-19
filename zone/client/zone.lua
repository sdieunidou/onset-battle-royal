AddRemoteEvent("BattleNewZone", function(x, y, z, radius)
    DrawCircle3D(x, y, z, radius)
    AddPlayerChat('BattleNewZone received')
end)
