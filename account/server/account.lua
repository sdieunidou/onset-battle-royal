
local pprint = require( ( 'packages/%s/utils/server/pprint' ):format( GetPackageName() ) )

function OnPlayerSteamAuth(player)
	pprint.info("OnPlayerServerAuth("..player..") has SteamId "..GetPlayerSteamId(player))

	CreatePlayerData(player)

	AddPlayerChatAll('<span color="#eeeeeeaa">'..GetPlayerName(player)..' from '..GetPlayerPropertyValue(player, "locale")..' joined the server</>')
	AddPlayerChatAll('<span color="#eeeeeeaa">There are '..GetPlayerCount()..' players on the server</>')
end
AddEvent("OnPlayerSteamAuth", OnPlayerSteamAuth)

AddEvent( "OnPlayerQuit" , function( player )
	AddPlayerChatAll('<span color="#eeeeeeaa">'..GetPlayerName(player)..' disconnected</>')
end)

function CreatePlayerData( player )
	--Account stuff
    SetPlayerPropertyValue(player, "locale", GetPlayerLocale(player), true)
    SetPlayerPropertyValue(player, "admin", false, true)

	--Gameplay stuff
    SetPlayerPropertyValue(player, "mute", false, true)
    SetPlayerPropertyValue(player, "chat_cooldown", 0, true)
    SetPlayerPropertyValue(player, "cmd_cooldown", 0, true)
end
