local package_name = GetPackageName()
local pprint = require( ( 'packages/%s/utils/server/pprint' ):format( GetPackageName() ) )

local spawnManager = {}

function spawnManager.setPlayerDimensionSpawn( player )
    SetPlayerDimension(player, BR.Config.DIMENSION_SPAWN)
    SetPlayerVoiceDimension(player, BR.Config.DIMENSION_SPAWN)
end

function spawnManager.OnPlayerJoin( player )
    spawnManager.setPlayerDimensionSpawn( player )
    SetPlayerSpawnLocation(player, 207078.484375, 192689.109375, 1306.94921875, 175.41589355469 )
    
	AddPlayerChat(player, '<span style="bold" size="14">============================</>')
	AddPlayerChat(player, '<span style="bold" size="14">Welcome to BattleRoyal (in development).</>')
	AddPlayerChat(player, 'You need to be at least 2 players to start a new battle royal.')
	AddPlayerChat(player, '<span color="#f4f142ff" style="bold" size="14">Wait for the next game</>.')
    AddPlayerChat(player, '<span style="bold" size="14">============================</>')

end

function spawnManager.init()
    AddEvent("OnPlayerJoin", spawnManager.OnPlayerJoin)
end

AddFunctionExport( 'init', spawnManager.init )
AddFunctionExport( 'setPlayerDimensionSpawn', spawnManager.setPlayerDimensionSpawn )

return spawnManager
