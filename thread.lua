require 'love.filesystem'
require 'love.image'

output = love.thread.getChannel("loadMap")
input = love.thread.getChannel("assets.threadInput")

while true do
	local instruction = input:pop()

	if instruction[1] == "image" then
		if love.filesystem.exists(yama.paths.capsule .. "images/"..instruction[2]..".png") then
			local image = love.graphics.newImage(yama.paths.capsule .. "images/"..instruction[2]..".png")

    		output:push(image)
		else
			error("Couldn't load image.")
		end
    end
end