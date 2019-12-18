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

local NiceColors = { 0xFF0000, 0xFF0066, 0xEF00FF, 0x8000FF, 0x1100FF, 0x004DFF, 0x00B3FF, 0x00FFD5, 0x00FF77, 0x00FF1A, 0x55FF00, 0xEFFF00, 0xFFBC00, 0xFFA200, 0x915425 }

local rgb2hex = function (rgb)
	local hexadecimal = '#'

	for key = 1, #rgb do
	    local value = rgb[key] 
		local hex = ''

		while (value > 0) do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if (string.len(hex) == 0) then
			hex = '00'
		elseif (string.len(hex) == 1) then
			hex = '0' .. hex
		end
		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end

function GetPlayerColorHEX(player)
	local r, g, b = HexToRGBA( NiceColors[ math.random( #NiceColors ) ] )

	rgba = {}
	rgba[1] = r
	rgba[2] = g
	rgba[3] = b

	return rgb2hex(rgba)
end

function OnPlayerChat(player, message)
	if (tonumber(GetPlayerPropertyValue(player, 'mute')) ~= 0) then
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
	if (GetTimeSeconds() > tonumber(GetPlayerPropertyValue(player, 'mute'))) then
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
