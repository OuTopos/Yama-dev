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
	capsule.map = yama.maps.load("test/gravityfall")
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

		if key == "n" then
			vp1.camera.r = vp1.camera.r + 0.1
		end

		if key == "m" then
			vp1.camera.r = vp1.camera.r - 0.1
		end

		if key == "z" then
			capsule.p2 = capsule.map.spawn("mplayer", "start2")
			capsule.vp2 = yama.viewports.new()
			capsule.vp2.view(capsule.map, capsule.p2)

			--vp2.setScale(4, 4)

			vp1.setSize(yama.screen.width / 2, yama.screen.height)
			vp2.setSize(yama.screen.width / 2, yama.screen.height)
			vp2.setPosition(yama.screen.width / 2)
			gravityfallPlayer = 2
			player2.joystick = 2
		end
	end
end



function capsule.update(dt)
end

return capsule