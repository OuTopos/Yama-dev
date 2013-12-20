local player = {}

function player.new( map, x, y, z )
	local self = {}
	self.boundingbox = {}

	self.x = x
	self.y = y
	self.z = z

	yc1 = nil

	local userdata = {}
	userdata.name = "Unnamed"
	userdata.type = "mplayer"
	userdata.properties = {}
	userdata.callback = self

	local shieldUserdata = {}
	shieldUserdata.name = "Unnamed"
	shieldUserdata.type = "shield"
	shieldUserdata.properties = {}
	shieldUserdata.callback = self

	local swordUserdata = {}
	swordUserdata.name = "Unnamed"
	swordUserdata.type = "melee"
	swordUserdata.properties = {}
	swordUserdata.callback = self

	--local camera = vp.getCamera()
	--local buffer = vp.addToBuffer()
	--local map = vp.getMap()
	--local swarm = vp.getSwarm()

	-- Common variables
	local width, height = 32, 32
	local ox, oy = width/2, height/2
	local sx, sy = 1, 1
	local r = 0
	self.cx, self.cy = x - ox + width / 2, y - oy + height / 2
	self.radius = yama.g.getDistance( self.cx, self.cy, x - ox, y - oy)
	self.type = "player"
	self.joystick = 1
	
	local aim = 0

	local remove = false
	local doLeg = 1

	-- BUTTONS --	
	buttonShoulderR = 8
	buttunFaceA = 9
	buttunTriggerR = 3

	ctrlJumpButtom = buttunFaceA
	ctrlMelee = buttonShoulderR
	ctrlAimShoot = 1

	local xvel, yvel = 0, 0
	local speed = 0
	local direction = 0
	local onGround = false
	local pContact = nil
	local jumpTimer = 0
	local jumpMaxTimer = 0.35
	local jumpForce = 900
	local jumpIncreaser = 1900
	local xForce = 4500
	local xJumpForce = 1900
	local maxSpeed = 600
	local friction = 0.2
	local stopFriction = 0.7
	local allowjump = true

	-- SHOOTING --
	local spawntimer = 0
	local bullet = nil
	local bullets = {}
	local bulletImpulse = 900
	local nAllowedBullets = 75

	-- bullet types
	local bulletStandardShieldDamage = 20
	local bulletStandardBodyDamage = 1.5

	-- MELEE --
	local meleeStandardShieldDamage = 1
	local meleeStandardBodyDamage = 80
	local meleeing = false
	local allowMelee = true
	local meleeWeaponMaskP1 = nil
	local meleeWeaponGroupIndexP1 = 3
	local meleeWeaponMaskP2 = nil
	local meleeWeaponGroupIndexP2 = nil
	local meleeTimer = 0
	local meleeMaxTimer = 0.2
	local meleeCoolDownTimer = 0
	local meleeCoolDownMaxTimer = 0.1

	-- SHIELD--
	local shieldMaxHealth = 140
	local shieldKilled = false
	local shieldHealth = shieldMaxHealth
	local shieldOn = true
	local shieldTimer = 0
	local shieldMaxTimer = 3
	local shieldMaskP1 = nil
	local shieldGroupIndexP1 = nil
	local shieldMaskP2 = nil
	local shieldGroupIndexP2 = nil

	-- vars for body --
	local bodyHealth = 100
	local bodyMask = nil
	local bodyGroupIndexP1 = -2
	local bodyGroupIndexP2 = -2

	-- BUFFER BATCH
	local bufferBatch = yama.buffers.newBatch(x, y, z)

	local spriteJumper = yama.buffers.newDrawable(yama.assets.loadImage("jumper"), x, y, z, r, sx, sy, ox, oy )

	local spriteArrow = yama.buffers.newDrawable(yama.assets.loadImage("directionarrowshootah"), x, y, 900, 1, sx, sy, 3, 3 )

	local weapon_meleeSprite = yama.buffers.newDrawable( yama.assets.loadImage("melee_weapon"), x, y, 900, 1, sx, sy, 3, 3 )

	-- SHIELD --
	local spriteShield = yama.buffers.newDrawable( yama.assets.loadImage( "shield" ), x, y, 1000, 0, sx, sy, 25, 25 )
	--spriteShield.blendmode = "additive"

	-- shield hit effect --
	--[[
	local ptcSpark = love.graphics.newParticleSystem( images.load( "spark" ), 1000 )
	ptcSpark:setEmissionRate( 2000 )
	ptcSpark:setSpeed( 100, 200 )
	ptcSpark:setSizes( 0, 1 )
	ptcSpark:setColors( 200, 200, 255, 255, 200, 200, 255, 0 )
	ptcSpark:setPosition( x, y )
	ptcSpark:setLifetime(0.09)
	ptcSpark:setParticleLife(0.25)
	--ptcSpark:setDirection(10)
	ptcSpark:setSpread( math.rad( 90 ) )
	ptcSpark:setTangentialAcceleration(200)
	ptcSpark:setRadialAcceleration(200)
	--ptcSpark:stop()
	local sparks = yama.buffers.newDrawable( ptcSpark, 0, 0, 24 )
	sparks.blendmode = "additive"
	local distSparkX = 0
	local distSparkY = 0


	local ptcShieldDestroyed = love.graphics.newParticleSystem( images.load( "spark" ), 1000 )
	ptcShieldDestroyed:setEmissionRate( 2000 )
	ptcShieldDestroyed:setSpeed( 1, 2 )
	ptcShieldDestroyed:setSizes( 0, 1 )
	ptcShieldDestroyed:setColors( 200, 200, 255, 255, 200, 200, 255, 0 )
	ptcShieldDestroyed:setPosition( x, y )
	ptcShieldDestroyed:setLifetime(0.3)
	ptcShieldDestroyed:setParticleLife(0.2)
	ptcShieldDestroyed:setDirection(10)
	ptcShieldDestroyed:setSpread( math.rad( 0 ) )
	ptcShieldDestroyed:setTangentialAcceleration(200)
	ptcShieldDestroyed:setRadialAcceleration(200)
	--ptcShieldDestroyed:stop()
	local ShieldDestroyed = yama.buffers.newDrawable( ptcShieldDestroyed, 0, 0, 24 )
	ShieldDestroyed.blendmode = "additive"
	--]]
	

	table.insert( bufferBatch.data, spriteJumper )
	table.insert( bufferBatch.data, spriteArrow )
	table.insert( bufferBatch.data, weapon_meleeSprite )
	table.insert( bufferBatch.data, spriteShield )
	--table.insert( bufferBatch.data, sparks )
	--table.insert( bufferBatch.data, ShieldDestroyed )
	
	-- Physics

	function self.initialize( data )
		--self.setBoundingBox()		-- body
	end

	local anchor = love.physics.newFixture( love.physics.newBody( map.world, x, y, "dynamic"), love.physics.newRectangleShape( width, height ) )
	anchor:setGroupIndex( 1 )
	anchor:setUserData( userdata )
	anchor:setRestitution( 0 )
	anchor:getBody():setFixedRotation( true )
	anchor:getBody():setLinearDamping( 1 )
	anchor:getBody():setMass( 1 )
	anchor:getBody():setInertia( 1 )
	anchor:getBody():setGravityScale( 9 )
	anchor:getBody():setBullet( true )

	local sword = love.physics.newFixture( anchor:getBody(), love.physics.newPolygonShape( 0, 0, 0, 7, 47, 7, 47, 0 ) )
	sword:setUserData( swordUserdata )
	sword:setGroupIndex( -2 )
	sword:setUserData( swordUserdata )
	sword:getBody( ):setMass( 1 )
	sword:setMask( 1 )


	local shield = love.physics.newFixture( anchor:getBody(), love.physics.newCircleShape( 26 ), 0 )
	shield:setUserData( shieldUserdata )
	--shield:setSensor(true)
	--local shield = love.physics.newFixture(love.physics.newBody( map.world, x, y, "dynamic"), love.physics.newCircleShape( 38 ) )
	shield:setGroupIndex( -2 )
	shield:setUserData( shieldUserdata )
	shield:getBody( ):setMass( 1 )
	--shieldJoint = love.physics.newWeldJoint( shield:getBody(), anchor:getBody(), x, y, false )
	--shieldJoint = love.physics.newDistanceJoint( shield:getBody(), anchor:getBody(), x, y, x+1, y+1, false )
	--shieldJoint:setLength(0.1)

	--shieldJoint:setFrequency(-60)
	--shieldJoint:setDampingRatio(-100)
	--shield:getBody( ):setLinearDamping( 0.001 )
	--shield:getBody( ):setMass( 0.0001 )
	--shield:getBody( ):setInertia( 0.01 )
	--shield:getBody( ):setGravityScale( 0.9 )

	--[[
	local canon = love.physics.newFixture(love.physics.newBody( map.world, x+14, y+3, "dynamic"), love.physics.newRectangleShape( 32, 6 ) )
	canon:setGroupIndex( -1 )
	canonJoint = love.physics.newRevoluteJoint( canon:getBody(), anchor:getBody(), x, y, false )
	canonJoint:enableMotor( true )
	--canonJoint = love.physics.newWheelJoint( canon:getBody(), anchor:getBody(), x, y, x, y )
	canon:getBody( ):setLinearDamping( 1 )
	canon:getBody( ):setMass( 0.0001 )
	canon:getBody( ):setInertia( 0.01 )
	canon:getBody( ):setGravityScale( 0.9 )
	--]]

	self.joystick = love.joystick.getJoysticks()[1]

	function self.update( dt )
		self.x = x
		self.y = y
		self.z = z
		self.updateInput( dt )
		self.updatePosition( )
		self.setBoundingBox( )
		self.updateShield( dt )
		
		self.cx, self.cy = x - ox + width / 2, y - oy + height / 2
		self.radius = yama.g.getDistance( self.cx, self.cy, x - ox, y - oy )

		--ptcSpark:start()
		--ptcSpark:setPosition( x+distSparkX, y+distSparkY )
		--ptcSpark:update( dt )

		--ptcSpark:start()
		randOffsetX = math.random( -32, 32 )
		randOffsetY = math.random( -32, 32 )
		--ptcShieldDestroyed:setPosition( x+randOffsetX, y+randOffsetY )
		--ptcShieldDestroyed:update( dt )
	end

	function self.updateInput( dt )
		xv, yv = anchor:getBody( ):getLinearVelocity( )
		if yv < 0.1 and yv > - 0.1 then
			--print( 'resetJumpUpdateInput' )
			jumpTimer = 0
		end

		self.movement( dt )
		self.bulletSpawn( dt )
		self.melee( dt )
		self.jumping( dt )

	end

	function self.updateShield( dt )
		if shieldHealth < shieldMaxHealth then
			if shieldTimer <= shieldMaxTimer then
			shieldTimer = shieldTimer + dt
			elseif not shieldOn and shieldKilled then
				local nxx = self.joystick:getAxis( 3 )
				local nyy = self.joystick:getAxis( 4 )
				if yama.g.getDistance( 0, 0, nxx, nyy ) < 0.26 then
					self.createShield( shieldMaxHealth, false )
				end
			end
		else
			shieldHealth = shieldMaxHealth
			spriteShield.color = { 255, 255, 255, math.floor( 255*( shieldHealth/shieldMaxHealth )+0.5 ) }
		end
	end

	function self.movement( dt )
		fx, fy = 0, 0
		relativeDirection = ""
		
		if yama.g.getDistance( 0, 0, self.joystick:getAxis( 1 ), self.joystick:getAxis( 2 ) ) > 0.26 then
			if not self.running then
				local xv, yv = anchor:getBody( ):getLinearVelocity( )
				if pContact and yv == 0 then
					self.running = true
					print('SETFRICRUN')
					pContact:setFriction( stopFriction )
				end
			end

			nx = self.joystick:getAxis( 1 )
			ny = self.joystick:getAxis( 2 )
			relativeDirection = yama.g.getRelativeDirection( math.atan2( ny, nx ) )
		else
			if self.running then
				local xv, yv = anchor:getBody( ):getLinearVelocity( )
				if pContact and yv == 0 then
					self.running = false
					print('STOPFRICTION')
					pContact:setFriction( stopFriction )
				end
			end
		end
		
		if love.keyboard.isDown( "right" ) or relativeDirection == "right" then
			direction = 1.570796327
			spriteJumper.sx = 1
			if yv == 0 then				
				fx = xForce
			else
				fx = xJumpForce
			end
			if xv <= maxSpeed then
				self.applyForce( fx, fy )
			end
		end
		if love.keyboard.isDown("left") or relativeDirection == "left" then
			direction = 4.71238898
			spriteJumper.sx = -1
			if yv == 0 then
				fx = - xForce
			else	
				fx = - xJumpForce
			end
			if xv >= - maxSpeed then
				self.applyForce( fx, fy )
			end
		end
	end

	function self.bulletSpawn( dt )
		-- BULLETS --

		local nx = self.joystick:getAxis( 3 )
		local ny = self.joystick:getAxis( 4 )
		if yama.g.getDistance( 0, 0, nx, ny ) > 0.26 then	
			spawntimer = spawntimer - dt
			if spawntimer <= 0 then
				local leftover = math.abs( spawntimer )
				spawntimer = 0.09 - leftover

				if shieldOn then
					self.removeShield( false )
				end

				aim = math.atan2( ny, nx )
				invaim = math.atan2( -ny, -nx )
				xrad = math.cos( aim )
				yrad = math.sin( aim )
				
				xPosBulletSpawn = x + 38*xrad
				yPosBulletSpawn = y + 38*yrad
				--print( xPosBulletSpawn, xPosBulletSpawn )
				bullet = map.spawnXYZ( "bullet", xPosBulletSpawn, yPosBulletSpawn, 0 )
				fxbullet = bulletImpulse * nx
				fybullet = bulletImpulse * ny				
				
				bullet.shoot( fxbullet, fybullet, invaim )
				table.insert( bullets, bullet )
				lenBullets = #bullets				
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
		if meleeTimer < meleeMaxTimer and allowMelee and self.joystick:isDown( ctrlMelee ) then
			print('whopp')
			if meleeTimer == 0 then
				print('WHAM')
				sword:setMask( )
				sword:setGroupIndex( 2 )
				meleeing = true
				self.refreshBufferBatch()
				allowMelee = false
				meleeCoolDownTimer = 0
			end
		end
		if meleeing then
			print('meleeing')
			meleeTimer = meleeTimer + dt
			if meleeTimer > meleeMaxTimer then
				print( 'NOTMELEE' )
				sword:setGroupIndex( -2 )
				sword:setMask( 1 )
				meleeing = false
				self.refreshBufferBatch()
				meleeTimer = 0
			end
		end
		if not meleeing and meleeCoolDownTimer < meleeCoolDownMaxTimer then
			print('coolioo')
			meleeCoolDownTimer = meleeCoolDownTimer + dt
			if meleeCoolDownTimer > meleeCoolDownMaxTimer then
				print('reset')
				allowMelee = true
			end
		end

		

		--if meleeTimer > meleeMaxTimer then

				
			--print( 'MELEE' )
		--elseif sword:getMask() ~= 1 and meleeTimer > meleeMaxTimer then

	--	end
	end

	function self.jumping(dt)

		-- JUMPING --
		xv, yv = anchor:getBody():getLinearVelocity()
		math.abs( yv )
		if yv < 0.1 and allowjump and ( love.keyboard.isDown( " " ) or self.joystick:isDown( ctrlJumpButtom ) ) then
			anchor:getBody():applyLinearImpulse( 0, -jumpForce )
			allowjump = false
		end

		self.jumpAccelerator( dt, ctrlJumpButtom, jumpMaxTimer, jumpIncreaser )

		if not love.keyboard.isDown(" ") and not self.joystick:isDown( ctrlJumpButtom ) and yv == 0 then
			allowjump = true
		end
	end

	function self.jumpAccelerator( dt, button, jMaxTimer, jIncreaser )

		if jumpTimer < jMaxTimer and ( love.keyboard.isDown( " " ) or self.joystick:isDown( button ) ) then
			self.applyForce( 0, -jIncreaser )
			jumpTimer = jumpTimer + dt
			xv, yv = anchor:getBody():getLinearVelocity()
			if jumpTimer > jMaxTimer and yv < 0.1 and yv > -0.1 then
				print( "jumptiner reset!")
				jumpTimer = 0
			end
		end
	end

	function self.bodyEnergy( damage )
		print( damage )
		bodyHealth = bodyHealth - damage
		if bodyHealth <= 0 then
			self.destroy()
		end
	end

	function self.shieldPower( damage )
		print( damage )
		shieldHealth = shieldHealth - damage
		spriteShield.color = { 255, 255, 255, math.floor( 255*( shieldHealth/shieldMaxHealth )+0.5 ) } 
		shieldTimer = 0
		if shieldHealth <= 0 and shieldOn then
			self.removeShield( true )
		end
	end

	function self.removeShield( killed )
		--shield:destroy()
		shield:setMask( 1 )
		shieldOn = false
		self.refreshBufferBatch()
		shieldKilled = killed
		if killed == true then
			--ptcShieldDestroyed:start( )
		end

		--self.destroy()
	end

	function self.createShield( health, killed )
		-- body
		--shield = love.physics.newFixture( anchor:getBody(), love.physics.newCircleShape( 32 ), 0 )
		--shield:setGroupIndex( -2 )
		--shield:setUserData( shieldUserdata )
		shield:setMask( )
		shieldHealth = health
		spriteShield.color = { 255, 255, 255, math.floor( 255 * ( shieldHealth/shieldMaxHealth ) + 0.5 ) }
		shieldOn = true
		self.refreshBufferBatch()
		shieldKilled = killed
		shieldTimer = 0
	end

	function self.applyForce( fx, fy )
		anchor:getBody():applyForce( fx, fy )
	end

	function self.refreshBufferBatch()

		bufferBatch = yama.buffers.newBatch(x, y, z)

		table.insert( bufferBatch.data, spriteJumper )
		table.insert( bufferBatch.data, spriteArrow )
		
		table.insert( bufferBatch.data, sparks )
		table.insert( bufferBatch.data, ShieldDestroyed )
		if shieldOn then
			table.insert( bufferBatch.data, spriteShield )
		end
		if meleeing then
			table.insert( bufferBatch.data, weapon_meleeSprite )
		end
	end

	function self.updatePosition(xn, yn)		
		x = anchor:getBody():getX()
		y = anchor:getBody():getY()
		r = anchor:getBody():getAngle()

		spriteJumper.x = x
		spriteJumper.y = y
		spriteJumper.z = 100
		spriteJumper.r = r
		
		spriteShield.x = x
		spriteShield.y = y
		spriteShield.z = 100

		spriteArrow.x = x --math.floor(x + 0.5)
		spriteArrow.y = y --math.floor(y-16 + 0.5)
		spriteArrow.z = 10
		spriteArrow.r = aim

		weapon_meleeSprite.x = x --math.floor(x + 0.5)
		weapon_meleeSprite.y = y --math.floor(y-16 + 0.5)
		weapon_meleeSprite.r = r
		
		bufferBatch.x = x
		bufferBatch.y = y
		bufferBatch.z = 100
		bufferBatch.r = r

	end

	local animation = {}
	animation.quad = 1
	animation.dt = 0

	self.callbacks = {}
	self.callbacks.shield = {}

	function self.callbacks.shield.BeginCont( a, b, contact )
		-- body
	end

	-- CONTACT --
	function self.beginContact( a, b, contact )

		contact:setRestitution( 0 )
		userdata = b:getUserData()
		userdata2 = a:getUserData()
		if userdata then
			print(userdata.type)
			print(userdata2.type)
			if userdata.type == 'floor' then
				xc1, yc1, xc2, yc2 = contact:getPositions( )
				if yc1 > self.y then
					pContact = contact
					--print( 'On floor!')
					jumpTimer = 0
		 			onGround = true
		 		end
			elseif userdata.type == 'bullet' and userdata2.type == 'shield' then
				self.shieldPower( bulletStandardShieldDamage )

				--aims = math.atan2( a:getBody:GetX(), b:getBody:GetX() )
				--xrad = math.cos( aim )
				--yrad = math.sin( aim )

				local sparkx1, sparky1, xxx, yyy = contact:getPositions()		
				
				distSparkX = sparkx1 - x				
				distSparkY = sparky1 - y
				local hitDirection = math.atan2( distSparkY, distSparkX )
				
				--ptcSpark:setPosition( sparkx1, sparky1 )
				--ptcSpark:setDirection( hitDirection )
				--ptcSpark:start( )
			end
			if userdata2 then
				if userdata.type == 'shield' and userdata2.type == 'melee' then
					self.shieldPower( meleeStandardShieldDamage )
				end
				if userdata.type == 'bullet' and userdata2.type == 'mplayer' then
					self.bodyEnergy( bulletStandardBodyDamage )
				end
				if userdata.type == 'melee' and userdata2.type == 'mplayer' then
					self.bodyEnergy( meleeStandardBodyDamage )
				end

			end
		end


		--print( "beginContact!" )

		--xc1, yc1, xc2, yc2 = contact:getPositions( )
		--[[		
		if a:getBody( ) == anchor:getBody( ) then
			--print( 'a = anchor' )
			if xc1 and xc2 then
			--	print( xc1-xc2 )
			end
			if xc1 and xc2 then 
				if xc1 - xc2 < 0.1 and xc1 - xc2 > - 0.1 then
					latestCol = 'wall'
				else
					--contact:setRestitution( 0 )
					latestCol = 'ground'
					jumpTimer = 0
					onGround = true					
					yposContact = anchor:getBody( ):getY( )
				end
			end
		end
		--]]

		-- JUMP STUFF --
		---[[

	end

	function self.endContact(a, b, contact)
		--local xc1, yc1, xc2, yc2 = contact:getPositions( )
		-- JUMP STUFF --
		if a:getBody() == anchor:getBody() then
			contact:setRestitution( 0 )
			if b:getUserData() then
				if b:getUserData().type == 'floor' then
					if yc1 > self.y then
						onGround = false
					end
				end
			end
		end
	end

	function self.draw( )
		love.graphics.setColorMode( "modulate" )
		love.graphics.setColor( 255, 255, 255, 255 );
		love.graphics.setBlendMode( "alpha" )
		if hud.enabled then
			physics.draw( anchor, { 0, 255, 0, 102 } )
		end
	end

	function self.addToBuffer( vp )
		vp.addToBuffer( bufferBatch )
	end
	-- Basic functions
	function self.setPosition( x, y )
		anchor.body:setPosition( x, y )
		anchor.body:setLinearVelocity( 0, 0 )
	end
	
	function self.getPosition( )
		return x, y
	end

	function self.getXvel( )
		return xvel
	end
	function self.getYvel( )
		return yvel
	end
	function self.destroy( )
		anchor:getBody():destroy()
		self.destroyed = true
	end

	-- GET
	function self.getType()
		return type
	end
	function self.getPosition()
		return x, y, z
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