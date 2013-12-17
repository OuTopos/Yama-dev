local cursor = {}

function cursor.new(map, x, y, z)
	local self = {}
	self.boundingbox = {}

	self.vp = nil

	self.userdata = {}
	self.userdata.name = "Unnamed"
	self.userdata.type = "camera"
	self.userdata.properties = {}
	self.userdata.callback = self

	-- ANCHOR/POSITION/SPRITE VARIABLES
	self.radius = 8
	self.mass = 1

	self.x, self.y, self.z = x, y, z
	self.r = 0
	self.width, self.height = 64, 64
	self.sx, self.sy = 1, 1
	self.ox, self.oy = self.width / 2, self.height
	self.aox, self.aoy = 0, self.radius

	self.object = {}
	self.object.x, self.object.y, self.object.z = x, y, z
	self.object.r = 0
	self.object.width, self.object.height = 70, 70
	self.object.sx, self.object.sy = 1, 1



	-- BUFFER BATCH
	self.tileset = yama.assets.tilesets["tiles_spritesheet"]
	self.sprite = yama.buffers.newDrawable(self.tileset.tiles[1], self.x + self.aox, self.y + self.aoy, self.z, self.r, self.sx, self.sy, 0, 0)

	-- BUFFER BATCH
	local bufferBatch = yama.buffers.newBatch(x, y, z)

	-- Destination
	local dx, dy = nil, nil
	local distance = 0


	-- Standard functions
	function self.update(dt)
		if self.vp then
			self.x, self.y = self.vp.cursor.x, self.vp.cursor.y
		end




		self.sprite.x, self.sprite.y, self.sprite.z = self.x, self.y, self.z
		self.sprite.r = self.r
		self.sprite.sx, self.sprite.sy = self.sx, self.sy

		self.setBoundingBox()
	end
	
	function self.addToBuffer(vp)
		vp.addToBuffer(self.sprite)
	end

	function self.follow(entity)
		if entity then
			self.target = entity
		end
	end


	-- GET
	function self.setBoundingBox()
		self.boundingbox.x = self.x - (self.width / 2) * self.sx
		self.boundingbox.y = self.y - (self.height / 2) * self.sy
		self.boundingbox.width = self.width * self.sx
		self.boundingbox.height = self.height * self.sy
	end
	function self.destroy()
		self.anchor:getBody():destroy()
		self.destroyed = true
	end

	return self
end

return cursor