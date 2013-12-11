local buffers = {}

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