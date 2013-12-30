local player = {}

function player.new(map, x, y, z)
	local self = {}

	self.world = map.world

	self.name = "Jonas"
	self.type = "player"
	self.properties = {}

	-- ANCHOR/POSITION/SPRITE VARIABLES
	self.radius = 10
	self.mass = 1

	self.x, self.y, self.z = x, y, z
	self.r = 0
	self.width, self.height = 96, 64
	self.sx, self.sy = 1, 1
	self.ox, self.oy = 48, 0
	self.aox, self.aoy = 0, 5
	self.sprite = nil

	self.boundingbox = {}

	self.scale = (self.sx + self.sy) / 2

	-- PHYSICS OBJECTS
	self.fixtures = {}

	self.fixtures.body = love.physics.newFixture(love.physics.newBody(self.world, self.x, self.y, "dynamic"), love.physics.newPolygonShape(-11, 0, 11, 0, 14, -3, 14, -35, 11, -38, -11, -38, -14, -35, -14, -3), self.mass)
	--
	self.fixtures.body:setRestitution(0)
	--self.fixtures.body:getBody():setLinearDamping(10)
	self.fixtures.body:getBody():setFixedRotation(true)
	self.fixtures.body:setUserData({type = "player", callbacks = self})


	self.fixtures.feet = love.physics.newFixture(self.fixtures.body:getBody(), love.physics.newPolygonShape(-12, 0, -12, 2, 12, 2, 12, 0))
	self.fixtures.feet:setSensor(true)
	self.fixtures.left = love.physics.newFixture(self.fixtures.body:getBody(), love.physics.newPolygonShape(-14, -8, -14, -30, -16, -30, -16, -8))
	self.fixtures.left:setSensor(true)
	self.fixtures.right = love.physics.newFixture(self.fixtures.body:getBody(), love.physics.newPolygonShape(14, -8, 14, -30, 16, -30, 16, -8))
	self.fixtures.right:setSensor(true)



	self.test = {}

	function self.test.beginContact(a, b, contact)
		print("JADÅ!!!")
	end


	self.weapon = {}
	self.weapon.data = {}
	self.weapon.data.callbacks = self.test
	self.weapon.data.type = "damage"
	self.weapon.data.properties = {}
	self.weapon.data.properties.physical = 3

	--self.fixtures.weapon = love.physics.newFixture(self.fixtures.body:getBody(), love.physics.newPolygonShape(0, 0, 16, -16, 32, -16, 32, 16, 16, 16), 0)
	--self.fixtures.weapon:setUserData(self.weapon.data)
	--self.fixtures.weapon:setSensor(true)
	--self.fixtures.weapon:setMask(1)



	-- Movement variables
	self.velocity = 250 * self.scale
	self.direction = 0
	self.aim = 0
	self.move = false
	self.state = "stand"




	self.states = {}
	self.states.jumping = false
	self.states.inair = false


	--function self.sprite.update()
		--yama.buffers.setBatchPosition(bufferBatch, self:getX() + self.oex, self:getY() + self.oey)
	--end


	self.joystick = 1

	local cooldown = 0

	-- BUFFER BATCH
	local bufferBatch = yama.buffers.newBatch(self.x, self.y, self.z)

	-- ANIMATION
	local animation = yama.animations.new()

	-- SPRITE
	--local tileset = "LPC/body/male/light"
	--images.quads.add(tileset, self.width, self.height)

	local tileset = yama.assets.tilesets["elisa"]
	print(tileset.tiles[1])
	local sprite = yama.buffers.newDrawable(tileset.tiles[1], self.x + self.aox, self.y + self.aoy, self.z, self.r, self.sx, self.sy, self.ox, self.oy)



	tilesetArrow = "directionarrow"
	--images.load(tilesetArrow):setFilter("linear", "linear")
	local spriteArrow = yama.buffers.newDrawable(yama.assets.loadImage(tilesetArrow), self.x, self.y-16, 640, 1, self.sx, self.sy, -24, 12)

	
	table.insert(bufferBatch.data, sprite)
	

	self.joystick = love.joystick.getJoysticks()[1]



	function self.updateInput(dt)
		local nx, ny = 0, 0
		local fx, fy = 0, 0
		local vmultiplier = 1
		animation.timescale = 1
		self.state = "stand"
		--self.fixtures.weapon:setMask(1)

		if self.state == "stand" or self.state == "walk" then

			if love.keyboard.isDown("lctrl") or self.joystick:isDown(1) then
				self.state = "sword"
				wvx = 500 * math.cos(self.direction)
				wvy = 500 * math.sin(self.direction)
				self.fixtures.weapon:setMask()
				vmultiplier = 1
				--self.fixtures.weapon:getBody():setPosition(x, y)
				--self.fixtures.weapon:getBody():setLinearVelocity(wvx, wvy)
			elseif yama.tools.getDistance(0, 0, self.joystick:getAxis(1), self.joystick:getAxis(2)) > 0.2 then
				self.state = "walk"
				nx = self.joystick:getAxis(1)
				ny = self.joystick:getAxis(2)
				self.direction = math.atan2(ny, nx)
				self.aim = self.direction
				vmultiplier = yama.tools.getDistance(0, 0, self.joystick:getAxis(1), self.joystick:getAxis(2))
				if vmultiplier >  1 then
					vmultiplier = 1
				end

			elseif love.keyboard.isDown("right") or love.keyboard.isDown("left") or love.keyboard.isDown("down") or love.keyboard.isDown("up") then
				self.state = "walk"
				if love.keyboard.isDown("right") then
					nx = nx+1
				end
				if love.keyboard.isDown("left") then
					nx = nx-1
				end
				if love.keyboard.isDown("up") then
					ny = ny-1
				end
				if love.keyboard.isDown("down") then
					ny = ny+1
				end
				self.direction = math.atan2(ny, nx)
				self.aim = self.direction
			elseif love.keyboard.isDown(" ") then
				patrol.update(self.fixtures.body:getBody():getX(), self.fixtures.body:getBody():getY())
				if patrol.isActive() then
					self.state = "walk"
					nx, ny = patrol.getPoint()
					self.direction = math.atan2(ny, nx)
					self.aim = self.direction
				else
					self.state = "stand"
				end
			end
		end

		

		if self.state == "walk" then
			if love.keyboard.isDown("lshift") or self.joystick:isDown(5) then
				vmultiplier = vmultiplier * 3
			end
			fx = self.velocity * vmultiplier * math.cos(self.direction)
			fy = self.velocity * vmultiplier * math.sin(self.direction)
			--self.fixtures.body:getBody():setAngle(self.direction)
			self.fixtures.body:getBody():applyForce(fx, fy)
			--animation.timescale = vmultiplier
		end

		if self.state == "sword" then
			animation.timescale = 0.1
		end


		--if yama.tools.getDistance(0, 0, love.joystick.getAxis(self.joystick, 4), love.joystick.getAxis(self.joystick, 5)) > 0.2 then
		if false then
			local nx = love.joystick.getAxis(self.joystick, 4)
			local ny = love.joystick.getAxis(self.joystick, 5)
			self.aim = math.atan2(ny, nx)
		end

		if self.joystick:isGamepadDown("a") and not self.states.jumping then
			self.states.jumping = true
			self.fixtures.body:getBody():applyLinearImpulse( 0, -200 )
		end

	end

	function self.updatePosition()

		-- Position updates
		self.x, self.y = map.translatePosition(self.fixtures.body:getBody():getX(), self.fixtures.body:getBody():getY())
		--self.x, self.y = math.floor(self.x + 0.5), math.floor(self.y + 0.5)
		--self.fixtures.body:getBody():setAngle(self.direction)

		yama.buffers.setBatchPosition(bufferBatch, self.x + self.aox, self.y + self.aoy)

		spriteArrow.x = self.x --math.floor(x + 0.5)
		spriteArrow.y = self.y-16 --math.floor(y-16 + 0.5)
		spriteArrow.r = self.aim


		--particle:setPosition(self.getX(), self.getY()-oy/2)
	end

	-- DEFAULT FUNCTIONS
	function self.initialize(object)
		print("PLAYER INITAD", self.fixtures.body.type())
	end

	function self.update(dt)
		cooldown = cooldown - dt
		self.updateInput(dt)
		self.updatePosition()

		if self.move then
			a = "walk"
		else
			a = "stand"
		end
		--if self.state == "walk" or self.state == "stand" or self.state == "sword" then
		--	animation.update(dt, "humanoid_"..self.state.."_"..yama.tools.getRelativeDirection(self.direction))
		--else
		--	animation.update(dt, "humanoid_die")
		--end
		animation.update(dt, "elisa_idle")
		sprite.drawable = tileset.tiles[animation.frame]

		--self.spores.ox = self.x
		--self.spores.oy = self.y

		--self.p:setPosition(self.x, self.y - 64)
		--self.p:start()
		--self.p:update(dt)

		self.setBoundingBox()
	end

	function self.addToBuffer(vp)
		vp.addToBuffer(bufferBatch)
		vp.addToBuffer(spriteArrow)
		--vp.getBuffer().add(fx)
	end

	function self.destroy()
		print("Destroying player")
		self.fixtures.body:getBody():destroy()
		--self.fixtures.weapon:getBody():destroy()
		self.destroyed = true
	end

	-- GET
	--function self.getType()
	--	return self.type
	--end
	--function self.getPosition()
	--	return self.x, self.y, self.z
	----end
	function self.setBoundingBox()
		self.boundingbox.x = self.x - (self.ox - self.aox) * self.sx
		self.boundingbox.y = (self.y - (self.oy - self.aoy) * self.sy) - self.height
		self.boundingbox.width = self.width * self.sx
		self.boundingbox.height = self.height * self.sy

	--	--return x, y, width, height
	end
	--function self.getBoundingCircle()
	--	local x, y, width, height = self.getBoundingBox()
	--	local cx, cy = x + width / 2, y + height / 2
	--	local radius = yama.tools.getDistance(x, y, cx, cy)

	--	return cx, cy, radius
	--end
	
	return self
end

return player