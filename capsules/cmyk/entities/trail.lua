local trail = {}

function trail.new(scene, x, y, z)
	local self = {}

	self.x, self.y = x, y

	self.invaim = 0
	self.isDestroyed = false

	local emissionRate = 900

	local lifeMaxTimer = 3
	local lifeTimer = 0

	local ptcTrail = love.graphics.newParticleSystem(  yama.assets.loadImage( "bullet" ), 1000)
	ptcTrail:setSizes( 1.5, 3.8 )
	ptcTrail:setEmissionRate( emissionRate )
	ptcTrail:setBufferSize(50000)
	--ptcTrail:setSpeed( 10, 20 ) -- shotgun
	ptcTrail:setSpeed( 50, 100 ) -- bouncer
	
	ptcTrail:setColors(
		255, 255, 180, 170,
		255, 255, 0, 170,
		255, 128, 128, 160,
		0, 0, 0, 130, 
		0, 0, 0, 70, 
		10, 10, 10, 15, 
		175, 175, 175, 10, 
		255, 255, 255, 0 
	)
	ptcTrail:setPosition( x, y )
	ptcTrail:setEmitterLifetime(3)
	--ptcTrail:setParticleLifetime(1.5)  -- shotgun
	ptcTrail:setParticleLifetime(1.2)  -- bouncer
	
	ptcTrail:setTangentialAcceleration(0.01)
	ptcTrail:setRadialAcceleration(0.01)
	--ptcTrail:stop()
	local trail = yama.buffers.newDrawable( ptcTrail, 0, 0, 24 )

	function self.initialize( properties )


	end

	-- Standard functions
	function self.update(dt)

	if self.isDestroyed then
		if lifeTimer <= lifeMaxTimer then
			lifeTimer = lifeTimer + dt
			emissionRate = emissionRate * 0.85
			ptcTrail:setEmissionRate( emissionRate )
			ptcTrail:setDirection( self.invaim ) -- bouncer
			--ptcTrail:setDirection( love.math.random() ) -- shotgun
			ptcTrail:setSpread( love.math.random( math.rad( -180 ), math.rad( 180 ) ) )
			ptcTrail:setSpeed( 80, 160 ) -- bouncer
			--ptcTrail:setColors( 255, 100, 100, 170, 255, 100, 100, 20, 255, 100, 255, 0 )
			ptcTrail:setParticleLifetime(1.2)
			ptcTrail:update(dt)
		else
			lifeTimer = 0
			self.destroy()
			--emissionRate = 800
		end
	else
		--ptcTrail:setEmissionRate( emissionRate )
		ptcTrail:setDirection( self.invaim ) -- bouncer
		--ptcTrail:setDirection( love.math.random() )
		ptcTrail:setPosition( self.x, self.y )
		
		local spread = love.math.random( 25, 50 )
		if love.math.random(0,1) == 1 then
			spread = -spread
		end
		ptcTrail:setSpread( math.rad(spread) )
		ptcTrail:update(dt)
	end

	end
	
	function self.addToBuffer( vp )
		vp.addToBuffer( trail )
	end

	function self.destroy()
		self.destroyed = true
	end

	return self
end

return trail