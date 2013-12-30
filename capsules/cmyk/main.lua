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
	capsule.p1 = capsule.map.spawn("player", "start", {id = 1})
	capsule.cam1 = capsule.map.spawn("camera", "start")
	capsule.cam1.follow(capsule.p1)
	capsule.vp1 = yama.viewports.new()
	capsule.vp1.connect(capsule.map, capsule.cam1)

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
			capsule.vp1.camera.r = capsule.vp1.camera.r + 0.1
		end

		if key == "m" then
			capsule.vp1.camera.r = capsule.vp1.camera.r - 0.1
		end
		if key == "k" then
			if capsule.vp1.parallax.enabled then
				capsule.vp1.parallax.enabled = false
			else
				capsule.vp1.parallax.enabled = true
			end
		end
		if key == "z" then
			capsule.p2 = capsule.map.spawn("player", "start2", {id = 2})
			capsule.p2.playerId = 2
			capsule.vp2 = yama.viewports.new()
			capsule.vp2.connect(capsule.map, capsule.p2)

			--vp2.setScale(4, 4)

			capsule.vp1.resize(love.window.getWidth() / 2, love.window.getHeight())
			capsule.vp2.resize(love.window.getWidth() / 2, love.window.getHeight())
			capsule.vp2.x = love.window.getWidth() / 2
			capsule.p2.joystick = love.joystick.getJoysticks()[2]

		end
		if key == "1" then
			capsule.vp1.zoom(1)
		end

		if key == "2" then
			capsule.vp1.zoom(2)
		end

		if key == "3" then
			capsule.vp1.zoom(3)
		end

		if key == "4" then
			capsule.vp1.zoom(4)
		end

		if key == "5" then
			capsule.vp1.zoom(0.5)
		end

		if key == "6" then
			capsule.vp1.zoom(0.25)
		end

		if key == "0" then
			local scale = capsule.vp1.camera.sx + 1
			if scale > 5 then
				scale = 1
			end
			capsule.vp1.camera.zoom(scale)
		end

		if key == "+" then
			if capsule.vp1.camera.round then
				capsule.vp1.camera.round = false
			else
				capsule.vp1.camera.round = true
			end
		end
	end

	function love.resize(w, h)
		if capsule.vp1 and capsule.vp2 then
			capsule.vp1.resize(w/2, h)
			capsule.vp2.resize(w/2, h)
			capsule.vp2.x = w/2
		elseif capsule.vp1 then
			capsule.vp1.resize(w, h)
		end
	end
end




function capsule.update(dt)
end

return capsule