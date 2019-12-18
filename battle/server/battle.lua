local package_name = GetPackageName()
local utilPlayer  = require( ( 'packages/%s/utils/server/player' ):format( package_name ) )
local spawnManager  = require( ( 'packages/%s/spawn/server/spawn' ):format( package_name ) )
local zoneManager  = require( ( 'packages/%s/zone/server/zone' ):format( package_name ) )
local pprint = require( ( 'packages/%s/utils/server/pprint' ):format( package_name ) )

local battleManager = {}

local STATE_WAITING = 0
local STATE_ACTIVE = 1

-- Init 
battleManager.state = STATE_WAITING
battleManager.players = { }
battleManager.timer = nil
battleManager.currentPosition = 0

battleManager.SpawnManager = spawnManager
battleManager.ZoneManager = zoneManager

function battleManager.init()
    battleManager.SpawnManager.init()
    
    AddEvent("OnPlayerDeath", battleManager.OnPlayerDeath)
    AddEvent("OnPlayerQuit", battleManager.OnPlayerQuit)

    battleManager.timer = CreateTimer(function()
        if battleManager.state ~= STATE_WAITING then return end

		if GetPlayerCount() < BR.Config.MIN_PLAYERS then
			return
        end

        battleManager.start()
	end, BR.Config.TIMER_CHECK_PLAYERS * 1000)

    battleManager.reset()
    battleManager.ZoneManager.init()
end

function battleManager.getState()
    return battleManager.state
end

function battleManager.OnPlayerDeath( player, instigator )
    battleManager.playerKilled ( player, instigator )
end

function battleManager.OnPlayerQuit( player )
    battleManager.playerKilled ( player )
end

function battleManager.stop()
    if ( not (battleManager.state == STATE_ACTIVE) ) then
        AddPlayerChatAll( 'Stopping current BattleRoyal...' )
        pprint.info( 'Stopping current BattleRoyal...' )
    end

    battleManager.reset()
end

function battleManager.reset()
    battleManager.state = STATE_WAITING
    UnpauseTimer(battleManager.timer)
    
    utilPlayer.doForAllPlayers(function(player)
        battleManager.SpawnManager.setPlayerDimensionSpawn( player )
    end)
    
    AddPlayerChatAll( 'Wait until the next game ;)' )
    pprint.info( 'Waiting for the next BattleRoyal.' )
end

function battleManager.start()
    pprint.info( ( 
            'Starting new BatteRoyal in 10 seconds! Rules: %d minutes - %d zones - %ds by zones - %d max players - %d zone radius - %d zone reduce radius'
        ):format(
          BR.Config.MAX_TIME / 60,
          BR.Config.ROUNDS,
          BR.Config.TIME_BY_ZONE,
          BR.Config.MAX_NUMBER_PLAYERS_BY_BATTLE,
          BR.Config.ZONE_RADIUS,
          BR.Config.ZONE_REDUCE_RADIUS
        ) 
    )
    AddPlayerChatAll( '<span color="#3c763d" style="bold" size="16">Starting new BatteRoyal in 10 seconds!</>' )
    PauseTimer(battleManager.timer)
    
    battleManager.state = STATE_ACTIVE
    battleManager.players = { }
    battleManager.currentPosition = 0

    Delay(10000, function(player)
        local i = 1;

        battleManager.ZoneManager.start()

        utilPlayer.doForAllPlayers(function(player)
            if (i > BR.Config.MAX_NUMBER_PLAYERS_BY_BATTLE) then return end
            battleManager.spawnPlayer(player)
            i = i + 1
        end)

        AddPlayerChatAll( 'BatteRoyal is started!' )
        pprint.info( 'BatteRoyal is started!' )
	end)
end

function battleManager.spawnPlayer (player)
    local cx, cy = battleManager.ZoneManager.getCenter():center()

    battleManager.players[player] = { }
    battleManager.players[player].kills = 0
    battleManager.players[player].position = 0
    
    local randomX = RandomFloat(cx + BR.Config.ZONE_REDUCE_RADIUS, cx - BR.Config.ZONE_REDUCE_RADIUS)
    local randomY = RandomFloat(cy + BR.Config.ZONE_REDUCE_RADIUS, cy - BR.Config.ZONE_REDUCE_RADIUS)
    SetPlayerLocation(player, randomX, randomY, 30000.000000)
    SetPlayerDimension(player, BR.Config.DIMENSION_BATTLE)

    SetPlayerHealth(player, 100)
    SetPlayerArmor(player, 100)

    SetPlayerWeapon(player, 13, 90, true, 1, true)
    SetPlayerWeapon(player, 7, 30, true, 2, true)
    SetPlayerWeapon(player, 1, 50, true, 3, true)
    
    Delay(1000, function()
        AttachPlayerParachute(player, true)
    end)
end

function battleManager.SetGameEnd( player )
    battleManager.stop()

    AddPlayerChatAll('<span color="#2db92f" style="bold" size="16">'..GetPlayerName(player)..' has win the battle with '..battleManager.players[player].kills..' kills</>')
    pprint.info( GetPlayerName(player).." has win the battle royal with "..battleManager.players[player].kills.." kills" )
end

function battleManager.playerKilled ( player, instigator )
    if battleManager.state == STATE_ACTIVE and battleManager.players[player] ~= nil then
        local playerPosition = #battleManager.players - battleManager.currentPosition
        battleManager.currentPosition = battleManager.currentPosition + 1

        battleManager.SpawnManager.setPlayerDimensionSpawn( player )

        -- If it's not suicide
        if (player ~= instigator) then
            battleManager.players[player].kills = battleManager.players[player].kills + 1
            battleManager.players[player].position = playerPosition

            if (instigator ~= nil) then
                AddPlayerChat(player, '<span color="#ee0000ee" style="bold" size="16">'..GetPlayerName(instigator).." has killed "..GetPlayerName(player)..'</>')
                AddPlayerChat(instigator, '<span color="#ee0000ee" style="bold" size="16">'..GetPlayerName(instigator).." has killed "..GetPlayerName(player)..'</>')
            end
        end

        AddPlayerChatAll( GetPlayerName(player).." has finished in position "..playerPosition.." with "..battleManager.players[player].kills.." kills" )
        pprint.info( GetPlayerName(player).." has finished in position "..playerPosition.." with "..battleManager.players[player].kills.." kills" )

        if (playerPosition == 2 or #battleManager.players < 2) then
            battleManager.SetGameEnd( instigator )
        end

        -- battleManager.players[player] = nil
	end
end

function battleManager.doForAllPlayersInBattle(func)
    if battleManager.state ~= STATE_ACTIVE then
        return
    end

	for k,v in ipairs(battleManager.players) do
		func(k)
	end
end

AddFunctionExport( 'init', battleManager.init )
AddFunctionExport( 'reset', battleManager.reset )
AddFunctionExport( 'stop', battleManager.stop )
AddFunctionExport( 'start', battleManager.start )
AddFunctionExport( 'getState', battleManager.getState )

return battleManager
