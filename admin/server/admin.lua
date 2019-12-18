--[[
Copyright (C) 2019 Blue Mountains GmbH

This program is free software: you can redistribute it and/or modify it under the terms of the Onset
Open Source License as published by Blue Mountains GmbH.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the Onset Open Source License for more details.

You should have received a copy of the Onset Open Source License along with this program. If not,
see https://bluemountains.io/Onset_OpenSourceSoftware_License.txt
]]--

function cmd_setadmin(player, otherplayer, level)
	if (GetPlayerPropertyValue(player, 'admin') < 5) then
		return AddPlayerChat(player, "Insufficient permission")
	end

	if (otherplayer == nil or level == nil) then
		return AddPlayerChat(player, "Usage: /setadmin <player> <level>")
	end

	otherplayer = math.tointeger(otherplayer)

	if (not IsValidPlayer(otherplayer)) then
		return AddPlayerChat(player, "Selected player does not exist")
	end

	if (GetPlayerPropertyValue(otherplayer, 'admin') > 4) then
		AddPlayerChat(player, "Cannot set admin on high level admin")
		return AddPlayerChat(otherplayer, GetPlayerName(player).." tried to change your admin level to "..level)
	end

	level = math.tointeger(level)

	if (level == nil or level < 0 or level > 5) then
		return AddPlayerChat(player, "Parameter \"level\" invalid length 0-5")
	end

	if (GetPlayerPropertyValue(otherplayer, 'admin') == level) then
		return AddPlayerChat(player, "Selected player already is level "..GetPlayerPropertyValue(otherplayer, 'admin'))
	end

	SetPlayerPropertyValue(player, "admin", level, false)

	AddPlayerChat(otherplayer, "Admin "..GetPlayerName(player).." has set your admin level to "..GetPlayerPropertyValue(otherplayer, 'admin'))
	AddPlayerChat(player, "You have made "..GetPlayerName(otherplayer).."("..otherplayer..") admin level "..GetPlayerPropertyValue(otherplayer, 'admin'))

	SavePlayerAccount(otherplayer)
end
AddCommand("setadmin", cmd_setadmin)

function cmd_kick(player, otherplayer, ...)
	if (GetPlayerPropertyValue(player, 'admin') < 2) then
		return AddPlayerChat(player, "Insufficient permission")
	end

	local reason = table.concat({...}, " ") 
	
	if (otherplayer == nil or #{...} == 0) then
		return AddPlayerChat(player, "Usage: /kick <player> <reason>")
	end

	otherplayer = tonumber(otherplayer)

	if (not IsValidPlayer(otherplayer)) then
		return AddPlayerChat(player, "Selected player does not exist")
	end

	if (#reason < 5 or #reason > 128) then
		return AddPlayerChat(player, "Parameter \"reason\" invalid length 5-128")
	end
	
	if (GetPlayerPropertyValue(otherplayer, 'admin') > 4) then
		AddPlayerChat(player, "Cannot kick high level admin")
		return AddPlayerChat(otherplayer, GetPlayerName(player).." tried to kick you")
	end

	KickPlayer(otherplayer, "You have been kicked from the server by "..GetPlayerName(player))

	AddPlayerChatAll('Player '..GetPlayerName(otherplayer)..' has been kicked by '..GetPlayerName(player)..'. Reason: '..reason..'')
end
AddCommand("kick", cmd_kick)

function cmd_getip(player, otherplayer)
	if (GetPlayerPropertyValue(player, 'admin') < 4) then
		return AddPlayerChat(player, "Insufficient permission")
	end

	if (otherplayer == nil) then
		return AddPlayerChat(player, "Usage: /getip <player>")
	end

	otherplayer = tonumber(otherplayer)

	if (not IsValidPlayer(otherplayer)) then
		return AddPlayerChat(player, "Selected player does not exist")
	end

	if (GetPlayerPropertyValue(otherplayer, 'admin') > 4) then
		AddPlayerChat(player, "Cannot get ip of high level admin")
		return AddPlayerChat(otherplayer, GetPlayerName(player).." tried to get your IP")
	end

	AddPlayerChat(player, "IP: "..GetPlayerIP(otherplayer))
end
AddCommand("getip", cmd_getip)

function cmd_announce(player, ...)
	if (GetPlayerPropertyValue(player, 'admin') < 4) then
		return AddPlayerChat(player, "Insufficient permission")
	end

	local message = table.concat({...}, " ") 

	if (#{...} == 0) then
		return AddPlayerChat(player, "Usage: /announce <message>")
	end

	if (#message < 1 or #message > 128) then
		return AddPlayerChat(player, "Parameter \"message\" invalid length 1-128")
	end

	AddPlayerChatAll('<span color="#ee0000ee" style="bold" size="16">ADMIN: '..message..'</>')
end
AddCommand("announce", cmd_announce)
AddCommand("ann", cmd_announce)

function cmd_mydimension(player)
	if (GetPlayerPropertyValue(player, 'admin') < 2) then
		return AddPlayerChat(player, "Insufficient permission")
	end

	AddPlayerChat(player, "Your dimension: "..GetPlayerDimension(player))
end
AddCommand("mydimension", cmd_mydimension)

function cmd_clear(player)
	if (GetPlayerPropertyValue(player, 'admin') < 2) then
		return AddPlayerChat(player, "Insufficient permission")
	end

	-- Send empty messages to clear the chat
	for i=1,15 do
		AddPlayerChatAll("")
	end
end
AddCommand("clear", cmd_clear)
