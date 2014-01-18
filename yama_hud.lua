local hud = {}
hud.enabled = false
hud.physics = false

joysticks = love.joystick.getJoysticks()

--love.graphics.setPointStyle("smooth")
love.graphics.setPointSize(8)

local function drawPaths(viewport)
	for k, path in pairs(viewport.scene.paths) do
		local vertices = {}
		for k = 1, #path.vertices do
			local vertex = path.vertices[k]
			table.insert(vertices, vertex.x)
			table.insert(vertices, vertex.y)
		end
		love.graphics.setColor(255, 0, 255, 255)
		love.graphics.line(vertices)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print(path.name, path.vertices[1].x, path.vertices[1].y)

	end
	love.graphics.setColor(255, 255, 255, 255)
end

local function drawLocations(viewport)
	for k, location in pairs(viewport.scene.locations) do
		love.graphics.setColor(255, 255, 0, 255)
		love.graphics.point(location.x, location.y)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print(location.name, location.x, location.y)

	end
	love.graphics.setColor(255, 255, 255, 255)
end

function hud.drawR(vp)
	if hud.enabled then
		if vp.scene then
			local scene = vp.scene
			local entities = scene.entities

			if hud.physics then
				yama.physics.draw(scene.world, vp.camera)

				drawPaths(vp)
				drawLocations(vp)
			end

			-- Entities

			for i = 1, #entities.list do
				if vp.isEntityInside(entities.list[i]) then
					local x, y, z = entities.list[i].x, entities.list[i].y, entities.list[i].z
					if entities.list[i].boundingbox then
						local left, top, width, height = entities.list[i].boundingbox.x, entities.list[i].boundingbox.y, entities.list[i].boundingbox.width, entities.list[i].boundingbox.height

						love.graphics.setColor(255, 0, 0, 127)
						love.graphics.rectangle( "line", left, top, width, height)
						love.graphics.line(left, top, left + width, top + height)
					end
				
					love.graphics.setColor(255, 255, 255, 255)
					--love.graphics.print(i, left + 2, top + 2)
					love.graphics.point(x, y)
					--love.graphics.setColor(0, 0, 0, 255)
					--love.graphics.print(math.floor(x + 0.5), left + 2, top + 12)
					--love.graphics.print(math.floor(y + 0.5), left + 2, top + 22)
					--love.graphics.print(math.floor(z + 0.5), left + 2, top + 32)
				end
			end
			love.graphics.setColor(255, 255, 255, 255)
		end
	end
end

function hud.draw(vp)
	if hud.enabled then



		-- Draw camera
		local lh = 10
		local left = vp.x
		local right = vp.x + vp.width * vp.sx
		local top = vp.y
		local bottom = vp.y + vp.height * vp.sy
		
		local camera = vp.camera
		--local scene = vp.scene
		local buffer = vp.buffer
		--local entities = scene.entities
		--local world = scene.world

		-- Debug text.
		
		-- Backgrounds
		love.graphics.setColor(0, 0, 0, 127)
		love.graphics.rectangle("fill", left, top, 100, 92)--+#yama.screen.modes*lh)

		love.graphics.rectangle("fill", right-122, top, 120, 160)--+#yama.screen.modes*lh)

		-- Text color
		love.graphics.setColor(0, 255, 0, 255)

		-- FPS
		love.graphics.printf(love.timer.getFPS() .. " fps", 0, 2, vp.width, "right")
		--love.graphics.print("FPS: "..love.timer.getFPS(), right - 39, top + 2)

		-- Entities
		--love.graphics.print("Entities: "..#entities.list, left + 2, top + 2)
		--love.graphics.print("  Visible: "..entities.visible[vp], left + 2, top + 12)
		-- Map
		if false then
			love.graphics.print("Map: "..map.data.width.."x"..map.data.height.."x"..map.data.layercount, left + 2, top + 22)
			--love.graphics.print("  View: "..map.view.width.."x"..map.view.height.." ("..map.view.x..":"..map.view.y..")", left + 2, top + 32)

			love.graphics.print("  Vertices: " ..map.debug.vertexcount, left + 2, top + 32)
			love.graphics.print("  Tiles: ".."/"..map.debug.tilecount, left + 2, top + 42)
			-- Physics
			if world then
				love.graphics.print("Physics: "..world:getBodyCount(), left + 2, top + 52)
			end
			-- Player
			if map.data.player then
				local player = map.data.player
				love.graphics.print("Player: "..player.getX()..":"..player.getY(), left + 2, top + 62)
				love.graphics.print("  Direction: "..player.getDirection().."   "..yama.g.getRelativeDirection(player.getDirection()), left + 2, top + 72)
				love.graphics.print("  Stick: "..love.joystick.getAxis(1, 1), left + 2, top + 82)
				love.graphics.print("  Stick: "..love.joystick.getAxis(1, 2), left + 2, top + 92)
				love.graphics.print("  Distance: "..yama.g.getDistance(0, 0, love.joystick.getAxis(1, 1), love.joystick.getAxis(1, 2)), left + 2, top + 102)
				love.graphics.print("  Button: ", left + 2, top + 112)
			end
		end


		for i, joystick in ipairs(joysticks) do
			love.graphics.print(i, 10, i * 10 + 112)
			love.graphics.print(joystick:getName(), 20, i * 10 + 112)
			love.graphics.print(joystick:getAxis(1), 250, i * 10 + 112)
			love.graphics.print(joystick:getAxis(2), 400, i * 10 + 112)
			love.graphics.print(yama.tools.getDistance(0, 0, joystick:getAxis(1), joystick:getAxis(2)), 550, i * 10 + 112)
			if joystick:isGamepadDown("a") then
				love.graphics.print("A!!!", 10, i * 10 + 122)
			end
		end




		local text = ""

		-- Buffer
		text = text .. "Buffer: " .. vp.debug.bufferSize
		text = text .. "\n Drawcalls: " .. vp.debug.drawcalls

		-- Screen
		text = text .. "\n\nViewport: " .. vp.width .. "x".. vp.height
		text = text .. "\nsx: " .. vp.sx .. " sy: " .. vp.sy
		text = text .. "\nx: " .. vp.x .. " y: " .. vp.y
		text = text .. "\n"

		-- Camera
		text = text .. "\n\nCamera: " .. camera.width .. "x" .. camera.height
		text = text .. "\nsx: " .. camera.sx .. " sy: " .. camera.sy
		text = text .. "\nx: " .. math.floor(camera.x + 0.5) .. " y: " .. math.floor(camera.y + 0.5)
		if false then
			text = text .. " (" .. math.floor(camera.x / map.data.tilewidth) .. ":" .. math.floor(camera.y / map.data.tileheight) .. ")"
		end

		text = text .. "\ncx: " .. math.floor(camera.cx + 0.5) .. " cy:" .. math.floor(camera.cy + 0.5)
		if false then
			text = text .. " (" .. math.floor(camera.cx / map.data.tilewidth) .. ":" .. math.floor(camera.cy / map.data.tileheight) .. ")"
		end


		-- Cursor
		text = text .. "\n\nCursor active: " .. tostring(vp.cursor.active)
		text = text .. "\nx: " .. math.floor(vp.cursor.x + 0.5) .. " y: " .. math.floor(vp.cursor.y + 0.5)




		-- Modes
		--love.graphics.print("Modes", right-118, top + 82)
		--for i = 1, #yama.screen.modes do
		--	love.graphics.print("  "..i..": "..yama.screen.modes[i].width.."x"..yama.screen.modes[i].height, right-118, top + 2+i*lh+80)
		--end

		-- 
		if false then
			love.graphics.print("Player: "..math.floor( player.getX() / map.data.tilewidth)..":"..math.floor( player.getY() / map.data.tileheight), left + 2, top + 152)
			love.graphics.print("  x = "..player.getX(), left + 2, top + 162)
			love.graphics.print("  y = "..player.getY(), left + 2, top + 172)
			love.graphics.print("  z = "..player.getZ(), left + 2, top + 182)
		end



		love.graphics.printf(text, right - 120, top + 2, 120, "left")








		--[[
		if love.joystick.getNumJoysticks() > 0  and false then
			xisDir1, axisDir2, axisDirN = love.joystick.getAxes( 1 )
			love.graphics.print(xisDir1, left + 2, top + 52)
			love.graphics.print(axisDir2, left + 2, top + 62)
			love.graphics.print(love.joystick.getNumAxes(1), left + 2, top + 72)
		end
		--]]

		love.graphics.setColor(255, 255, 255, 255)
	end
end

return hud