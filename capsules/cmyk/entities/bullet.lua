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
	local blastTimer = 0
	self.doBlast = false
	self.firePositionX = 0
	self.firePositionY = 0
	self.bulletMaxTravelDistance = 90000
	self.blast = false
	self.weaponProperties = {}
	local dummy = nil

	local blastPosX = 0
	local blastPosY = 0

	self.bulletShieldDeadly = false
	self.bulletBodyDeadly = false

	self.bounces = 0
	self.blastRadius = 0
	self.isDestroyed = false

	self.trail = map.newEntity( "trail", {self.x, self.y, 0})

	-- BUFFER BATCH
	local bufferBatch = yama.buffers.newBatch( self.x, self.y, self.z )

	-- SPRITE (PLAYER)	
	local bulletsprite = yama.buffers.newDrawable( yama.assets.loadImage( "bullet" ), self.x, self.y, self.z, r, sx, sy, ox, oy )

	--local bulletsprite = yama.buffers.newDrawable( yama.assets.loadImage("bullet"), x, y, z, r, sx, sy, ox, oy )

	table.insert( bufferBatch.data, bulletsprite )

	-- Physics
	self.bullet = love.physics.newFixture(love.physics.newBody( map.world, x, y, "dynamic"), love.physics.newCircleShape( 1.5 ) )
	--local bullet = love.physics.newFixture(love.physics.newBody( map.world, x, y, "dynamic"), love.physics.newRectangleShape( 8, 8 ) )
	self.bullet:setGroupIndex( -1 )
	self.bullet:setCategory( 2 )
	self.bullet:setMask( 2 )
	self.bullet:setUserData( bulletUserdata )
	self.bullet:setRestitution( 0.90 )
	self.bullet:getBody( ):setFixedRotation( false )
	self.bullet:getBody( ):setLinearDamping( 0.3 )
	self.bullet:getBody( ):setMass( 0.4 )
	self.bullet:getBody( ):setInertia( 0.2 )
	self.bullet:getBody( ):setGravityScale( 1 )
	self.bullet:getBody( ):setBullet( true )


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

		xvb, yvb = self.bullet:getBody():getLinearVelocity()
		local invaim = math.atan2( -yvb, -xvb )
		xvb = math.abs( xvb )
		yvb = math.abs( yvb )

		self.trail.x = x
		self.trail.y = y
		self.trail.invaim = invaim

		self.x = x
		self.y = y
		self.z = z
		
		self.updatePosition( )


		if self.isDestroyed then
			if self.doBlast then			
				if not self.blast then
					self.blast = love.physics.newFixture( self.bullet:getBody(), love.physics.newCircleShape( self.blastRadius ), 1 )
					print( "Blast! Size::", self.blastRadius)
					self.blast:setGroupIndex( -1 )
					self.blast:setCategory( 2 )
					self.blast:setMask( 2 )
					self.blast:setSensor( 2 )
					self.blast:setUserData( bulletUserdata )
					--blast:setRestitution( 0.90 )
					--blast:setSensor(true)
					--blast:getBody( ):setFixedRotation( false )
				--	bullet.blast:getBody( ):setLinearDamping( 0.3 )
					self.blast:getBody( ):setMass( 0.01 )
				--	blast:getBody( ):setInertia( 0.2 )
				--	blast:getBody( ):setGravityScale( 0.1 )
					self.blast:getBody( ):setBullet( true )
				else
					if blastTimer <= 0.2 then
						blastTimer = blastTimer + dt
						self.bullet:getBody():setLinearVelocity( 0,0 )
					else
						blastTimer = 0
						self.doBlast = false
						self.destroy()
					end
				end
			end
		end

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
	end
	
	function self.shoot( fx, fy, weaponProperties )

		self.firePositionX = self.x
		self.firePositionY = self.y


		self.weaponProperties = weaponProperties

		self.bullet:getBody( ):setMass( self.weaponProperties.bulletWeight )
		
		self.maxBounces = 				weaponProperties.nrBounces
		self.bulletMaxTimer = 			weaponProperties.lifetime
		self.type = 					weaponProperties.name
		self.blastRadius = 				weaponProperties.blastRadius
		self.bulletMaxTravelDistance = 	weaponProperties.bulletTravelDistance

		self.bullet:getBody( ):applyLinearImpulse( fx, fy )
	end

	function self.setId( id )
		bulletUserdata.id = id
		self.bullet:setUserData( bulletUserdata )

	end

	function self.updatePosition( xn, yn )
		x = self.bullet:getBody( ):getX( )
		y = self.bullet:getBody( ):getY( )
		r = self.bullet:getBody( ):getAngle( )

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
		if self.bounces > self.weaponProperties.nrBounces then
			if self.blastRadius > 0 then
				contact:setRestitution( 0 )
				blastPosX, blastPosY, dummy, dummy = contact:getPositions( )
				self.doBlast = true
				self.isDestroyed = true
			else
				self.isDestroyed = true
			end
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
			self.bullet:getBody():destroy()
			self.destroyed = true
			self.trail.isDestroyed = true
		end
	end

	return self
end

return bullet