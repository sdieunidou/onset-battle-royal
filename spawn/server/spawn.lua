BR = BR or {}

local spawnManager = {}

function spawnManager.setPlayerDimensionSpawn( player )
    SetPlayerRandomColor( player )
    
    SetPlayerDimension(player, BR.Config.DIMENSION_SPAWN)
    SetPlayerVoiceDimension(player, BR.Config.DIMENSION_SPAWN)
    
    SetPlayerLocation( player, -167958.000000, 78089.000000, 1569.000000)
    SetPlayerHeading( player, -90.0)
end

function spawnManager.OnPlayerJoin( player )
    spawnManager.setPlayerDimensionSpawn( player )
end

function spawnManager.OnPlayerSpawn( player )
    spawnManager.setPlayerDimensionSpawn( player )
end
function spawnManager.init()
    AddEvent("OnPlayerJoin", spawnManager.OnPlayerJoin)
    AddEvent("OnPlayerSpawn", spawnManager.OnPlayerSpawn)
end

AddFunctionExport( 'init', spawnManager.init )
AddFunctionExport( 'setPlayerDimensionSpawn', spawnManager.setPlayerDimensionSpawn )

return spawnManager
