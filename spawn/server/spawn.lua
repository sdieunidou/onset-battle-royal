local package_name = GetPackageName()
local pprint = require( ( 'packages/%s/utils/server/pprint' ):format( GetPackageName() ) )

local spawnManager = {}

function spawnManager.setPlayerDimensionSpawn( player )
    SetPlayerDimension(player, BR.Config.DIMENSION_SPAWN)
    SetPlayerVoiceDimension(player, BR.Config.DIMENSION_SPAWN)
    
    pprint.info(GetPlayerName(player).." setPlayerDimensionSpawn" )
end

function spawnManager.OnPlayerJoin( player )
    spawnManager.setPlayerDimensionSpawn( player )

    SetPlayerLocation(player, 114900.375, -4946.166015625, 1292.6826171875)

    pprint.info(GetPlayerName(player).." has spawn in lobby" )
end

function spawnManager.init()
    AddEvent("OnPlayerJoin", spawnManager.OnPlayerJoin)
end

AddFunctionExport( 'init', spawnManager.init )
AddFunctionExport( 'setPlayerDimensionSpawn', spawnManager.setPlayerDimensionSpawn )

return spawnManager
