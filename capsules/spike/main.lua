
local capsule = {}

function capsule.load()
	love.window.setTitle("Mattias CMYK")
	love.window.setMode(800, 600, {
		fullscreen = false,
		fullscreentype = "desktop",
		vsync = false,
		fsaa = 0,
		resizable = true,
		borderless = false,
		centered = true,
	})
	capsule.map = yama.maps.load("untitled")
	-- capsule.p1 = capsule.map.spawn("player", "start")
	capsule.p1 = capsule.map.spawn("player", "start")
	capsule.vp1 = yama.viewports.new()
	capsule.vp1.view(capsule.map, capsule.p1)

	function love.keypressed(key)
		if key == "escape" then
			love.event.push("quit")
		end
		if key == "h" then
			if yama.hud.enabled then
				yama.hud.enabled = false
			else
				yama.hud.enabled = true
			end
		end
		if key == "j" then
			if yama.hud.physics then
				yama.hud.physics = false
			else
				yama.hud.physics = true
			end
		end

		if key == "p" then
			if yama.g.paused then
				yama.g.paused = false
			else
				yama.g.paused = true
			end
		end


	end
end



function capsule.update(dt)
end

return capsule