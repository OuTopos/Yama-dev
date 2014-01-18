local player = {}

function player.new( map, x, y, z )
	local self = {}
	self.fixtures = {}
	self.worldstates = {}
	self.forces = {}
	self.mass = 1
	self.forces.forceAdjuster = 1

	self.x = x
	self.y = y
	self.z = z

	self.bodyUserdata = {}
	self.bodyUserdata.name = "Unnamed"
	self.bodyUserdata.type = "player"
	self.bodyUserdata.properties = {}
	self.bodyUserdata.callbacks = {}

	self.feetUserdata = {}
	self.feetUserdata.name = "Unnamed"
	self.feetUserdata.type = "feet"
	self.feetUserdata.properties = {}
	self.feetUserdata.callbacks = {}

	self.headUserdata = {}
	self.headUserdata.name = "Unnamed"
	self.headUserdata.type = "feet"
	self.headUserdata.properties = {}
	self.headUserdata.callbacks = {}

	self.shieldUserdata = {}
	self.shieldUserdata.name = "Unnamed"
	self.shieldUserdata.type = "shield"
	self.shieldUserdata.properties = {}
	self.shieldUserdata.callbacks = {}

	self.swordUserdata = {}
	self.swordUserdata.name = "Unnamed"
	self.swordUserdata.type = "melee"
	self.swordUserdata.properties = {}
	self.swordUserdata.callbacks = {}

	--local camera = vp.getCamera()
	--local buffer = vp.addToBuffer()
	--local map = vp.getMap()
	--local swarm = vp.getSwarm()

	-- Common variables
	local width, height = 128, 128
	local ox, oy = width/2, height/2
	local sx, sy = 1, 1
	local r = 0
	self.cx, self.cy = x - ox + width / 2, y - oy + height / 2
	self.radius = yama.tools.getDistance( self.cx, self.cy, x - ox, y - oy)
	self.type = "player"
	self.joystick = 1
	self.worldstates.onGround = false
	self.worldstates.onWall = false

	self.state = nil

	-- BUTTONS --	
	self.buttonShoulderR = 8
	self.buttonFaceA = 9
	self.buttonTriggerR = 3

	local ctrlJumpButtom = self.buttonFaceA
	local ctrlMelee = self.buttonShoulderR
	local ctrlAimShoot = 1

	self.jumpMaxTimer = 0.55	
	self.jumpVelocity = -900
	self.forces.jump = 900
	self.forces.jumpIncreaser = 2200
	self.forces.run = 3000
	self.forces.runJump = 1900
	
	local maxSpeed = 600
	local friction = 0.2
	local stopFriction = 1.0
	local allowjump = true
	local feetContact = nil

	-- SHOOTING --
	local spawntimer = 0
	local bullet = nil
	local bullets = {}
	local bulletImpulse = 900
	local nAllowedBullets = 75

	-- bullet types
	local bulletStandardShieldDamage = 17
	local bulletStandardBodyDamage = 6

	-- MELEE --
	local meleeStandardShieldDamage = 20
	local meleeStandardBodyDamage = 80
	local meleeing = false
	local allowMelee = true
	local meleeTimer = 0
	local meleeMaxTimer = 0.2
	local meleeCoolDownTimer = 0
	local meleeCoolDownMaxTimer = 0.05
	local ctrlMeleeDown = false

	-- SHIELD--
	local shieldMaxHealth = 140
	local shieldKilled = false
	local shieldHealth = shieldMaxHealth
	local shieldOn = true
	local shieldTimer = 0
	local shieldMaxTimer = 3

	-- vars for body --
	local bodyHealth = 100

	-- BUFFER BATCH
	self.bufferBatch = yama.buffers.newBatch(self.x, self.y, 0)
	--spriteJumper = yama.buffers.newDrawable(yama.assets.loadImage("jumper"),self.x, self.y, self.z, r, sx, sy, ox, oy )

	local spriteArrow = yama.buffers.newDrawable(yama.assets.loadImage("directionarrowshootah"), self.x, self.y, 1, 1, sx, sy, 3, 3 )

	local weapon_meleeSprite = yama.buffers.newDrawable( yama.assets.loadImage("melee_weapon"), self.x, self.y, 900, 1, sx, sy, 3, 3 )

	-- ANIMATION
	local animation = yama.animations.new()
	local tileset = yama.assets.tilesets["elisa"]
	local spriteJumper = yama.buffers.newDrawable(tileset.tiles[1], self.x, self.y, 0, 2, sx, sy, tileset.tilewidth/2, -21 )

	-- SHIELD --
	local spriteShield = yama.buffers.newDrawable( yama.assets.loadImage( "shield_2" ), self.x, self.y, 1000, 0, sx, sy, 25, 25 )
	--spriteShield.blendmode = "additive"

	-- shield hit effect --
	---[[
	local ptcSpark = love.graphics.newParticleSystem( yama.assets.loadImage( "spark" ), 1000 )
	ptcSpark:setEmissionRate( 2000 )
	ptcSpark:setSpeed( 100, 200 )
	ptcSpark:setSizes( 0, 1 )
	ptcSpark:setColors( 255, 255, 255, 255, 255, 255, 255, 0 )
	ptcSpark:setPosition( x, y )
	ptcSpark:setEmitterLifetime(0.09)
	ptcSpark:setParticleLifetime(0.25)
	--ptcSpark:setDirection(10)
	ptcSpark:setSpread( math.rad( 90 ) )
	ptcSpark:setTangentialAcceleration(200)
	ptcSpark:setRadialAcceleration(200)
	--ptcSpark:stop()
	local sparks = yama.buffers.newDrawable( ptcSpark, 0, 0, 24 )
	sparks.blendmode = "additive"
	self.distSparkX = 0
	self.distSparkY = 0


	local ptcShieldDestroyed = love.graphics.newParticleSystem( yama.assets.loadImage( "spark" ), 1000 )
	ptcShieldDestroyed:setEmissionRate( 2000 )
	ptcShieldDestroyed:setSpeed( 1, 2 )
	ptcShieldDestroyed:setSizes( 0, 1 )
	ptcShieldDestroyed:setColors( 255, 255, 255, 255, 255, 255, 255, 0 )
	ptcShieldDestroyed:setPosition( x, y )
	ptcShieldDestroyed:setEmitterLifetime(0.3)
	ptcShieldDestroyed:setParticleLifetime(0.2)
	ptcShieldDestroyed:setDirection(10)
	ptcShieldDestroyed:setSpread( math.rad( 0 ) )
	ptcShieldDestroyed:setTangentialAcceleration(200)
	ptcShieldDestroyed:setRadialAcceleration(200)
	--ptcShieldDestroyed:stop()
	local ShieldDestroyed = yama.buffers.newDrawable( ptcShieldDestroyed, 0, 0, 24 )
	ShieldDestroyed.blendmode = "additive"
	--]]

	
	table.insert( self.bufferBatch.data, spriteArrow )
	table.insert( self.bufferBatch.data, spriteJumper )
	table.insert( self.bufferBatch.data, weapon_meleeSprite )
	table.insert( self.bufferBatch.data, spriteShield )
	table.insert( self.bufferBatch.data, sparks )
	table.insert( self.bufferBatch.data, ShieldDestroyed )

	-- Physics
	
	function self.initialize( properties )
		self.bodyUserdata.playerId = properties.id
		self.swordUserdata.playerId = properties.id
		self.shieldUserdata.playerId = properties.id

		self.refreshBufferBatch()
	end

	--self.fixtures.main = love.physics.newFixture( love.physics.newBody( map.world, x, y, "dynamic"), love.physics.newRectangleShape( width, height ) )
	self.fixtures.main = love.physics.newFixture(love.physics.newBody(  map.world, self.x, self.y, "dynamic"), love.physics.newPolygonShape(-13,16, -16,13, -16,-13, -13,-16, 13,-16, 16,-13, 16,13, 13,16), self.mass)
	self.fixtures.main:setGroupIndex( 1 )
	self.fixtures.main:setCategory( 1 )
	self.fixtures.main:setUserData( self.bodyUserdata )
	self.fixtures.main:setRestitution( 0 )
	self.fixtures.main:getBody():setFixedRotation( true )
	self.fixtures.main:getBody():setLinearDamping( 1 )
	self.fixtures.main:getBody():setMass( self.mass )
	self.fixtures.main:getBody():setInertia( 1 )
	self.fixtures.main:getBody():setGravityScale( 9 )
	self.fixtures.main:getBody():setBullet( true )
	self.fixtures.feet1 = love.physics.newFixture(self.fixtures.main:getBody(), love.physics.newPolygonShape( -13,14, -13,16, 13,16, 13,14 ),1)
	self.fixtures.feet1:setSensor(true)
	self.fixtures.feet1:setUserData( self.feetUserdata )
	self.fixtures.head = love.physics.newFixture(self.fixtures.main:getBody(), love.physics.newPolygonShape( -13,-15, -13,-17, 13,-17, 13,-15 ),1)
	self.fixtures.head:setSensor(true)
	self.fixtures.head:setUserData( self.headUserdata )

	self.fixtures.sword = love.physics.newFixture( love.physics.newBody( map.world, self.x+25, self.y, "dynamic"), love.physics.newRectangleShape( 50, 7 ), 1 )
	self.fixtures.sword:setUserData( self.swordUserdata )
	self.fixtures.sword:setGroupIndex( -2 )
	self.fixtures.sword:setMask( 1 )
	self.fixtures.sword:setSensor( true )
	self.fixtures.sword:getBody():setMass( self.mass )

	--self.fixtures.shield = love.physics.newFixture( self.fixtures.main:getBody(), love.physics.newCircleShape( 26 ), 0 )
	self.fixtures.shield = love.physics.newFixture( love.physics.newBody( map.world, self.x, self.y, "dynamic"), love.physics.newCircleShape( 26 ), 0 )
	self.fixtures.shield:setUserData( self.shieldUserdata )
	--self.fixtures.shield:setSensor(true)
	--self.fixtures.shield = love.physics.newFixture(love.physics.newBody( map.world, x, y, "dynamic"), love.physics.newCircleShape( 38 ) )
	self.fixtures.shield:setGroupIndex( -2 )
	--self.fixtures.shield:setCategory( 2 )
	self.fixtures.shield:setMask( 1 )
	self.fixtures.shield:getBody( ):setMass( self.mass )
	--self.fixtures.shield.entity = self
	--shieldJoint = love.physics.newWeldJoint( self.fixtures.shield:getBody(), self.fixtures.main:getBody(), x, y, false )
	--shieldJoint = love.physics.newDistanceJoint( self.fixtures.shield:getBody(), self.fixtures.main:getBody(), x, y, x+1, y+1, false )
	--shieldJoint:setLength(0.1)

	--shieldJoint:setFrequency(-60)
	--shieldJoint:setDampingRatio(-100)
	--self.fixtures.shield:getBody( ):setLinearDamping( 0.001 )
	--self.fixtures.shield:getBody( ):setMass( 0.0001 )
	--self.fixtures.shield:getBody( ):setInertia( 0.01 )
	--self.fixtures.shield:getBody( ):setGravityScale( 0.9 )

	--[[
	local canon = love.physics.newFixture(love.physics.newBody( map.world, x+14, y+3, "dynamic"), love.physics.newRectangleShape( 32, 6 ) )
	canon:setGroupIndex( -1 )
	canonJoint = love.physics.newRevoluteJoint( canon:getBody(), self.fixtures.main:getBody(), x, y, false )
	canonJoint:enableMotor( true )
	--canonJoint = love.physics.newWheelJoint( canon:getBody(), self.fixtures.main:getBody(), x, y, x, y )
	canon:getBody( ):setLinearDamping( 1 )
	canon:getBody( ):setMass( 0.0001 )
	canon:getBody( ):setInertia( 0.01 )
	canon:getBody( ):setGravityScale( 0.9 )
	--]]

	self.joystick = love.joystick.getJoysticks()[1]
	local boostah = 0
	local jumpTimer = 0
	function self.update( dt )
		self.deltaT = dt
		self.xv, self.yv = self.fixtures.main:getBody( ):getLinearVelocity( )
		self.x = x
		self.y = y
		self.z = z
		self.updateInput( dt )
		self.updatePosition( )
		self.updateAnimation( dt )		
		self.updateShield( dt )

		--ptcSpark:start()
		ptcSpark:setPosition( x+self.distSparkX, y+self.distSparkY )
		ptcSpark:update( dt )

		--ptcSpark:start()
		local randOffsetX = math.random( -32, 32 )
		local randOffsetY = math.random( -32, 32 )
		ptcShieldDestroyed:setPosition( x+randOffsetX, y+randOffsetY )
		ptcShieldDestroyed:update( dt )
		

		local count = 0
		for k, v in pairs(self.feetContacts) do
				count = count + 1
		end
		if count > 0 then
			--self.fixtures.main:getBody():applyLinearImpulse( 0, -self.forces.jump*self.forces.forceAdjuster )
			allowjump = true
			self.worldstates.onGround = true								
			jumpTimer = 0
		else
			self.worldstates.onGround = false
		end
		
		if self.worldstates.onGround then
			if math.abs(self.xv) > 0.1 then
				--self.state = "walk"
			else
				--self.state = "idle"
			end
		elseif not self.worldstates.onGround and self.yv < - 0.2 then
			self.state = "jumping"
		elseif not self.worldstates.onGround and self.yv > 0.2 then
			self.state = "falling"
		end
		--print( self.worldstates.onGround )
		--print( self.state )
		--print( self.xv )
	end
	function self.updateInput( dt )
		--self.jumping( dt )
		self.boostJump( dt )
		self.movement( dt )
		self.bulletSpawn( dt )
		self.melee( dt )
		if self.joystick:isDown( ctrlJumpButtom ) then
			self.ctrlJumpDown = true
		end
		if not self.joystick:isDown( ctrlJumpButtom ) and self.ctrlJumpDown then
			self.ctrlJumpDown = false
			jumpTimer = 1
		end
	end

	function self.movement( dt )
		local fx, fy = 0, 0
		local nx = self.joystick:getAxis( 1 )
		local ny = self.joystick:getAxis( 2 )
		local stickdistance = yama.tools.getDistance( 0, 0, nx, ny )
		if stickdistance > 0.22 then			
			if self.worldstates.onGround then
				--print('walk')
				fx = self.forces.run * stickdistance
				self.state = "walk"
				--print( self.xv )
			else
				fx = self.forces.runJump * stickdistance
				--print('runJump')
			end
			
			self.direction = yama.tools.getRelativeDirection( math.atan2( ny, nx ) )
			if love.keyboard.isDown( "right" ) or self.direction == "right" then
				spriteJumper.sx = 1
			elseif love.keyboard.isDown("left") or self.direction == "left" then
				spriteJumper.sx = -1
				fx = - fx
			end
			if maxSpeed > math.abs( self.xv ) then
				self.applyForce( fx, fy )
			end
		elseif self.worldstates.onGround then
			self.state = "idle"
			if self.xv < - 0.1 then
				self.applyForce( 4000, 0 )
			elseif self.xv > 0.1 then
				self.applyForce( -4000, 0 )
			end
		end
	end

	function self.jumping(dt)
		
		-- JUMPING --
		--not allowing jump boost if jump boost button is released and pressed again mid air, must release jump button to be able to jump again (no bunny hopping)
		--print( self.state )
				--if not self.ctrlJumpDown and self.worldstates.onGround and ( love.keyboard.isDown( " " ) or self.joystick:isDown( ctrlJumpButtom ) ) then
		--allowjump
		if not self.ctrlJumpDown and allowjump and ( love.keyboard.isDown( " " ) or self.joystick:isDown( ctrlJumpButtom ) ) then
			self.ctrlJumpDown = true
			self.fixtures.main:getBody():setLinearVelocity( self.xv, self.jumpVelocity )		
		end

		if ( love.keyboard.isDown( " " ) or self.joystick:isDown( ctrlJumpButtom ) ) then
			self.jumpAccelerator( dt, ctrlJumpButtom, self.jumpMaxTimer, self.forces.jumpIncreaser*self.forces.forceAdjuster )
		end
	end
	function self.jumpAccelerator( dt, button, jMaxTimer, jumpIncreaser )
		if jumpTimer < jMaxTimer then
			self.applyForce( 0, -jumpIncreaser )
			jumpTimer = jumpTimer + dt
		end
	end
	
	function self.boostJump( dt )
		if self.isJumping and self.joystick:isGamepadDown( "a" ) then
			if jumpTimer < self.jumpMaxTimer and self.isJumping and self.yv < -200 then
				self.applyForce( 0, -self.forces.jumpIncreaser*self.forces.forceAdjuster )
				jumpTimer = jumpTimer + dt
				--boostah = boostah*(self.xv/self.jumpVelocity)
			end
		end
	end
	
	function self.gamepadpressed( button )
		if button == "a" then
			self.beginJump()
		end
	end
	function self.gamepadreleased( button )
		if button == "a" then
			self.endJump()
		end
	end

	function self.beginJump( )
		if self.worldstates.onGround then
			self.fixtures.main:getBody():setLinearVelocity( self.xv, self.jumpVelocity )
			self.isJumping = true	
		end	
	end

	function self.endJump( )
		self.isJumping = false
	end

	
	function self.bulletSpawn( dt )
		-- BULLETS --

		local nx = self.joystick:getAxis( 3 )
		local ny = self.joystick:getAxis( 4 )
		if yama.tools.getDistance( 0, 0, nx, ny ) > 0.26 then	
			spawntimer = spawntimer - dt
			if spawntimer <= 0 then
				local leftover = math.abs( spawntimer )
				spawntimer = 0.09 - leftover

				if shieldOn then
					self.removeShield( false )
				end

				self.aim = math.atan2( ny, nx )
				local invaim = math.atan2( -ny, -nx )
				local xrad = math.cos( self.aim )
				local yrad = math.sin( self.aim )
				
				local xPosBulletSpawn = x + 38*xrad
				local yPosBulletSpawn = y + 38*yrad
				--print( xPosBulletSpawn, xPosBulletSpawn )
				self.bullet = map.newEntity( "bullet", {xPosBulletSpawn, yPosBulletSpawn, 0} )
				local fxbullet = bulletImpulse * nx
				local fybullet = bulletImpulse * ny				
				
				self.bullet.shoot( fxbullet, fybullet, invaim )
				table.insert( bullets, self.bullet )
				local lenBullets = #bullets				
				if lenBullets >= nAllowedBullets then
					bullets[1].destroy()
					table.remove( bullets, 1 )
				end
			end
		elseif not shieldOn and not shieldKilled then
			self.createShield( shieldHealth )
		end
	end

	function self.melee( dt )
		--print( 'FUNC MELEE' )

		if not self.joystick:isDown( ctrlMelee ) and ctrlMeleeDown then
			ctrlMeleeDown = false
		end

		if not ctrlMeleeDown and meleeTimer < meleeMaxTimer and allowMelee and self.joystick:isDown( ctrlMelee ) then
			ctrlMeleeDown = true
			--print('whopp')
			if meleeTimer == 0 then
				--print('WHAM')
				self.fixtures.sword:setMask( )
				self.fixtures.sword:setGroupIndex( 2 )
				meleeing = true
				self.refreshBufferBatch()
				allowMelee = false
				meleeCoolDownTimer = 0
			end
		end
		if meleeing then
			--print('meleeing')
			meleeTimer = meleeTimer + dt
			if meleeTimer > meleeMaxTimer then
				--print( 'NOTMELEE' )
				self.fixtures.sword:setGroupIndex( -2 )
				self.fixtures.sword:setMask( 1 )
				meleeing = false
				self.refreshBufferBatch()
				meleeTimer = 0
			end
		end
		if not meleeing and meleeCoolDownTimer < meleeCoolDownMaxTimer then
			--print('coolioo')
			meleeCoolDownTimer = meleeCoolDownTimer + dt
			if meleeCoolDownTimer > meleeCoolDownMaxTimer then
				print('reset melee timer')
				allowMelee = true
			end
		end
		--if meleeTimer > meleeMaxTimer then

				
			--print( 'MELEE' )
		--elseif self.fixtures.sword:getMask() ~= 1 and meleeTimer > meleeMaxTimer then

	--	end
	end

	function self.updateAnimation( dt )
		if self.state == "walk" or self.state == "idle" or self.state == "sword" then
			animation.update(dt, "elisa_"..self.state)
		else
			--animation.update(dt, "elisa_die")
		end
		spriteJumper.drawable = tileset.tiles[animation.frame]
		if self.state == "walk" then
			local timescaler = math.abs(self.xv)/maxSpeed
			if timescaler < 0.2 then
				timescaler = 0.2
			end
			animation.timescale = timescaler
		else
			animation.timescale = 0.9
		end
	end

	function self.updateShield( dt )
		if shieldHealth < shieldMaxHealth then
			if shieldTimer <= shieldMaxTimer then
			shieldTimer = shieldTimer + dt
			elseif not shieldOn and shieldKilled then
				local nxx = self.joystick:getAxis( 3 )
				local nyy = self.joystick:getAxis( 4 )
				if yama.tools.getDistance( 0, 0, nxx, nyy ) < 0.26 then
					self.createShield( shieldMaxHealth, false )
				end
			end
		else
			shieldHealth = shieldMaxHealth
			spriteShield.color = { 255, 255, 255, math.floor( 255*( shieldHealth/shieldMaxHealth )+0.5 ) }
		end
	end

	function self.bodyEnergy( damage )
		bodyHealth = bodyHealth - damage
		if bodyHealth <= 0 then
			self.destroy()
		end
	end

	function self.shieldPower( damage )
		shieldHealth = shieldHealth - damage
		spriteShield.color = { 255, 255, 255, math.floor( 255*( shieldHealth/shieldMaxHealth )+0.5 ) } 
		shieldTimer = 0
		if shieldHealth <= 0 and shieldOn then
			self.removeShield( true )
		end
	end

	function self.removeShield( killed )
		--shield:destroy()
		--self.fixtures.shield:setGroupIndex( -2 )
		self.fixtures.shield:setMask( 1, 2 )
		shieldOn = false
		self.refreshBufferBatch()
		shieldKilled = killed
		if killed == true then
			ptcShieldDestroyed:start( )
		end

		--self.destroy()
	end

	function self.createShield( health, killed )
		-- body
		--self.fixtures.shield = love.physics.newFixture( self.fixtures.main:getBody(), love.physics.newCircleShape( 32 ), 0 )
		--self.fixtures.shield:setGroupIndex( -2 )
		--self.fixtures.shield:setUserData( self.shieldUserdata )
		--self.fixtures.shield:setGroupIndex( 2 )
		self.fixtures.shield:setMask( 1 )
		shieldHealth = health
		spriteShield.color = { 255, 255, 255, math.floor( 255 * ( shieldHealth/shieldMaxHealth ) + 0.5 ) }
		shieldOn = true
		self.refreshBufferBatch()
		shieldKilled = killed
		shieldTimer = 0
	end

	function self.applyForce( fx, fy )
		self.fixtures.main:getBody():applyForce( fx, fy )
	end
	self.feetContacts = {}
	function self.feetUserdata.callbacks.beginContact( a, b, contact )
		--print('flooooor')
		
		self.feetContacts[contact] = true

		contact:setRestitution( 1 )
		local userdata = a:getUserData()
		local userdata2 = b:getUserData()
		if userdata2 then
			if userdata2.type == "floor" or userdata2.type == "player" then
				print("feet meets floor")				
		 		jumpTimer = 0
		 		if self.state == "falling" then
		 			--bajs
		 		end
		 	end
		 end
	end
	function self.feetUserdata.callbacks.endContact( a, b, contact )
		print(self.feetContacts[contact], contact)
		self.feetContacts[contact] = nil
		

	--	print('leavefloor')
		contact:setRestitution( 0 )
		local userdata = a:getUserData()
		local userdata2 = b:getUserData()
		if userdata2 then
			if userdata2.type == 'floor' then
				print('feet leaves floor')
		 	end
		 end
	end
	function self.headUserdata.callbacks.beginContact( a, b, contact )
		contact:setRestitution( 0 )
		local userdata = a:getUserData()
		local userdata2 = b:getUserData()
		if userdata2 then
			if userdata2.type == 'floor' then
				print('leavefloor')
				jumpTimer = 1
		 	end
		 end
	end	

	function self.shieldUserdata.callbacks.beginContact( a, b, contact )
		local userdata = b:getUserData()
		local userdata2 = a:getUserData()
		if userdata then
			if userdata.type == 'bullet' then
				print('hitShieldBullet!')
				self.shieldPower( bulletStandardShieldDamage )

				--self.aim = math.atan2( a:getBody:GetX(), b:getBody:GetX() )
				--xrad = math.cos( self.aim )
				--yrad = math.sin( self.aim )

				local sparkx1, sparky1, xxx, yyy = contact:getPositions()		
				
				self.distSparkX = sparkx1 - x				
				self.distSparkY = sparky1 - y
				self.hitDirection = math.atan2( self.distSparkY, self.distSparkX )
				
				ptcSpark:setPosition( sparkx1, sparky1 )
				ptcSpark:setDirection( self.hitDirection )
				ptcSpark:start( )
			elseif userdata.type == 'melee' and userdata.playerId ~= userdata2.playerId then
				print('hitShieldMelee!')
				self.shieldPower( meleeStandardShieldDamage )
			end
		end
	end

	function self.bodyUserdata.callbacks.beginContact( a, b, contact )
		contact:setRestitution( 0 )
		local userdata = a:getUserData()
		local userdata2 = b:getUserData()
		if userdata2 then
		 	if userdata2.type == 'bullet' then
		 		print('hitbodybullet!')
				self.bodyEnergy( bulletStandardBodyDamage )
			elseif userdata2.type == 'melee' and not shieldOn and userdata.playerId ~= userdata2.playerId then
				print('hitBodyMelee!')
				self.bodyEnergy( meleeStandardBodyDamage )
			end
		end
	end

	function self.bodyUserdata.callbacks.endContact( a, b, contact )
		contact:setRestitution( 0 )
		if a:getBody() == self.fixtures.main:getBody() then
			if b:getUserData() then
				if b:getUserData().type == 'floor' then
					--print( 'body leavs floor')
				end
			end
		end
	end
	function self.swordUserdata.callbacks.beginContact( a, b, contact )
	end
--]]
	function self.refreshBufferBatch()

		self.bufferBatch = yama.buffers.newBatch(x, y, z)

		table.insert( self.bufferBatch.data, spriteJumper )
		table.insert( self.bufferBatch.data, spriteArrow )
				
		table.insert( self.bufferBatch.data, sparks )
		table.insert( self.bufferBatch.data, ShieldDestroyed )
		if shieldOn then
			table.insert( self.bufferBatch.data, spriteShield )
		end
		if meleeing then
			table.insert( self.bufferBatch.data, weapon_meleeSprite )
		end
	end

	function self.updatePosition(xn, yn)		
		x = self.fixtures.main:getBody():getX()
		y = self.fixtures.main:getBody():getY()
		r = self.fixtures.main:getBody():getAngle()

		spriteJumper.x = x
		spriteJumper.y = y
		spriteJumper.z = 0
		spriteJumper.r = r
		
		spriteShield.x = x
		spriteShield.y = y
		spriteShield.z = 0
		self.fixtures.shield:getBody():setX( x )
		self.fixtures.shield:getBody():setY( y )

		if spriteJumper.sx == 1 then
			self.fixtures.sword:getBody():setX( x+25 )
			self.fixtures.sword:getBody():setY( y )
			weapon_meleeSprite.x = x --math.floor(x + 0.5)
			weapon_meleeSprite.y = y --math.floor(y-16 + 0.5)
			weapon_meleeSprite.r = r
		else
			self.fixtures.sword:getBody():setX( x-25 )
			self.fixtures.sword:getBody():setY( y )
			weapon_meleeSprite.x = x-50 --math.floor(x + 0.5)
			weapon_meleeSprite.y = y --math.floor(y-16 + 0.5)
			weapon_meleeSprite.r = r
		end

		spriteArrow.x = x --math.floor(x + 0.5)
		spriteArrow.y = y --math.floor(y-16 + 0.5)
		spriteArrow.z = 0
		spriteArrow.r = self.aim
		
		self.bufferBatch.x = x
		self.bufferBatch.y = y
		self.bufferBatch.z = 0
		self.bufferBatch.r = r
	end

	--local animation = {}
	--animation.quad = 1
	--animation.dt = 0

	self.callbacks = {}
	self.callbacks.shield = {}
	---[[

	function self.draw( )
		love.graphics.setColorMode( "modulate" )
		love.graphics.setColor( 255, 255, 255, 255 );
		love.graphics.setBlendMode( "alpha" )
		if hud.enabled then
			physics.draw( self.fixtures.main, { 0, 255, 0, 102 } )
		end
	end

	function self.addToBuffer( vp )
		vp.addToBuffer( self.bufferBatch )
	end
	-- Basic functions
	function self.setPosition( x, y )
		self.fixtures.main.body:setPosition( x, y )
		self.fixtures.main.body:setLinearVelocity( 0, 0 )
	end
	
	function self.getPosition( )
		return self.x, self.y
	end

	function self.destroy( )
		self.fixtures.main:getBody():destroy()
		self.destroyed = true
	end

	-- GET
	function self.getType()
		return type
	end
	function self.getPosition()
		return self.x, self.y, self.z
	end
	function self.getBoundingBox()
		local bx = x - ox * sx
		local by = y - oy * sy

		return bx, by, width * sx, height * sy
	end
	function self.setBoundingBox()
		--print('before'..self.boundingbox.x )
		self.boundingbox.x = x - ox * sx
		self.boundingbox.y = y - oy * sy

		self.boundingbox.width = width * sx
		self.boundingbox.height = height * sy
	end
	return self
end

return player