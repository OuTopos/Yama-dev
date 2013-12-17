local viewports = {}

function viewports.new()
	local self = {}

	-- DEBUG
	self.debug = {}
	self.debug.drawcalls = 0

	self.buffer = {}


	self.map = nil
	self.entity = nil

	self.x = x or 0
	self.y = y or 0
	self.r = r or 0

	self.width, self.height = love.window.getDimensions()

	self.sx = 1
	self.sy = 1
	self.csx = 1
	self.csy = 1

	self.zoom = true


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

	function self.camera.setPosition(x, y, center)
		if center then
			self.camera.x = x - self.camera.width / 2 / self.camera.sx
			self.camera.y = y - self.camera.height / 2 / self.camera.sy
		else
			self.camera.x = x
			self.camera.y = y
		end
		self.boundaries.apply()
		--self.camera.x = math.floor(self.camera.x * self.camera.sx + 0.5) / self.camera.sx
		--self.camera.y = math.floor(self.camera.y * self.camera.sy + 0.5) / self.camera.sy
	end

	-- CURSOR
	self.cursor = {}
	self.cursor.x = 0
	self.cursor.y = 0

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

	function self.setBoundaries(x, y, width, height)
		self.boundaries.x = x
		self.boundaries.y = y
		self.boundaries.width = width
		self.boundaries.height = height
	end


	-- MAP VIEW
	self.mapview = {}
	self.mapview.x = 0
	self.mapview.y = 0
	self.mapview.width = 0
	self.mapview.height = 0
	self.mapview.tilewidth = 1
	self.mapview.tilewidth = 1

	-- RESET
	--function self.reset()
	--	print("Why reset?")
		-- Set buffer to empty table.
		--self.buffer = {}

	--	self.debug.redraws = 0
	--end

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


	-- RESIZE
	function self.resize()
		if self.zoom then
			-- This means that scaling will be done by scaling the camera.
			self.canvas = love.graphics.newCanvas(self.width, self.height)
			self.csx, self.csy = 1, 1
		else
			-- This means scaling will be done by scaling the canvas.
			self.canvas = love.graphics.newCanvas(self.width / self.sx, self.height / self.sy)
			self.csx, self.csy = self.sx, self.sy
		end
		-- Setting the filtering for canvas.
		self.canvas:setFilter("nearest", "nearest")

		-- RESIZE CAMERA
		self.camera.width = self.width / self.sx
		self.camera.height = self.height / self.sy

		if self.zoom then
			self.camera.sx = self.sx
			self.camera.sy = self.sy
		else
			self.camera.sx = 1
			self.camera.sy = 1
		end

		-- RESIZE MAP VIEW
		-- Get the tilewidth and tileheight from the map.
		self.mapview.tilewidth, self.mapview.tileheight = self.map.data.tilewidth, self.map.data.tileheight
		-- Get the size of the the map view in tiles (not pixels).
		self.mapview.width = math.ceil(self.camera.width / self.mapview.tilewidth) + 1
		self.mapview.height = math.ceil(self.camera.height / self.mapview.tilewidth) + 1
	end

	-- PARALLAX
	self.parallax = {}
	self.parallax.enabled = false
	self.parallax.factor = 0.1

	-- UPDATE
	function self.update(dt)
		if self.entity then
			self.camera.setPosition(self.entity.x, self.entity.y, true)
		end

		-- UPDATE CAMERA
		self.camera.cx = self.camera.x + self.camera.width / 2
		self.camera.cy = self.camera.y + self.camera.height / 2
		self.camera.radius = yama.g.getDistance(self.camera.cx, self.camera.cy, self.camera.x, self.camera.y)

		-- UPDATE CURSOR
		self.cursor.x = love.mouse.getX() + self.camera.x
		self.cursor.y = love.mouse.getY() + self.camera.y

		-- UPDATE MAP VIEW
		-- Get the new map view coordinates in tiles (not pixels).
		self.mapview.x = math.floor(self.camera.x / self.mapview.tilewidth)
		self.mapview.y = math.floor(self.camera.y / self.mapview.tilewidth)
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
		love.graphics.draw(self.canvas, self.x, self.y, self.r, self.csx, self.csy)

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

	-- MISC

	function self.isEntityInside(entity)
		-- Check distance
		--[[
		if yama.g.getDistance(self.camera.cx, self.camera.cy, entity.getCX(), entity.getCY()) < self.camera.radius + entity.getRadius() then
			return true
		else
			return false
		end
		--]]

		-- Check bounding box
		--local x, y, width, height = entity.getBoundingBox()
		if entity.boundingbox.x + entity.boundingbox.width > self.camera.x and entity.boundingbox.x < self.camera.x + self.camera.width and entity.boundingbox.y + entity.boundingbox.height > self.camera.y and entity.boundingbox.y < self.camera.y + self.camera.height then
			return true
		else
			return false
		end
	end



	function self.setPosition(x, y)
		self.x = x or 0
		self.y = y or 0
	end

	function self.setSize(width, height, sx, sy, zoom)
		self.width = width or yama.screen.width
		self.height = height or yama.screen.height
		self.sx = sx or self.sx
		self.sy = sy or self.sy
		self.zoom = zoom or self.zoom
		self.resize()
	end

	function self.setScale(sx, sy, zoom)
		self.sx = sx or self.sx
		self.sy = sy or sx or self.sy
		if zoom == false then
			self.zoom = false
		else
			self.zoom = true
		end
		self.resize()
	end



	function self.view(map, entity)
		if map then
			if self.map then
				self.map.removeViewport(self)
			end
			self.map = map
			self.map.addViewport(self)

			
			self.resize()
		else
			if self.map then
				self.map.removeViewport(self)
			end
			self.map = nil
		end

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
			self.entity = nil
		end
	end

	function self.getCamera()
		return self.camera
	end

	function self.getMapview()
		return self.mapview
	end

	function self.getBuffer()
		return self.buffer
	end

	function self.getMap()
		return self.map
	end

	function self.getX()
		return self.x
	end

	function self.getY()
		return self.y
	end

	function self.getWidth()
		return self.width
	end

	function self.getHeight()
		return self.height
	end

	function self.getSx()
		return self.sx
	end

	function self.getSy()
		return self.sy
	end

	return self

end

return viewports