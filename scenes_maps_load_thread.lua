require("love.filesystem")
require("love.image")
require("love.timer")

local channel = love.thread.getChannel("scenes_maps_load_thread")
channel = channel:demand()


local mappath = channel:demand()

while true do
	channel:push(mappath)
end