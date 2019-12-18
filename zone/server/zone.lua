local package_name = GetPackageName()
local pprint = require( ( 'packages/%s/utils/server/pprint' ):format( GetPackageName() ) )

local zoneManager = { }
zoneManager.currentRound = 1
zoneManager.currentRadius = nil
zoneManager.timer = nil
zoneManager.reduceRadius = nil
zoneManager.center = {}

function zoneManager.init()
    zoneManager.timer = CreateTimer(function()
        local newRadius = zoneManager.currentRadius - BR.Config.ZONE_REDUCE_RADIUS
        if (newRadius < BR.Config.MIN_ZONE_RADIUS) then
            newRadius = BR.Config.MIN_ZONE_RADIUS
        end

        zoneManager.currentRadius = newRadius
        
        if (zoneManager.currentRound == BR.Config.ROUNDS) then
            zoneManager.stop()
        else
            zoneManager.next()
        end
    end, BR.Config.TIME_BY_ZONE * 1000 )
    
    PauseTimer( zoneManager.timer )
end

function zoneManager.next()
    zoneManager.currentRound = zoneManager.currentRound + 1
    
    pprint.info( 'New zone, the next zone will be in '..BR.Config.TIME_BY_ZONE..' seconds! (radius: '..zoneManager.currentRadius..' meters)' )
    AddPlayerChatAll( 'New zone, the next zone will be <span color="#ff0000ee">'..BR.Config.TIME_BY_ZONE..' seconds</>!' )

    BR.BattleManager.doForAllPlayersInBattle( function( player )
        local x, y, z = GetPlayerLocation( player )

        local distance = GetDistance3D(
            zoneManager.center.x, 
            zoneManager.center.y, 
            zoneManager.center.z, 
            x, y, z
        )
    
        local meters = math.floor(tonumber(distance) / 100)
        if (meters > 500) then
            pprint.info( GetPlayerName(player).." is at " .. math.floor(tonumber(distance) / 100) .. " meters from the center." )
            AddPlayerChatAll( GetPlayerName(player).." is at " .. math.floor(tonumber(distance) / 100) .. " meters from the center." )
        end
    end)
end

function zoneManager.start()
    zoneManager.currentRound = 1
    zoneManager.currentRadius = BR.Config.ZONE_RADIUS
    
    zoneManager.center.x = RandomFloat(183818, -217367)
    zoneManager.center.y = RandomFloat(183818, -217367)
    zoneManager.center.z = RandomFloat(0, 2000)
    
    UnpauseTimer( zoneManager.timer )
end

function zoneManager.stop()
    PauseTimer(zoneManager.timer)

    pprint.info( 'Final zone!!! (radius: '..zoneManager.currentRadius..' meters)' )
    AddPlayerChatAll( 'Final zone!!!' )
end

function zoneManager.getCenter()
    return zoneManager.center
end

return zoneManager
