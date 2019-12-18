local utilPlayer = {}

function utilPlayer.doForAllPlayers(func)
	for _, v in pairs( GetAllPlayers() )  do
		func(v)
	end
end

return utilPlayer
