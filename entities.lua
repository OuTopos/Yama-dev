local entities = {}

function entities.load()
	if love.filesystem.exists(yama.paths.capsule .. "entities") then
		local files = love.filesystem.getDirectoryItems(yama.paths.capsule .. "entities")
		for k, file in ipairs(files) do
			print("INFO: ENTITIES -> Loading entity #" .. k .. ": " .. file:gsub("%.lua", ""))
			entities[file:gsub("%.lua", "")] = require(yama.paths.capsule .. "entities/" .. file:gsub("%.lua", ""))
		end
	end
end

return entities