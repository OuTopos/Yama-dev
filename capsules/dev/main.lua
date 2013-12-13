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



	scaleToggle = 1


	vp1 = yama.viewports.new()
	arkanosPlayer = 0
	gravityfallPlayer = 0

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

		-- ARKANOS
		if key == "1" then
			arkanos = yama.maps.load("test/start")
			if arkanosPlayer == 0 then
				local player1 = arkanos.spawn("player", "start")
				local camera = arkanos.spawn("camera", "start")
				camera.follow(player1)
				vp1.view(arkanos, camera)
				vp1.setScale(4, 4)
				arkanosPlayer = 1
			elseif arkanosPlayer == 1 then
				local player2 = arkanos.spawn("player", "start")
				vp2 = yama.viewports.new()
				vp2.view(arkanos, player2)
				vp2.setScale(4, 4)


				vp1.setSize(yama.screen.width / 2, yama.screen.height)
				vp2.setSize(yama.screen.width / 2, yama.screen.height)
				vp2.setPosition(yama.screen.width / 2)
				arkanosPlayer = 2
			elseif arkanosPlayer == 2 then
				local player3 = arkanos.spawn("player", "start")
				vp3 = yama.viewports.new()
				vp3.view(arkanos, player3)
				vp3.setScale(4, 4)


				vp1.setSize(yama.screen.width / 3, yama.screen.height)
				vp2.setSize(yama.screen.width / 3, yama.screen.height)
				vp2.setPosition(yama.screen.width / 3)
				vp3.setSize(yama.screen.width / 3, yama.screen.height)
				vp3.setPosition((yama.screen.width / 3) * 2)
				arkanosPlayer = 3
			elseif arkanosPlayer == 3 then
				local player4 = arkanos.spawn("player", "start")
				vp4 = yama.viewports.new()
				vp4.view(arkanos, player4)


				vp1.setSize(yama.screen.width / 2, yama.screen.height / 2)
				
				vp2.setSize(yama.screen.width / 2, yama.screen.height / 2)
				vp2.setPosition(yama.screen.width / 2, 0)

				vp3.setSize(yama.screen.width / 2, yama.screen.height / 2)
				vp3.setPosition(0, yama.screen.height / 2)

				vp4.setSize(yama.screen.width / 2, yama.screen.height / 2)
				vp4.setPosition(yama.screen.width / 2, yama.screen.height / 2)

				vp1.setScale(2, 2)
				vp2.setScale(2, 2)
				vp3.setScale(2, 2)
				vp4.setScale(2, 2)

				arkanosPlayer = 4
			end
		end

		-- CUBICLES
		if key == "2" then
			arkanos = yama.maps.load("test/cubicles")
			if arkanosPlayer == 0 then
				local player1 = arkanos.spawn("player", "start")
				vp1.view(arkanos, player1)
				vp1.setScale(4, 4)
				arkanosPlayer = 1
			end
		end


		-- PLATFORM
		if key == "3" then
			arkanos = yama.maps.load("platform/start")
			if arkanosPlayer == 0 then
				local player1 = arkanos.spawn("player", "start")
				vp1.view(arkanos, player1)
				vp1.setScale(0.5, 0.5)
				arkanosPlayer = 1
			end
		end

		-- GRAVITYFALL
		if key == "z" then
			gravityfall = yama.maps.load("test/gravityfall")

			if gravityfallPlayer == 0 then
				player1 = gravityfall.spawn("mplayer", "start")
				vp1.view(gravityfall, player1)
				--vp1.setScale(4, 4)
				gravityfallPlayer = 1
			
			elseif gravityfallPlayer == 1 then
				player2 = gravityfall.spawn("mplayer", "start2")
				vp2 = yama.viewports.new()
				vp2.view(gravityfall, player2)

				--vp2.setScale(4, 4)


				vp1.setSize(yama.screen.width / 2, yama.screen.height)
				vp2.setSize(yama.screen.width / 2, yama.screen.height)
				vp2.setPosition(yama.screen.width / 2)
				gravityfallPlayer = 2
				player2.joystick = 2
			end

		end

		if key == 'v' then
			if player1.destroyed then
				player1 = gravityfall.spawn("mplayer", "start")
				vp1.view(gravityfall, player1)
			end
			if player2.destroyed then
				player2 = gravityfall.spawn("mplayer", "start2")
				vp2.view(gravityfall, player2)
				player2.joystick = 2
			end
		end

		if key == "a" then
			spaceMap = yama.maps.load("space/planets")
			vp1.view(spaceMap)
		end
		if key == "e" then
			arkanos.spawnXYZ("monster", math.random(100, 300), math.random(100, 300), 32)
			arkanos.spawnXYZ("humanoid", math.random(100, 300), math.random(100, 300), 32)
		end
		if key == "q" then
			jonasMap.getEntities().list[1].destroy()
			--entities.new("fplayer", math.random(100, 300), math.random(100, 300), 0, yama.viewports.list.a)
		end


		if key == "0" then
			scaleToggle = scaleToggle + 1
			if scaleToggle > 5 then
				scaleToggle = 1
			end
			vp1.setScale(scaleToggle)
		end
	end

	function love.resize(w, h)
		print(("Window resized to width: %d and height: %d."):format(w, h))
		if vp1 then
			vp1.setSize()
		end
		--yama.screen.resize(w, h)
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