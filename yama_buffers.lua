local buffers = {}

function buffers.new()
	local self = {}
	self.objects = {}

	function self.add(object)
		if not object[self] then
			table.insert(self.objects, object)
			object[self] = true
			return true
		else
			warning("Buffer object already added. Maybe optimize?")
			return false
		end
	end

	function self.draw()
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

		self.objects = {}
	end

	function self.drawBatch(batch)
		for i = 1, #batch.data do
			self.drawObject(batch.data[i])
		end
	end

	function self.drawObject(object)
		if self.parallax.enabled then
			-- UGLY WIDTH AND HEIGHT
			local factor = object.z / self.map.data.tileheight * self.parallax.factor

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
		--self.debug.drawcalls = self.debug.drawcalls + 1
	end

	return self
end

function buffers.newBatch(x, y, z, data)
	local self = {}
	self.type = "batch"
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
	self.data = data or {}

	function self.setPosition(x, y, z)
		self.x = x or self.x
		self.y = y or self.y 
		self.z = z or self.z 
		for i = 1, #self.data do
			self.data[i].x = self.x
			self.data[i].y = self.y
			self.data[i].z = self.z
		end
	end

	return self
end

function buffers.newDrawable(drawable, x, y, z, r, sx, sy, ox, oy, kx, ky, color, colormode, blendmode)
	local self = {}
	self.type = "drawable"
	self.drawable = drawable
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
	self.r = r or 0
	self.sx = sx or 1
	self.sy = sy or sx or 1
	self.ox = ox or 0
	self.oy = oy or 0
	self.kx = kx or 0
	self.ky = ky or 0
	self.color = color or nil
	self.colormode = colormode or nil
	self.blendmode = blendmode or nil

	return self
end

--[[
function buffers.newSprite(image, quad, x, y, z, r, sx, sy, ox, oy, kx, ky, color, colormode, blendmode)
	local self = {}
	self.type = "sprite"
	self.image = image
	self.quad = quad
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
	self.r = r or 0
	self.sx = sx or 1
	self.sy = sy or sx or 1
	self.ox = ox or 0
	self.oy = oy or 0
	self.kx = kx or 0
	self.ky = ky or 0
	self.color = color or nil
	self.colormode = colormode or nil
	self.blendmode = blendmode or nil
	
	return self
end
]]--


function buffers.setBatchPosition(batch, x, y, z)
	batch.x = x or batch.x
	batch.y = y or batch.y 
	batch.z = z or batch.z 
	for i = 1, #batch.data do
		batch.data[i].x = batch.x
		batch.data[i].y = batch.y
		batch.data[i].z = batch.z
	end
end
function buffers.setBatchQuad(batch, quad)
	for i = 1, #batch.data do
		batch.data[i].quad = quad
	end
end

return buffers