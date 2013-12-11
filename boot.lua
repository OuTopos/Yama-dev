local boot = {}

function boot.start()
	love.load = yama.boot.load
	love.update = yama.boot.update
	love.draw = yama.boot.draw

	love.keypressed = yama.boot.keypressed
	love.textinput = yama.boot.textinput
end

function boot.load()
	love.window.setTitle("Yama bootloader")
	love.window.setIcon(love.image.newImageData("boot/icon.png"))
	love.window.setMode(840, 570, {
		fullscreen = false,
		fullscreentype = "desktop",
		vsync = false,
		fsaa = 0,
		resizable = false,
		borderless = true,
		centered = true,
	})

	love.graphics.setDefaultFilter("nearest", "nearest")
	boot.font = love.graphics.newImageFont(love.graphics.newImage("boot/font.png"),"!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ")
	love.graphics.setFont(boot.font)

	boot.color = {124, 112, 220, 255}
	boot.bgcolor = {62, 50, 162, 255}


	boot.msg = "\n**** YAMA 64 BASIC V2 ****\n\n64K RAM SYSTEM 1337 BASIC BYTES FREE"
	boot.text = "\n\n\n\n\nREADY.\n"
	boot.line = ""

	boot.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())

	boot.capsules = {}

	if love.filesystem.exists(yama.paths.capsules) then
		local capsules = love.filesystem.getDirectoryItems(yama.paths.capsules)
		for k, capsule in ipairs(capsules) do
			if love.filesystem.exists(yama.paths.capsules .. capsule .. "/main.lua") then
				table.insert(boot.capsules, capsule)
			end
		end
	end
end

function boot.update(dt)
	local linecount = 0
	for lb in string.gmatch(boot.text, "[\n]") do
		linecount = linecount + 1
	end

	if linecount > 25 then
		for i = linecount, 25, - 1 do
			boot.msg = ""
			boot.text = boot.text:sub(boot.text:find("[\n]") + 1 )
		end
	end
end

function boot.draw()
	love.graphics.setCanvas(boot.canvas)

	love.graphics.setColor(boot.color)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	love.graphics.setColor(boot.bgcolor)
	love.graphics.rectangle("fill", 60, 60, 720, 450)

	love.graphics.setColor(boot.color)
	love.graphics.printf(boot.msg, 60, 60, 720 / 2, "center", 0, 2, 2)
	love.graphics.printf(boot.text .. boot.line, 60, 60, 720 / 2, "left", 0, 2, 2)

	love.graphics.setCanvas()


	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(boot.canvas, 0, 0)
end

function boot.keypressed(key)
	if key == "escape" then
		love.event.push("quit")
	elseif key == "backspace" then
		boot.line = boot.line:sub(1, #boot.line - 1)
	elseif key == "delete" then
		boot.msg = ""
		boot.text = "READY.\n"
		boot.line = ""
	elseif key == "return" or key == "kpenter" then
		boot.run()
	elseif key == "f1" then
		boot.run("run 1")
	elseif key == "f2" then
		boot.run("run 2")
	elseif key == "f3" then
		boot.run("run 3")
	elseif key == "f4" then
		boot.run("run 4")
	elseif key == "f5" then
		boot.run("run 5")
	elseif key == "f6" then
		boot.run("run 6")
	elseif key == "f7" then
		boot.run("run 7")
	elseif key == "f8" then
		boot.run("run 8")
	elseif key == "f9" then
		boot.run("run 9")
	elseif key == "f10" then
		boot.run("run 10")
	elseif key == "f11" then
		boot.run("run 11")
	elseif key == "f12" then
		boot.run("run 12")
	end

end

function boot.textinput(text)
	text = text:upper()
	boot.line = boot.line .. text
end

function boot.run(line)
	local line = line or boot.line
	boot.text = boot.text .. boot.line .. "\n"
	boot.line = ""

	local cmd = ""
	local args = {}

	for word in line:gmatch("%w+") do
		if cmd == "" then
			cmd = word:lower()
		else
			table.insert(args, word:lower())
		end	
	end

	if boot.commands[cmd] then
		boot.commands[cmd](unpack(args))
	else
		boot.text = boot.text .. "COMMAND NOT FOUND.\n"	
	end

	boot.text = boot.text .. "READY.\n"
end

boot.commands = {}

function boot.commands.list()
	for k, capsule in ipairs(boot.capsules) do
		boot.text = boot.text .. "".. k .. "." .. capsule:upper() .. "\n"
	end
end

function boot.commands.run(capsule)
	if capsule then
		capsule = tonumber(capsule)
	end
	if boot.capsules[capsule] then
		boot.text = boot.text .. "LOADING." .. boot.capsules[capsule]:upper() .. "\n"
		print("INFO: BOOT -> Starting capsule " .. boot.capsules[capsule])
		yama.start(boot.capsules[capsule])
		yama.boot = nil
		love.load()
	else
		boot.text = boot.text .. "CAPSULE NOT FOUND.\n"
	end
end

function boot.commands.color(r, g, b)
	r, g, b = tonumber(r), tonumber(g), tonumber(b)
	if r and g and b then
		if r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 then
			boot.color = {r, g, b, 255}
		else
			boot.text = boot.text .. "INVALID COLOR.\n"
		end
	else
		boot.text = boot.text .. "INVALID COLOR.\n"
	end
end

function boot.commands.bgcolor(r, g, b)
	r, g, b = tonumber(r), tonumber(g), tonumber(b)
	if r and g and b then
		if r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 then
			boot.bgcolor = {r, g, b, 255}
		else
			boot.text = boot.text .. "INVALID COLOR.\n"
		end
	else
		boot.text = boot.text .. "INVALID COLOR.\n"
	end
end

return boot