local tools = {}

function tools.serialize(t, d)
	if type(t) == "table" then
		if not d or d < 0 then
			d = 0
		end

		local f = {}

		function f.indent(d)
			local s = ""
			for i = 1, d do
				s = s .. "\t"
			end
			return s
		end

		function f.value(v, d)
			local vtype = type(v)
			if vtype == "string" then
				return string.format("%q", v)
			elseif vtype == "number" then
				return v
			elseif vtype == "table" then
				return "{" .. f.table(v, d + 1) .. f.indent(d) .. "}"
			elseif vtype == "boolean" then
				return tostring(v)
			else
				return ""
			end
		end

		function f.table(t, d)
			local s = "\n"
			for i, v in pairs(t) do
				s = string.format("%s%s[%s] = %s,\n", s, f.indent(d), f.value(i, d), f.value(v, d))
			end

			return s
		end

		return f.value(t, d)
	end
end

function tools.getDistance(x1, y1, x2, y2)
	return math.sqrt((x1-x2)^2+(y1-y2)^2)
end

function tools.getDirection(x1, y1, x2, y2)
	return math.atan2(y2-y1, x2-x1)
end

function tools.getRelativeDirection(r)
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

function tools.print(type, text)
	local info = debug.getinfo(2, "lS")
	print(type .. ": " .. info.short_src .. ":" .. info.currentline .. ": " .. text)
end

return tools