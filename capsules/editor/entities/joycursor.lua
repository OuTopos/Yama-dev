local cursor = {}

function cursor.new(map, x, y, z)
	local self = {}
	self.boundingbox = {}

	-- ANCHOR/POSITION/SPRITE VARIABLES
	self.radius = 8
	self.mass = 1

	self.x, self.y, self.z = x, y, 1
	self.r = 0
	self.width, self.height = 64, 64
	self.sx, self.sy = 1, 1
	self.ox, self.oy = self.width / 2, self.height
	self.aox, self.aoy = 0, self.radius

	-- ASSET
	self.asset = {}
	self.asset.x, self.asset.y, self.asset.z = self.x, self.y, self.z
	self.asset.r = 0
	self.asset.sx, self.asset.sy = 1, 1

	-- BUFFER BATCH
	self.tileset = yama.assets.tilesets["tiles_spritesheet"]
	self.sprite = yama.buffers.newDrawable(self.tileset.tiles[1], self.x + self.aox, self.y + self.aoy, self.z, self.r, self.sx, self.sy, self.ox, self.oy)

	-- Destination
	local dx, dy = nil, nil
	local distance = 0

	self.speed = 1000

	self.joystick = love.joystick.getJoysticks()[1]


	-- Standard functions
	function self.update(dt)
		local controlAsset = nil

		if self.controlmode == "asset" then


		end
		-- JOYSTICK

		-- Move
		local axis = {}
		axis.x = self.joystick:getAxis(3)
		axis.y = self.joystick:getAxis(4)

		local multiplier = (1 - self.joystick:getAxis(6)) / 2
		print(multiplier)
		if yama.g.getDistance(0, 0, axis.x, axis.y) > 0.2 then
			self.x = self.x + axis.x * self.speed * dt * multiplier
			self.y = self.y + axis.y * self.speed * dt * multiplier
		end

		-- ASSET

		-- Rotate
		local rotate = {}

		self.asset.x = self.x
		self.asset.y = self.y

		-- Update the soprite
		self.sprite.x = self.asset.x
		self.sprite.y = self.asset.y
		self.sprite.z = self.asset.z
		self.sprite.r = self.asset.r
		self.sprite.sx = self.asset.sx
		self.sprite.sy = self.asset.sy

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