
function UpdateScoreboardData(playerid)
	local PlayerTable = { }
	
	for _, v in ipairs(GetAllPlayers()) do
		PlayerTable[v] = {
			GetPlayerName(v),
			GetPlayerPing(v),
			GetPlayerPropertyValue(v, "kills")
		}
	end
	
	CallRemoteEvent(playerid, "OnGetScoreboardData", GetServerName(), GetPlayerCount(), GetMaxPlayers(), PlayerTable)
end
AddRemoteEvent("UpdateScoreboardData", UpdateScoreboardData)