--[[
VIEWPORTS
To do:
 Make smooth camera movement. 
]]--
local viewports = {}

function viewports.new()
	local self = {}

	-- DEBUG
	self.debug = {}
	self.debug.drawcalls = 0

	self.buffer = {}

	self.map = nil
	self.entity = nil

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

	self.camera.speed = 0.1
	self.camera.target = nil

	self.camera.vx = 0
	self.camera.vy = 0

	function self.camera.move(x, y)
		local distance = yama.tools.getDistance(x, y, self.camera.cx, self.camera.cy)
		local direction = math.atan2(y-self.camera.cy, x-self.camera.cx)

		self.camera.vx = math.cos(direction)
		self.camera.vy = math.sin(direction)

		--print(self.camera.vx, distance, self.camera.vx * distance)
		self.camera.cx = self.camera.cx + self.camera.vx * distance/100 * self.camera.speed
		self.camera.cy = self.camera.cy + self.camera.vy * distance/100 * self.camera.speed
	end

	function self.camera.update()
		-- SET THE CX, CY or not.
		if self.entity then
			--self.camera.cx = self.entity.x -- self.camera.width / 2
			--self.camera.cy = self.entity.y -- self.camera.height / 2

			-- New smooth camera stuff
			--local x = self.camera.x
			--local y = self.camera.y
			--table.insert(self.camera.targets, 1, {x = x, y = y})
			--table.remove(self.camera.targets, 4)
			self.camera.move(self.entity.x, self.entity.y)
		end
		-- GET X, Y from CX, XY
		 self.camera.x = self.camera.cx - self.camera.width / 2
		 self.camera.y = self.camera.cy - self.camera.height / 2
		
		self.boundaries.apply()

		if self.camera.round then
			self.ox = self.camera.x - math.floor(self.camera.x * self.camera.sx + 0.5) / self.camera.sx
			self.oy = self.camera.y - math.floor(self.camera.y * self.camera.sx + 0.5) / self.camera.sx
		else
			self.ox = 0
			self.oy = 0
		end
	end

	function self.camera.follow(entity)
		if entity then
			if self.entity then
				self.entity.vp = nil
			end
			self.entity = entity
			entity.vp = self

			self.camera.follow = entity
		else
			if self.entity then
				self.entity.vp = nil
			end

			print("WARNING: VIEWPORT -> No entity specified for camera to follow.")
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
				elseif self.camera.x > self.boundaries.width - self.camera.width then
					self.camera.x = self.boundaries.width - self.camera.width
				end
			else
				self.camera.x = self.boundaries.x - (self.camera.width - self.boundaries.width) / 2
			end

			if self.camera.height <= self.boundaries.height then
				if self.camera.y < self.boundaries.y then
					self.camera.y = self.boundaries.y
				elseif self.camera.y > self.boundaries.height - self.camera.height then
					self.camera.y = self.boundaries.height - self.camera.height
				end
			else
				self.camera.y = self.boundaries.y - (self.camera.height - self.boundaries.height) / 2
			end
		end
	end

	-- RESIZE & ZOOM
	function self.resize(width, height)
		self.width = width or love.window.getWidth()
		self.height = height or love.window.getHeight()

		self.canvas = love.graphics.newCanvas(self.width, self.height)
		--self.canvas:setFilter("linear", "linear")

		self.zoom(self.camera.sx, self.camera.sy)
	end

	function self.zoom(sx, sy)
		self.camera.sx = sx or 1
		self.camera.sy = sy or sx or 1

		self.camera.width = self.width / self.camera.sx
		self.camera.height = self.height / self.camera.sy
		self.camera.radius = yama.tools.getDistance(0, 0, self.camera.width / 2, self.camera.height / 2)
	end

	-- CURSOR
	self.cursor = {}
	self.cursor.x = 0
	self.cursor.y = 0

	function self.cursor.update()
		self.cursor.x = love.mouse.getX() + self.camera.x
		self.cursor.y = love.mouse.getY() + self.camera.y
	end

	function self.addToBuffer(object)
		if not object[self] then
			table.insert(self.buffer, object)
			object[self] = true
			return true
		else
			return false
		end
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
		if a.z < b.z then
			return true
		end
		return false
	end

	function self.depthsorts.y(a, b)
		if a.y < b.y then
			return true
		end
		return false
	end

	function self.depthsorts.yz(a, b)
		if a.y+a.z < b.y+b.z then
			return true
		end
		if a.z == b.z then
			if a.y < b.y then
				return true
			end
			if a.y == b.y then
				if a.x < b.x then
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
		love.graphics.translate(- self.camera.x + self.ox, - self.camera.y + self.oy)
		
		-- SET CANVAS
		love.graphics.setCanvas(self.canvas)

		-- SORT BUFFER
		table.sort(self.buffer, self.depthsorts[self.depthmode])

		-- DRAW BUFFER
		for i = 1, #self.buffer do
			if self.buffer[i].type == "batch" then
				self.drawBatch(self.buffer[i])
			else
				self.drawObject(self.buffer[i])
			end
			self.buffer[i][self] = nil

			-- DEBUG
			self.debug.bufferSize = self.debug.bufferSize + 1
		end

		-- EMPTY BUFFER
		self.buffer = {}

		-- DRAW DEBUG GRAPHICS
		yama.hud.drawR(self)

		-- UNSET CAMERA
		love.graphics.pop()

		-- UNSET CANVAS
		love.graphics.setCanvas()

		-- DRAW CANVAS
		love.graphics.draw(self.canvas, self.x, self.y, self.r, self.sx, self.sy, self.ox, self.oy)

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
		if object.type == "drawable" then
			-- DRAWABLE
			--print(object.x, object.y)
			if self.parallax.enabled then
				-- UGLY WIDTH AND HEIGHT
				local factor = object.z / self.map.data.tileheight * self.parallax.factor

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
		elseif object.type == "sprite" then
			-- SPRITE
			print("THEW FUCK? SPRITES SHOULD NOT BE!")
			love.graphics.draw(object.quad, object.x, object.y, object.r, object.sx, object.sy, object.ox, object.oy, object.kx, object.ky)
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

	-- CONNECTION TO MAP
	function self.connect(map, entity)
		if map and map ~= self.map then
			if self.map then
				self.map.disconnectViewport(self)
			end
			self.map = map
			self.map.connectViewport(self)

			self.resize()

			if entity then
				self.camera.follow(entity)
			end
		else
			print("WARNING: VIEWPORT -> No map specified to connect to.")
		end
	end

	function self.disconnect()
		if self.map then
			self.map.disconnectViewport(self)
		end
		if self.entity then
			self.entity.vp = nil
			self.camera.follow = nil
		end
	end

	return self

end

return viewports