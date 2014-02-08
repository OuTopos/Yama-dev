local bullet = {}

function bullet.new( map, x, y, z )
	local self = {}

	local bulletUserdata = {}
	bulletUserdata.name = "Unnamed"
	bulletUserdata.type = "bullet"
	bulletUserdata.properties = {}
	bulletUserdata.id = 0
	bulletUserdata.callbacks = self

	self.x = x
	self.y = y
	self.z = z	

	-- Common variables
	local width, height = 5, 5
	local width2, height2 = 4, 4
	local ox, oy = width2/2, height2/2
	local sx, sy = 1, 1
	local r = 0
	self.type = "brick"
	
	local aim = 0
	local direction = 0
	local remove = false
	local speed = 0
	local bulletImpulse = 2
	local maxSpeed = 100
	local bulletTimer = 0
	self.bulletMaxTimer = 7.0
	local xvb = 0
	local yvb = 0
	self.firePositionX = 0
	self.firePositionY = 0
	self.bulletMaxTravelDistance = 90000

	self.bulletShieldDeadly = false
	self.bulletBodyDeadly = false
	self.maxBounces = 0
	self.bounces = 0

	self.trail = map.newEntity( "trail", {self.x, self.y, 0})

	-- BUFFER BATCH
	local bufferBatch = yama.buffers.newBatch( self.x, self.y, self.z )

	-- SPRITE (PLAYER)	
	local bulletsprite = yama.buffers.newDrawable( yama.assets.loadImage( "bullet" ), self.x, self.y, self.z, r, sx, sy, ox, oy )

	--local bulletsprite = yama.buffers.newDrawable( yama.assets.loadImage("bullet"), x, y, z, r, sx, sy, ox, oy )

	table.insert( bufferBatch.data, bulletsprite )

	-- Physics
	local bullet = love.physics.newFixture(love.physics.newBody( map.world, x, y, "dynamic"), love.physics.newCircleShape( 1.5 ) )
	--local bullet = love.physics.newFixture(love.physics.newBody( map.world, x, y, "dynamic"), love.physics.newRectangleShape( 8, 8 ) )
	bullet:setGroupIndex( -1 )
	bullet:setCategory( 2 )
	bullet:setMask( 2 )
	bullet:setUserData( bulletUserdata )
	bullet:setRestitution( 0.90 )
	bullet:getBody( ):setFixedRotation( false )
	bullet:getBody( ):setLinearDamping( 0.3 )
	bullet:getBody( ):setMass( 0.4 )
	bullet:getBody( ):setInertia( 0.2 )
	bullet:getBody( ):setGravityScale( 1 )
	bullet:getBody( ):setBullet( true )

	--[[
	local ptcTrail = love.graphics.newParticleSystem(  yama.assets.loadImage( "bullet" ), 1000)
	ptcTrail:setEmissionRate( 600 )
	ptcTrail:setSpeed( 30, 60 )
	ptcTrail:setSizes( 1, 3 )
	ptcTrail:setColors( 255, 255, 255, 170, 255, 255, 255, 20, 255, 255, 255, 0 )
	ptcTrail:setPosition( x, y )
	ptcTrail:setEmitterLifetime(200)
	ptcTrail:setParticleLifetime(0.9)
	ptcTrail:setSpread( math.rad( 30 ) )
	ptcTrail:setTangentialAcceleration(0.01)
	ptcTrail:setRadialAcceleration(0.01)
	--ptcTrail:stop()
	local trail = yama.buffers.newDrawable( ptcTrail, 0, 0, 24 )
	table.insert( bufferBatch.data, trail )
	--]]
	function self.initialize( properties )

	end

	

	function self.update( dt )

		self.updatePosition( )

		self.x = x
		self.y = y
		self.z = z

		xvb, yvb = bullet:getBody():getLinearVelocity()
		local invaim = math.atan2( -yvb, -xvb )
		xvb = math.abs( xvb )
		yvb = math.abs( yvb )
		local velxy = xvb + yvb

		self.trail.x = self.x
		self.trail.y = self.y
		self.trail.invaim = invaim
		
		--[[
		ptcTrail:setEmissionRate( 500 )
		ptcTrail:setDirection( invaim )
		ptcTrail:setPosition( self.x, self.y )
		--ptcTrail:update(dt)
		--]]


		if bulletTimer <= self.bulletMaxTimer then
			bulletTimer = bulletTimer + dt
		else
			bulletTimer = 0
			self.destroy()
		end

		self.bulletTravelDistance = yama.tools.getDistance( self.firePositionX, self.firePositionY, self.x, self.y )
		if self.bulletTravelDistance > self.bulletMaxTravelDistance then
			self.destroy()
		end

		if velxy < 75 then
			self.destroy()
		end

		--ptcTrail:setEmissionRate( velxy )

	end
	
	function self.shoot( fx, fy, lifetime, maxbounces, bulletMaxTravelDistance, type )
		self.maxBounces = maxbounces
		self.bulletMaxTimer = lifetime
		self.firePositionX = self.x
		self.firePositionY = self.y
		self.type = type
		self.bulletMaxTravelDistance = bulletMaxTravelDistance
		bullet:getBody( ):applyLinearImpulse( fx, fy )
	end

	function self.setId( id )
		bulletUserdata.id = id
		bullet:setUserData( bulletUserdata )

	end

	function self.updatePosition( xn, yn )
		x = bullet:getBody( ):getX( )
		y = bullet:getBody( ):getY( )
		r = bullet:getBody( ):getAngle( )

		bufferBatch.x = x
		bufferBatch.y = y
		bufferBatch.z = 100
		bufferBatch.r = r
		
		bulletsprite.x = x --math.floor(x + 0.5)
		bulletsprite.y = y --math.floor(y-16 + 0.5)
		bulletsprite.r = aim

	end

	local animation = {}
	animation.quad = 1
	animation.dt = 0

	-- CONTACT --
	function self.beginContact( a, b, contact )
		--print( 'bullet: beginContact')
		--print( a:getBody( ):getMass() )
		local userdata = b:getUserData( )
		if userdata then
			--print( a:getUserData().type, userdata.type )
			if userdata.type == 'shield' then  
				--print('bullet: shield hit!')
				self.destroy()
			elseif userdata.type == 'player' then
				--print('bullet: body hit!')
				self.destroy()
			end
		end
		self.bounces = self.bounces + 1
		if self.bounces > self.maxBounces then
			self.destroy()
		end
	end
	function self.endContact( a, b, contact )
		--print( 'bullet: beginContact')
		--print( a:getBody( ):getMass() )
		local userdata = b:getUserData( )
		if userdata then
			--print( a:getUserData().type, userdata.type )
			if userdata.type == 'shield' then  
				--print('bullet: shield end contact!')
			elseif userdata.type == 'player' then
				--print('bullet: body end contact!')
			end
		end
	end

	function self.draw( )
		love.graphics.setColorMode( "modulate" )

		love.graphics.setColor( 255, 255, 255, 255 );
		love.graphics.setBlendMode( "alpha" )

		if hud.enabled then
			physics.draw( bullet, { 0, 255, 0, 102 } )
		end
	end

	function self.addToBuffer( vp )
		vp.addToBuffer( bufferBatch )
	end


	-- Basic functions
	function self.setPosition( x, y )
		bullet.body:setPosition( x, y )
		bullet.body:setLinearVelocity( 0, 0 )
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
		if not self.destroyed then
			bullet:getBody():destroy()
			self.destroyed = true
			self.trail.isDestroyed = true
		end
	end

	return self
end

return bullet