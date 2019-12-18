local package_name = GetPackageName()
local pprint = require( ( 'packages/%s/utils/server/pprint' ):format( GetPackageName() ) )
local HC = require( ( 'packages/%s/vendor/HC' ):format( GetPackageName() ) )

local zoneManager = { }
zoneManager.currentRound = 1
zoneManager.currentRadius = nil
zoneManager.timer = nil
zoneManager.timerDamage = nil
zoneManager.reduceRadius = nil
zoneManager.center = nil

function zoneManager.init()
    zoneManager.timer = CreateTimer(function()
        local newRadius = zoneManager.currentRadius - BR.Config.ZONE_REDUCE_RADIUS
        if (newRadius < BR.Config.MIN_ZONE_RADIUS) then
            newRadius = BR.Config.MIN_ZONE_RADIUS
        end

        zoneManager.currentRadius = newRadius
        
        if (zoneManager.currentRound == BR.Config.ROUNDS + 1) then
            zoneManager.lastRound()
        else
            zoneManager.next()
        end
    end, BR.Config.TIME_BY_ZONE * 1000 )
    PauseTimer( zoneManager.timer )

    zoneManager.timerDamage = CreateTimer(function()
        if (zoneManager.center == nil) then return end

        BR.BattleManager.doForAllPlayersInBattle( function( player )
            local x, y, z = GetPlayerLocation( player )
    
            if (not zoneManager.center:contains(x, y)) then
                zoneManager.playerZoneDamage( player )
            end
        end)
    end, 1000 )
    PauseTimer( zoneManager.timerDamage )
end

function zoneManager.next()
    zoneManager.currentRound = zoneManager.currentRound + 1

    local cx, cy = zoneManager.center:center()
    zoneManager.center = nil

    zoneManager.center = HC.circle(cx, cy, zoneManager.currentRadius)
    
    pprint.info( 'New zone is here! You have '..(BR.Config.TIME_BY_ZONE / 2)..' seconds to go in. The next zone will be in '..BR.Config.TIME_BY_ZONE..' seconds! (current zone radius: '..zoneManager.currentRadius..' meters)' )
    AddPlayerChatAll( '<span color="#f4f142ff" style="bold" size="16">New zone is here! You have '..(BR.Config.TIME_BY_ZONE / 2)..' seconds to go in!</>' )

    BR.BattleManager.doForAllPlayersInBattle( function( player )
        local x, y, z = GetPlayerLocation( player )

        BR.BattleManager.doForAllPlayersInBattle( function( targetPlayer )
            local tx, ty, tz = GetPlayerLocation( targetPlayer )
            local distance = GetDistance3D( x, y, z, tx, ty, tz )
        
            local meters = math.floor(tonumber(distance) / 100)
            if (meters > BR.Config.MAX_DISTANCE_PLAYERS_ANNOUNCE) then
                pprint.info(  '<span color="#ee0000ee" style="bold">'..GetPlayerName(player).."</> is at " .. math.floor(tonumber(distance) / 100) .. " meters from "..GetPlayerName(targetPlayer).."." )
                AddPlayerChatAll( GetPlayerName(player).." is at " .. math.floor(tonumber(distance) / 100) .. " meters from you." )
            end
        end)
    end)

    Delay((BR.Config.TIME_BY_ZONE / 2) * 1000, function()
        pprint.info( 'Start zone damage for '..(BR.Config.TIME_BY_ZONE / 2)..' secondes' )
        UnpauseTimer( zoneManager.timerDamage )
    end)

    Delay(BR.Config.TIME_BY_ZONE * 1000, function()
        pprint.info( 'End zone damage' )
        PauseTimer( zoneManager.timerDamage )
    end)
end

function zoneManager.playerZoneDamage (player) 
    pprint.info( GetPlayerName( player )..' not in zone!' )
    AddPlayerChat( player, 'You are not in the zone!' )

    local playerArmor = GetPlayerArmor(player) - BR.Config.DAMAGE_PER_SECOND
    local playerHealth = GetPlayerHealth(player)

    if (playerArmor <= 0) then
        playerHealth = playerHealth + playerArmor
        playerArmor = 0
    end

    if (playerHealth < 0) then
        playerHealth = 0
    end

    SetPlayerArmor(player, playerArmor)
    SetPlayerHealth(player, playerHealth)
end

function zoneManager.start()
    zoneManager.center = nil
    zoneManager.currentRound = 1
    zoneManager.currentRadius = BR.Config.ZONE_RADIUS + BR.Config.ZONE_REDUCE_RADIUS
    
    zoneManager.center = HC.circle(randomFloat(-19000, 183818), randomFloat(-19000, 183818), BR.Config.ZONE_RADIUS)

    pprint.info('Center point is ' .. zoneManager.center:center())

    UnpauseTimer( zoneManager.timer )
    PauseTimer(zoneManager.timerDamage)
end

function zoneManager.lastRound()
    PauseTimer(zoneManager.timer)

    pprint.info( 'Final zone!!! (radius: '..zoneManager.currentRadius..' meters)' )
    AddPlayerChatAll('<span color="#ee0000ee" style="bold" size="16">Final zone!!!</>')


    Delay((BR.Config.TIME_BY_ZONE / 2) * 1000, function()
        pprint.info( 'Start zone damage for '..(BR.Config.TIME_BY_ZONE / 2)..' secondes' )
        UnpauseTimer( zoneManager.timerDamage )
    end)
end

function zoneManager.getCenter()
    return zoneManager.center
end

function randomFloat(min, max, precision)
	-- Generate a random floating point number between min and max
	--[[1]] local range = max - min
	--[[2]] local offset = range * math.random()
	--[[3]] local unrounded = min + offset

	-- Return unrounded number if precision isn't given
	if not precision then
		return unrounded
	end

	-- Round number to precision and return
	--[[1]] local powerOfTen = 10 ^ precision
	local n
	--[[2]] n = unrounded * powerOfTen
	--[[3]] n = n + 0.5
	--[[4]] n = math.floor(n)
	--[[5]] n = n / powerOfTen
	return n
end

return zoneManager
