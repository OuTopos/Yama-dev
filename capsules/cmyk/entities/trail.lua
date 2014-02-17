local trail = {}

function trail.new(scene, x, y, z)
	local self = {}

	self.x, self.y = x, y

	self.invaim = 0
	self.isDestroyed = false
	self.properties = {}

	local emissionRate = 400

	local lifeMaxTimer = 3
	local lifeTimer = 0

	local list = {255, 255, 120, 170,
		255, 255, 0, 170,
		255, 128, 128, 160,
		0, 0, 0, 130, 
		0, 0, 0, 70, 
		10, 10, 10, 15, 
		175, 175, 175, 10, 
		255, 255, 255, 0
		}

	function self.initialize( properties )

	self.properties = properties
	self.ptcTrail = love.graphics.newParticleSystem(  yama.assets.loadImage( self.properties.name ), 1000)
	self.ptcTrail:setPosition( x, y )
	
	self.ptcTrail:setSizes(	unpack( self.properties.ptclSpriteSizes ) )
	
	self.ptcTrail:setEmissionRate( self.properties.ptclEmissionRate )
	
	self.ptcTrail:setEmitterLifetime(
		self.properties.ptclEmitterLifetime )
	
	self.ptcTrail:setBufferSize(
		self.properties.ptclBufferSize )
	
	self.ptcTrail:setSpeed(
		unpack(self.properties.ptclSpeed) ) 
	
	self.ptcTrail:setLinearAcceleration(
		unpack(self.properties.ptclLinearAcceleration) )
	
	self.ptcTrail:setParticleLifetime(
		self.properties.ptclSpriteLifetime )
	
	self.ptcTrail:setTangentialAcceleration(
		self.properties.ptclTangentialAcceleration )
	
	self.ptcTrail:setRadialAcceleration(
		unpack(self.properties.ptclRadialAcceleration) )

	self.ptcTrail:setAreaSpread(
		unpack(self.properties.ptclAreaSpread ) )

	self.ptcTrail:setSpread(
		self.properties.ptclSpread )

	self.ptcTrail:setSpin(
		unpack( self.properties.ptclSpin ) )

	self.ptcTrail:setColors(
		unpack( self.properties.ptclColors ) )




	self.trail = yama.buffers.newDrawable( self.ptcTrail, 0, 0, 24 )


	end

	-- Standard functions
	function self.update(dt)

	if self.isDestroyed then
		if lifeTimer <= lifeMaxTimer then
			lifeTimer = lifeTimer + dt
			emissionRate = emissionRate * 0.95
			self.ptcTrail:setEmissionRate( emissionRate )
			self.ptcTrail:setDirection( self.invaim ) -- bouncer
			--self.ptcTrail:setDirection( love.math.random() ) -- shotgun
			self.ptcTrail:setSpread( love.math.random( math.rad( -180 ), math.rad( 180 ) ) )
			self.ptcTrail:setSpeed( 50, 110 ) -- bouncer
			--ptcTrail:setColors( 255, 100, 100, 170, 255, 100, 100, 20, 255, 100, 255, 0 )
			--ptcTrail:setParticleLifetime(1.2)
			self.ptcTrail:update(dt)
		else
			lifeTimer = 0
			self.destroy()
			emissionRate = 800
		end
	else
		--self.ptcTrail:setEmissionRate( emissionRate )
		self.ptcTrail:setDirection( self.invaim ) -- bouncer
		--self.ptcTrail:setDirection( love.math.random() )
		self.ptcTrail:setPosition( self.x, self.y )
		
		local spread = love.math.random( 35, 70 )
		if love.math.random(0,1) == 1 then
			spread = -spread
		end
		self.ptcTrail:setSpread( math.rad(spread) )
		self.ptcTrail:update(dt)
	end

	end
	
	function self.addToBuffer( vp )
		vp.addToBuffer( self.trail )
	end

	function self.destroy()
		self.destroyed = true
	end

	return self
end

return trail