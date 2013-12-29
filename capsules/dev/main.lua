local capsule = {}

function capsule.load()
	love.window.setTitle("Adventures of Princess Moe")
	love.window.setIcon(love.image.newImageData(yama.paths.capsule .. "icon.png"))
	love.window.setMode(1280, 720, {
		fullscreen = false,
		fullscreentype = "desktop",
		vsync = false,
		fsaa = 0,
		resizable = true,
		borderless = false,
		centered = true,
	})
	love.graphics.setDefaultFilter("nearest", "nearest")

	love.graphics.setFont(love.graphics.newImageFont(yama.assets.loadImage("font")," abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\""))

	capsule.map = yama.maps.load("test/start")

	capsule.p1 = capsule.map.spawn("player", "start")

	--capsule.cam1 = capsule.map.spawn("camera", "start")
	--capsule.cam1.follow(capsule.p1)

	capsule.vp1 = yama.viewports.new()
	capsule.vp1.connect(capsule.map, capsule.p1)

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
			if yama.v.paused then
				yama.v.paused = false
			else
				yama.v.paused = true
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
		if capsule.vp1 then
			capsule.vp1.resize(w, h)
		end
	end

	function love.joystickadded(joystick)
		joysticks = love.joystick.getJoysticks()
	end
	function love.joystickremoved(joystick)
		joysticks = love.joystick.getJoysticks()
	end
end

function capsule.update(dt)
end

return capsule