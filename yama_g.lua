local g = {}
-- General function and other things I don't yet know where to put
g.pause = false

local sqrt = math.sqrt
local atan2 = math.atan2

function g.getDistance(x1, y1, x2, y2)
	return sqrt((x1-x2)^2+(y1-y2)^2)
end

function g.getDirection(x1, y1, x2, y2)
	return atan2(y2-y1, x2-x1)
end

function g.getRelativeDirection(r)
	--if r < 0 then
	--	r = 4*math.pi/2+r
	--elseif r >= 4*math.pi/2 then
	--	while r >= 4*math.pi/2 do
	--		r = r - 4*math.pi/2
	--	end
	--end

	local i = math.floor(r / (math.pi/2) + 0.5)
	
	while i < 0 do
		i = i + 4
	end
	while i >= 4 do
		i = i - 4
	end

	if i == 0 then
		return "right"
	elseif i == 1 then
		return "down"
	elseif i == 2 then
		return "left"
	elseif i == 3 then
		return "up"
	else
		print("retard "..i..r)
	end
end

return g