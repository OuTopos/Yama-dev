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
	--[[
	if type(table) == "table" then
		print("is a table")



		local string = ""

		local process = {}

		local function v(v, d)
		end

		--local function table(t, d)
		--	string = process.tabulate(string, d)
		--	string = string .. "{\n"
--
		--	for k, v in pairs(t) do
				vtype = type(v)
--
				

		--	end

		--	string = string .. "}"
		--end

		function process.tabulate(s, d)
			for i = 1, d do
				s = s .. "\t"
			end
			return s
		end


		--process.table(table, 0)


		return string
	else
		return nil
	end
	--]]
end

return tools