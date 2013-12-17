local tools = {}

function tools.serialize(table)
	if type(table) == "table" then
		print("is a table")



		local string = ""

		local process = {}

		function process.table(t, d)
			string = process.tabulate(string, d)
			string = string .. "{\n"

			for k, v in pairs(t) do
				vtype = type(v)

				if vtype == "table" then
					process.table(v, d + 1)
				end
			end

			string = string .. "}"
		end

		function process.tabulate(s, d)
			for i = 1, d do
				s = s .. "\t"
			end
			return s
		end


		process.table(table, 0)


		return string
	else
		return nil
	end
end

return tools