local capsule = {}

function capsule.load()
	love.window.setTitle("Yama Editor")
	love.window.setMode(1280, 720, {
		fullscreen = false,
		fullscreentype = "desktop",
		vsync = false,
		fsaa = 0,
		resizable = true,
		borderless = false,
		centered = true,
	})
	capsule.map = yama.maps.load("editor2")
	capsule.p1 = capsule.map.spawnXYZ("cursor", 200, 200, 0)
	capsule.vp1 = yama.viewports.new()
	capsule.p1.vp = capsule.vp1
	capsule.vp1.view(capsule.map)

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

		if key == "k" then
			if capsule.vp1.parallax.enabled then
				capsule.vp1.parallax.enabled = false
			else
				capsule.vp1.parallax.enabled = true
			end
		end
	end

	-- FILE WRITE STUFF
	--love.filesystem.setIdentity("Yama")

	local table = {}
	table.a = "En sträng"
	table.b = 123
	table[1] = true
	table.d = {a = "sträng sträng", b = "balle"}

	print(yama.tools.serialize(table))

	local table = {"abs", 3, false, true, 567, "jadå", {"meta", 123, true}, "undra om det gick"}
	print(yama.tools.serialize(table))

	testfile = love.filesystem.newFile("TESTTEST.lua", "w")
	testfile:write("return ")
	testfile:write(yama.tools.serialize(yama.assets))
	testfile:close()

	--love.filesystem.createDirectory(yama.paths.capsules)
	love.filesystem.createDirectory(yama.paths.capsule)
	print(love.filesystem.getIdentity())
	print(love.filesystem.getWorkingDirectory( ))
	print(love.filesystem.getSaveDirectory( ))


end



function capsule.update(dt)
	if love.keyboard.isDown("w") then
		capsule.vp1.camera.y = capsule.vp1.camera.y - 1000 * dt
	end
	if love.keyboard.isDown("a") then
		capsule.vp1.camera.x = capsule.vp1.camera.x - 1000 * dt
	end
	if love.keyboard.isDown("s") then
		capsule.vp1.camera.y = capsule.vp1.camera.y + 1000 * dt
	end
	if love.keyboard.isDown("d") then
		capsule.vp1.camera.x = capsule.vp1.camera.x + 1000 * dt
	end

	if love.mouse.isDown("l") then
		capsule.vp1.parallax.factor = capsule.vp1.parallax.factor + 0.1 * dt
	elseif love.mouse.isDown("r") then
		capsule.vp1.parallax.factor = capsule.vp1.parallax.factor - 0.1 * dt
	end
end

return capsule