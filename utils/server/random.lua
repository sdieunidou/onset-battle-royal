local random = {}

function random.randomFloat(min, max, precision)
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

return random

