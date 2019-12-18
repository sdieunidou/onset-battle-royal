local package_name = GetPackageName()
local pprint = require( ( 'packages/%s/utils/server/pprint' ):format( GetPackageName() ) )
local HC = require 'packages/battleroyal/HC'

local zoneManager = { }
zoneManager.currentRound = 1
zoneManager.currentRadius = nil
zoneManager.hasZoneDamage = false
zoneManager.timer = nil
zoneManager.reduceRadius = nil
zoneManager.center = nil

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

    zoneManager.center = nil
    zoneManager.center = HC.circle(RandomFloat(183818, -217367), RandomFloat(183818, -217367), zoneManager.currentRadius)
    
    pprint.info( 'New zone, the next zone will be in '..BR.Config.TIME_BY_ZONE..' seconds! (current zone radius: '..zoneManager.currentRadius..' meters)' )
    AddPlayerChatAll( 'New zone, the next zone will be <span color="#ff0000ee">'..BR.Config.TIME_BY_ZONE..' seconds</>!' )

    BR.BattleManager.doForAllPlayersInBattle( function( player )
        local x, y, z = GetPlayerLocation( player )

        if (not zoneManager.center.containts(x, y)) then
            zoneManager.playerZoneDommage()
        end

        BR.BattleManager.doForAllPlayersInBattle( function( targetPlayer )
            local tx, ty, tz = GetPlayerLocation( targetPlayer )
            local distance = GetDistance3D( x, y, z, tx, ty, tz )
        
            local meters = math.floor(tonumber(distance) / 100)
            if (meters > BR.Config.MAX_DISTANCE_PLAYERS_ANNOUNCE) then
                pprint.info( GetPlayerName(player).." is at " .. math.floor(tonumber(distance) / 100) .. " meters from "..GetPlayerName(targetPlayer).."." )
                AddPlayerChatAll( GetPlayerName(player).." is at " .. math.floor(tonumber(distance) / 100) .. " meters from you." )
            end
        end)
    end)
end

function zoneManager.playerZoneDommage (player) 
    zoneManager.hasZoneDamage = true
    if (zoneManager.hasZoneDamage) then
        pprint.info( GetPlayerName(player)..' not in zone!' )
        AddPlayerChat( player, 'You are not in the zone!' )
    end
end

function zoneManager.start()
    zoneManager.center = nil
    zoneManager.currentRound = 1
    zoneManager.currentRadius = BR.Config.ZONE_RADIUS
    
    zoneManager.center = HC.circle(RandomFloat(183818, -217367), RandomFloat(183818, -217367), BR.Config.ZONE_RADIUS)

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
