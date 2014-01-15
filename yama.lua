local yama = {}

function info(text)
	local info = debug.getinfo(2, "lS")
	print("Info: " .. info.short_src .. ":" .. info.currentline .. ": " .. text)
end
function warning(text)
	local info = debug.getinfo(2, "lS")
	print("Warning: " .. info.short_src .. ":" .. info.currentline .. ": " .. text)
end

-- Bootloader. Mainly for development. Remove or replace with launcher.
yama.boot           = require("boot")

-- MODULES
yama.assets         = require("yama_assets")
yama.entities       = require("entities")
yama.buffers      	= require("yama_buffers")
yama.scenes         = require("scenes")
yama.viewports      = require("viewports")
yama.gui            = require("yama_gui")
yama.hud            = require("yama_hud")
yama.animations     = require("yama_animations")
yama.ai             = require("yama_ai")
yama.ai.patrols     = require("yama_ai_patrols")
yama.physics        = require("yama_physics")

yama.tools		    = require("tools")

-- PATHS
yama.paths = {}
yama.paths.capsules = "capsules/"
yama.paths.images = "images/"
yama.paths.tilesets = "tilesets/"

-- VARIABLES
yama.v = {}
yama.v.paused = false
yama.v.timescale = 1


function yama.start(capsule)
	if not yama.paths.capsule and capsule then
		yama.paths.capsule = yama.paths.capsules .. capsule .. "/"
	else
		yama.paths.capsule = ""
	end
	yama.capsule = require(yama.paths.capsule  .. "main")

	love.load = yama.load
	love.update = yama.update
	love.draw = yama.draw
end

function yama.load()
	yama.assets.load()
	yama.gui.load()
	yama.entities.load()
	yama.capsule.load()
end

function yama.update(dt)
	yama.assets.update()
	yama.capsule.update(dt)
	if not yama.v.paused then
		yama.viewports.update(dt * yama.v.timescale)
		yama.scenes.update(dt * yama.v.timescale)
		--yama.maps.update(dt * yama.v.timescale)
	end
end

function yama.draw()
	local screenwidth, screenheight = love.window.getDimensions( )

	yama.viewports.draw()
	-- DRAW MAPS
	--yama.maps.draw()

	local fps = love.timer.getFPS()
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.printf(fps .. " fps", 0, 3, screenwidth, "right")

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf(fps .. " fps", 0, 2, screenwidth, "right")
end

return yama