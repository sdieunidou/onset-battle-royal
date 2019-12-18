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

function OnPlayerChat(player, message)
	if (GetPlayerPropertyValue(player, 'mute') ~= 0) then
		if (not CheckForUnmute(player)) then
			return AddPlayerChat(player, "You have been muted")
		end
	end

	if (GetTimeSeconds() - GetPlayerPropertyValue(player, 'chat_cooldown') < 0.8) then
		return AddPlayerChat(player, "Slow down chatting")
	end

	SetPlayerPropertyValue(player, "chat_cooldown", GetTimeSeconds(), false)

	local c = string.sub(message, 1, 1)
	if (c == '#') then
		return AddAdminChat(GetPlayerName(player).."("..player.."): "..string.sub(message, 2))
	end

	message = message:gsub("<span.->(.-)</>", "%1") -- removes chat span tag

	local fullchatmessage = '<span color="'..GetPlayerColorHEX(player)..'">'..GetPlayerName(player)..'('..player..'):</> '..message
	AddPlayerChatAll(fullchatmessage)
end
AddEvent("OnPlayerChat", OnPlayerChat)

function CheckForUnmute(player)
	if (GetTimeSeconds() > GetPlayerPropertyValue(player, 'mute')) then
		SetPlayerPropertyValue(player, "mute", 0, false)
		return true
	end
	return false
end

function OnPlayerChatCommand(player, cmd, exists)	
	if (GetTimeSeconds() - GetPlayerPropertyValue(player, 'cmd_cooldown') < 0.5) then
		AddPlayerChat(player, "Slow down with your commands")
		return false
	end

	SetPlayerPropertyValue(player, "cmd_cooldown", 0, GetTimeSeconds())

	if not exists then
		AddPlayerChat(player, "Command '/"..cmd.."' not found!")
	end
	return true
end
AddEvent("OnPlayerChatCommand", OnPlayerChatCommand)
