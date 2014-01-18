--[[
VIEWPORTS
To do:
 Make smooth camera movement. 
]]--
local viewports = {}
viewports.list = {}

function viewports.new()
	local self = {}

	-- DEBUG
	self.debug = {}
	self.debug.drawcalls = 0

	self.buffer = {}

	self.scene = nil

	-- CANVAS
	self.x = 0
	self.y = 0
	self.r = 0
	self.sx = 1
	self.sy = 1
	self.ox = 0
	self.oy = 0
	self.width, self.height = love.window.getDimensions()

	-- CAMERA
	self.camera = {}
	self.camera.x = 0
	self.camera.y = 0
	self.camera.r = 0

	self.camera.width, self.camera.height = self.width, self.height

	self.camera.sx = 1
	self.camera.sy = 1

	self.camera.cx = 0
	self.camera.cy = 0
	self.camera.radius = 0

	self.camera.round = false

	self.camera.targets = {}

	self.camera.speed = 5
	self.camera.target = nil

	self.camera.vx = 0
	self.camera.vy = 0

	-- RESIZE & ZOOM
	function self.resize(width, height)
		self.width = width or love.window.getWidth()
		self.height = height or love.window.getHeight()

		self.canvas = love.graphics.newCanvas(self.width, self.height)
		self.canvas:setFilter("linear", "linear")

		self.zoom(self.camera.sx, self.camera.sy)
	end

	function self.zoom(sx, sy)
		self.camera.sx = sx or 1
		self.camera.sy = sy or sx or 1

		self.camera.width = self.width / self.camera.sx
		self.camera.height = self.height / self.camera.sy
		self.camera.radius = yama.tools.getDistance(0, 0, self.camera.width / 2, self.camera.height / 2)
	end

	function self.follow(entity)
		if entity then
			if self.camera.target then
				self.camera.target.vp = nil
			end
			self.camera.target = entity
			entity.vp = self

			self.camera.target = entity
		else
			if self.camera.target then
				self.camera.target.vp = nil
			end

			warning("No entity specified for camera to follow.")
		end
	end

	function self.camera.move(x, y)
		local distance = yama.tools.getDistance(x, y, self.camera.cx, self.camera.cy)
		local direction = math.atan2(y-self.camera.cy, x-self.camera.cx)

		self.camera.vx = math.cos(direction)
		self.camera.vy = math.sin(direction)

		--print(self.camera.vx, distance, self.camera.vx * distance)
		self.camera.cx = self.camera.cx + self.camera.vx * distance/1000 * self.camera.speed
		self.camera.cy = self.camera.cy + self.camera.vy * distance/1000 * self.camera.speed
	end

	function self.camera.update()
		-- SET THE CX, CY or not.
		if self.camera.target then
			--self.camera.cx = self.camera.target.x -- self.camera.width / 2
			--self.camera.cy = self.camera.target.y -- self.camera.height / 2

			-- New smooth camera stuff
			--local x = self.camera.x
			--local y = self.camera.y
			--table.insert(self.camera.targets, 1, {x = x, y = y})
			--table.remove(self.camera.targets, 4)
			--self.camera.move(self.camera.target.x, self.camera.target.y)
			self.camera.cx = self.camera.target.x
			self.camera.cy = self.camera.target.y
			self.camera.z = self.camera.target.z
			--print(self.camera.z+self.camera.y)
			--self.camera.z = self.camera.target.z
		end
		-- GET X, Y from CX, XY
		self.camera.x = self.camera.cx - self.camera.width / 2
		self.camera.y = self.camera.cy - self.camera.height / 2
		
		self.boundaries.apply()

		if self.camera.round then
			self.ox = (self.camera.x - math.floor(self.camera.x + 0.5)) * self.camera.sx
			self.oy = (self.camera.y - math.floor(self.camera.y + 0.5))  * self.camera.sy
			self.camera.x = math.floor(self.camera.x + 0.5)
			self.camera.y = math.floor(self.camera.y + 0.5)
		else
			self.ox = 0
			self.oy = 0
		end
	end

	-- BOUNDARIES
	self.boundaries = {}
	self.boundaries.x = 0
	self.boundaries.y = 0
	self.boundaries.width = 0
	self.boundaries.height = 0

	function self.boundaries.apply()
		if not (self.boundaries.x == 0 and self.boundaries.y == 0 and self.boundaries.width == 0 and self.boundaries.height == 0) then
			if self.camera.width <= self.boundaries.width then
				if self.camera.x < self.boundaries.x then
					self.camera.x = self.boundaries.x
					self.camera.cx = self.camera.x + self.camera.width / 2
				elseif self.camera.x > self.boundaries.width - self.camera.width then
					self.camera.x = self.boundaries.width - self.camera.width
					self.camera.cx = self.camera.x + self.camera.width / 2
				end
			else
				self.camera.x = self.boundaries.x - (self.camera.width - self.boundaries.width) / 2
			end

			if self.camera.height <= self.boundaries.height then
				if self.camera.y < self.boundaries.y then
					self.camera.y = self.boundaries.y
					self.camera.cy = self.camera.y + self.camera.height / 2
				elseif self.camera.y > self.boundaries.height - self.camera.height then
					self.camera.y = self.boundaries.height - self.camera.height
					self.camera.cy = self.camera.y + self.camera.height / 2
				end
			else
				self.camera.y = self.boundaries.y - (self.camera.height - self.boundaries.height) / 2
			end
		end
	end

	-- CURSOR
	self.cursor = {}
	self.cursor.x = 0
	self.cursor.y = 0
	self.cursor.active = false

	function self.cursor.update()
		self.cursor.x = love.mouse.getX() + self.camera.x
		self.cursor.y = love.mouse.getY() + self.camera.y

		if self.cursor.x > self.x and self.cursor.x < self.width * self.sx and self.cursor.y > self.y and self.cursor.y < self.height * self.sy then
			self.cursor.active = true
		else
			self.cursor.active = false
		end
	end

	function self.addToBuffer(object)
		--if not object[self] then
			table.insert(self.buffer, object)
		--	object[self] = true
		--	return true
		--else
		--	error("already added to buffer")
		--	return false
		--end
	end

	-- DEPTH SORTING
	self.depthmode = "z"
	self.depthsorts = {}

	function self.setDepthMode(mode)
		if self.depthsorts[mode] then
			self.depthmode = mode
		else
			self.depthmode = "z"
		end
	end

	function self.depthsorts.z(a, b)
		if a.z > b.z then
			return true
		end
		return false
	end

	function self.depthsorts.y(a, b)
		if a.y > b.y then
			return true
		end
		return false
	end

	function self.depthsorts.yz(a, b)
		if a.y+a.z > b.y+b.z then
			return true
		end
		if a.z == b.z then
			if a.y > b.y then
				return true
			end
			if a.y == b.y then
				if a.x > b.x then
					return true
				end
			end
		end
		return false
	end

	-- PARALLAX
	self.parallax = {}
	self.parallax.enabled = false
	self.parallax.factor = 0.1

	-- UPDATE
	function self.update(dt)
		self.camera.update()
		self.cursor.update()
	end


	-- DRAW
	function self.draw()
		-- DEBUG
		self.debug.bufferSize = 0
		self.debug.drawcalls = 0

		-- SET CAMERA
		love.graphics.push()
		love.graphics.translate(self.camera.width / 2 * self.camera.sx, self.camera.height / 2 * self.camera.sy)
 		love.graphics.rotate(- self.camera.r)
		love.graphics.translate(- self.camera.width / 2 * self.camera.sx, - self.camera.height / 2 * self.camera.sy)
		love.graphics.scale(self.camera.sx, self.camera.sy)
		love.graphics.translate(- self.camera.x, - self.camera.y)
		
		-- SET CANVAS
		love.graphics.setCanvas(self.canvas)

		-- SORT BUFFER
		table.sort(self.buffer, self.depthsorts[self.depthmode])

		-- DRAW BUFFER
		for i = #self.buffer, 1, -1 do
			local object = table.remove(self.buffer)
			if object.type == "batch" then
				self.drawBatch(object)
			else
				self.drawObject(object)
			end
			--self.buffer[i][self] = nil

			-- DEBUG
			self.debug.bufferSize = self.debug.bufferSize + 1
		end

		-- EMPTY BUFFER
		self.buffer = nil
		self.buffer = {}

		-- DRAW DEBUG GRAPHICS
		yama.hud.drawR(self)

		-- UNSET CAMERA
		love.graphics.pop()

		-- UNSET CANVAS
		love.graphics.setCanvas()

		-- DRAW CANVAS
		if self.canvas then
			love.graphics.draw(self.canvas, self.x, self.y, self.r, self.sx, self.sy, self.ox, self.oy)
		end

		-- DRAW GUI
		yama.gui.draw(self)

		-- DRAW DEBUG TEXT
		yama.hud.draw(self)
	end

	function self.drawBatch(batch)
		for i = 1, #batch.data do
			self.drawObject(batch.data[i])
		end
	end

	function self.drawObject(object)
		-- THE ACTUAL DRAW
		if object.drawable then
			-- DRAWABLE
			--print(object.x, object.y)
			if self.parallax.enabled and self.depthmode == "z" then
				-- UGLY WIDTH AND HEIGHT
				local factor = object.z / 32 * self.parallax.factor

			--	local w, h = self.map.data.width * self.map.data.tilewidth, self.map.data.height * self.map.data.tileheight
			--	local cox = self.camera.cx - w / 2
			--	print("NEW OBJECT, factor: ", factor)
				--print((w * (object.sx + factor) - w) / 2)
				--print(object.z, factor, cox * factor)
			--	local testx = (w * (object.sx + factor) - w) / 2 -- self.camera.cx * factor
			--	local coxpercent = cox / w * (object.sx + factor) / 2
			--	print(testx, coxpercent, coxpercent * testx)
				--local cameraox = self.camera.cx / w / 2
				--print(testx, object.z, factor, cameraox * testx)

				local x = object.x - self.camera.cx * factor
				local y = object.y - self.camera.cy * factor
				local sx = object.sx + factor
				local sy = object.sy + factor
				if sx < 0 then
					sx = 0
				end
				if sy < 0 then
					sy = 0
				end

				love.graphics.draw(object.drawable, x, y, object.r, sx, sy, object.ox, object.oy, object.kx, object.ky)
			else
				love.graphics.draw(object.drawable, object.x, object.y, object.r, object.sx, object.sy, object.ox, object.oy, object.kx, object.ky)
			end
			self.debug.drawcalls = self.debug.drawcalls + 1
		end
	end

	-- BOUNDING VOLUME CHECK
	function self.isEntityInside(entity)
		if entity.boundingbox then
			if entity.boundingbox.x + entity.boundingbox.width > self.camera.x and entity.boundingbox.x < self.camera.x + self.camera.width and entity.boundingbox.y + entity.boundingbox.height > self.camera.y and entity.boundingbox.y < self.camera.y + self.camera.height then
				return true
			else
				return false
			end
		elseif entity.boundingcircle then
			if yama.tools.getDistance(self.camera.cx, self.camera.cy, entity.boundingcircle.x, entity.boundingcircle.y) < self.camera.radius + entity.boundingcircle.radius then
				return true
			else
				return false
			end
		else
			return true
		end
	end

	-- CONNECTION TO SCENE
	function self.connect(scene, entity)
		if scene and scene ~= self.scene then
			if self.scene then
				self.scene.disconnectViewport(self)
			end
			self.scene = scene
			self.scene.connectViewport(self)

			self.resize()

			if entity then
				self.follow(entity)
				self.camera.cx = entity.x
				self.camera.cy = entity.y
			end
		else
			print("WARNING: VIEWPORT -> No scene specified to connect to.")
		end
	end

	function self.disconnect()
		if self.scene then
			self.scene.disconnectViewport(self)
		end
		if self.camera.target then
			self.camera.target.vp = nil
			self.camera.follow = nil
		end
	end

	table.insert(viewports.list, self)
	return self
end

function viewports.update(dt)
	for k = 1, #viewports.list do
		viewports.list[k].update(dt)
	end
end

function viewports.draw()
	for k = 1, #viewports.list do
		viewports.list[k].draw()
	end
end

return viewports