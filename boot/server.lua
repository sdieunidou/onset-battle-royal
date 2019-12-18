local package_name = GetPackageName()
local battleManager = require( ( 'packages/%s/battle/server/battle' ):format( package_name ) )
local pprint = require( ( 'packages/%s/utils/server/pprint' ):format( package_name ) )

BR = BR or {}

-- Config BR
BR.Config = {}
BR.Config.DIMENSION_SPAWN = 0
BR.Config.DIMENSION_BATTLE = 100
BR.Config.MAX_TIME = 2 * 60
BR.Config.TIME_BY_ZONE = 30
BR.Config.ROUNDS = BR.Config.MAX_TIME / BR.Config.TIME_BY_ZONE
BR.Config.MIN_PLAYERS = 1
BR.Config.TIMER_CHECK_PLAYERS = 5
BR.Config.MAX_NUMBER_PLAYERS_BY_BATTLE = GetMaxPlayers()
BR.Config.ZONE_RADIUS = 2000
BR.Config.ZONE_REDUCE_RADIUS = BR.Config.ZONE_RADIUS / BR.Config.ROUNDS
BR.Config.MIN_ZONE_RADIUS = 10
BR.Config.MAX_DISTANCE_PLAYERS_ANNOUNCE = 700

BR.BattleManager = battleManager

AddEvent( "OnPackageStart" , function()
    pprint.info( "Loading BattleRoyal\n" )
    BR.BattleManager.init()
end)
