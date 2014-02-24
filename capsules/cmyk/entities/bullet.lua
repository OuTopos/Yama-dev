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

	local garbageTime = 0
	
	local aim = 0
	local direction = 0
	local remove = false
	local speed = 0
	local bulletImpulse = 2
	local maxSpeed = 100
	local bulletTimer = 0

	local fx = 0
	local fy = 0

	self.isCreated = false
	local xvb = 0
	local yvb = 0
	local xVelScaler = 1.009
	local yVelScaler = 1.009
	local blastTimer = 0
	self.firePositionX = 0
	self.firePositionY = 0
	self.bulletMaxTravelDistance = 90000
	self.blast = false
	self.weaponProperties = {}
	local dummy = nil

	local blastPosX = 0.01
	local blastPosY = 0.01

	self.bounces = 0
	self.isDestroyed = false
	self.isOff = false

	-- BUFFER BATCH
	local bufferBatch = yama.buffers.newBatch( self.x, self.y, self.z )

	-- SPRITE (PLAYER)	
	local bulletsprite = yama.buffers.newDrawable( yama.assets.loadImage( "bullet" ), self.x, self.y, self.z, r, sx, sy, ox, oy )

	--local bulletsprite = yama.buffers.newDrawable( yama.assets.loadImage("bullet"), x, y, z, r, sx, sy, ox, oy )

	table.insert( bufferBatch.data, bulletsprite )

	function self.initialize( properties )

		print("CREATED")

		self.weaponProperties = properties

		-- Physics
		
		self.bullet = love.physics.newFixture(love.physics.newBody( map.world, self.x, self.y, "dynamic"), love.physics.newCircleShape( self.weaponProperties.sizeX ) )
		self.isCreated = true
		self.bullet:setGroupIndex( -1 )
		self.bullet:setCategory( 2 )
		self.bullet:setMask( 2 )
		self.bullet:setUserData( bulletUserdata )
		self.bullet:setRestitution( 0.90 )
		self.bullet:getBody( ):setFixedRotation( false )
		self.bullet:getBody( ):setLinearDamping( self.weaponProperties.linearDamping )
		self.bullet:getBody( ):setMass( self.weaponProperties.bulletWeight )
		self.bullet:getBody( ):setInertia( self.weaponProperties.inertia )
		self.bullet:getBody( ):setGravityScale( self.weaponProperties.gravityScale )
		self.bullet:getBody( ):setBullet( true )

		self.trail = map.newEntity( "trail", {self.x, self.y, 0}, self.weaponProperties)
	end

	function self.update( dt )

		self.updatePosition( )

		if not self.isOff then

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

			if bulletTimer <= self.weaponProperties.lifetime then
				bulletTimer = bulletTimer + dt
			else
				--print( "bulletTimer ends! killing bullet")
				bulletTimer = 0
				self.isDestroyed = true
				print("Bullet: update: lifetime run out!")
			end

			self.bulletTravelDistance = yama.tools.getDistance( self.firePositionX, self.firePositionY, x, y )

			if self.weaponProperties.bulletTravelDistance and self.bulletTravelDistance > self.weaponProperties.bulletTravelDistance then

				--print("Bullet: update: max travel distance!", self.bulletTravelDistance)
				self.isDestroyed = true
				if garbageTime <= 0.002 then
					garbageTime = garbageTime + dt
					collectgarbage()
				else
					print("zero")
					garbageTime = 0
				end
			end

			if self.isDestroyed then
				self.bullet:getBody():setLinearVelocity( 0,0 )
				if self.weaponProperties.blastRadius > 0 then			
					if not self.blast then
						self.blast = love.physics.newFixture( self.bullet:getBody(), love.physics.newCircleShape( self.weaponProperties.blastRadius ), 1 )
						--print( "Blast! Size::", self.weaponProperties.blastRadius )
						self.blast:setGroupIndex( -1 )
						self.blast:setCategory( 2 )
						self.blast:setMask( 2 )
						self.blast:setSensor( true )
						self.blast:setUserData( bulletUserdata )
						--blast:setRestitution( 0.90 )
						--blast:setSensor(true)
						--blast:getBody( ):setFixedRotation( false )
					--	bullet.blast:getBody( ):setLinearDamping( 0.3 )
						self.blast:getBody( ):setMass( 0.01 )
					--	blast:getBody( ):setInertia( 0.2 )
						self.blast:getBody( ):setGravityScale( 0.001 )
						self.blast:getBody( ):setBullet( true )
						self.bullet:setSensor( true )
					else
						if blastTimer <= 0.2 then
							blastTimer = blastTimer + dt
						else
							print("removing blast")
							blastTimer = 0
							self.bullet:setSensor( false )
							self.blast:destroy()
							self.destroy()
							self.blast = false
						end
					end
				else
					print("destroy")
					self.destroy()
				end
				if garbageTime <= 0.007 then
					garbageTime = garbageTime + dt
					collectgarbage()
				else
					print("zero")
					garbageTime = 0
				end
			end
		end
	end
	
	function self.shoot( xpos, ypos, fxx, fyy, props )
		self.weaponProperties = props
		self.trail.setParticles(self.weaponProperties)
		self.trail.isDestroyed = false
		self.trail.x = xpos
		self.trail.y = ypos
		--self.trail.invaim = invaim
		print("Bullet: shoot!")
		bulletTimer = 0
		self.isOff = false		

		self.bullet:setUserData( bulletUserdata )
		self.bullet:getBody( ):setLinearDamping( self.weaponProperties.linearDamping )
		self.bullet:getBody( ):setMass( self.weaponProperties.bulletWeight )
		self.bullet:getBody( ):setInertia( self.weaponProperties.inertia )
		self.bullet:getBody( ):setGravityScale( self.weaponProperties.gravityScale )
		self.bullet:getBody( ):setPosition( xpos, ypos )

		self.updatePosition()

		
		fx = fxx
		fy = fyy

		self.firePositionX = xpos
		self.firePositionY = ypos


		self.bullet:getBody( ):applyLinearImpulse( fx, fy )

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
				self.isDestroyed = true
				print("CONTACKDESTORYED")
			elseif userdata.type == 'player' then
				--print('bullet: body hit!')
				self.isDestroyed = true
				print("CONTACKDESTORYED")
			end
		end
		self.bounces = self.bounces + 1
		if self.weaponProperties.nrBounces and self.bounces > self.weaponProperties.nrBounces then
			if self.weaponProperties.blastRadius > 0 then
				--print( "max bullet bounces reached! Killing bullet ")
				contact:setRestitution( 0 )
				blastPosX, blastPosY, dummy, dummy = contact:getPositions( )
				self.isDestroyed = true
			else
				--print( "AWEVT&%&¤%/&%")
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
		if self.isOff then
			love.graphics.setColorMode( "modulate" )

			love.graphics.setColor( 255, 255, 255, 255 );
			love.graphics.setBlendMode( "alpha" )

			if hud.enabled then
				physics.draw( bullet, { 0, 255, 0, 102 } )
			end
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

			print("Bullet: Destroy!")
			self.isOff = true
			self.bullet:getBody( ):setLinearVelocity( 0, 0 )
			self.bullet:getBody( ):setPosition( 0, 0 )
			self.bullet:getBody( ):setAwake( false )
			
			self.bulletTravelDistance = 0
			self.bounces = 0
			self.isDestroyed = false
			--self.bullet:getBody():destroy()
			--self.destroyed = true
			
			self.trail.isDestroyed = true
	end


	return self
end

return bullet