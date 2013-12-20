local camera = {}

function camera.new(map, x, y, z)
	local self = {}
	self.boundingbox = {}

	self.userdata = {}
	self.userdata.name = "Unnamed"
	self.userdata.type = "camera"
	self.userdata.properties = {}
	self.userdata.callback = self

	-- ANCHOR/POSITION/SPRITE VARIABLES
	self.radius = 8
	self.mass = 1

	self.x, self.y = x, y
	self.r = 0
	self.width, self.height = 64, 64
	self.sx, self.sy = 1, 1
	self.ox, self.oy = self.width / 2, self.height
	self.aox, self.aoy = 0, self.radius

	-- PHYSICS OBJECT
	self.anchor = love.physics.newFixture(love.physics.newBody(map.world, self.x, self.y, "dynamic"), love.physics.newCircleShape(self.radius), self.mass)
	self.anchor:getBody():setLinearDamping(100)
	self.anchor:getBody():setFixedRotation(true)
	self.anchor:setSensor(true)

	-- Movement variables
	local mass = 1
	local velocity = 75
	local direction = math.atan2(math.random(-1, 1), math.random(-1, 1))
	local move = false

	-- BUFFER BATCH
	local bufferBatch = yama.buffers.newBatch(x, y, z)

	-- ANIMATION
	local animation = yama.animations.new()
	animation.set("eyeball_walk_down")
	animation.timescale = math.random(9, 11)/10

	-- Destination
	local dx, dy = nil, nil
	local distance = 0


	-- Standard functions
	function §.update(dt)

		distance = yama.distance(self.anchor:getBody():getX(), self.anchor:getBody():getY(), self.target.x, self.target.y)

		if distance > 1 then
			if self.target.x and self.target.y then
				dx, dy = self.target.x, self.target.y
				move = true
			else
				dx, dy = nil, nil
				move = false
			end

			if dx and dy then
				direction = math.atan2(dy-self.anchor:getBody():getY(), dx-self.anchor:getBody():getX())
			end

			if move then
				fx = velocity * math.cos(direction) * distance
				fy = velocity * math.sin(direction) * distance
				self.anchor:getBody():applyForce( fx, fy )
			end
		end

		-- Position updates
		self.x = self.anchor:getBody():getX()
		self.y = self.anchor:getBody():getY() - 22

		self.setBoundingBox()
	end
	
	function self.addToBuffer(vp)
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

return camera